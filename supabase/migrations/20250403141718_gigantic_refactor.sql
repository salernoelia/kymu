drop policy "Enable insert for users based on therapist_uid" on "public"."assessments";

drop policy "Enable select for users based on therapist_uid" on "public"."assessments";

drop policy "Enable therapists read therapists based on uid" on "public"."therapists";

alter table "public"."exercises" drop constraint "public_exercises_training_unit_id_fkey";

alter table "public"."connection_families_and_therapists" drop constraint "public_connection_families_and_therapists_family_id_fkey";

alter table "public"."connection_families_and_therapists" drop constraint "public_connection_families_and_therapists_therapist_id_fkey";

create table "public"."assessments_and_tests" (
    "assessment_id" uuid not null,
    "test_id" uuid not null,
    "prev_test_id" uuid
);


alter table "public"."assessments_and_tests" enable row level security;

create table "public"."default_assessments_and_tests" (
    "assessment_id" uuid not null,
    "test_id" uuid not null,
    "prev_test_id" uuid
);


alter table "public"."default_assessments_and_tests" enable row level security;

create table "public"."default_units_and_exercises" (
    "exercise_id" uuid not null,
    "unit_id" uuid not null,
    "prev_exercise_id" uuid
);


alter table "public"."default_units_and_exercises" enable row level security;

create table "public"."tests" (
    "id" uuid not null default gen_random_uuid(),
    "created_at" timestamp with time zone not null default now(),
    "name" text not null,
    "description" text,
    "default_test_instruction_id" uuid not null,
    "test_focus" record_types not null,
    "data" jsonb,
    "therapist_uid" uuid not null,
    "inherited_default_test_id" uuid
);


alter table "public"."tests" enable row level security;

create table "public"."units_and_exercises" (
    "exercise_id" uuid not null,
    "unit_id" uuid not null,
    "prev_exercise_id" uuid
);


alter table "public"."units_and_exercises" enable row level security;

alter table "public"."assessments" drop column "test_ids";

alter table "public"."assessments" add column "patient_uid" uuid;

alter table "public"."connection_families_and_therapists" drop column "family_id";

alter table "public"."connection_families_and_therapists" drop column "therapist_id";

alter table "public"."connection_families_and_therapists" add column "family_uid" uuid not null;

alter table "public"."connection_families_and_therapists" add column "therapist_uid" uuid not null;

alter table "public"."default_assessments" drop column "default_test_ids";

alter table "public"."default_units" drop column "exercises_index";

alter table "public"."exercises" drop column "unit_id";

alter table "public"."units" drop column "exercises_index";

CREATE UNIQUE INDEX assesments_and_tests_prev_test_id_key ON public.assessments_and_tests USING btree (prev_test_id);

CREATE UNIQUE INDEX assessments_and_tests_pkey ON public.assessments_and_tests USING btree (assessment_id, test_id);

CREATE UNIQUE INDEX default_assesments_and_tests_pkey ON public.default_assessments_and_tests USING btree (assessment_id, test_id);

CREATE UNIQUE INDEX default_assesments_and_tests_prev_test_id_key ON public.default_assessments_and_tests USING btree (prev_test_id);

CREATE UNIQUE INDEX default_units_and_exercises_exercise_id_key ON public.default_units_and_exercises USING btree (exercise_id);

CREATE UNIQUE INDEX default_units_exercises_pkey ON public.default_units_and_exercises USING btree (exercise_id, unit_id);

CREATE UNIQUE INDEX default_units_exercises_prev_exercise_id_key ON public.default_units_and_exercises USING btree (prev_exercise_id);

CREATE UNIQUE INDEX tests_pkey ON public.tests USING btree (id);

CREATE UNIQUE INDEX units_and_exercises_exercise_id_key ON public.units_and_exercises USING btree (exercise_id);

CREATE UNIQUE INDEX units_exercises_pkey ON public.units_and_exercises USING btree (exercise_id, unit_id);

CREATE UNIQUE INDEX units_exercises_prev_exercise_id_key ON public.units_and_exercises USING btree (prev_exercise_id);

alter table "public"."assessments_and_tests" add constraint "assessments_and_tests_pkey" PRIMARY KEY using index "assessments_and_tests_pkey";

alter table "public"."default_assessments_and_tests" add constraint "default_assesments_and_tests_pkey" PRIMARY KEY using index "default_assesments_and_tests_pkey";

