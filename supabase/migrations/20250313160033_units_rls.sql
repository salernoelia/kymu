

-- drop index if exists "public"."specialist_types_name_key";

-- drop table "public"."specialist_types";

alter table "public"."connection_families_and_therapists" alter column "id" set not null;

alter table "public"."exercises" add column "description" text;

alter table "public"."exercises" add column "unit_id" uuid;

alter table "public"."units" alter column "exercises_index" drop default;

alter table "public"."units" alter column "id" set default gen_random_uuid();

-- alter table "public"."units" alter column "id" drop identity;

alter table "public"."units" alter column "id" set data type uuid using "id"::uuid;

CREATE UNIQUE INDEX connection_families_and_therapists_pkey ON public.connection_families_and_therapists USING btree (id);

alter table "public"."connection_families_and_therapists" add constraint "connection_families_and_therapists_pkey" PRIMARY KEY using index "connection_families_and_therapists_pkey";

alter table "public"."exercises" add constraint "public_exercises_training_unit_id_fkey" FOREIGN KEY (unit_id) REFERENCES units(id) ON UPDATE CASCADE ON DELETE SET NULL not valid;

alter table "public"."exercises" validate constraint "public_exercises_training_unit_id_fkey";

create policy "Enable read access for all users"
on "public"."default_exercises"
as permissive
for select
to public
using (true);


create policy "Enable delete for users based on therapist_uid"
on "public"."exercises"
as permissive
for delete
to public
using ((auth.uid() = therapist_uid));


create policy "Enable delete for users based on therapist_uid"
on "public"."units"
as permissive
for delete
to public
using ((auth.uid() = therapist_uid));