revoke delete on table "public"."patient_exercise_records" from "anon";

revoke insert on table "public"."patient_exercise_records" from "anon";

revoke references on table "public"."patient_exercise_records" from "anon";

revoke select on table "public"."patient_exercise_records" from "anon";

revoke trigger on table "public"."patient_exercise_records" from "anon";

revoke truncate on table "public"."patient_exercise_records" from "anon";

revoke update on table "public"."patient_exercise_records" from "anon";

revoke delete on table "public"."patient_exercise_records" from "authenticated";

revoke insert on table "public"."patient_exercise_records" from "authenticated";

revoke references on table "public"."patient_exercise_records" from "authenticated";

revoke select on table "public"."patient_exercise_records" from "authenticated";

revoke trigger on table "public"."patient_exercise_records" from "authenticated";

revoke truncate on table "public"."patient_exercise_records" from "authenticated";

revoke update on table "public"."patient_exercise_records" from "authenticated";

revoke delete on table "public"."patient_exercise_records" from "service_role";

revoke insert on table "public"."patient_exercise_records" from "service_role";

revoke references on table "public"."patient_exercise_records" from "service_role";

revoke select on table "public"."patient_exercise_records" from "service_role";

revoke trigger on table "public"."patient_exercise_records" from "service_role";

revoke truncate on table "public"."patient_exercise_records" from "service_role";

revoke update on table "public"."patient_exercise_records" from "service_role";

alter table "public"."patient_exercise_records" drop constraint "patient_achievements_patient_uid_fkey";

alter table "public"."patient_exercise_records" drop constraint "patient_achievements_vr_session_id_fkey";

alter table "public"."patient_exercise_records" drop constraint "public_patient_exercise_records_exercise_id_fkey";

alter table "public"."patient_exercise_records" drop constraint "patient_achievements_pkey";

alter table "public"."patient_sessions" drop constraint "vr_sessions_pkey";

drop index if exists "public"."patient_achievements_pkey";

drop index if exists "public"."vr_sessions_pkey";

drop table "public"."patient_exercise_records";

create table "public"."assessments" (
    "id" uuid not null default gen_random_uuid(),
    "created_at" timestamp with time zone not null default now(),
    "therapist_uid" uuid not null,
    "patient_uid" uuid not null,
    "test_ids" uuid[],
    "inherited_default_assessment_id" uuid
);


alter table "public"."assessments" enable row level security;

create table "public"."default_assessments" (
    "id" uuid not null default gen_random_uuid(),
    "created_at" timestamp with time zone not null default now(),
    "default_test_ids" text[] not null,
    "name" text not null,
    "description" text
);


alter table "public"."default_assessments" enable row level security;

create table "public"."default_test_instructions" (
    "created_at" timestamp with time zone not null default now(),
    "video_urls" text,
    "image_urls" text,
    "description" text,
    "id" uuid not null
);


alter table "public"."default_test_instructions" enable row level security;

create table "public"."default_tests" (
    "id" uuid not null default gen_random_uuid(),
    "created_at" timestamp with time zone not null default now(),
    "name" text not null,
    "description" text,
    "default_test_instruction_id" uuid not null,
    "test_focus" text,
    "data" jsonb
);


alter table "public"."default_tests" enable row level security;

create table "public"."patient_records" (
    "created_at" timestamp with time zone not null default now(),
    "patient_uid" uuid not null,
    "focus_type" record_types not null,
    "data" jsonb not null,
    "exercise_id" uuid,
    "assessment_id" uuid,
    "id" uuid not null default gen_random_uuid(),
    "session_id" uuid
);


alter table "public"."patient_records" enable row level security;

-- alter table "public"."default_exercise_instructions" alter column "id" drop identity;

-- Drop the identity property first
alter table "public"."exercise_instructions" alter column "id" drop identity;

-- Add a temporary UUID column
ALTER TABLE "public"."exercise_instructions" ADD COLUMN "temp_id" uuid DEFAULT gen_random_uuid();

-- Update the temporary column with UUIDs
UPDATE "public"."exercise_instructions" 
SET "temp_id" = gen_random_uuid();

-- Drop the old ID column
ALTER TABLE "public"."exercise_instructions" DROP COLUMN "id";

-- Rename the temporary column to id
ALTER TABLE "public"."exercise_instructions" RENAME COLUMN "temp_id" TO "id";

-- Add constraints back to the ID column
ALTER TABLE "public"."exercise_instructions" ALTER COLUMN "id" SET NOT NULL;
ALTER TABLE "public"."exercise_instructions" ADD PRIMARY KEY ("id");


