drop policy "delete_connection_families_and_therapists_as_family" on "public"."connection_families_and_therapists";

drop policy "delete_families_and_therapists_as_therapist" on "public"."connection_families_and_therapists";

drop policy "insert_connection_families_and_therapists_as_family" on "public"."connection_families_and_therapists";

drop policy "insert_families_and_therapists_as_therapist" on "public"."connection_families_and_therapists";

drop policy "select_connection_families_and_therapists_as_family" on "public"."connection_families_and_therapists";

drop policy "select_families_and_therapists_as_therapist" on "public"."connection_families_and_therapists";

drop policy "update_connection_families_and_therapists_as_family" on "public"."connection_families_and_therapists";

drop policy "update_families_and_therapists_as_therapist" on "public"."connection_families_and_therapists";

drop policy "Enable families read for therapists based on therapist_uid" on "public"."families";

revoke delete on table "public"."connection_families_and_therapists" from "anon";

revoke insert on table "public"."connection_families_and_therapists" from "anon";

revoke references on table "public"."connection_families_and_therapists" from "anon";

revoke select on table "public"."connection_families_and_therapists" from "anon";

revoke trigger on table "public"."connection_families_and_therapists" from "anon";

revoke truncate on table "public"."connection_families_and_therapists" from "anon";

revoke update on table "public"."connection_families_and_therapists" from "anon";

revoke delete on table "public"."connection_families_and_therapists" from "authenticated";

revoke insert on table "public"."connection_families_and_therapists" from "authenticated";

revoke references on table "public"."connection_families_and_therapists" from "authenticated";

revoke select on table "public"."connection_families_and_therapists" from "authenticated";

revoke trigger on table "public"."connection_families_and_therapists" from "authenticated";

revoke truncate on table "public"."connection_families_and_therapists" from "authenticated";

revoke update on table "public"."connection_families_and_therapists" from "authenticated";

revoke delete on table "public"."connection_families_and_therapists" from "service_role";

revoke insert on table "public"."connection_families_and_therapists" from "service_role";

revoke references on table "public"."connection_families_and_therapists" from "service_role";

revoke select on table "public"."connection_families_and_therapists" from "service_role";

revoke trigger on table "public"."connection_families_and_therapists" from "service_role";

revoke truncate on table "public"."connection_families_and_therapists" from "service_role";

revoke update on table "public"."connection_families_and_therapists" from "service_role";

revoke delete on table "public"."families" from "anon";

revoke insert on table "public"."families" from "anon";

revoke references on table "public"."families" from "anon";

revoke select on table "public"."families" from "anon";

revoke trigger on table "public"."families" from "anon";

revoke truncate on table "public"."families" from "anon";

revoke update on table "public"."families" from "anon";

revoke delete on table "public"."families" from "authenticated";

revoke insert on table "public"."families" from "authenticated";

revoke references on table "public"."families" from "authenticated";

revoke select on table "public"."families" from "authenticated";

revoke trigger on table "public"."families" from "authenticated";

revoke truncate on table "public"."families" from "authenticated";

revoke update on table "public"."families" from "authenticated";

revoke delete on table "public"."families" from "service_role";

revoke insert on table "public"."families" from "service_role";

revoke references on table "public"."families" from "service_role";

revoke select on table "public"."families" from "service_role";

revoke trigger on table "public"."families" from "service_role";

revoke truncate on table "public"."families" from "service_role";

revoke update on table "public"."families" from "service_role";

alter table "public"."connection_families_and_therapists" drop constraint "public_connection_families_and_therapists_family_id_fkey";

alter table "public"."connection_families_and_therapists" drop constraint "public_connection_families_and_therapists_therapist_id_fkey";

alter table "public"."families" drop constraint "patients_uid_fkey";

alter table "public"."families" drop constraint "patients_uid_key";

alter table "public"."families" drop constraint "public_families_therapist_uid_fkey";

alter table "public"."assessments" drop constraint "public_assessments_patient_uid_fkey";

alter table "public"."patient_records" drop constraint "patient_achievements_patient_uid_fkey";

