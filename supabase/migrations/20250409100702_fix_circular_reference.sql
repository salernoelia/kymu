drop trigger if exists "check_circular_reference" on "public"."units_and_exercises";

alter table "public"."assessments" alter column "isTemplate" set not null;

alter table "public"."exercises" alter column "modality" set not null;

alter table "public"."exercises" alter column "name" set not null;

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.check_and_repair_unit_linked_list(target_unit_id uuid)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
    null_count int;
    exercise_count int;
    reached_count int;
    current_exercise uuid;
    visited uuid[];
    has_cycle boolean := false;
BEGIN
    -- Count total exercises in the unit
    SELECT COUNT(*) INTO exercise_count
    FROM units_and_exercises
    WHERE unit_id = target_unit_id;
    
    IF exercise_count = 0 THEN
        -- Empty unit, nothing to do
        RETURN;
    END IF;
    
    -- Count exercises with null prev_exercise_id (roots)
    SELECT COUNT(*) INTO null_count
    FROM units_and_exercises
    WHERE unit_id = target_unit_id AND prev_exercise_id IS NULL;
    
    -- If no roots or multiple roots, fix it
    IF null_count <> 1 THEN
        -- Choose an arbitrary exercise as the new root
        UPDATE units_and_exercises
        SET prev_exercise_id = NULL
        WHERE id = (
            SELECT id 
            FROM units_and_exercises
            WHERE unit_id = target_unit_id
            ORDER BY id
            LIMIT 1
        );
        
        -- Reset all other exercises to have no incoming references
        UPDATE units_and_exercises
        SET prev_exercise_id = NULL
        WHERE unit_id = target_unit_id
        AND id <> (
            SELECT id 
            FROM units_and_exercises
            WHERE unit_id = target_unit_id
            ORDER BY id
            LIMIT 1
        );
        
        -- Rebuild chain in order
        WITH RECURSIVE ordered_exercises AS (
            -- Start with the root node
            SELECT id, exercise_id, 1 as position
            FROM units_and_exercises
            WHERE unit_id = target_unit_id AND prev_exercise_id IS NULL
            
            UNION ALL
            
            -- Join with other exercises not yet in chain
            SELECT ue.id, ue.exercise_id, o.position + 1
            FROM units_and_exercises ue
            JOIN ordered_exercises o ON TRUE
            WHERE ue.unit_id = target_unit_id
            AND ue.id NOT IN (SELECT id FROM ordered_exercises)
            AND ue.prev_exercise_id IS NULL
            ORDER BY ue.id
            LIMIT 1
        )
        UPDATE units_and_exercises ue
        SET prev_exercise_id = (
            SELECT exercise_id
            FROM ordered_exercises
            WHERE position = (
                SELECT position FROM ordered_exercises WHERE id = ue.id
            ) - 1
        )
        WHERE ue.unit_id = target_unit_id
        AND ue.id IN (SELECT id FROM ordered_exercises WHERE position > 1);
        
        -- Done rebuilding
        RETURN;
    END IF;
    
    -- If we get here, we have exactly one root. Let's verify connectivity
    SELECT exercise_id INTO current_exercise
    FROM units_and_exercises
    WHERE unit_id = target_unit_id AND prev_exercise_id IS NULL;
    
    visited := ARRAY[current_exercise];
    
    -- Traverse the chain to check for cycles and count reachable nodes
    LOOP
        -- Find next node in chain
        SELECT exercise_id INTO current_exercise
        FROM units_and_exercises
        WHERE unit_id = target_unit_id AND prev_exercise_id = current_exercise;
        
        EXIT WHEN current_exercise IS NULL;
        
        -- Check for cycle
        IF current_exercise = ANY(visited) THEN
            has_cycle := true;
            EXIT;
        END IF;
        
        visited := visited || current_exercise;
        
        -- Safety exit
        IF array_length(visited, 1) >= exercise_count THEN
            EXIT;
        END IF;
    END LOOP;
    
    reached_count := array_length(visited, 1);
    
    -- If cycle detected or not all nodes reachable, rebuild the chain
    IF has_cycle OR reached_count <> exercise_count THEN
        -- First, find all exercises in the unit
        WITH exercises AS (
            SELECT id, exercise_id
            FROM units_and_exercises
            WHERE unit_id = target_unit_id
            ORDER BY id
        ),
        -- Create a numbered sequence
        numbered AS (
            SELECT id, exercise_id, row_number() OVER () as seq
            FROM exercises
        )
        -- Update the chain links
        UPDATE units_and_exercises ue
        SET prev_exercise_id = (
            SELECT exercise_id
            FROM numbered
            WHERE seq = (
                SELECT seq FROM numbered WHERE id = ue.id
            ) - 1
        )
        WHERE ue.unit_id = target_unit_id
        AND ue.id IN (SELECT id FROM numbered WHERE seq > 1);
        
        -- Set the first one as root
        UPDATE units_and_exercises
        SET prev_exercise_id = NULL
        WHERE unit_id = target_unit_id
        AND id = (
            SELECT id FROM numbered WHERE seq = 1
        );
    END IF;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.fix_unit_linked_list(unit_id uuid)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
    null_count int;
    first_exercise uuid;
    current_exercise uuid;
    next_exercise uuid;
    detected_cycle boolean := false;
    visited uuid[];