alter table "public"."default_exercises" drop column "default_exercise_instruction_ids";

alter table "public"."default_exercises" add column "default_exercise_instruction_id" uuid;

alter table "public"."exercise_instructions" alter column "id" set default gen_random_uuid();

-- alter table "public"."exercise_instructions" alter column "id" drop identity;

-- alter table "public"."exercise_instructions" alter column "id" set data type uuid using "id"::uuid;

-- alter table "public"."patient_sessions" alter column "id" drop identity;

-- alter table "public"."patient_sessions" alter column "id" set data type uuid using "id"::uuid;

alter table "public"."patient_sessions" alter column "id" drop identity;

-- Add a temporary UUID column
ALTER TABLE "public"."patient_sessions" ADD COLUMN "temp_id" uuid DEFAULT gen_random_uuid();

-- Update the temporary column with UUIDs
UPDATE "public"."patient_sessions" 
SET "temp_id" = gen_random_uuid();

-- Drop the old ID column
ALTER TABLE "public"."patient_sessions" DROP COLUMN "id";

-- Rename the temporary column to id
ALTER TABLE "public"."patient_sessions" RENAME COLUMN "temp_id" TO "id";

-- Add constraints back to the ID column
ALTER TABLE "public"."patient_sessions" ALTER COLUMN "id" SET NOT NULL;
ALTER TABLE "public"."patient_sessions" ALTER COLUMN "id" SET DEFAULT gen_random_uuid();
-- Note: The primary key constraint will be added later in your script using the index

CREATE UNIQUE INDEX assessments_pkey ON public.assessments USING btree (id);

CREATE UNIQUE INDEX default_assessment_instructions_id_key ON public.default_test_instructions USING btree (id);

CREATE UNIQUE INDEX default_assessment_instructions_pkey ON public.default_test_instructions USING btree (id);

CREATE UNIQUE INDEX default_exercise_instructions_id_key ON public.default_exercise_instructions USING btree (id);

CREATE UNIQUE INDEX default_mp_assesments_pkey ON public.default_assessments USING btree (id);

CREATE UNIQUE INDEX default_tests_pkey ON public.default_tests USING btree (id);

CREATE UNIQUE INDEX exercise_instructions_id_key ON public.exercise_instructions USING btree (id);

CREATE UNIQUE INDEX patient_records_id_key ON public.patient_records USING btree (id);

CREATE UNIQUE INDEX patient_records_pkey ON public.patient_records USING btree (id);

CREATE UNIQUE INDEX patient_sessions_id_n_key ON public.patient_sessions USING btree (id);

CREATE UNIQUE INDEX patient_sessions_pkey ON public.patient_sessions USING btree (id);

alter table "public"."assessments" add constraint "assessments_pkey" PRIMARY KEY using index "assessments_pkey";

alter table "public"."default_assessments" add constraint "default_mp_assesments_pkey" PRIMARY KEY using index "default_mp_assesments_pkey";

alter table "public"."default_test_instructions" add constraint "default_assessment_instructions_pkey" PRIMARY KEY using index "default_assessment_instructions_pkey";

alter table "public"."default_tests" add constraint "default_tests_pkey" PRIMARY KEY using index "default_tests_pkey";

alter table "public"."patient_records" add constraint "patient_records_pkey" PRIMARY KEY using index "patient_records_pkey";

alter table "public"."patient_sessions" add constraint "patient_sessions_pkey" PRIMARY KEY using index "patient_sessions_pkey";

