drop policy "Enable insert for users based on therapist_uid" on "public"."training_block_exercises";

drop policy "Enable select for users based on therapist_uid" on "public"."training_block_exercises";

drop policy "Enable update for users based on therapist_uid" on "public"."training_block_exercises";

drop policy "Enable insert for users based on therapist_uid" on "public"."training_blocks";

drop policy "Enable select for users based on therapist_uid" on "public"."training_blocks";

drop policy "Enable update for users based on therapist_uid" on "public"."training_blocks";

drop policy "Enable insert for users based on therapist_uid" on "public"."training_units";

drop policy "Enable select for users based on therapist_uid" on "public"."training_units";

drop policy "Enable update for users based on therapist_uid" on "public"."training_units";

revoke delete on table "public"."training_block_exercises" from "anon";

revoke insert on table "public"."training_block_exercises" from "anon";

revoke references on table "public"."training_block_exercises" from "anon";

revoke select on table "public"."training_block_exercises" from "anon";

revoke trigger on table "public"."training_block_exercises" from "anon";

revoke truncate on table "public"."training_block_exercises" from "anon";

revoke update on table "public"."training_block_exercises" from "anon";

revoke delete on table "public"."training_block_exercises" from "authenticated";

revoke insert on table "public"."training_block_exercises" from "authenticated";

revoke references on table "public"."training_block_exercises" from "authenticated";

revoke select on table "public"."training_block_exercises" from "authenticated";

revoke trigger on table "public"."training_block_exercises" from "authenticated";

revoke truncate on table "public"."training_block_exercises" from "authenticated";

revoke update on table "public"."training_block_exercises" from "authenticated";

revoke delete on table "public"."training_block_exercises" from "service_role";

revoke insert on table "public"."training_block_exercises" from "service_role";

revoke references on table "public"."training_block_exercises" from "service_role";

revoke select on table "public"."training_block_exercises" from "service_role";

revoke trigger on table "public"."training_block_exercises" from "service_role";

revoke truncate on table "public"."training_block_exercises" from "service_role";

revoke update on table "public"."training_block_exercises" from "service_role";

revoke delete on table "public"."training_blocks" from "anon";

revoke insert on table "public"."training_blocks" from "anon";

revoke references on table "public"."training_blocks" from "anon";

revoke select on table "public"."training_blocks" from "anon";

revoke trigger on table "public"."training_blocks" from "anon";

revoke truncate on table "public"."training_blocks" from "anon";

revoke update on table "public"."training_blocks" from "anon";

revoke delete on table "public"."training_blocks" from "authenticated";

revoke insert on table "public"."training_blocks" from "authenticated";

revoke references on table "public"."training_blocks" from "authenticated";

revoke select on table "public"."training_blocks" from "authenticated";

revoke trigger on table "public"."training_blocks" from "authenticated";

revoke truncate on table "public"."training_blocks" from "authenticated";

revoke update on table "public"."training_blocks" from "authenticated";

revoke delete on table "public"."training_blocks" from "service_role";

revoke insert on table "public"."training_blocks" from "service_role";

revoke references on table "public"."training_blocks" from "service_role";

revoke select on table "public"."training_blocks" from "service_role";

revoke trigger on table "public"."training_blocks" from "service_role";

revoke truncate on table "public"."training_blocks" from "service_role";

revoke update on table "public"."training_blocks" from "service_role";

revoke delete on table "public"."training_blocks_default_templates" from "anon";

revoke insert on table "public"."training_blocks_default_templates" from "anon";

revoke references on table "public"."training_blocks_default_templates" from "anon";

revoke select on table "public"."training_blocks_default_templates" from "anon";

revoke trigger on table "public"."training_blocks_default_templates" from "anon";

revoke truncate on table "public"."training_blocks_default_templates" from "anon";

revoke update on table "public"."training_blocks_default_templates" from "anon";

revoke delete on table "public"."training_blocks_default_templates" from "authenticated";

revoke insert on table "public"."training_blocks_default_templates" from "authenticated";

revoke references on table "public"."training_blocks_default_templates" from "authenticated";

revoke select on table "public"."training_blocks_default_templates" from "authenticated";

revoke trigger on table "public"."training_blocks_default_templates" from "authenticated";

revoke truncate on table "public"."training_blocks_default_templates" from "authenticated";

revoke update on table "public"."training_blocks_default_templates" from "authenticated";

revoke delete on table "public"."training_blocks_default_templates" from "service_role";