alter table "public"."patient_sessions" drop constraint "vr_sessions_patient_id_fkey";

alter table "public"."units" drop constraint "training_plans_patient_id_fkey";

alter table "public"."connection_families_and_therapists" drop constraint "connection_families_and_therapists_pkey";

alter table "public"."families" drop constraint "patients_pkey";

drop index if exists "public"."connection_families_and_therapists_pkey";

drop index if exists "public"."patients_pkey";

drop index if exists "public"."patients_uid_key";

drop table "public"."connection_families_and_therapists";

drop table "public"."families";

create table "public"."connection_patient_and_therapists" (
    "created_at" timestamp with time zone not null default now(),
    "family_uid" uuid not null,
    "therapist_uid" uuid not null,
    "id" uuid not null default gen_random_uuid()
);


alter table "public"."connection_patient_and_therapists" enable row level security;

create table "public"."patients" (
    "created_at" timestamp with time zone not null default now(),
    "patient_first_name" text not null,
    "patient_last_name" text not null,
    "uid" uuid not null,
    "caregiver_first_name" text,
    "caregiver_last_name" text,
    "therapist_uid" uuid not null
);


alter table "public"."patients" enable row level security;

alter table "public"."assessments" add column "isTemplate" boolean default false;

CREATE UNIQUE INDEX connection_families_and_therapists_pkey ON public.connection_patient_and_therapists USING btree (id);

CREATE UNIQUE INDEX patients_pkey ON public.patients USING btree (uid);

CREATE UNIQUE INDEX patients_uid_key ON public.patients USING btree (uid);

alter table "public"."connection_patient_and_therapists" add constraint "connection_families_and_therapists_pkey" PRIMARY KEY using index "connection_families_and_therapists_pkey";

alter table "public"."patients" add constraint "patients_pkey" PRIMARY KEY using index "patients_pkey";

alter table "public"."connection_patient_and_therapists" add constraint "public_connection_families_and_therapists_family_id_fkey" FOREIGN KEY (family_uid) REFERENCES patients(uid) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."connection_patient_and_therapists" validate constraint "public_connection_families_and_therapists_family_id_fkey";

alter table "public"."connection_patient_and_therapists" add constraint "public_connection_families_and_therapists_therapist_id_fkey" FOREIGN KEY (therapist_uid) REFERENCES therapists(uid) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."connection_patient_and_therapists" validate constraint "public_connection_families_and_therapists_therapist_id_fkey";