alter table "public"."assessments" add constraint "public_assessments_inherited_default_assessment_id_fkey" FOREIGN KEY (inherited_default_assessment_id) REFERENCES default_assessments(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."assessments" validate constraint "public_assessments_inherited_default_assessment_id_fkey";

alter table "public"."assessments" add constraint "public_assessments_patient_uid_fkey" FOREIGN KEY (patient_uid) REFERENCES families(uid) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."assessments" validate constraint "public_assessments_patient_uid_fkey";

alter table "public"."assessments" add constraint "public_assessments_therapist_uid_fkey" FOREIGN KEY (therapist_uid) REFERENCES therapists(uid) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."assessments" validate constraint "public_assessments_therapist_uid_fkey";

alter table "public"."default_exercise_instructions" add constraint "default_exercise_instructions_id_key" UNIQUE using index "default_exercise_instructions_id_key";

-- Add this before the constraint creation:

-- Convert default_exercise_instructions.id to UUID
-- Drop the identity property first (if it has one)
alter table "public"."default_exercise_instructions" alter column "id" drop identity if exists;

-- Add a temporary UUID column
ALTER TABLE "public"."default_exercise_instructions" ADD COLUMN "temp_id" uuid DEFAULT gen_random_uuid();

-- Update the temporary column with UUIDs
UPDATE "public"."default_exercise_instructions" 
SET "temp_id" = gen_random_uuid();

-- Drop the old ID column
ALTER TABLE "public"."default_exercise_instructions" DROP COLUMN "id";

-- Rename the temporary column to id
ALTER TABLE "public"."default_exercise_instructions" RENAME COLUMN "temp_id" TO "id";

-- Add constraints back to the ID column
ALTER TABLE "public"."default_exercise_instructions" ALTER COLUMN "id" SET NOT NULL;
ALTER TABLE "public"."default_exercise_instructions" ADD PRIMARY KEY ("id");
ALTER TABLE "public"."default_exercise_instructions" ALTER COLUMN "id" SET DEFAULT gen_random_uuid();

alter table "public"."default_exercises" add constraint "public_default_exercises_default_exercise_instruction_id_fkey" FOREIGN KEY (default_exercise_instruction_id) REFERENCES default_exercise_instructions(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."default_exercises" validate constraint "public_default_exercises_default_exercise_instruction_id_fkey";

alter table "public"."default_test_instructions" add constraint "default_assessment_instructions_id_key" UNIQUE using index "default_assessment_instructions_id_key";

alter table "public"."default_tests" add constraint "public_default_tests_default_test_instruction_id_fkey" FOREIGN KEY (default_test_instruction_id) REFERENCES default_test_instructions(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."default_tests" validate constraint "public_default_tests_default_test_instruction_id_fkey";

alter table "public"."exercise_instructions" add constraint "exercise_instructions_id_key" UNIQUE using index "exercise_instructions_id_key";

alter table "public"."patient_records" add constraint "patient_achievements_patient_uid_fkey" FOREIGN KEY (patient_uid) REFERENCES families(uid) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."patient_records" validate constraint "patient_achievements_patient_uid_fkey";

alter table "public"."patient_records" add constraint "patient_records_id_key" UNIQUE using index "patient_records_id_key";

alter table "public"."patient_records" add constraint "public_patient_exercise_records_exercise_id_fkey" FOREIGN KEY (exercise_id) REFERENCES exercises(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."patient_records" validate constraint "public_patient_exercise_records_exercise_id_fkey";

alter table "public"."patient_records" add constraint "public_patient_records_assessment_id_fkey" FOREIGN KEY (assessment_id) REFERENCES assessments(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."patient_records" validate constraint "public_patient_records_assessment_id_fkey";

alter table "public"."patient_records" add constraint "public_patient_records_session_id_fkey" FOREIGN KEY (session_id) REFERENCES patient_sessions(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."patient_records" validate constraint "public_patient_records_session_id_fkey";

alter table "public"."patient_sessions" add constraint "patient_sessions_id_n_key" UNIQUE using index "patient_sessions_id_n_key";

grant delete on table "public"."assessments" to "anon";

grant insert on table "public"."assessments" to "anon";

grant references on table "public"."assessments" to "anon";

grant select on table "public"."assessments" to "anon";

grant trigger on table "public"."assessments" to "anon";

grant truncate on table "public"."assessments" to "anon";

grant update on table "public"."assessments" to "anon";

grant delete on table "public"."assessments" to "authenticated";

grant insert on table "public"."assessments" to "authenticated";

grant references on table "public"."assessments" to "authenticated";

grant select on table "public"."assessments" to "authenticated";

grant trigger on table "public"."assessments" to "authenticated";

grant truncate on table "public"."assessments" to "authenticated";

grant update on table "public"."assessments" to "authenticated";

grant delete on table "public"."assessments" to "service_role";

grant insert on table "public"."assessments" to "service_role";

grant references on table "public"."assessments" to "service_role";

grant select on table "public"."assessments" to "service_role";

grant trigger on table "public"."assessments" to "service_role";

grant truncate on table "public"."assessments" to "service_role";

grant update on table "public"."assessments" to "service_role";

grant delete on table "public"."default_assessments" to "anon";

grant insert on table "public"."default_assessments" to "anon";

grant references on table "public"."default_assessments" to "anon";

grant select on table "public"."default_assessments" to "anon";

grant trigger on table "public"."default_assessments" to "anon";

grant truncate on table "public"."default_assessments" to "anon";

grant update on table "public"."default_assessments" to "anon";

grant delete on table "public"."default_assessments" to "authenticated";

grant insert on table "public"."default_assessments" to "authenticated";

grant references on table "public"."default_assessments" to "authenticated";

grant select on table "public"."default_assessments" to "authenticated";

grant trigger on table "public"."default_assessments" to "authenticated";

grant truncate on table "public"."default_assessments" to "authenticated";

grant update on table "public"."default_assessments" to "authenticated";

grant delete on table "public"."default_assessments" to "service_role";

grant insert on table "public"."default_assessments" to "service_role";

grant references on table "public"."default_assessments" to "service_role";

grant select on table "public"."default_assessments" to "service_role";

grant trigger on table "public"."default_assessments" to "service_role";

grant truncate on table "public"."default_assessments" to "service_role";

grant update on table "public"."default_assessments" to "service_role";

grant delete on table "public"."default_test_instructions" to "anon";

grant insert on table "public"."default_test_instructions" to "anon";

grant references on table "public"."default_test_instructions" to "anon";

grant select on table "public"."default_test_instructions" to "anon";

grant trigger on table "public"."default_test_instructions" to "anon";

grant truncate on table "public"."default_test_instructions" to "anon";

grant update on table "public"."default_test_instructions" to "anon";

grant delete on table "public"."default_test_instructions" to "authenticated";

grant insert on table "public"."default_test_instructions" to "authenticated";

grant references on table "public"."default_test_instructions" to "authenticated";

grant select on table "public"."default_test_instructions" to "authenticated";

grant trigger on table "public"."default_test_instructions" to "authenticated";

grant truncate on table "public"."default_test_instructions" to "authenticated";

grant update on table "public"."default_test_instructions" to "authenticated";

grant delete on table "public"."default_test_instructions" to "service_role";

grant insert on table "public"."default_test_instructions" to "service_role";

grant references on table "public"."default_test_instructions" to "service_role";

grant select on table "public"."default_test_instructions" to "service_role";

grant trigger on table "public"."default_test_instructions" to "service_role";

grant truncate on table "public"."default_test_instructions" to "service_role";

grant update on table "public"."default_test_instructions" to "service_role";

grant delete on table "public"."default_tests" to "anon";

grant insert on table "public"."default_tests" to "anon";

grant references on table "public"."default_tests" to "anon";

grant select on table "public"."default_tests" to "anon";

grant trigger on table "public"."default_tests" to "anon";

grant truncate on table "public"."default_tests" to "anon";

grant update on table "public"."default_tests" to "anon";

grant delete on table "public"."default_tests" to "authenticated";

grant insert on table "public"."default_tests" to "authenticated";

grant references on table "public"."default_tests" to "authenticated";

grant select on table "public"."default_tests" to "authenticated";

grant trigger on table "public"."default_tests" to "authenticated";

grant truncate on table "public"."default_tests" to "authenticated";

grant update on table "public"."default_tests" to "authenticated";

grant delete on table "public"."default_tests" to "service_role";

grant insert on table "public"."default_tests" to "service_role";

grant references on table "public"."default_tests" to "service_role";

grant select on table "public"."default_tests" to "service_role";

grant trigger on table "public"."default_tests" to "service_role";

grant truncate on table "public"."default_tests" to "service_role";

grant update on table "public"."default_tests" to "service_role";

grant delete on table "public"."patient_records" to "anon";

grant insert on table "public"."patient_records" to "anon";

grant references on table "public"."patient_records" to "anon";

grant select on table "public"."patient_records" to "anon";

grant trigger on table "public"."patient_records" to "anon";

grant truncate on table "public"."patient_records" to "anon";

grant update on table "public"."patient_records" to "anon";

grant delete on table "public"."patient_records" to "authenticated";

grant insert on table "public"."patient_records" to "authenticated";

grant references on table "public"."patient_records" to "authenticated";

grant select on table "public"."patient_records" to "authenticated";

grant trigger on table "public"."patient_records" to "authenticated";

grant truncate on table "public"."patient_records" to "authenticated";

grant update on table "public"."patient_records" to "authenticated";

grant delete on table "public"."patient_records" to "service_role";

grant insert on table "public"."patient_records" to "service_role";

grant references on table "public"."patient_records" to "service_role";

grant select on table "public"."patient_records" to "service_role";

grant trigger on table "public"."patient_records" to "service_role";

grant truncate on table "public"."patient_records" to "service_role";

grant update on table "public"."patient_records" to "service_role";