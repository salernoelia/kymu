create type "public"."focus_types" as enum ('strength', 'balance', 'endurance', 'coordination', 'motor function');

create type "public"."therapist_types" as enum ('physio', 'occupational', 'speech', 'other');

drop policy "Enable read access for all users" on "public"."default_unit_templates";

revoke delete on table "public"."default_unit_templates" from "anon";

revoke insert on table "public"."default_unit_templates" from "anon";

revoke references on table "public"."default_unit_templates" from "anon";

revoke select on table "public"."default_unit_templates" from "anon";

revoke trigger on table "public"."default_unit_templates" from "anon";

revoke truncate on table "public"."default_unit_templates" from "anon";

revoke update on table "public"."default_unit_templates" from "anon";

revoke delete on table "public"."default_unit_templates" from "authenticated";

revoke insert on table "public"."default_unit_templates" from "authenticated";

revoke references on table "public"."default_unit_templates" from "authenticated";

revoke select on table "public"."default_unit_templates" from "authenticated";

revoke trigger on table "public"."default_unit_templates" from "authenticated";

revoke truncate on table "public"."default_unit_templates" from "authenticated";

revoke update on table "public"."default_unit_templates" from "authenticated";

revoke delete on table "public"."default_unit_templates" from "service_role";

revoke insert on table "public"."default_unit_templates" from "service_role";

revoke references on table "public"."default_unit_templates" from "service_role";

revoke select on table "public"."default_unit_templates" from "service_role";

revoke trigger on table "public"."default_unit_templates" from "service_role";

revoke truncate on table "public"."default_unit_templates" from "service_role";

revoke update on table "public"."default_unit_templates" from "service_role";

revoke delete on table "public"."specialist_types" from "anon";

revoke insert on table "public"."specialist_types" from "anon";

revoke references on table "public"."specialist_types" from "anon";

revoke select on table "public"."specialist_types" from "anon";

revoke trigger on table "public"."specialist_types" from "anon";

revoke truncate on table "public"."specialist_types" from "anon";

revoke update on table "public"."specialist_types" from "anon";

revoke delete on table "public"."specialist_types" from "authenticated";

revoke insert on table "public"."specialist_types" from "authenticated";

revoke references on table "public"."specialist_types" from "authenticated";

revoke select on table "public"."specialist_types" from "authenticated";

revoke trigger on table "public"."specialist_types" from "authenticated";

revoke truncate on table "public"."specialist_types" from "authenticated";

revoke update on table "public"."specialist_types" from "authenticated";

revoke delete on table "public"."specialist_types" from "service_role";

revoke insert on table "public"."specialist_types" from "service_role";

revoke references on table "public"."specialist_types" from "service_role";

revoke select on table "public"."specialist_types" from "service_role";

revoke trigger on table "public"."specialist_types" from "service_role";

revoke truncate on table "public"."specialist_types" from "service_role";

revoke update on table "public"."specialist_types" from "service_role";

alter table "public"."exercises" drop constraint "public_training_block_exercises_default_exercise_id_fkey";

alter table "public"."exercises" drop constraint "public_training_block_exercises_training_unit_id_fkey";

alter table "public"."patient_achievements" drop constraint "patient_achievements_exercise_id_fkey";

alter table "public"."specialist_types" drop constraint "specialist_types_name_key";



alter table "public"."default_exercises" drop constraint "exercises_pkey";

alter table "public"."default_unit_templates" drop constraint "training_blocks_therapist_templates_pkey";

alter table "public"."exercises" drop constraint "training_plan_selected_exercises_pkey";

alter table "public"."specialist_types" drop constraint "specialist_types_pkey";

alter table "public"."units" drop constraint "training_plans_pkey";

drop index if exists "public"."specialist_types_name_key";

drop index if exists "public"."specialist_types_pkey";

drop index if exists "public"."training_blocks_therapist_templates_pkey";

