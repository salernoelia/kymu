drop trigger if exists "check_circular_reference_units_and_exercises" on "public"."units_and_exercises";

drop policy "Enable read access for all auth users" on "public"."units_and_exercises";

alter table "public"."assessments" add column "description" text;

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.check_circular_reference_units_and_exercises()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
    current UUID;
    current_unit_id UUID;
BEGIN
    -- Skip check if no previous exercise
    IF NEW.prev_exercise_id IS NULL THEN
        RETURN NEW;
    END IF;
    
    -- Check that the previous exercise exists in the same unit
    SELECT unit_id INTO current_unit_id
    FROM units_and_exercises
    WHERE exercise_id = NEW.prev_exercise_id;
    
    -- If prev_exercise_id doesn't exist or is in a different unit, reject
    IF current_unit_id IS NULL THEN
        -- Previous exercise doesn't exist, set to null instead of rejecting
        NEW.prev_exercise_id := NULL;
        RETURN NEW;
    END IF;
    
    IF current_unit_id != NEW.unit_id THEN
        RAISE EXCEPTION 'Previous exercise must be in the same unit';
    END IF;
    
    -- Check for circular references
    current := NEW.prev_exercise_id;
    
    WHILE current IS NOT NULL LOOP
        -- Check for circular reference
        IF current = NEW.exercise_id THEN
            RAISE EXCEPTION 'Circular reference detected';
        END IF;
        
        -- Get the next link in the chain
        SELECT prev_exercise_id INTO current
        FROM units_and_exercises
        WHERE exercise_id = current AND unit_id = NEW.unit_id;
        
        -- Exit if we've reached the end of the chain or found a reference to a non-existent exercise
        IF current IS NULL THEN
            EXIT;
        END IF;
    END LOOP;
    
    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.default_move_unit_exercise(old_unit_id uuid, new_unit_id uuid, moved_exercise_id uuid, new_prev_exercise_id uuid DEFAULT NULL::uuid)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
declare
    old_prev uuid;
    old_successor uuid;
    new_successor uuid;
begin
    -- Unlink from old unit
    select prev_exercise_id into old_prev
    from default_units_and_exercises
    where unit_id = old_unit_id and exercise_id = moved_exercise_id;

    select exercise_id into old_successor
    from default_units_and_exercises
    where unit_id = old_unit_id and prev_exercise_id = moved_exercise_id;

    if old_successor is not null then
        update default_units_and_exercises
        set prev_exercise_id = old_prev
        where unit_id = old_unit_id and exercise_id = old_successor;
    end if;

    -- Delete from old unit
    delete from default_units_and_exercises
    where unit_id = old_unit_id and exercise_id = moved_exercise_id;

    -- Get new successor
    if new_prev_exercise_id is not null then
        select exercise_id into new_successor
        from default_units_and_exercises
        where unit_id = new_unit_id and prev_exercise_id = new_prev_exercise_id
        and exercise_id != moved_exercise_id
        limit 1;
    else
        select exercise_id into new_successor
        from default_units_and_exercises
        where unit_id = new_unit_id and prev_exercise_id is null
        and exercise_id != moved_exercise_id
        limit 1;
    end if;

    -- Temporarily detach successor to avoid check constraint or unique conflict
    if new_successor is not null then
        update default_units_and_exercises
        set prev_exercise_id = null
        where unit_id = new_unit_id and exercise_id = new_successor;
    end if;

    -- Insert moved exercise
    insert into default_units_and_exercises (unit_id, exercise_id, prev_exercise_id)
    values (new_unit_id, moved_exercise_id, new_prev_exercise_id);

    -- Reconnect successor to new exercise
    if new_successor is not null then
        update default_units_and_exercises
        set prev_exercise_id = moved_exercise_id
        where unit_id = new_unit_id and exercise_id = new_successor;
    end if;
end;
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
begin
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

create policy "Enable insert for authenticated users only"
on "public"."units_and_exercises"
as permissive
for all
to authenticated
with check (true);


CREATE TRIGGER check_circular_reference BEFORE INSERT OR UPDATE ON public.units_and_exercises FOR EACH STATEMENT EXECUTE FUNCTION check_circular_reference_units_and_exercises();