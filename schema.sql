
SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

CREATE EXTENSION IF NOT EXISTS "pg_net" WITH SCHEMA "extensions";

CREATE EXTENSION IF NOT EXISTS "pgsodium" WITH SCHEMA "pgsodium";

COMMENT ON SCHEMA "public" IS 'standard public schema';

CREATE EXTENSION IF NOT EXISTS "pg_graphql" WITH SCHEMA "graphql";

CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";

CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";

CREATE EXTENSION IF NOT EXISTS "pgjwt" WITH SCHEMA "extensions";

CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";

CREATE TYPE "public"."exercise_type" AS ENUM (
    'exercise_screen',
    'exericse_vr',
    'assessment_screen',
    'assessment_vr'
);

ALTER TYPE "public"."exercise_type" OWNER TO "postgres";

COMMENT ON TYPE "public"."exercise_type" IS 'Type of an exercise e.g. if it''s an assesment it can be tracked, a default exercise is just a video shown etc.';

CREATE TYPE "public"."record_types" AS ENUM (
    'strength',
    'balance',
    'endurance',
    'coordination',
    'motor-function',
    'range-of-motion',
    'other'
);

ALTER TYPE "public"."record_types" OWNER TO "postgres";

CREATE TYPE "public"."therapist_types" AS ENUM (
    'physio',
    'occupational',
    'speech',
    'other'
);

ALTER TYPE "public"."therapist_types" OWNER TO "postgres";

COMMENT ON TYPE "public"."therapist_types" IS 'Type of therapist';

CREATE OR REPLACE FUNCTION "public"."check_and_repair_unit_linked_list"("target_unit_id" "uuid") RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
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
$$;

ALTER FUNCTION "public"."check_and_repair_unit_linked_list"("target_unit_id" "uuid") OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."check_circular_reference_units_and_exercises"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
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
$$;

ALTER FUNCTION "public"."check_circular_reference_units_and_exercises"() OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."default_move_unit_exercise"("old_unit_id" "uuid", "new_unit_id" "uuid", "moved_exercise_id" "uuid", "new_prev_exercise_id" "uuid" DEFAULT NULL::"uuid") RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
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
$$;

ALTER FUNCTION "public"."default_move_unit_exercise"("old_unit_id" "uuid", "new_unit_id" "uuid", "moved_exercise_id" "uuid", "new_prev_exercise_id" "uuid") OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."fix_unit_linked_list"("unit_id" "uuid") RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
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
$$;

ALTER FUNCTION "public"."fix_unit_linked_list"("unit_id" "uuid") OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."handle_new_user"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
begin
insert into public.profiles (
    id, 
    first_name, 
    last_name, 
    user_type, 
    language
  )
  values (
    new.id, 
    new.raw_user_meta_data ->> 'first_name', 
    new.raw_user_meta_data ->> 'last_name', 
    new.raw_user_meta_data ->> 'user_type', 
    new.raw_user_meta_data ->> 'language'
  );
  return new;
end;
$$;

ALTER FUNCTION "public"."handle_new_user"() OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."move_unit_exercise"("old_unit_id" "uuid", "new_unit_id" "uuid", "moved_exercise_id" "uuid", "new_prev_exercise_id" "uuid" DEFAULT NULL::"uuid") RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
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
$$;

ALTER FUNCTION "public"."move_unit_exercise"("old_unit_id" "uuid", "new_unit_id" "uuid", "moved_exercise_id" "uuid", "new_prev_exercise_id" "uuid") OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."prevent_circular_references_assessments_and_tests"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
    current UUID;
    chain_assessment_id UUID;
BEGIN
    -- Get the assessment_id of the new row
    SELECT assessment_id INTO chain_assessment_id
    FROM assessments_and_tests
    WHERE test_id = NEW.test_id;

    -- Start from the new prev_test_id and traverse up the chain
    current := NEW.prev_test_id;

    WHILE current IS NOT NULL LOOP
        -- Check for circular reference
        IF current = NEW.test_id THEN
            RAISE EXCEPTION 'Circular reference detected!';
        END IF;

        -- Get the next parent in the chain and check assessment_id consistency
        SELECT prev_test_id, assessment_id INTO current, chain_assessment_id
        FROM assessments_and_tests
        WHERE test_id = current;

        IF chain_assessment_id IS DISTINCT FROM NEW.assessment_id THEN
            RAISE EXCEPTION 'Chain contains a different assessment_id!';
        END IF;
    END LOOP;

    RETURN NEW;
END;
$$;

ALTER FUNCTION "public"."prevent_circular_references_assessments_and_tests"() OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."prevent_circular_references_default_assessments_and_tests"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
    current UUID;
    chain_assessment_id UUID;
BEGIN
    -- Get the assessment_id of the new row
    SELECT assessment_id INTO chain_assessment_id
    FROM default_assessments_and_tests
    WHERE test_id = NEW.test_id;

    -- Start from the new prev_test_id and traverse up the chain
    current := NEW.prev_test_id;

    WHILE current IS NOT NULL LOOP
        -- Check for circular reference
        IF current = NEW.test_id THEN
            RAISE EXCEPTION 'Circular reference detected!';
        END IF;

        -- Get the next parent in the chain and check assessment_id consistency
        SELECT prev_test_id, assessment_id INTO current, chain_assessment_id
        FROM default_assessments_and_tests
        WHERE test_id = current;

        IF chain_assessment_id IS DISTINCT FROM NEW.assessment_id THEN
            RAISE EXCEPTION 'Chain contains a different assessment_id!';
        END IF;
    END LOOP;

    RETURN NEW;
END;
$$;

ALTER FUNCTION "public"."prevent_circular_references_default_assessments_and_tests"() OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."prevent_circular_references_default_units_and_exercises"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
    current UUID;
    chain_unit_id UUID;
BEGIN
    -- Get the unit_id of the new row
    SELECT unit_id INTO chain_unit_id
    FROM default_units_and_exercises
    WHERE exercise_id = NEW.exercise_id;

    -- Start from the new prev_exercise_id and traverse up the chain
    current := NEW.prev_exercise_id;

    WHILE current IS NOT NULL LOOP
        -- Check for circular reference
        IF current = NEW.exercise_id THEN
            RAISE EXCEPTION 'Circular reference detected!';
        END IF;

        -- Get the next parent in the chain and check unit_id consistency
        SELECT prev_exercise_id, unit_id INTO current, chain_unit_id
        FROM default_units_and_exercises
        WHERE exercise_id = current;

        IF chain_unit_id IS DISTINCT FROM NEW.unit_id THEN
            RAISE EXCEPTION 'Chain contains a different unit_id!';
        END IF;
    END LOOP;

    RETURN NEW;