revoke insert on table "public"."training_blocks_default_templates" from "service_role";

revoke references on table "public"."training_blocks_default_templates" from "service_role";

revoke select on table "public"."training_blocks_default_templates" from "service_role";

revoke trigger on table "public"."training_blocks_default_templates" from "service_role";

revoke truncate on table "public"."training_blocks_default_templates" from "service_role";

revoke update on table "public"."training_blocks_default_templates" from "service_role";

revoke delete on table "public"."training_blocks_therapist_templates" from "anon";

revoke insert on table "public"."training_blocks_therapist_templates" from "anon";

revoke references on table "public"."training_blocks_therapist_templates" from "anon";

revoke select on table "public"."training_blocks_therapist_templates" from "anon";

revoke trigger on table "public"."training_blocks_therapist_templates" from "anon";

revoke truncate on table "public"."training_blocks_therapist_templates" from "anon";

revoke update on table "public"."training_blocks_therapist_templates" from "anon";

revoke delete on table "public"."training_blocks_therapist_templates" from "authenticated";

revoke insert on table "public"."training_blocks_therapist_templates" from "authenticated";

revoke references on table "public"."training_blocks_therapist_templates" from "authenticated";

revoke select on table "public"."training_blocks_therapist_templates" from "authenticated";

revoke trigger on table "public"."training_blocks_therapist_templates" from "authenticated";

revoke truncate on table "public"."training_blocks_therapist_templates" from "authenticated";

revoke update on table "public"."training_blocks_therapist_templates" from "authenticated";

revoke delete on table "public"."training_blocks_therapist_templates" from "service_role";

revoke insert on table "public"."training_blocks_therapist_templates" from "service_role";

revoke references on table "public"."training_blocks_therapist_templates" from "service_role";

revoke select on table "public"."training_blocks_therapist_templates" from "service_role";

revoke trigger on table "public"."training_blocks_therapist_templates" from "service_role";

revoke truncate on table "public"."training_blocks_therapist_templates" from "service_role";

revoke update on table "public"."training_blocks_therapist_templates" from "service_role";

revoke delete on table "public"."training_units" from "anon";

revoke insert on table "public"."training_units" from "anon";

revoke references on table "public"."training_units" from "anon";

revoke select on table "public"."training_units" from "anon";

revoke trigger on table "public"."training_units" from "anon";

revoke truncate on table "public"."training_units" from "anon";

revoke update on table "public"."training_units" from "anon";

revoke delete on table "public"."training_units" from "authenticated";

revoke insert on table "public"."training_units" from "authenticated";

revoke references on table "public"."training_units" from "authenticated";

revoke select on table "public"."training_units" from "authenticated";

revoke trigger on table "public"."training_units" from "authenticated";

revoke truncate on table "public"."training_units" from "authenticated";

revoke update on table "public"."training_units" from "authenticated";

revoke delete on table "public"."training_units" from "service_role";

revoke insert on table "public"."training_units" from "service_role";

revoke references on table "public"."training_units" from "service_role";

revoke select on table "public"."training_units" from "service_role";

revoke trigger on table "public"."training_units" from "service_role";

revoke truncate on table "public"."training_units" from "service_role";

revoke update on table "public"."training_units" from "service_role";


alter table "public"."training_block_exercises" drop constraint "public_training_block_exercises_default_exercise_id_fkey";

alter table "public"."training_block_exercises" drop constraint "public_training_block_exercises_therapist_uid_fkey";

alter table "public"."training_block_exercises" drop constraint "public_training_block_exercises_training_block_id_fkey";

alter table "public"."training_block_exercises" drop constraint "public_training_block_exercises_training_unit_id_fkey";

alter table "public"."training_blocks" drop constraint "public_training_blocks_patient_uid_fkey";

alter table "public"."training_blocks" drop constraint "public_training_blocks_therapist_uid_fkey";

alter table "public"."training_blocks" drop constraint "public_training_blocks_training_plan_id_fkey";

alter table "public"."training_blocks_therapist_templates" drop constraint "public_training_blocks_therapist_templates_therapist_uid_fkey";

alter table "public"."training_units" drop constraint "training_plans_patient_id_fkey";

alter table "public"."training_units" drop constraint "training_plans_therapist_id_fkey";

alter table "public"."training_block_exercises" drop constraint "training_plan_selected_exercises_pkey";

alter table "public"."training_blocks" drop constraint "training_blocks_pkey";

