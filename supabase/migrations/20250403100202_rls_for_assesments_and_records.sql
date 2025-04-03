drop policy "Enable insert for users based on therapist_uid" on "public"."assessments";

drop policy "Enable select for users based on therapist_uid" on "public"."assessments";

drop policy "Enable therapists read therapists based on uid" on "public"."therapists";

alter table "public"."connection_families_and_therapists" drop constraint "public_connection_families_and_therapists_family_id_fkey";

alter table "public"."connection_families_and_therapists" drop constraint "public_connection_families_and_therapists_therapist_id_fkey";

alter table "public"."connection_families_and_therapists" drop column "family_id";

alter table "public"."connection_families_and_therapists" drop column "therapist_id";

alter table "public"."connection_families_and_therapists" add column "family_uid" uuid not null;

alter table "public"."connection_families_and_therapists" add column "therapist_uid" uuid not null;

alter table "public"."connection_families_and_therapists" add constraint "public_connection_families_and_therapists_family_id_fkey" FOREIGN KEY (family_uid) REFERENCES families(uid) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."connection_families_and_therapists" validate constraint "public_connection_families_and_therapists_family_id_fkey";

alter table "public"."connection_families_and_therapists" add constraint "public_connection_families_and_therapists_therapist_id_fkey" FOREIGN KEY (therapist_uid) REFERENCES therapists(uid) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."connection_families_and_therapists" validate constraint "public_connection_families_and_therapists_therapist_id_fkey";

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
on "public"."default_exercise_instructions"
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