alter table "public"."patients" add constraint "patients_uid_fkey" FOREIGN KEY (uid) REFERENCES auth.users(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."patients" validate constraint "patients_uid_fkey";

alter table "public"."patients" add constraint "patients_uid_key" UNIQUE using index "patients_uid_key";

alter table "public"."patients" add constraint "public_families_therapist_uid_fkey" FOREIGN KEY (therapist_uid) REFERENCES therapists(uid) not valid;

alter table "public"."patients" validate constraint "public_families_therapist_uid_fkey";

alter table "public"."assessments" add constraint "public_assessments_patient_uid_fkey" FOREIGN KEY (patient_uid) REFERENCES patients(uid) ON UPDATE CASCADE ON DELETE SET NULL not valid;

alter table "public"."assessments" validate constraint "public_assessments_patient_uid_fkey";

alter table "public"."patient_records" add constraint "patient_achievements_patient_uid_fkey" FOREIGN KEY (patient_uid) REFERENCES patients(uid) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."patient_records" validate constraint "patient_achievements_patient_uid_fkey";

alter table "public"."patient_sessions" add constraint "vr_sessions_patient_id_fkey" FOREIGN KEY (patient_uid) REFERENCES patients(uid) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."patient_sessions" validate constraint "vr_sessions_patient_id_fkey";

alter table "public"."units" add constraint "training_plans_patient_id_fkey" FOREIGN KEY (patient_uid) REFERENCES patients(uid) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."units" validate constraint "training_plans_patient_id_fkey";

grant delete on table "public"."connection_patient_and_therapists" to "anon";

grant insert on table "public"."connection_patient_and_therapists" to "anon";

grant references on table "public"."connection_patient_and_therapists" to "anon";

grant select on table "public"."connection_patient_and_therapists" to "anon";

grant trigger on table "public"."connection_patient_and_therapists" to "anon";

grant truncate on table "public"."connection_patient_and_therapists" to "anon";

grant update on table "public"."connection_patient_and_therapists" to "anon";

grant delete on table "public"."connection_patient_and_therapists" to "authenticated";

grant insert on table "public"."connection_patient_and_therapists" to "authenticated";

grant references on table "public"."connection_patient_and_therapists" to "authenticated";

grant select on table "public"."connection_patient_and_therapists" to "authenticated";

grant trigger on table "public"."connection_patient_and_therapists" to "authenticated";

grant truncate on table "public"."connection_patient_and_therapists" to "authenticated";

grant update on table "public"."connection_patient_and_therapists" to "authenticated";

grant delete on table "public"."connection_patient_and_therapists" to "service_role";

grant insert on table "public"."connection_patient_and_therapists" to "service_role";

grant references on table "public"."connection_patient_and_therapists" to "service_role";

grant select on table "public"."connection_patient_and_therapists" to "service_role";

grant trigger on table "public"."connection_patient_and_therapists" to "service_role";

grant truncate on table "public"."connection_patient_and_therapists" to "service_role";

grant update on table "public"."connection_patient_and_therapists" to "service_role";

grant delete on table "public"."patients" to "anon";

grant insert on table "public"."patients" to "anon";

grant references on table "public"."patients" to "anon";

grant select on table "public"."patients" to "anon";

grant trigger on table "public"."patients" to "anon";

grant truncate on table "public"."patients" to "anon";

grant update on table "public"."patients" to "anon";

grant delete on table "public"."patients" to "authenticated";

grant insert on table "public"."patients" to "authenticated";

grant references on table "public"."patients" to "authenticated";

grant select on table "public"."patients" to "authenticated";

grant trigger on table "public"."patients" to "authenticated";

grant truncate on table "public"."patients" to "authenticated";

grant update on table "public"."patients" to "authenticated";

grant delete on table "public"."patients" to "service_role";

grant insert on table "public"."patients" to "service_role";

grant references on table "public"."patients" to "service_role";

grant select on table "public"."patients" to "service_role";

grant trigger on table "public"."patients" to "service_role";

grant truncate on table "public"."patients" to "service_role";

grant update on table "public"."patients" to "service_role";

create policy "delete_connection_families_and_therapists_as_family"
on "public"."connection_patient_and_therapists"
as permissive
for delete
to public
using ((family_uid = auth.uid()));


create policy "delete_families_and_therapists_as_therapist"
on "public"."connection_patient_and_therapists"
as permissive
for delete
to public
using ((therapist_uid = auth.uid()));


create policy "insert_connection_families_and_therapists_as_family"
on "public"."connection_patient_and_therapists"
as permissive
for insert
to public
with check ((family_uid = auth.uid()));


create policy "insert_families_and_therapists_as_therapist"
on "public"."connection_patient_and_therapists"
as permissive
for insert
to public
with check ((therapist_uid = auth.uid()));


create policy "select_connection_families_and_therapists_as_family"
on "public"."connection_patient_and_therapists"
as permissive
for select
to public
using ((family_uid = auth.uid()));


create policy "select_families_and_therapists_as_therapist"
on "public"."connection_patient_and_therapists"
as permissive
for select
to public
using ((therapist_uid = auth.uid()));


create policy "update_connection_families_and_therapists_as_family"
on "public"."connection_patient_and_therapists"
as permissive
for update
to public
using ((family_uid = auth.uid()));


create policy "update_families_and_therapists_as_therapist"
on "public"."connection_patient_and_therapists"
as permissive
for update
to public
using ((therapist_uid = auth.uid()));


create policy "Enable delete for users based on user_id"
on "public"."patients"
as permissive
for select
to public
using ((auth.uid() = uid));


create policy "Enable families read for therapists based on therapist_uid"
on "public"."patients"
as permissive
for select
to public
using ((auth.uid() = therapist_uid));