END;
$$;

ALTER FUNCTION "public"."prevent_circular_references_default_units_and_exercises"() OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."prevent_circular_references_units_and_exercises"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
    current UUID;
    chain_unit_id UUID;
BEGIN
    -- Get the unit_id of the new row
    SELECT unit_id INTO chain_unit_id
    FROM units_and_exercises
    WHERE exercise_id = NEW.exercise_id;

    -- Start from the new prev_exercise_id and traverse up the chain
    current := NEW.prev_exercise_id;

    WHILE current IS NOT NULL LOOP
        -- Check for circular reference
        IF current = NEW.exercise_id THEN
            RAISE EXCEPTION 'Circular reference detected!';
        END IF;

        -- Get the next parent in the chain and check unit_id consistency
        SELECT prev_exercise_id, unit_id INTO current, chain_unit_id
        FROM units_and_exercises
        WHERE exercise_id = current;

        IF chain_unit_id IS DISTINCT FROM NEW.unit_id THEN
            RAISE EXCEPTION 'Chain contains a different unit_id!';
        END IF;
    END LOOP;

    RETURN NEW;
END;
$$;

ALTER FUNCTION "public"."prevent_circular_references_units_and_exercises"() OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";

CREATE TABLE IF NOT EXISTS "public"."assessments" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "therapist_uid" "uuid" NOT NULL,
    "inherited_default_assessment_id" "uuid",
    "name" "text" NOT NULL,
    "patient_uid" "uuid",
    "description" "text",
    "isTemplate" boolean DEFAULT false NOT NULL
);

ALTER TABLE "public"."assessments" OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."assessments_and_tests" (
    "assessment_id" "uuid" NOT NULL,
    "test_id" "uuid" NOT NULL,
    "prev_test_id" "uuid",
    CONSTRAINT "check_prev_exercise" CHECK (("test_id" <> "prev_test_id"))
);

ALTER TABLE "public"."assessments_and_tests" OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."connection_patient_and_therapists" (
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "family_uid" "uuid" NOT NULL,
    "therapist_uid" "uuid" NOT NULL,
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL
);

ALTER TABLE "public"."connection_patient_and_therapists" OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."default_assessments" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "name" "text" NOT NULL,
    "description" "text"
);

ALTER TABLE "public"."default_assessments" OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."default_assessments_and_tests" (
    "assessment_id" "uuid" NOT NULL,
    "test_id" "uuid" NOT NULL,
    "prev_test_id" "uuid",
    CONSTRAINT "check_prev_exercise" CHECK (("test_id" <> "prev_test_id"))
);

ALTER TABLE "public"."default_assessments_and_tests" OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."default_exercise_instructions" (
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "video_urls" "text",
    "image_urls" "text",
    "description" "text",
    "id" "uuid" NOT NULL
);

ALTER TABLE "public"."default_exercise_instructions" OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."default_exercises" (
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "name" "text" NOT NULL,
    "description" "text" NOT NULL,
    "thumbnail_url" "text",
    "duration_seconds_goal" smallint,
    "repetitions_goal" smallint,
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "focus_type" "public"."record_types",
    "image_urls" "text"[],
    "video_urls" "text"[],
    "creator_username" "text" DEFAULT 'Kymu'::"text",
    "default_exercise_instruction_id" "uuid"
);

ALTER TABLE "public"."default_exercises" OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."default_test_instructions" (
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "video_urls" "text",
    "image_urls" "text",
    "description" "text",
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "Name" "text" NOT NULL
);

ALTER TABLE "public"."default_test_instructions" OWNER TO "postgres";

COMMENT ON TABLE "public"."default_test_instructions" IS 'This is a duplicate of default_exercise_instructions';

CREATE TABLE IF NOT EXISTS "public"."default_tests" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "name" "text" NOT NULL,
    "description" "text",
    "default_test_instruction_id" "uuid" NOT NULL,
    "test_focus" "public"."record_types" NOT NULL,
    "data" "jsonb"
);

ALTER TABLE "public"."default_tests" OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."default_units" (
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "name" "text" NOT NULL,
    "description" "text",
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "start_assessment_id" "uuid",
    "end_assessment_id" "uuid"
);

ALTER TABLE "public"."default_units" OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."default_units_and_exercises" (
    "exercise_id" "uuid" NOT NULL,
    "unit_id" "uuid" NOT NULL,
    "prev_exercise_id" "uuid",
    CONSTRAINT "check_prev_exercise" CHECK (("exercise_id" <> "prev_exercise_id"))
);

ALTER TABLE "public"."default_units_and_exercises" OWNER TO "postgres";

COMMENT ON TABLE "public"."default_units_and_exercises" IS 'This is a duplicate of units_exercises';

CREATE TABLE IF NOT EXISTS "public"."exercise_categories" (
    "id" bigint NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "name" "text" NOT NULL,
    "data" "jsonb" NOT NULL
);

ALTER TABLE "public"."exercise_categories" OWNER TO "postgres";

ALTER TABLE "public"."exercise_categories" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."exercise_categories_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

CREATE TABLE IF NOT EXISTS "public"."exercise_instructions" (
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "video_urls" "text",
    "image_urls" "text",
    "description" "text",
    "therapist_uid" "uuid" NOT NULL,
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL
);

ALTER TABLE "public"."exercise_instructions" OWNER TO "postgres";

COMMENT ON TABLE "public"."exercise_instructions" IS 'This is a duplicate of default_exercise_instructions';

CREATE TABLE IF NOT EXISTS "public"."exercises" (
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "duration_seconds_goal" smallint,
    "repetitions_goal" smallint,
    "family_scene_adjustment_access" boolean DEFAULT true NOT NULL,
    "therapist_uid" "uuid" NOT NULL,
    "name" "text" DEFAULT 'Exercise'::"text" NOT NULL,
    "focus_type" "public"."record_types" DEFAULT 'strength'::"public"."record_types" NOT NULL,
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "inherited_default_exercise" "uuid",
    "is_template" boolean,
    "description" "text",
    "therapist_added_image_urls" "text"[],
    "therapist_added_video_urls" "text"[],
    "exercise_instruction_ids" bigint[],
    "exercise_type" "public"."exercise_type" DEFAULT 'exercise_screen'::"public"."exercise_type" NOT NULL,
    "data" "jsonb"
);