drop index if exists "public"."training_plan_selected_exercises_pkey";

drop index if exists "public"."training_plans_pkey";

drop index if exists "public"."exercises_pkey";

drop table "public"."default_unit_templates";

drop table "public"."specialist_types";

create table "public"."default_units" (
    "created_at" timestamp with time zone not null default now(),
    "name" text not null,
    "description" text,
    "id" uuid not null default gen_random_uuid(),
    "exercises_index" uuid[] not null
);


alter table "public"."default_units" enable row level security;

-- Step 1: Add a new column with UUID type
ALTER TABLE "public"."connection_families_and_therapists"
ADD COLUMN "new_id" uuid DEFAULT gen_random_uuid();

-- Step 2: Populate the new column with generated UUIDs
UPDATE "public"."connection_families_and_therapists"
SET "new_id" = gen_random_uuid();

-- Step 3: Drop the old id column
ALTER TABLE "public"."connection_families_and_therapists"
DROP COLUMN "id";

-- Step 4: Rename the new column to id
ALTER TABLE "public"."connection_families_and_therapists"
RENAME COLUMN "new_id" TO "id";

alter table "public"."default_exercise_instructions" drop column "3d_animation_urls";

alter table "public"."default_exercise_instructions" add column "3d_animation" text;

alter table "public"."default_exercise_instructions" add column "name" text;

alter table "public"."default_exercises" drop column "possible_exercise_instructions";

alter table "public"."default_exercises" add column "default_exercise_instructions" bigint[] not null;

alter table "public"."default_exercises" alter column "focus_type" drop default;

alter table "public"."default_exercises" alter column "focus_type" drop not null;

alter table "public"."default_exercises" alter column "focus_type" set data type focus_types using "focus_type"::focus_types;

-- Step 1: Add a new column with UUID type
ALTER TABLE "public"."default_exercises"
ADD COLUMN "new_id" uuid DEFAULT gen_random_uuid();

-- Step 2: Populate the new column with generated UUIDs
UPDATE "public"."default_exercises"
SET "new_id" = gen_random_uuid();

-- Step 3: Drop the old id column
ALTER TABLE "public"."default_exercises"
DROP COLUMN "id";

-- Step 4: Rename the new column to id
ALTER TABLE "public"."default_exercises"
RENAME COLUMN "new_id" TO "id";
alter table "public"."exercises" drop column "default_exercise_id";

alter table "public"."exercises" drop column "training_unit_id";

alter table "public"."exercises" add column "inherited_default_exercise" uuid;

alter table "public"."exercises" add column "is_template" boolean;

alter table "public"."exercises" alter column "focus_type" set default 'strength'::focus_types;

alter table "public"."exercises" alter column "focus_type" set data type focus_types using "focus_type"::focus_types;

-- Step 1: Add a new column with UUID type
ALTER TABLE "public"."exercises"
ADD COLUMN "new_id" uuid DEFAULT gen_random_uuid();

-- Step 2: Populate the new column with generated UUIDs
UPDATE "public"."exercises"
SET "new_id" = gen_random_uuid();

-- Step 3: Drop the old id column
ALTER TABLE "public"."exercises"
DROP COLUMN "id";

-- Step 4: Rename the new column to id
ALTER TABLE "public"."exercises"
RENAME COLUMN "new_id" TO "id";

alter table "public"."patient_achievements" alter column "patient_uid" set not null;

alter table "public"."therapists" drop column "specialist_type";

alter table "public"."therapists" add column "therapist_type" therapist_types not null;

alter table "public"."units" add column "inherited_default_unit" uuid;

alter table "public"."units" alter column "exercises_index" drop not null;

-- Step 1: Add a new column with UUID[] type
ALTER TABLE "public"."units"
ADD COLUMN "new_exercises_index" uuid[] DEFAULT '{}';

