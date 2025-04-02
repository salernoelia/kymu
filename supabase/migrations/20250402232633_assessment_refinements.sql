create type "public"."modality" as enum ('augmented-reality', 'virtual-reality', 'screen', 'other');

alter table "public"."assessments" drop constraint "public_assessments_patient_uid_fkey";

alter table "public"."assessments" drop column "patient_uid";

alter table "public"."assessments" add column "name" text not null;

alter table "public"."default_assessments" add column "modality" modality not null;

alter table "public"."default_exercises" alter column "modality" set data type modality using "modality"::text::modality;

alter table "public"."default_test_instructions" add column "Name" text not null;

alter table "public"."default_test_instructions" alter column "id" set default gen_random_uuid();

alter table "public"."default_units" add column "end_assessment_id" uuid;

alter table "public"."default_units" add column "start_assessment_id" uuid;

alter table "public"."exercises" alter column "modality" set data type modality using "modality"::text::modality;

alter table "public"."units" add column "end_assessment_id" uuid;

alter table "public"."units" add column "start_assessment_id" uuid;

drop type "public"."exercise_modality";

alter table "public"."default_units" add constraint "public_default_units_end_assessment_id_fkey" FOREIGN KEY (end_assessment_id) REFERENCES default_assessments(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."default_units" validate constraint "public_default_units_end_assessment_id_fkey";

alter table "public"."default_units" add constraint "public_default_units_start_assessment_id_fkey" FOREIGN KEY (start_assessment_id) REFERENCES default_assessments(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."default_units" validate constraint "public_default_units_start_assessment_id_fkey";

alter table "public"."units" add constraint "public_units_end_assessment_id_fkey" FOREIGN KEY (end_assessment_id) REFERENCES assessments(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."units" validate constraint "public_units_end_assessment_id_fkey";

alter table "public"."units" add constraint "public_units_start_assessment_id_fkey" FOREIGN KEY (start_assessment_id) REFERENCES assessments(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."units" validate constraint "public_units_start_assessment_id_fkey";

create policy "Enable insert for users based on therapist_uid"
on "public"."assessments"
as permissive
for insert
to public
with check ((auth.uid() = therapist_uid));


create policy "Enable select for users based on therapist_uid"
on "public"."assessments"
as permissive
for select
to public
using ((auth.uid() = therapist_uid));


create policy "Enable read access for all authenticated users"
on "public"."default_assessments"
as permissive
for select
to authenticated
using (true);


create policy "Enable read access for all authenticated users"
on "public"."default_test_instructions"
as permissive
for select
to authenticated
using (true);


create policy "Enable read access for all authenticated users"
on "public"."default_tests"
as permissive
for select
to authenticated
using (true);