ALTER TABLE "public"."exercises" OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."patient_records" (
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "patient_uid" "uuid" NOT NULL,
    "focus_type" "public"."record_types" NOT NULL,
    "data" "jsonb" NOT NULL,
    "exercise_id" "uuid",
    "assessment_id" "uuid",
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "session_id" "uuid"
);

ALTER TABLE "public"."patient_records" OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."patient_sessions" (
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "patient_uid" "uuid",
    "id" "uuid" NOT NULL
);

ALTER TABLE "public"."patient_sessions" OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."patients" (
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "patient_first_name" "text" NOT NULL,
    "patient_last_name" "text" NOT NULL,
    "uid" "uuid" NOT NULL,
    "caregiver_first_name" "text",
    "caregiver_last_name" "text",
    "therapist_uid" "uuid" NOT NULL
);

ALTER TABLE "public"."patients" OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."profiles" (
    "id" "uuid" NOT NULL,
    "first_name" "text",
    "last_name" "text",
    "user_type" "text",
    "language" "text"
);

ALTER TABLE "public"."profiles" OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."tests" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "name" "text" NOT NULL,
    "description" "text",
    "default_test_instruction_id" "uuid" NOT NULL,
    "test_focus" "public"."record_types" NOT NULL,
    "data" "jsonb",
    "therapist_uid" "uuid" NOT NULL,
    "inherited_default_test_id" "uuid"
);

ALTER TABLE "public"."tests" OWNER TO "postgres";

COMMENT ON TABLE "public"."tests" IS 'This is a duplicate of default_tests';

CREATE TABLE IF NOT EXISTS "public"."therapists" (
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "first_name" "text" NOT NULL,
    "last_name" "text" NOT NULL,
    "prefix_phone_number" "text",
    "phone_number" "text",
    "country" "text",
    "street" "text",
    "street_number" "text",
    "postal_code" "text",
    "city" "text",
    "uid" "uuid" NOT NULL,
    "avatar_url" "text",
    "language" "text" DEFAULT 'de-CH'::"text",
    "therapist_type" "public"."therapist_types" NOT NULL
);

ALTER TABLE "public"."therapists" OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."units" (
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "patient_uid" "uuid" NOT NULL,
    "therapist_uid" "uuid" NOT NULL,
    "name" "text" NOT NULL,
    "description" "text",
    "is_template" boolean DEFAULT false NOT NULL,
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "inherited_default_unit" "uuid",
    "isFocus" boolean DEFAULT false NOT NULL,
    "start_assessment_id" "uuid",
    "end_assessment_id" "uuid"
);

ALTER TABLE "public"."units" OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."units_and_exercises" (
    "exercise_id" "uuid" NOT NULL,
    "unit_id" "uuid" NOT NULL,
    "prev_exercise_id" "uuid",
    CONSTRAINT "check_prev_exercise" CHECK (("exercise_id" <> "prev_exercise_id"))
);

ALTER TABLE "public"."units_and_exercises" OWNER TO "postgres";

ALTER TABLE ONLY "public"."assessments_and_tests"
    ADD CONSTRAINT "assesments_and_tests_prev_test_id_key" UNIQUE ("prev_test_id");

ALTER TABLE ONLY "public"."assessments_and_tests"
    ADD CONSTRAINT "assessments_and_tests_pkey" PRIMARY KEY ("assessment_id", "test_id");

ALTER TABLE ONLY "public"."assessments"
    ADD CONSTRAINT "assessments_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."connection_patient_and_therapists"
    ADD CONSTRAINT "connection_families_and_therapists_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."default_assessments_and_tests"
    ADD CONSTRAINT "default_assesments_and_tests_pkey" PRIMARY KEY ("assessment_id", "test_id");

ALTER TABLE ONLY "public"."default_assessments_and_tests"
    ADD CONSTRAINT "default_assesments_and_tests_prev_test_id_key" UNIQUE ("prev_test_id");

ALTER TABLE ONLY "public"."default_test_instructions"
    ADD CONSTRAINT "default_assessment_instructions_id_key" UNIQUE ("id");

ALTER TABLE ONLY "public"."default_test_instructions"
    ADD CONSTRAINT "default_assessment_instructions_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."default_exercise_instructions"
    ADD CONSTRAINT "default_exercise_instructions_id_key" UNIQUE ("id");

ALTER TABLE ONLY "public"."default_exercise_instructions"
    ADD CONSTRAINT "default_exercise_instructions_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."default_exercises"
    ADD CONSTRAINT "default_exercises_id_key" UNIQUE ("id");

ALTER TABLE ONLY "public"."default_exercises"
    ADD CONSTRAINT "default_exercises_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."default_assessments"
    ADD CONSTRAINT "default_mp_assesments_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."default_tests"
    ADD CONSTRAINT "default_tests_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."default_units_and_exercises"
    ADD CONSTRAINT "default_units_and_exercises_exercise_id_key" UNIQUE ("exercise_id");

ALTER TABLE ONLY "public"."default_units_and_exercises"
    ADD CONSTRAINT "default_units_exercises_pkey" PRIMARY KEY ("exercise_id", "unit_id");

ALTER TABLE ONLY "public"."default_units_and_exercises"
    ADD CONSTRAINT "default_units_exercises_prev_exercise_id_key" UNIQUE ("prev_exercise_id");

ALTER TABLE ONLY "public"."default_units"
    ADD CONSTRAINT "default_units_id_key" UNIQUE ("id");

ALTER TABLE ONLY "public"."default_units"
    ADD CONSTRAINT "default_units_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."exercise_categories"
    ADD CONSTRAINT "exercise_categories_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."exercise_instructions"
    ADD CONSTRAINT "exercise_instructions_id_key" UNIQUE ("id");

ALTER TABLE ONLY "public"."exercise_instructions"
    ADD CONSTRAINT "exercise_instructions_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."exercises"
    ADD CONSTRAINT "exercises_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."patient_records"
    ADD CONSTRAINT "patient_records_id_key" UNIQUE ("id");

ALTER TABLE ONLY "public"."patient_records"
    ADD CONSTRAINT "patient_records_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."patient_sessions"
    ADD CONSTRAINT "patient_sessions_id_n_key" UNIQUE ("id");

ALTER TABLE ONLY "public"."patient_sessions"
    ADD CONSTRAINT "patient_sessions_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."patients"
    ADD CONSTRAINT "patients_pkey" PRIMARY KEY ("uid");

ALTER TABLE ONLY "public"."patients"
    ADD CONSTRAINT "patients_uid_key" UNIQUE ("uid");