-- Step 2: Drop the old column (since we can't directly convert bigint[] to uuid[])
ALTER TABLE "public"."units"
DROP COLUMN "exercises_index";

-- Step 3: Rename the new column
ALTER TABLE "public"."units"
RENAME COLUMN "new_exercises_index" TO "exercises_index";

CREATE UNIQUE INDEX default_exercise_instructions_id_key ON public.default_exercise_instructions USING btree (id);

CREATE UNIQUE INDEX default_exercise_instructions_name_key ON public.default_exercise_instructions USING btree (name);

CREATE UNIQUE INDEX default_exercises_id_key ON public.default_exercises USING btree (id);

CREATE UNIQUE INDEX default_exercises_pkey ON public.default_exercises USING btree (id);

CREATE UNIQUE INDEX default_units_id_key ON public.default_units USING btree (id);

CREATE UNIQUE INDEX default_units_pkey ON public.default_units USING btree (id);

CREATE UNIQUE INDEX units_pkey ON public.units USING btree (id);

CREATE UNIQUE INDEX exercises_pkey ON public.exercises USING btree (id);

alter table "public"."default_exercises" add constraint "default_exercises_pkey" PRIMARY KEY using index "default_exercises_pkey";

alter table "public"."default_units" add constraint "default_units_pkey" PRIMARY KEY using index "default_units_pkey";

alter table "public"."exercises" add constraint "exercises_pkey" PRIMARY KEY using index "exercises_pkey";

alter table "public"."units" add constraint "units_pkey" PRIMARY KEY using index "units_pkey";

alter table "public"."default_exercise_instructions" add constraint "default_exercise_instructions_id_key" UNIQUE using index "default_exercise_instructions_id_key";

alter table "public"."default_exercise_instructions" add constraint "default_exercise_instructions_name_key" UNIQUE using index "default_exercise_instructions_name_key";

alter table "public"."default_exercises" add constraint "default_exercises_id_key" UNIQUE using index "default_exercises_id_key";

alter table "public"."default_units" add constraint "default_units_id_key" UNIQUE using index "default_units_id_key";

alter table "public"."exercises" add constraint "public_exercises_inherited_default_exercise_fkey" FOREIGN KEY (inherited_default_exercise) REFERENCES default_exercises(id) ON UPDATE CASCADE ON DELETE SET NULL not valid;

alter table "public"."exercises" validate constraint "public_exercises_inherited_default_exercise_fkey";

alter table "public"."units" add constraint "public_units_inherited_default_unit_fkey" FOREIGN KEY (inherited_default_unit) REFERENCES default_units(id) ON UPDATE CASCADE ON DELETE SET NULL not valid;

alter table "public"."units" validate constraint "public_units_inherited_default_unit_fkey";

grant delete on table "public"."default_units" to "anon";

grant insert on table "public"."default_units" to "anon";

grant references on table "public"."default_units" to "anon";

grant select on table "public"."default_units" to "anon";

grant trigger on table "public"."default_units" to "anon";

grant truncate on table "public"."default_units" to "anon";

grant update on table "public"."default_units" to "anon";

grant delete on table "public"."default_units" to "authenticated";

grant insert on table "public"."default_units" to "authenticated";

grant references on table "public"."default_units" to "authenticated";

grant select on table "public"."default_units" to "authenticated";

grant trigger on table "public"."default_units" to "authenticated";

grant truncate on table "public"."default_units" to "authenticated";

grant update on table "public"."default_units" to "authenticated";

grant delete on table "public"."default_units" to "service_role";

grant insert on table "public"."default_units" to "service_role";

grant references on table "public"."default_units" to "service_role";

grant select on table "public"."default_units" to "service_role";

grant trigger on table "public"."default_units" to "service_role";

grant truncate on table "public"."default_units" to "service_role";

grant update on table "public"."default_units" to "service_role";

create policy "Enable read access for all users"
on "public"."default_units"
as permissive
for select
to authenticated
using (true);