alter table "public"."training_blocks_default_templates" drop constraint "training_blocks_default_templates_pkey";

alter table "public"."training_blocks_therapist_templates" drop constraint "training_blocks_therapist_templates_pkey";

alter table "public"."training_units" drop constraint "training_plans_pkey";

drop index if exists "public"."training_blocks_default_templates_pkey";

drop index if exists "public"."training_blocks_pkey";

drop index if exists "public"."idx_training_plans_patient_id";

drop index if exists "public"."idx_training_plans_patient_uid";

drop index if exists "public"."idx_training_plans_therapist_uid";

drop index if exists "public"."training_blocks_therapist_templates_pkey";

drop index if exists "public"."training_plan_selected_exercises_pkey";

drop index if exists "public"."training_plans_pkey";

drop table "public"."training_block_exercises";

drop table "public"."training_blocks";

drop table "public"."training_blocks_default_templates";

drop table "public"."training_blocks_therapist_templates";

drop table "public"."training_units";

create table "public"."exercises" (
    "id" bigint generated by default as identity not null,
    "created_at" timestamp with time zone not null default now(),
    "default_exercise_id" bigint not null,
    "duration_seconds_goal" smallint,
    "repetitions_goal" smallint,
    "focus_type" text not null default ''::text,
    "family_scene_adjustment_access" boolean not null default true,
    "training_unit_id" bigint not null,
    "therapist_uid" uuid not null,
    "name" text default 'Exercise'::text
);


alter table "public"."exercises" enable row level security;

create table "public"."exercises_default_templates" (
    "id" bigint generated by default as identity not null,
    "created_at" timestamp with time zone not null default now(),
    "default_exercise_id" bigint not null,
    "duration_seconds_goal" smallint,
    "repetitions_goal" smallint,
    "focus_type" text not null default ''::text,
    "family_scene_adjustment_access" boolean not null default true,
    "name" text default 'Exercise'::text
);


alter table "public"."exercises_default_templates" enable row level security;

create table "public"."test" (
    "id" bigint generated by default as identity not null,
    "created_at" timestamp with time zone not null default now()
);


create table "public"."unit_default_templates" (
    "id" bigint generated by default as identity not null,
    "created_at" timestamp with time zone not null default now(),
    "name" text not null,
    "description" text,
    "therapist_uid" uuid not null,
    "exercises_index" bigint[]
);


alter table "public"."unit_default_templates" enable row level security;

create table "public"."units" (
    "id" bigint generated by default as identity not null,
    "created_at" timestamp with time zone not null default now(),
    "patient_uid" uuid not null,
    "therapist_uid" uuid not null,
    "name" text not null,
    "description" text,
    "exercises_index" bigint[],
    "is_template" boolean not null default false
);


alter table "public"."units" enable row level security;

CREATE UNIQUE INDEX exercises_default_templates_pkey ON public.exercises_default_templates USING btree (id);

CREATE UNIQUE INDEX test_pkey ON public.test USING btree (id);

CREATE INDEX idx_training_plans_patient_id ON public.units USING btree (patient_uid);

CREATE INDEX idx_training_plans_patient_uid ON public.units USING btree (patient_uid);

CREATE INDEX idx_training_plans_therapist_uid ON public.units USING btree (therapist_uid);

CREATE UNIQUE INDEX training_blocks_therapist_templates_pkey ON public.unit_default_templates USING btree (id);

CREATE UNIQUE INDEX training_plan_selected_exercises_pkey ON public.exercises USING btree (id);

CREATE UNIQUE INDEX training_plans_pkey ON public.units USING btree (id);

alter table "public"."exercises" add constraint "training_plan_selected_exercises_pkey" PRIMARY KEY using index "training_plan_selected_exercises_pkey";

alter table "public"."exercises_default_templates" add constraint "exercises_default_templates_pkey" PRIMARY KEY using index "exercises_default_templates_pkey";

alter table "public"."test" add constraint "test_pkey" PRIMARY KEY using index "test_pkey";

alter table "public"."unit_default_templates" add constraint "training_blocks_therapist_templates_pkey" PRIMARY KEY using index "training_blocks_therapist_templates_pkey";

alter table "public"."units" add constraint "training_plans_pkey" PRIMARY KEY using index "training_plans_pkey";