ALTER TABLE ONLY "public"."profiles"
    ADD CONSTRAINT "profiles_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."tests"
    ADD CONSTRAINT "tests_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."therapists"
    ADD CONSTRAINT "therapists_avatar_url_key" UNIQUE ("avatar_url");

ALTER TABLE ONLY "public"."therapists"
    ADD CONSTRAINT "therapists_pkey" PRIMARY KEY ("uid");

ALTER TABLE ONLY "public"."therapists"
    ADD CONSTRAINT "therapists_uid_key" UNIQUE ("uid");

ALTER TABLE ONLY "public"."units_and_exercises"
    ADD CONSTRAINT "units_and_exercises_exercise_id_key" UNIQUE ("exercise_id");

ALTER TABLE ONLY "public"."units_and_exercises"
    ADD CONSTRAINT "units_exercises_pkey" PRIMARY KEY ("exercise_id", "unit_id");

ALTER TABLE ONLY "public"."units_and_exercises"
    ADD CONSTRAINT "units_exercises_prev_exercise_id_key" UNIQUE ("prev_exercise_id");

ALTER TABLE ONLY "public"."units"
    ADD CONSTRAINT "units_pkey" PRIMARY KEY ("id");

CREATE INDEX "idx_training_plans_patient_id" ON "public"."units" USING "btree" ("patient_uid");

CREATE INDEX "idx_training_plans_patient_uid" ON "public"."units" USING "btree" ("patient_uid");

CREATE INDEX "idx_training_plans_therapist_uid" ON "public"."units" USING "btree" ("therapist_uid");

CREATE INDEX "idx_vr_sessions_patient_id" ON "public"."patient_sessions" USING "btree" ("patient_uid");

CREATE INDEX "idx_vr_sessions_patient_uid" ON "public"."patient_sessions" USING "btree" ("patient_uid");

CREATE OR REPLACE TRIGGER "check_circular_reference" BEFORE INSERT OR UPDATE ON "public"."units_and_exercises" FOR EACH ROW EXECUTE FUNCTION "public"."check_circular_reference_units_and_exercises"();

CREATE OR REPLACE TRIGGER "check_circular_reference_assessments_and_tests" BEFORE INSERT OR UPDATE ON "public"."assessments_and_tests" FOR EACH ROW EXECUTE FUNCTION "public"."prevent_circular_references_assessments_and_tests"();

CREATE OR REPLACE TRIGGER "check_circular_reference_default_assessments_and_tests" BEFORE INSERT OR UPDATE ON "public"."default_assessments_and_tests" FOR EACH ROW EXECUTE FUNCTION "public"."prevent_circular_references_default_assessments_and_tests"();

CREATE OR REPLACE TRIGGER "check_circular_reference_default_units_and_exercises" BEFORE INSERT OR UPDATE ON "public"."default_units_and_exercises" FOR EACH ROW EXECUTE FUNCTION "public"."prevent_circular_references_default_units_and_exercises"();