alter table "public"."default_units_and_exercises" add constraint "default_units_exercises_pkey" PRIMARY KEY using index "default_units_exercises_pkey";

alter table "public"."tests" add constraint "tests_pkey" PRIMARY KEY using index "tests_pkey";

alter table "public"."units_and_exercises" add constraint "units_exercises_pkey" PRIMARY KEY using index "units_exercises_pkey";

alter table "public"."assessments" add constraint "public_assessments_patient_uid_fkey" FOREIGN KEY (patient_uid) REFERENCES families(uid) ON UPDATE CASCADE ON DELETE SET NULL not valid;

alter table "public"."assessments" validate constraint "public_assessments_patient_uid_fkey";

alter table "public"."assessments_and_tests" add constraint "assesments_and_tests_prev_test_id_key" UNIQUE using index "assesments_and_tests_prev_test_id_key";

alter table "public"."assessments_and_tests" add constraint "check_prev_exercise" CHECK ((test_id <> prev_test_id)) not valid;

alter table "public"."assessments_and_tests" validate constraint "check_prev_exercise";

alter table "public"."assessments_and_tests" add constraint "public_assesments_and_tests_assesment_id_fkey" FOREIGN KEY (assessment_id) REFERENCES assessments(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."assessments_and_tests" validate constraint "public_assesments_and_tests_assesment_id_fkey";

alter table "public"."assessments_and_tests" add constraint "public_assesments_and_tests_prev_test_id_fkey" FOREIGN KEY (prev_test_id) REFERENCES tests(id) ON UPDATE CASCADE ON DELETE SET NULL not valid;

alter table "public"."assessments_and_tests" validate constraint "public_assesments_and_tests_prev_test_id_fkey";

alter table "public"."assessments_and_tests" add constraint "public_assesments_and_tests_test_id_fkey" FOREIGN KEY (test_id) REFERENCES tests(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."assessments_and_tests" validate constraint "public_assesments_and_tests_test_id_fkey";

alter table "public"."default_assessments_and_tests" add constraint "check_prev_exercise" CHECK ((test_id <> prev_test_id)) not valid;

alter table "public"."default_assessments_and_tests" validate constraint "check_prev_exercise";

alter table "public"."default_assessments_and_tests" add constraint "default_assesments_and_tests_prev_test_id_key" UNIQUE using index "default_assesments_and_tests_prev_test_id_key";

alter table "public"."default_assessments_and_tests" add constraint "public_default_assesments_and_tests_assesment_id_fkey" FOREIGN KEY (assessment_id) REFERENCES default_assessments(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."default_assessments_and_tests" validate constraint "public_default_assesments_and_tests_assesment_id_fkey";

alter table "public"."default_assessments_and_tests" add constraint "public_default_assesments_and_tests_prev_test_id_fkey" FOREIGN KEY (prev_test_id) REFERENCES default_tests(id) ON UPDATE CASCADE ON DELETE SET NULL not valid;

alter table "public"."default_assessments_and_tests" validate constraint "public_default_assesments_and_tests_prev_test_id_fkey";

alter table "public"."default_assessments_and_tests" add constraint "public_default_assesments_and_tests_test_id_fkey" FOREIGN KEY (test_id) REFERENCES default_tests(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."default_assessments_and_tests" validate constraint "public_default_assesments_and_tests_test_id_fkey";

alter table "public"."default_units_and_exercises" add constraint "check_prev_exercise" CHECK ((exercise_id <> prev_exercise_id)) not valid;

alter table "public"."default_units_and_exercises" validate constraint "check_prev_exercise";

alter table "public"."default_units_and_exercises" add constraint "default_units_and_exercises_exercise_id_key" UNIQUE using index "default_units_and_exercises_exercise_id_key";

alter table "public"."default_units_and_exercises" add constraint "default_units_exercises_prev_exercise_id_key" UNIQUE using index "default_units_exercises_prev_exercise_id_key";

alter table "public"."default_units_and_exercises" add constraint "public_default_units_exercises_exercise_id_fkey" FOREIGN KEY (exercise_id) REFERENCES default_exercises(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."default_units_and_exercises" validate constraint "public_default_units_exercises_exercise_id_fkey";

alter table "public"."default_units_and_exercises" add constraint "public_default_units_exercises_prev_exercise_id_fkey" FOREIGN KEY (prev_exercise_id) REFERENCES default_exercises(id) ON UPDATE CASCADE ON DELETE SET NULL not valid;

alter table "public"."default_units_and_exercises" validate constraint "public_default_units_exercises_prev_exercise_id_fkey";

alter table "public"."default_units_and_exercises" add constraint "public_default_units_exercises_unit_id_fkey" FOREIGN KEY (unit_id) REFERENCES default_units(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."default_units_and_exercises" validate constraint "public_default_units_exercises_unit_id_fkey";

alter table "public"."tests" add constraint "public_tests_default_test_instruction_id_fkey" FOREIGN KEY (default_test_instruction_id) REFERENCES default_test_instructions(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."tests" validate constraint "public_tests_default_test_instruction_id_fkey";

alter table "public"."tests" add constraint "public_tests_inherited_default_test_fkey" FOREIGN KEY (inherited_default_test_id) REFERENCES default_tests(id) ON UPDATE CASCADE ON DELETE SET NULL not valid;

alter table "public"."tests" validate constraint "public_tests_inherited_default_test_fkey";

alter table "public"."tests" add constraint "public_tests_therapist_uid_fkey" FOREIGN KEY (therapist_uid) REFERENCES therapists(uid) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."tests" validate constraint "public_tests_therapist_uid_fkey";

alter table "public"."units_and_exercises" add constraint "check_prev_exercise" CHECK ((exercise_id <> prev_exercise_id)) not valid;

alter table "public"."units_and_exercises" validate constraint "check_prev_exercise";

alter table "public"."units_and_exercises" add constraint "public_units_exercises_exercise_id_fkey" FOREIGN KEY (exercise_id) REFERENCES exercises(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."units_and_exercises" validate constraint "public_units_exercises_exercise_id_fkey";

alter table "public"."units_and_exercises" add constraint "public_units_exercises_prev_exercise_id_fkey" FOREIGN KEY (prev_exercise_id) REFERENCES exercises(id) ON UPDATE CASCADE ON DELETE SET NULL not valid;

alter table "public"."units_and_exercises" validate constraint "public_units_exercises_prev_exercise_id_fkey";

alter table "public"."units_and_exercises" add constraint "public_units_exercises_unit_id_fkey" FOREIGN KEY (unit_id) REFERENCES units(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."units_and_exercises" validate constraint "public_units_exercises_unit_id_fkey";

alter table "public"."units_and_exercises" add constraint "units_and_exercises_exercise_id_key" UNIQUE using index "units_and_exercises_exercise_id_key";

alter table "public"."units_and_exercises" add constraint "units_exercises_prev_exercise_id_key" UNIQUE using index "units_exercises_prev_exercise_id_key";

alter table "public"."connection_families_and_therapists" add constraint "public_connection_families_and_therapists_family_id_fkey" FOREIGN KEY (family_uid) REFERENCES families(uid) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."connection_families_and_therapists" validate constraint "public_connection_families_and_therapists_family_id_fkey";

alter table "public"."connection_families_and_therapists" add constraint "public_connection_families_and_therapists_therapist_id_fkey" FOREIGN KEY (therapist_uid) REFERENCES therapists(uid) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."connection_families_and_therapists" validate constraint "public_connection_families_and_therapists_therapist_id_fkey";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.prevent_circular_references_assessments_and_tests()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
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
$function$
;

CREATE OR REPLACE FUNCTION public.prevent_circular_references_default_assessments_and_tests()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
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
$function$
;

CREATE OR REPLACE FUNCTION public.prevent_circular_references_default_units_and_exercises()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
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
$function$
;

CREATE OR REPLACE FUNCTION public.prevent_circular_references_units_and_exercises()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
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
$function$
;

grant delete on table "public"."assessments_and_tests" to "anon";

grant insert on table "public"."assessments_and_tests" to "anon";

grant references on table "public"."assessments_and_tests" to "anon";

grant select on table "public"."assessments_and_tests" to "anon";

grant trigger on table "public"."assessments_and_tests" to "anon";

grant truncate on table "public"."assessments_and_tests" to "anon";

grant update on table "public"."assessments_and_tests" to "anon";

grant delete on table "public"."assessments_and_tests" to "authenticated";

grant insert on table "public"."assessments_and_tests" to "authenticated";

grant references on table "public"."assessments_and_tests" to "authenticated";

grant select on table "public"."assessments_and_tests" to "authenticated";

grant trigger on table "public"."assessments_and_tests" to "authenticated";

grant truncate on table "public"."assessments_and_tests" to "authenticated";

grant update on table "public"."assessments_and_tests" to "authenticated";

grant delete on table "public"."assessments_and_tests" to "service_role";

grant insert on table "public"."assessments_and_tests" to "service_role";

grant references on table "public"."assessments_and_tests" to "service_role";

grant select on table "public"."assessments_and_tests" to "service_role";

grant trigger on table "public"."assessments_and_tests" to "service_role";

grant truncate on table "public"."assessments_and_tests" to "service_role";

grant update on table "public"."assessments_and_tests" to "service_role";

grant delete on table "public"."default_assessments_and_tests" to "anon";

grant insert on table "public"."default_assessments_and_tests" to "anon";

grant references on table "public"."default_assessments_and_tests" to "anon";

grant select on table "public"."default_assessments_and_tests" to "anon";

grant trigger on table "public"."default_assessments_and_tests" to "anon";

grant truncate on table "public"."default_assessments_and_tests" to "anon";

grant update on table "public"."default_assessments_and_tests" to "anon";

grant delete on table "public"."default_assessments_and_tests" to "authenticated";

grant insert on table "public"."default_assessments_and_tests" to "authenticated";

grant references on table "public"."default_assessments_and_tests" to "authenticated";

grant select on table "public"."default_assessments_and_tests" to "authenticated";

grant trigger on table "public"."default_assessments_and_tests" to "authenticated";

grant truncate on table "public"."default_assessments_and_tests" to "authenticated";

grant update on table "public"."default_assessments_and_tests" to "authenticated";

grant delete on table "public"."default_assessments_and_tests" to "service_role";

grant insert on table "public"."default_assessments_and_tests" to "service_role";

grant references on table "public"."default_assessments_and_tests" to "service_role";

grant select on table "public"."default_assessments_and_tests" to "service_role";

grant trigger on table "public"."default_assessments_and_tests" to "service_role";

grant truncate on table "public"."default_assessments_and_tests" to "service_role";

grant update on table "public"."default_assessments_and_tests" to "service_role";

grant delete on table "public"."default_units_and_exercises" to "anon";

grant insert on table "public"."default_units_and_exercises" to "anon";

grant references on table "public"."default_units_and_exercises" to "anon";

grant select on table "public"."default_units_and_exercises" to "anon";

grant trigger on table "public"."default_units_and_exercises" to "anon";

grant truncate on table "public"."default_units_and_exercises" to "anon";

grant update on table "public"."default_units_and_exercises" to "anon";

grant delete on table "public"."default_units_and_exercises" to "authenticated";

grant insert on table "public"."default_units_and_exercises" to "authenticated";

grant references on table "public"."default_units_and_exercises" to "authenticated";

grant select on table "public"."default_units_and_exercises" to "authenticated";

grant trigger on table "public"."default_units_and_exercises" to "authenticated";

grant truncate on table "public"."default_units_and_exercises" to "authenticated";

grant update on table "public"."default_units_and_exercises" to "authenticated";

grant delete on table "public"."default_units_and_exercises" to "service_role";

grant insert on table "public"."default_units_and_exercises" to "service_role";

grant references on table "public"."default_units_and_exercises" to "service_role";

grant select on table "public"."default_units_and_exercises" to "service_role";

grant trigger on table "public"."default_units_and_exercises" to "service_role";

grant truncate on table "public"."default_units_and_exercises" to "service_role";

grant update on table "public"."default_units_and_exercises" to "service_role";

grant delete on table "public"."tests" to "anon";

grant insert on table "public"."tests" to "anon";

grant references on table "public"."tests" to "anon";

grant select on table "public"."tests" to "anon";

grant trigger on table "public"."tests" to "anon";

grant truncate on table "public"."tests" to "anon";

grant update on table "public"."tests" to "anon";

grant delete on table "public"."tests" to "authenticated";

grant insert on table "public"."tests" to "authenticated";

grant references on table "public"."tests" to "authenticated";

grant select on table "public"."tests" to "authenticated";

grant trigger on table "public"."tests" to "authenticated";

grant truncate on table "public"."tests" to "authenticated";

grant update on table "public"."tests" to "authenticated";

grant delete on table "public"."tests" to "service_role";

grant insert on table "public"."tests" to "service_role";

grant references on table "public"."tests" to "service_role";

grant select on table "public"."tests" to "service_role";

grant trigger on table "public"."tests" to "service_role";

grant truncate on table "public"."tests" to "service_role";

grant update on table "public"."tests" to "service_role";

grant delete on table "public"."units_and_exercises" to "anon";

grant insert on table "public"."units_and_exercises" to "anon";

grant references on table "public"."units_and_exercises" to "anon";

grant select on table "public"."units_and_exercises" to "anon";

grant trigger on table "public"."units_and_exercises" to "anon";

grant truncate on table "public"."units_and_exercises" to "anon";

grant update on table "public"."units_and_exercises" to "anon";

grant delete on table "public"."units_and_exercises" to "authenticated";

grant insert on table "public"."units_and_exercises" to "authenticated";

grant references on table "public"."units_and_exercises" to "authenticated";

grant select on table "public"."units_and_exercises" to "authenticated";

grant trigger on table "public"."units_and_exercises" to "authenticated";

grant truncate on table "public"."units_and_exercises" to "authenticated";

grant update on table "public"."units_and_exercises" to "authenticated";

grant delete on table "public"."units_and_exercises" to "service_role";

grant insert on table "public"."units_and_exercises" to "service_role";

grant references on table "public"."units_and_exercises" to "service_role";

grant select on table "public"."units_and_exercises" to "service_role";

grant trigger on table "public"."units_and_exercises" to "service_role";

grant truncate on table "public"."units_and_exercises" to "service_role";

grant update on table "public"."units_and_exercises" to "service_role";

create policy "delete_own_assessments"
on "public"."assessments"
as permissive
for delete
to public
using ((therapist_uid = auth.uid()));


create policy "insert_own_assessments"
on "public"."assessments"
as permissive
for insert
to public
with check ((therapist_uid = auth.uid()));


create policy "select_own_assessments"
on "public"."assessments"
as permissive
for select
to public
using ((therapist_uid = auth.uid()));


create policy "update_own_assessments"
on "public"."assessments"
as permissive
for update
to public
using ((therapist_uid = auth.uid()));


create policy "patient_access_policy"
on "public"."assessments_and_tests"
as permissive
for all
to public
using ((EXISTS ( SELECT 1
   FROM assessments
  WHERE ((assessments.id = assessments_and_tests.assessment_id) AND (assessments.patient_uid = auth.uid())))))
with check ((EXISTS ( SELECT 1
   FROM assessments
  WHERE ((assessments.id = assessments_and_tests.assessment_id) AND (assessments.patient_uid = auth.uid())))));


create policy "therapist_access_policy"
on "public"."assessments_and_tests"
as permissive
for all
to public
using ((EXISTS ( SELECT 1
   FROM assessments
  WHERE ((assessments.id = assessments_and_tests.assessment_id) AND (assessments.therapist_uid = auth.uid())))))
with check ((EXISTS ( SELECT 1
   FROM assessments
  WHERE ((assessments.id = assessments_and_tests.assessment_id) AND (assessments.therapist_uid = auth.uid())))));


create policy "delete_connection_families_and_therapists_as_family"
on "public"."connection_families_and_therapists"
as permissive
for delete
to public
using ((family_uid = auth.uid()));


create policy "delete_families_and_therapists_as_therapist"
on "public"."connection_families_and_therapists"
as permissive
for delete
to public
using ((therapist_uid = auth.uid()));


create policy "insert_connection_families_and_therapists_as_family"
on "public"."connection_families_and_therapists"
as permissive
for insert
to public
with check ((family_uid = auth.uid()));


create policy "insert_families_and_therapists_as_therapist"
on "public"."connection_families_and_therapists"
as permissive
for insert
to public
with check ((therapist_uid = auth.uid()));


create policy "select_connection_families_and_therapists_as_family"
on "public"."connection_families_and_therapists"
as permissive
for select
to public
using ((family_uid = auth.uid()));


create policy "select_families_and_therapists_as_therapist"
on "public"."connection_families_and_therapists"
as permissive
for select
to public
using ((therapist_uid = auth.uid()));


create policy "update_connection_families_and_therapists_as_family"
on "public"."connection_families_and_therapists"
as permissive
for update
to public
using ((family_uid = auth.uid()));


create policy "update_families_and_therapists_as_therapist"
on "public"."connection_families_and_therapists"
as permissive
for update
to public
using ((therapist_uid = auth.uid()));


create policy "Enable read access for all users"
on "public"."default_assessments_and_tests"
as permissive
for select
to authenticated
using (true);


create policy "Enable read access for all users"
on "public"."default_exercise_instructions"
as permissive
for select
to authenticated
using (true);


create policy "Enable read access for all auth users"
on "public"."default_units_and_exercises"
as permissive
for select
to authenticated
using (true);


create policy "delete_exercise_instruction_as_therapist"
on "public"."exercise_instructions"
as permissive
for delete
to public
using ((therapist_uid = auth.uid()));


create policy "insert_exercise_instruction_as_therapist"
on "public"."exercise_instructions"
as permissive
for insert
to public
with check ((therapist_uid = auth.uid()));


create policy "select_exercise_instruction_as_therapist"
on "public"."exercise_instructions"
as permissive
for select
to public
using ((therapist_uid = auth.uid()));


create policy "update_exercise_instruction_as_therapist"
on "public"."exercise_instructions"
as permissive
for update
to public
using ((therapist_uid = auth.uid()));


create policy "delete_patient_record_as_patient"
on "public"."patient_records"
as permissive
for delete
to public
using ((patient_uid = auth.uid()));


create policy "insert_patient_record_as_patient"
on "public"."patient_records"
as permissive
for insert
to public
with check ((patient_uid = auth.uid()));


create policy "select_patient_record_as_patient"
on "public"."patient_records"
as permissive
for select
to public
using ((patient_uid = auth.uid()));


create policy "update_patient_record_as_patient"
on "public"."patient_records"
as permissive
for update
to public
using ((patient_uid = auth.uid()));


create policy "delete_patient_session_as_patient"
on "public"."patient_sessions"
as permissive
for delete
to public
using ((patient_uid = auth.uid()));


create policy "insert_patient_session_as_patient"
on "public"."patient_sessions"
as permissive
for insert
to public
with check ((patient_uid = auth.uid()));


create policy "select_patient_session_as_patient"
on "public"."patient_sessions"
as permissive
for select
to public
using ((patient_uid = auth.uid()));


create policy "update_patient_session_as_patient"
on "public"."patient_sessions"
as permissive
for update
to public
using ((patient_uid = auth.uid()));


create policy "Enable read access for all users"
on "public"."profiles"
as permissive
for select
to authenticated
using (true);


create policy "therapist_access_policy"
on "public"."tests"
as permissive
for all
to public
using ((therapist_uid = auth.uid()));


create policy "delete_own_therapists"
on "public"."therapists"
as permissive
for delete
to public
using ((uid = auth.uid()));


create policy "insert_own_therapists"
on "public"."therapists"
as permissive
for insert
to public
with check ((uid = auth.uid()));


create policy "select_own_therapists"
on "public"."therapists"
as permissive
for select
to public
using ((uid = auth.uid()));


create policy "update_own_therapists"
on "public"."therapists"
as permissive
for update
to public
using ((uid = auth.uid()));


create policy "Enable read access for all auth users"
on "public"."units_and_exercises"
as permissive
for select
to authenticated
using (true);


create policy "patient_access_policy"
on "public"."units_and_exercises"
as permissive
for all
to public
using ((EXISTS ( SELECT 1
   FROM units
  WHERE ((units.id = units_and_exercises.unit_id) AND (units.patient_uid = auth.uid())))));


create policy "therapist_access_policy"
on "public"."units_and_exercises"
as permissive
for all
to public
using ((EXISTS ( SELECT 1
   FROM units
  WHERE ((units.id = units_and_exercises.unit_id) AND (units.therapist_uid = auth.uid())))));


CREATE TRIGGER check_circular_reference_assessments_and_tests BEFORE INSERT OR UPDATE ON public.assessments_and_tests FOR EACH ROW EXECUTE FUNCTION prevent_circular_references_assessments_and_tests();

CREATE TRIGGER check_circular_reference_default_assessments_and_tests BEFORE INSERT OR UPDATE ON public.default_assessments_and_tests FOR EACH ROW EXECUTE FUNCTION prevent_circular_references_default_assessments_and_tests();

CREATE TRIGGER check_circular_reference_default_units_and_exercises BEFORE INSERT OR UPDATE ON public.default_units_and_exercises FOR EACH ROW EXECUTE FUNCTION prevent_circular_references_default_units_and_exercises();

CREATE TRIGGER check_circular_reference_units_and_exercises BEFORE INSERT OR UPDATE ON public.units_and_exercises FOR EACH ROW EXECUTE FUNCTION prevent_circular_references_units_and_exercises();