alter table "public"."exercises" add constraint "public_training_block_exercises_default_exercise_id_fkey" FOREIGN KEY (default_exercise_id) REFERENCES default_exercises(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."exercises" validate constraint "public_training_block_exercises_default_exercise_id_fkey";

alter table "public"."exercises" add constraint "public_training_block_exercises_therapist_uid_fkey" FOREIGN KEY (therapist_uid) REFERENCES therapists(uid) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."exercises" validate constraint "public_training_block_exercises_therapist_uid_fkey";

alter table "public"."exercises" add constraint "public_training_block_exercises_training_unit_id_fkey" FOREIGN KEY (training_unit_id) REFERENCES units(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."exercises" validate constraint "public_training_block_exercises_training_unit_id_fkey";

alter table "public"."exercises_default_templates" add constraint "public_exercises_default_templates_default_exercise_id_fkey" FOREIGN KEY (default_exercise_id) REFERENCES default_exercises(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."exercises_default_templates" validate constraint "public_exercises_default_templates_default_exercise_id_fkey";

alter table "public"."unit_default_templates" add constraint "public_training_blocks_therapist_templates_therapist_uid_fkey" FOREIGN KEY (therapist_uid) REFERENCES therapists(uid) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."unit_default_templates" validate constraint "public_training_blocks_therapist_templates_therapist_uid_fkey";

alter table "public"."units" add constraint "training_plans_patient_id_fkey" FOREIGN KEY (patient_uid) REFERENCES families(uid) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."units" validate constraint "training_plans_patient_id_fkey";

alter table "public"."units" add constraint "training_plans_therapist_id_fkey" FOREIGN KEY (therapist_uid) REFERENCES therapists(uid) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."units" validate constraint "training_plans_therapist_id_fkey";

grant delete on table "public"."exercises" to "anon";

grant insert on table "public"."exercises" to "anon";

grant references on table "public"."exercises" to "anon";

grant select on table "public"."exercises" to "anon";

grant trigger on table "public"."exercises" to "anon";

grant truncate on table "public"."exercises" to "anon";

grant update on table "public"."exercises" to "anon";

grant delete on table "public"."exercises" to "authenticated";

grant insert on table "public"."exercises" to "authenticated";

grant references on table "public"."exercises" to "authenticated";

grant select on table "public"."exercises" to "authenticated";

grant trigger on table "public"."exercises" to "authenticated";

grant truncate on table "public"."exercises" to "authenticated";

grant update on table "public"."exercises" to "authenticated";

grant delete on table "public"."exercises" to "service_role";

grant insert on table "public"."exercises" to "service_role";

grant references on table "public"."exercises" to "service_role";

grant select on table "public"."exercises" to "service_role";

grant trigger on table "public"."exercises" to "service_role";

grant truncate on table "public"."exercises" to "service_role";

grant update on table "public"."exercises" to "service_role";

grant delete on table "public"."exercises_default_templates" to "anon";

grant insert on table "public"."exercises_default_templates" to "anon";

grant references on table "public"."exercises_default_templates" to "anon";

grant select on table "public"."exercises_default_templates" to "anon";

grant trigger on table "public"."exercises_default_templates" to "anon";

grant truncate on table "public"."exercises_default_templates" to "anon";

grant update on table "public"."exercises_default_templates" to "anon";

grant delete on table "public"."exercises_default_templates" to "authenticated";

grant insert on table "public"."exercises_default_templates" to "authenticated";

grant references on table "public"."exercises_default_templates" to "authenticated";

grant select on table "public"."exercises_default_templates" to "authenticated";

grant trigger on table "public"."exercises_default_templates" to "authenticated";

grant truncate on table "public"."exercises_default_templates" to "authenticated";

grant update on table "public"."exercises_default_templates" to "authenticated";

grant delete on table "public"."exercises_default_templates" to "service_role";

grant insert on table "public"."exercises_default_templates" to "service_role";

grant references on table "public"."exercises_default_templates" to "service_role";

grant select on table "public"."exercises_default_templates" to "service_role";

grant trigger on table "public"."exercises_default_templates" to "service_role";

grant truncate on table "public"."exercises_default_templates" to "service_role";

grant update on table "public"."exercises_default_templates" to "service_role";

grant delete on table "public"."test" to "anon";

grant insert on table "public"."test" to "anon";

grant references on table "public"."test" to "anon";

grant select on table "public"."test" to "anon";

grant trigger on table "public"."test" to "anon";

grant truncate on table "public"."test" to "anon";

grant update on table "public"."test" to "anon";

grant delete on table "public"."test" to "authenticated";

grant insert on table "public"."test" to "authenticated";

grant references on table "public"."test" to "authenticated";

grant select on table "public"."test" to "authenticated";

grant trigger on table "public"."test" to "authenticated";

grant truncate on table "public"."test" to "authenticated";

grant update on table "public"."test" to "authenticated";

grant delete on table "public"."test" to "service_role";

grant insert on table "public"."test" to "service_role";

grant references on table "public"."test" to "service_role";

grant select on table "public"."test" to "service_role";

grant trigger on table "public"."test" to "service_role";

grant truncate on table "public"."test" to "service_role";

grant update on table "public"."test" to "service_role";

grant delete on table "public"."unit_default_templates" to "anon";

grant insert on table "public"."unit_default_templates" to "anon";

grant references on table "public"."unit_default_templates" to "anon";

grant select on table "public"."unit_default_templates" to "anon";

grant trigger on table "public"."unit_default_templates" to "anon";

grant truncate on table "public"."unit_default_templates" to "anon";

grant update on table "public"."unit_default_templates" to "anon";

grant delete on table "public"."unit_default_templates" to "authenticated";

grant insert on table "public"."unit_default_templates" to "authenticated";

grant references on table "public"."unit_default_templates" to "authenticated";

grant select on table "public"."unit_default_templates" to "authenticated";

grant trigger on table "public"."unit_default_templates" to "authenticated";

grant truncate on table "public"."unit_default_templates" to "authenticated";

grant update on table "public"."unit_default_templates" to "authenticated";

grant delete on table "public"."unit_default_templates" to "service_role";

grant insert on table "public"."unit_default_templates" to "service_role";

grant references on table "public"."unit_default_templates" to "service_role";

grant select on table "public"."unit_default_templates" to "service_role";

grant trigger on table "public"."unit_default_templates" to "service_role";

grant truncate on table "public"."unit_default_templates" to "service_role";

grant update on table "public"."unit_default_templates" to "service_role";

grant delete on table "public"."units" to "anon";

grant insert on table "public"."units" to "anon";

grant references on table "public"."units" to "anon";

grant select on table "public"."units" to "anon";

grant trigger on table "public"."units" to "anon";

grant truncate on table "public"."units" to "anon";

grant update on table "public"."units" to "anon";

grant delete on table "public"."units" to "authenticated";

grant insert on table "public"."units" to "authenticated";

grant references on table "public"."units" to "authenticated";

grant select on table "public"."units" to "authenticated";

grant trigger on table "public"."units" to "authenticated";

grant truncate on table "public"."units" to "authenticated";

grant update on table "public"."units" to "authenticated";

grant delete on table "public"."units" to "service_role";

grant insert on table "public"."units" to "service_role";

grant references on table "public"."units" to "service_role";

grant select on table "public"."units" to "service_role";

grant trigger on table "public"."units" to "service_role";

grant truncate on table "public"."units" to "service_role";

grant update on table "public"."units" to "service_role";

create policy "Enable insert for users based on therapist_uid"
on "public"."exercises"
as permissive
for insert
to public
with check ((auth.uid() = therapist_uid));


create policy "Enable select for users based on therapist_uid"
on "public"."exercises"
as permissive
for select
to public
using ((auth.uid() = therapist_uid));


create policy "Enable update for users based on therapist_uid"
on "public"."exercises"
as permissive
for update
to public
using ((auth.uid() = therapist_uid));


create policy "Enable read access for all users"
on "public"."exercises_default_templates"
as permissive
for select
to authenticated
using (true);


create policy "Enable families read for therapists based on therapist_uid"
on "public"."families"
as permissive
for select
to public
using ((auth.uid() = therapist_uid));


create policy "Enable therapists read therapists based on uid"
on "public"."therapists"
as permissive
for select
to public
using ((auth.uid() = uid));


create policy "Enable read access for all users"
on "public"."unit_default_templates"
as permissive
for select
to authenticated
using (true);


create policy "Enable insert for users based on therapist_uid"
on "public"."units"
as permissive
for insert
to public
with check ((auth.uid() = therapist_uid));


create policy "Enable select for users based on therapist_uid"
on "public"."units"
as permissive
for select
to public
using ((auth.uid() = therapist_uid));


create policy "Enable update for users based on therapist_uid"
on "public"."units"
as permissive
for update
to public
using ((auth.uid() = therapist_uid));