BEGIN
    -- Count exercises with null prev_exercise_id in this unit
    SELECT COUNT(*) INTO null_count
    FROM units_and_exercises
    WHERE unit_id = unit_id AND prev_exercise_id IS NULL;
    
    -- If there are multiple or no roots, repair the list
    IF null_count <> 1 THEN
        -- Find the first exercise to act as root
        SELECT exercise_id INTO first_exercise
        FROM units_and_exercises
        WHERE unit_id = unit_id
        ORDER BY created_at ASC
        LIMIT 1;
        
        IF first_exercise IS NULL THEN
            -- No exercises in unit, nothing to do
            RETURN;
        END IF;
        
        -- Reset all prev_exercise_id values to NULL to start fresh
        UPDATE units_and_exercises
        SET prev_exercise_id = NULL
        WHERE unit_id = unit_id;
        
        -- Mark the first exercise as the root (it already has NULL prev_exercise_id)
        current_exercise := first_exercise;
        visited := ARRAY[current_exercise];
        
        -- Build a properly linked chain through all remaining exercises
        LOOP
            -- Find another exercise not yet in our chain
            SELECT e.exercise_id INTO next_exercise
            FROM units_and_exercises e
            WHERE e.unit_id = unit_id
            AND e.exercise_id != ALL(visited)
            ORDER BY e.created_at ASC
            LIMIT 1;
            
            EXIT WHEN next_exercise IS NULL;
            
            -- Connect this exercise to our current end of chain
            UPDATE units_and_exercises
            SET prev_exercise_id = current_exercise
            WHERE unit_id = unit_id AND exercise_id = next_exercise;
            
            -- Move to the next exercise
            current_exercise := next_exercise;
            visited := visited || current_exercise;
            
            -- Safety check to prevent infinite loop
            IF array_length(visited, 1) > 1000 THEN
                RAISE EXCEPTION 'Too many exercises in unit chain, possible data corruption';
            END IF;
        END LOOP;
    END IF;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.move_unit_exercise(old_unit_id uuid, new_unit_id uuid, moved_exercise_id uuid, new_prev_exercise_id uuid DEFAULT NULL::uuid)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
declare
    old_prev uuid;
    old_successor uuid;
    new_successor uuid;
    record_exists boolean;
begin
    -- First check if the exercise exists in the old unit
    SELECT EXISTS(
        SELECT 1 FROM units_and_exercises 
        WHERE unit_id = old_unit_id AND exercise_id = moved_exercise_id
    ) INTO record_exists;
    
    IF NOT record_exists THEN
        RAISE EXCEPTION 'Exercise % not found in unit %', moved_exercise_id, old_unit_id;
    END IF;
    
    -- Check that the new_prev_exercise_id is in the target unit if it's not null
    IF new_prev_exercise_id IS NOT NULL THEN
        SELECT EXISTS(
            SELECT 1 FROM units_and_exercises
            WHERE unit_id = new_unit_id AND exercise_id = new_prev_exercise_id
        ) INTO record_exists;
        
        IF NOT record_exists AND old_unit_id <> new_unit_id THEN
            RAISE EXCEPTION 'Previous exercise % not found in target unit %', new_prev_exercise_id, new_unit_id;
        END IF;
    END IF;

    -- Unlink from old unit
    select prev_exercise_id into old_prev
    from units_and_exercises
    where unit_id = old_unit_id and exercise_id = moved_exercise_id;

    select exercise_id into old_successor
    from units_and_exercises
    where unit_id = old_unit_id and prev_exercise_id = moved_exercise_id;

    if old_successor is not null then
        update units_and_exercises
        set prev_exercise_id = old_prev
        where unit_id = old_unit_id and exercise_id = old_successor;
    end if;

    -- Delete from old unit
    delete from units_and_exercises
    where unit_id = old_unit_id and exercise_id = moved_exercise_id;

    -- Get new successor
    if new_prev_exercise_id is not null then
        select exercise_id into new_successor
        from units_and_exercises
        where unit_id = new_unit_id and prev_exercise_id = new_prev_exercise_id
        and exercise_id != moved_exercise_id
        limit 1;
    else
        select exercise_id into new_successor
        from units_and_exercises
        where unit_id = new_unit_id and prev_exercise_id is null
        and exercise_id != moved_exercise_id
        limit 1;
    end if;

    -- Temporarily detach successor to avoid check constraint or unique conflict
    if new_successor is not null then
        update units_and_exercises
        set prev_exercise_id = null
        where unit_id = new_unit_id and exercise_id = new_successor;
    end if;

    -- Insert moved exercise
    insert into units_and_exercises (unit_id, exercise_id, prev_exercise_id)
    values (new_unit_id, moved_exercise_id, new_prev_exercise_id);

    -- Reconnect successor to new exercise
    if new_successor is not null then
        update units_and_exercises
        set prev_exercise_id = moved_exercise_id
        where unit_id = new_unit_id and exercise_id = new_successor;
    end if;
end;
$function$
;

CREATE TRIGGER check_circular_reference BEFORE INSERT OR UPDATE ON public.units_and_exercises FOR EACH ROW EXECUTE FUNCTION check_circular_reference_units_and_exercises();