ALTER TABLE ONLY "public"."patient_records"
    ADD CONSTRAINT "patient_achievements_patient_uid_fkey" FOREIGN KEY ("patient_uid") REFERENCES "public"."patients"("uid") ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY "public"."patients"
    ADD CONSTRAINT "patients_uid_fkey" FOREIGN KEY ("uid") REFERENCES "auth"."users"("id") ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY "public"."profiles"
    ADD CONSTRAINT "profiles_id_fkey" FOREIGN KEY ("id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."assessments_and_tests"
    ADD CONSTRAINT "public_assesments_and_tests_assesment_id_fkey" FOREIGN KEY ("assessment_id") REFERENCES "public"."assessments"("id") ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY "public"."assessments_and_tests"
    ADD CONSTRAINT "public_assesments_and_tests_prev_test_id_fkey" FOREIGN KEY ("prev_test_id") REFERENCES "public"."tests"("id") ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE ONLY "public"."assessments_and_tests"
    ADD CONSTRAINT "public_assesments_and_tests_test_id_fkey" FOREIGN KEY ("test_id") REFERENCES "public"."tests"("id") ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY "public"."assessments"
    ADD CONSTRAINT "public_assessments_inherited_default_assessment_id_fkey" FOREIGN KEY ("inherited_default_assessment_id") REFERENCES "public"."default_assessments"("id") ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY "public"."assessments"
    ADD CONSTRAINT "public_assessments_patient_uid_fkey" FOREIGN KEY ("patient_uid") REFERENCES "public"."patients"("uid") ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE ONLY "public"."assessments"
    ADD CONSTRAINT "public_assessments_therapist_uid_fkey" FOREIGN KEY ("therapist_uid") REFERENCES "public"."therapists"("uid") ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY "public"."connection_patient_and_therapists"
    ADD CONSTRAINT "public_connection_families_and_therapists_family_id_fkey" FOREIGN KEY ("family_uid") REFERENCES "public"."patients"("uid") ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY "public"."connection_patient_and_therapists"
    ADD CONSTRAINT "public_connection_families_and_therapists_therapist_id_fkey" FOREIGN KEY ("therapist_uid") REFERENCES "public"."therapists"("uid") ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY "public"."default_assessments_and_tests"
    ADD CONSTRAINT "public_default_assesments_and_tests_assesment_id_fkey" FOREIGN KEY ("assessment_id") REFERENCES "public"."default_assessments"("id") ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY "public"."default_assessments_and_tests"
    ADD CONSTRAINT "public_default_assesments_and_tests_prev_test_id_fkey" FOREIGN KEY ("prev_test_id") REFERENCES "public"."default_tests"("id") ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE ONLY "public"."default_assessments_and_tests"
    ADD CONSTRAINT "public_default_assesments_and_tests_test_id_fkey" FOREIGN KEY ("test_id") REFERENCES "public"."default_tests"("id") ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY "public"."default_exercises"
    ADD CONSTRAINT "public_default_exercises_default_exercise_instruction_id_fkey" FOREIGN KEY ("default_exercise_instruction_id") REFERENCES "public"."default_exercise_instructions"("id") ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY "public"."default_tests"
    ADD CONSTRAINT "public_default_tests_default_test_instruction_id_fkey" FOREIGN KEY ("default_test_instruction_id") REFERENCES "public"."default_test_instructions"("id") ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY "public"."default_units"
    ADD CONSTRAINT "public_default_units_end_assessment_id_fkey" FOREIGN KEY ("end_assessment_id") REFERENCES "public"."default_assessments"("id") ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY "public"."default_units_and_exercises"
    ADD CONSTRAINT "public_default_units_exercises_exercise_id_fkey" FOREIGN KEY ("exercise_id") REFERENCES "public"."default_exercises"("id") ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY "public"."default_units_and_exercises"
    ADD CONSTRAINT "public_default_units_exercises_prev_exercise_id_fkey" FOREIGN KEY ("prev_exercise_id") REFERENCES "public"."default_exercises"("id") ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE ONLY "public"."default_units_and_exercises"
    ADD CONSTRAINT "public_default_units_exercises_unit_id_fkey" FOREIGN KEY ("unit_id") REFERENCES "public"."default_units"("id") ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY "public"."default_units"
    ADD CONSTRAINT "public_default_units_start_assessment_id_fkey" FOREIGN KEY ("start_assessment_id") REFERENCES "public"."default_assessments"("id") ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY "public"."exercise_instructions"
    ADD CONSTRAINT "public_exercise_instructions_therapist_uid_fkey" FOREIGN KEY ("therapist_uid") REFERENCES "public"."therapists"("uid") ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY "public"."exercises"
    ADD CONSTRAINT "public_exercises_inherited_default_exercise_fkey" FOREIGN KEY ("inherited_default_exercise") REFERENCES "public"."default_exercises"("id") ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE ONLY "public"."patients"
    ADD CONSTRAINT "public_families_therapist_uid_fkey" FOREIGN KEY ("therapist_uid") REFERENCES "public"."therapists"("uid");

ALTER TABLE ONLY "public"."patient_records"
    ADD CONSTRAINT "public_patient_exercise_records_exercise_id_fkey" FOREIGN KEY ("exercise_id") REFERENCES "public"."exercises"("id") ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY "public"."patient_records"
    ADD CONSTRAINT "public_patient_records_assessment_id_fkey" FOREIGN KEY ("assessment_id") REFERENCES "public"."assessments"("id") ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY "public"."patient_records"
    ADD CONSTRAINT "public_patient_records_session_id_fkey" FOREIGN KEY ("session_id") REFERENCES "public"."patient_sessions"("id") ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY "public"."tests"
    ADD CONSTRAINT "public_tests_default_test_instruction_id_fkey" FOREIGN KEY ("default_test_instruction_id") REFERENCES "public"."default_test_instructions"("id") ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY "public"."tests"
    ADD CONSTRAINT "public_tests_inherited_default_test_fkey" FOREIGN KEY ("inherited_default_test_id") REFERENCES "public"."default_tests"("id") ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE ONLY "public"."tests"
    ADD CONSTRAINT "public_tests_therapist_uid_fkey" FOREIGN KEY ("therapist_uid") REFERENCES "public"."therapists"("uid") ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY "public"."exercises"
    ADD CONSTRAINT "public_training_block_exercises_therapist_uid_fkey" FOREIGN KEY ("therapist_uid") REFERENCES "public"."therapists"("uid") ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY "public"."units"
    ADD CONSTRAINT "public_units_end_assessment_id_fkey" FOREIGN KEY ("end_assessment_id") REFERENCES "public"."assessments"("id") ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY "public"."units_and_exercises"
    ADD CONSTRAINT "public_units_exercises_exercise_id_fkey" FOREIGN KEY ("exercise_id") REFERENCES "public"."exercises"("id") ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY "public"."units_and_exercises"
    ADD CONSTRAINT "public_units_exercises_prev_exercise_id_fkey" FOREIGN KEY ("prev_exercise_id") REFERENCES "public"."exercises"("id") ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE ONLY "public"."units_and_exercises"
    ADD CONSTRAINT "public_units_exercises_unit_id_fkey" FOREIGN KEY ("unit_id") REFERENCES "public"."units"("id") ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY "public"."units"
    ADD CONSTRAINT "public_units_inherited_default_unit_fkey" FOREIGN KEY ("inherited_default_unit") REFERENCES "public"."default_units"("id") ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE ONLY "public"."units"
    ADD CONSTRAINT "public_units_start_assessment_id_fkey" FOREIGN KEY ("start_assessment_id") REFERENCES "public"."assessments"("id") ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY "public"."therapists"
    ADD CONSTRAINT "therapists_uid_fkey" FOREIGN KEY ("uid") REFERENCES "auth"."users"("id") ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY "public"."units"
    ADD CONSTRAINT "training_plans_patient_id_fkey" FOREIGN KEY ("patient_uid") REFERENCES "public"."patients"("uid") ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY "public"."units"
    ADD CONSTRAINT "training_plans_therapist_id_fkey" FOREIGN KEY ("therapist_uid") REFERENCES "public"."therapists"("uid") ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY "public"."patient_sessions"
    ADD CONSTRAINT "vr_sessions_patient_id_fkey" FOREIGN KEY ("patient_uid") REFERENCES "public"."patients"("uid") ON UPDATE CASCADE ON DELETE CASCADE;

CREATE POLICY "Enable delete for users based on therapist_uid" ON "public"."exercises" FOR DELETE USING (("auth"."uid"() = "therapist_uid"));

CREATE POLICY "Enable delete for users based on therapist_uid" ON "public"."units" FOR DELETE USING (("auth"."uid"() = "therapist_uid"));

CREATE POLICY "Enable delete for users based on user_id" ON "public"."patients" FOR SELECT USING (("auth"."uid"() = "uid"));

CREATE POLICY "Enable families read for therapists based on therapist_uid" ON "public"."patients" FOR SELECT USING (("auth"."uid"() = "therapist_uid"));

CREATE POLICY "Enable insert for authenticated users only" ON "public"."units_and_exercises" TO "authenticated" WITH CHECK (true);

CREATE POLICY "Enable insert for users based on therapist_uid" ON "public"."exercises" FOR INSERT WITH CHECK (("auth"."uid"() = "therapist_uid"));

CREATE POLICY "Enable insert for users based on therapist_uid" ON "public"."units" FOR INSERT WITH CHECK (("auth"."uid"() = "therapist_uid"));

CREATE POLICY "Enable read access for all auth users" ON "public"."default_units_and_exercises" FOR SELECT TO "authenticated" USING (true);

CREATE POLICY "Enable read access for all authenticated users" ON "public"."default_assessments" FOR SELECT TO "authenticated" USING (true);

CREATE POLICY "Enable read access for all authenticated users" ON "public"."default_test_instructions" FOR SELECT TO "authenticated" USING (true);

CREATE POLICY "Enable read access for all authenticated users" ON "public"."default_tests" FOR SELECT TO "authenticated" USING (true);

CREATE POLICY "Enable read access for all users" ON "public"."default_assessments_and_tests" FOR SELECT TO "authenticated" USING (true);

CREATE POLICY "Enable read access for all users" ON "public"."default_exercise_instructions" FOR SELECT TO "authenticated" USING (true);

CREATE POLICY "Enable read access for all users" ON "public"."default_exercises" FOR SELECT USING (true);

CREATE POLICY "Enable read access for all users" ON "public"."default_units" FOR SELECT TO "authenticated" USING (true);

CREATE POLICY "Enable read access for all users" ON "public"."profiles" FOR SELECT TO "authenticated" USING (true);

CREATE POLICY "Enable select for users based on therapist_uid" ON "public"."exercises" FOR SELECT USING (("auth"."uid"() = "therapist_uid"));

CREATE POLICY "Enable select for users based on therapist_uid" ON "public"."units" FOR SELECT USING (("auth"."uid"() = "therapist_uid"));

CREATE POLICY "Enable update for users based on therapist_uid" ON "public"."exercises" FOR UPDATE USING (("auth"."uid"() = "therapist_uid"));

CREATE POLICY "Enable update for users based on therapist_uid" ON "public"."units" FOR UPDATE USING (("auth"."uid"() = "therapist_uid"));

CREATE POLICY "all_authenticated_assessments" ON "public"."assessments" TO "authenticated" USING (true) WITH CHECK (true);

CREATE POLICY "all_authenticated_assessments_and_tests" ON "public"."assessments_and_tests" TO "authenticated" USING (true) WITH CHECK (true);

CREATE POLICY "all_authenticated_connection_patient_and_therapists" ON "public"."connection_patient_and_therapists" TO "authenticated" USING (true) WITH CHECK (true);

CREATE POLICY "all_authenticated_default_assessments" ON "public"."default_assessments" TO "authenticated" USING (true) WITH CHECK (true);

CREATE POLICY "all_authenticated_default_assessments_and_tests" ON "public"."default_assessments_and_tests" TO "authenticated" USING (true) WITH CHECK (true);

CREATE POLICY "all_authenticated_default_exercise_instructions" ON "public"."default_exercise_instructions" TO "authenticated" USING (true) WITH CHECK (true);

CREATE POLICY "all_authenticated_default_exercises" ON "public"."default_exercises" TO "authenticated" USING (true) WITH CHECK (true);

CREATE POLICY "all_authenticated_default_test_instructions" ON "public"."default_test_instructions" TO "authenticated" USING (true) WITH CHECK (true);

CREATE POLICY "all_authenticated_default_tests" ON "public"."default_tests" TO "authenticated" USING (true) WITH CHECK (true);

CREATE POLICY "all_authenticated_default_units" ON "public"."default_units" TO "authenticated" USING (true) WITH CHECK (true);

CREATE POLICY "all_authenticated_default_units_and_exercises" ON "public"."default_units_and_exercises" TO "authenticated" USING (true) WITH CHECK (true);

CREATE POLICY "all_authenticated_exercise_instructions" ON "public"."exercise_instructions" TO "authenticated" USING (true) WITH CHECK (true);

CREATE POLICY "all_authenticated_exercises" ON "public"."exercises" TO "authenticated" USING (true) WITH CHECK (true);

CREATE POLICY "all_authenticated_patient_records" ON "public"."patient_records" TO "authenticated" USING (true) WITH CHECK (true);

CREATE POLICY "all_authenticated_patient_sessions" ON "public"."patient_sessions" TO "authenticated" USING (true) WITH CHECK (true);

CREATE POLICY "all_authenticated_patients" ON "public"."patients" TO "authenticated" USING (true) WITH CHECK (true);

CREATE POLICY "all_authenticated_profiles" ON "public"."profiles" TO "authenticated" USING (true) WITH CHECK (true);

CREATE POLICY "all_authenticated_tests" ON "public"."tests" TO "authenticated" USING (true) WITH CHECK (true);

CREATE POLICY "all_authenticated_therapists" ON "public"."therapists" TO "authenticated" USING (true) WITH CHECK (true);

CREATE POLICY "all_authenticated_units" ON "public"."units" TO "authenticated" USING (true) WITH CHECK (true);

CREATE POLICY "all_authenticated_units_and_exercises" ON "public"."units_and_exercises" TO "authenticated" USING (true) WITH CHECK (true);

ALTER TABLE "public"."assessments" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."assessments_and_tests" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."connection_patient_and_therapists" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."default_assessments" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."default_assessments_and_tests" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."default_exercise_instructions" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."default_exercises" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."default_test_instructions" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."default_tests" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."default_units" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."default_units_and_exercises" ENABLE ROW LEVEL SECURITY;

CREATE POLICY "delete_connection_families_and_therapists_as_family" ON "public"."connection_patient_and_therapists" FOR DELETE USING (("family_uid" = "auth"."uid"()));

CREATE POLICY "delete_exercise_instruction_as_therapist" ON "public"."exercise_instructions" FOR DELETE USING (("therapist_uid" = "auth"."uid"()));

CREATE POLICY "delete_families_and_therapists_as_therapist" ON "public"."connection_patient_and_therapists" FOR DELETE USING (("therapist_uid" = "auth"."uid"()));

CREATE POLICY "delete_own_assessments" ON "public"."assessments" FOR DELETE USING (("therapist_uid" = "auth"."uid"()));

CREATE POLICY "delete_own_therapists" ON "public"."therapists" FOR DELETE USING (("uid" = "auth"."uid"()));

CREATE POLICY "delete_patient_record_as_patient" ON "public"."patient_records" FOR DELETE USING (("patient_uid" = "auth"."uid"()));

CREATE POLICY "delete_patient_session_as_patient" ON "public"."patient_sessions" FOR DELETE USING (("patient_uid" = "auth"."uid"()));

ALTER TABLE "public"."exercise_categories" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."exercise_instructions" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."exercises" ENABLE ROW LEVEL SECURITY;

CREATE POLICY "insert_connection_families_and_therapists_as_family" ON "public"."connection_patient_and_therapists" FOR INSERT WITH CHECK (("family_uid" = "auth"."uid"()));

CREATE POLICY "insert_exercise_instruction_as_therapist" ON "public"."exercise_instructions" FOR INSERT WITH CHECK (("therapist_uid" = "auth"."uid"()));

CREATE POLICY "insert_families_and_therapists_as_therapist" ON "public"."connection_patient_and_therapists" FOR INSERT WITH CHECK (("therapist_uid" = "auth"."uid"()));

CREATE POLICY "insert_own_assessments" ON "public"."assessments" FOR INSERT WITH CHECK (("therapist_uid" = "auth"."uid"()));

CREATE POLICY "insert_own_therapists" ON "public"."therapists" FOR INSERT WITH CHECK (("uid" = "auth"."uid"()));

CREATE POLICY "insert_patient_record_as_patient" ON "public"."patient_records" FOR INSERT WITH CHECK (("patient_uid" = "auth"."uid"()));

CREATE POLICY "insert_patient_session_as_patient" ON "public"."patient_sessions" FOR INSERT WITH CHECK (("patient_uid" = "auth"."uid"()));

CREATE POLICY "patient_access_policy" ON "public"."assessments_and_tests" USING ((EXISTS ( SELECT 1
   FROM "public"."assessments"
  WHERE (("assessments"."id" = "assessments_and_tests"."assessment_id") AND ("assessments"."patient_uid" = "auth"."uid"()))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."assessments"
  WHERE (("assessments"."id" = "assessments_and_tests"."assessment_id") AND ("assessments"."patient_uid" = "auth"."uid"())))));

CREATE POLICY "patient_access_policy" ON "public"."units_and_exercises" USING ((EXISTS ( SELECT 1
   FROM "public"."units"
  WHERE (("units"."id" = "units_and_exercises"."unit_id") AND ("units"."patient_uid" = "auth"."uid"())))));

ALTER TABLE "public"."patient_records" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."patient_sessions" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."patients" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."profiles" ENABLE ROW LEVEL SECURITY;

CREATE POLICY "select_connection_families_and_therapists_as_family" ON "public"."connection_patient_and_therapists" FOR SELECT USING (("family_uid" = "auth"."uid"()));

CREATE POLICY "select_exercise_instruction_as_therapist" ON "public"."exercise_instructions" FOR SELECT USING (("therapist_uid" = "auth"."uid"()));

CREATE POLICY "select_families_and_therapists_as_therapist" ON "public"."connection_patient_and_therapists" FOR SELECT USING (("therapist_uid" = "auth"."uid"()));

CREATE POLICY "select_own_assessments" ON "public"."assessments" FOR SELECT USING (("therapist_uid" = "auth"."uid"()));

CREATE POLICY "select_own_therapists" ON "public"."therapists" FOR SELECT USING (("uid" = "auth"."uid"()));

CREATE POLICY "select_patient_record_as_patient" ON "public"."patient_records" FOR SELECT USING (("patient_uid" = "auth"."uid"()));

CREATE POLICY "select_patient_session_as_patient" ON "public"."patient_sessions" FOR SELECT USING (("patient_uid" = "auth"."uid"()));

ALTER TABLE "public"."tests" ENABLE ROW LEVEL SECURITY;

CREATE POLICY "therapist_access_policy" ON "public"."assessments_and_tests" USING ((EXISTS ( SELECT 1
   FROM "public"."assessments"
  WHERE (("assessments"."id" = "assessments_and_tests"."assessment_id") AND ("assessments"."therapist_uid" = "auth"."uid"()))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."assessments"
  WHERE (("assessments"."id" = "assessments_and_tests"."assessment_id") AND ("assessments"."therapist_uid" = "auth"."uid"())))));

CREATE POLICY "therapist_access_policy" ON "public"."tests" USING (("therapist_uid" = "auth"."uid"()));

CREATE POLICY "therapist_access_policy" ON "public"."units_and_exercises" USING ((EXISTS ( SELECT 1
   FROM "public"."units"
  WHERE (("units"."id" = "units_and_exercises"."unit_id") AND ("units"."therapist_uid" = "auth"."uid"())))));

ALTER TABLE "public"."therapists" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."units" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."units_and_exercises" ENABLE ROW LEVEL SECURITY;

CREATE POLICY "update_connection_families_and_therapists_as_family" ON "public"."connection_patient_and_therapists" FOR UPDATE USING (("family_uid" = "auth"."uid"()));

CREATE POLICY "update_exercise_instruction_as_therapist" ON "public"."exercise_instructions" FOR UPDATE USING (("therapist_uid" = "auth"."uid"()));

CREATE POLICY "update_families_and_therapists_as_therapist" ON "public"."connection_patient_and_therapists" FOR UPDATE USING (("therapist_uid" = "auth"."uid"()));

CREATE POLICY "update_own_assessments" ON "public"."assessments" FOR UPDATE USING (("therapist_uid" = "auth"."uid"()));

CREATE POLICY "update_own_therapists" ON "public"."therapists" FOR UPDATE USING (("uid" = "auth"."uid"()));

CREATE POLICY "update_patient_record_as_patient" ON "public"."patient_records" FOR UPDATE USING (("patient_uid" = "auth"."uid"()));

CREATE POLICY "update_patient_session_as_patient" ON "public"."patient_sessions" FOR UPDATE USING (("patient_uid" = "auth"."uid"()));

ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";

GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";

GRANT ALL ON FUNCTION "public"."check_and_repair_unit_linked_list"("target_unit_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."check_and_repair_unit_linked_list"("target_unit_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."check_and_repair_unit_linked_list"("target_unit_id" "uuid") TO "service_role";

GRANT ALL ON FUNCTION "public"."check_circular_reference_units_and_exercises"() TO "anon";
GRANT ALL ON FUNCTION "public"."check_circular_reference_units_and_exercises"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."check_circular_reference_units_and_exercises"() TO "service_role";

GRANT ALL ON FUNCTION "public"."default_move_unit_exercise"("old_unit_id" "uuid", "new_unit_id" "uuid", "moved_exercise_id" "uuid", "new_prev_exercise_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."default_move_unit_exercise"("old_unit_id" "uuid", "new_unit_id" "uuid", "moved_exercise_id" "uuid", "new_prev_exercise_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."default_move_unit_exercise"("old_unit_id" "uuid", "new_unit_id" "uuid", "moved_exercise_id" "uuid", "new_prev_exercise_id" "uuid") TO "service_role";

GRANT ALL ON FUNCTION "public"."fix_unit_linked_list"("unit_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."fix_unit_linked_list"("unit_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."fix_unit_linked_list"("unit_id" "uuid") TO "service_role";

GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "anon";
GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "service_role";

GRANT ALL ON FUNCTION "public"."move_unit_exercise"("old_unit_id" "uuid", "new_unit_id" "uuid", "moved_exercise_id" "uuid", "new_prev_exercise_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."move_unit_exercise"("old_unit_id" "uuid", "new_unit_id" "uuid", "moved_exercise_id" "uuid", "new_prev_exercise_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."move_unit_exercise"("old_unit_id" "uuid", "new_unit_id" "uuid", "moved_exercise_id" "uuid", "new_prev_exercise_id" "uuid") TO "service_role";

GRANT ALL ON FUNCTION "public"."prevent_circular_references_assessments_and_tests"() TO "anon";
GRANT ALL ON FUNCTION "public"."prevent_circular_references_assessments_and_tests"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."prevent_circular_references_assessments_and_tests"() TO "service_role";

GRANT ALL ON FUNCTION "public"."prevent_circular_references_default_assessments_and_tests"() TO "anon";
GRANT ALL ON FUNCTION "public"."prevent_circular_references_default_assessments_and_tests"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."prevent_circular_references_default_assessments_and_tests"() TO "service_role";

GRANT ALL ON FUNCTION "public"."prevent_circular_references_default_units_and_exercises"() TO "anon";
GRANT ALL ON FUNCTION "public"."prevent_circular_references_default_units_and_exercises"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."prevent_circular_references_default_units_and_exercises"() TO "service_role";

GRANT ALL ON FUNCTION "public"."prevent_circular_references_units_and_exercises"() TO "anon";
GRANT ALL ON FUNCTION "public"."prevent_circular_references_units_and_exercises"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."prevent_circular_references_units_and_exercises"() TO "service_role";

GRANT ALL ON TABLE "public"."assessments" TO "anon";
GRANT ALL ON TABLE "public"."assessments" TO "authenticated";
GRANT ALL ON TABLE "public"."assessments" TO "service_role";

GRANT ALL ON TABLE "public"."assessments_and_tests" TO "anon";
GRANT ALL ON TABLE "public"."assessments_and_tests" TO "authenticated";
GRANT ALL ON TABLE "public"."assessments_and_tests" TO "service_role";

GRANT ALL ON TABLE "public"."connection_patient_and_therapists" TO "anon";
GRANT ALL ON TABLE "public"."connection_patient_and_therapists" TO "authenticated";
GRANT ALL ON TABLE "public"."connection_patient_and_therapists" TO "service_role";

GRANT ALL ON TABLE "public"."default_assessments" TO "anon";
GRANT ALL ON TABLE "public"."default_assessments" TO "authenticated";
GRANT ALL ON TABLE "public"."default_assessments" TO "service_role";

GRANT ALL ON TABLE "public"."default_assessments_and_tests" TO "anon";
GRANT ALL ON TABLE "public"."default_assessments_and_tests" TO "authenticated";
GRANT ALL ON TABLE "public"."default_assessments_and_tests" TO "service_role";

GRANT ALL ON TABLE "public"."default_exercise_instructions" TO "anon";
GRANT ALL ON TABLE "public"."default_exercise_instructions" TO "authenticated";
GRANT ALL ON TABLE "public"."default_exercise_instructions" TO "service_role";

GRANT ALL ON TABLE "public"."default_exercises" TO "anon";
GRANT ALL ON TABLE "public"."default_exercises" TO "authenticated";
GRANT ALL ON TABLE "public"."default_exercises" TO "service_role";

GRANT ALL ON TABLE "public"."default_test_instructions" TO "anon";
GRANT ALL ON TABLE "public"."default_test_instructions" TO "authenticated";
GRANT ALL ON TABLE "public"."default_test_instructions" TO "service_role";

GRANT ALL ON TABLE "public"."default_tests" TO "anon";
GRANT ALL ON TABLE "public"."default_tests" TO "authenticated";
GRANT ALL ON TABLE "public"."default_tests" TO "service_role";

GRANT ALL ON TABLE "public"."default_units" TO "anon";
GRANT ALL ON TABLE "public"."default_units" TO "authenticated";
GRANT ALL ON TABLE "public"."default_units" TO "service_role";

GRANT ALL ON TABLE "public"."default_units_and_exercises" TO "anon";
GRANT ALL ON TABLE "public"."default_units_and_exercises" TO "authenticated";
GRANT ALL ON TABLE "public"."default_units_and_exercises" TO "service_role";

GRANT ALL ON TABLE "public"."exercise_categories" TO "anon";
GRANT ALL ON TABLE "public"."exercise_categories" TO "authenticated";
GRANT ALL ON TABLE "public"."exercise_categories" TO "service_role";

GRANT ALL ON SEQUENCE "public"."exercise_categories_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."exercise_categories_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."exercise_categories_id_seq" TO "service_role";

GRANT ALL ON TABLE "public"."exercise_instructions" TO "anon";
GRANT ALL ON TABLE "public"."exercise_instructions" TO "authenticated";
GRANT ALL ON TABLE "public"."exercise_instructions" TO "service_role";

GRANT ALL ON TABLE "public"."exercises" TO "anon";
GRANT ALL ON TABLE "public"."exercises" TO "authenticated";
GRANT ALL ON TABLE "public"."exercises" TO "service_role";

GRANT ALL ON TABLE "public"."patient_records" TO "anon";
GRANT ALL ON TABLE "public"."patient_records" TO "authenticated";
GRANT ALL ON TABLE "public"."patient_records" TO "service_role";

GRANT ALL ON TABLE "public"."patient_sessions" TO "anon";
GRANT ALL ON TABLE "public"."patient_sessions" TO "authenticated";
GRANT ALL ON TABLE "public"."patient_sessions" TO "service_role";

GRANT ALL ON TABLE "public"."patients" TO "anon";
GRANT ALL ON TABLE "public"."patients" TO "authenticated";
GRANT ALL ON TABLE "public"."patients" TO "service_role";

GRANT ALL ON TABLE "public"."profiles" TO "anon";
GRANT ALL ON TABLE "public"."profiles" TO "authenticated";
GRANT ALL ON TABLE "public"."profiles" TO "service_role";

GRANT ALL ON TABLE "public"."tests" TO "anon";
GRANT ALL ON TABLE "public"."tests" TO "authenticated";
GRANT ALL ON TABLE "public"."tests" TO "service_role";

GRANT ALL ON TABLE "public"."therapists" TO "anon";
GRANT ALL ON TABLE "public"."therapists" TO "authenticated";
GRANT ALL ON TABLE "public"."therapists" TO "service_role";

GRANT ALL ON TABLE "public"."units" TO "anon";
GRANT ALL ON TABLE "public"."units" TO "authenticated";
GRANT ALL ON TABLE "public"."units" TO "service_role";

GRANT ALL ON TABLE "public"."units_and_exercises" TO "anon";
GRANT ALL ON TABLE "public"."units_and_exercises" TO "authenticated";
GRANT ALL ON TABLE "public"."units_and_exercises" TO "service_role";

ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "service_role";

ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "service_role";

ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "service_role";

RESET ALL;
