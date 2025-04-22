create policy "all_authenticated_assessments"
on "public"."assessments"
as permissive
for all
to authenticated
using (true)
with check (true);


create policy "all_authenticated_assessments_and_tests"
on "public"."assessments_and_tests"
as permissive
for all
to authenticated
using (true)
with check (true);


create policy "all_authenticated_connection_patient_and_therapists"
on "public"."connection_patient_and_therapists"
as permissive
for all
to authenticated
using (true)
with check (true);


create policy "all_authenticated_default_assessments"
on "public"."default_assessments"
as permissive
for all
to authenticated
using (true)
with check (true);


create policy "all_authenticated_default_assessments_and_tests"
on "public"."default_assessments_and_tests"
as permissive
for all
to authenticated
using (true)
with check (true);


create policy "all_authenticated_default_exercise_instructions"
on "public"."default_exercise_instructions"
as permissive
for all
to authenticated
using (true)
with check (true);


create policy "all_authenticated_default_exercises"
on "public"."default_exercises"
as permissive
for all
to authenticated
using (true)
with check (true);


create policy "all_authenticated_default_test_instructions"
on "public"."default_test_instructions"
as permissive
for all
to authenticated
using (true)
with check (true);


create policy "all_authenticated_default_tests"
on "public"."default_tests"
as permissive
for all
to authenticated
using (true)
with check (true);


create policy "all_authenticated_default_units"
on "public"."default_units"
as permissive
for all
to authenticated
using (true)
with check (true);


create policy "all_authenticated_default_units_and_exercises"
on "public"."default_units_and_exercises"
as permissive
for all
to authenticated
using (true)
with check (true);


create policy "all_authenticated_exercise_instructions"
on "public"."exercise_instructions"
as permissive
for all
to authenticated
using (true)
with check (true);


create policy "all_authenticated_exercises"
on "public"."exercises"
as permissive
for all
to authenticated
using (true)
with check (true);


create policy "all_authenticated_patient_records"
on "public"."patient_records"
as permissive
for all
to authenticated
using (true)
with check (true);


create policy "all_authenticated_patient_sessions"
on "public"."patient_sessions"
as permissive
for all
to authenticated
using (true)
with check (true);


create policy "all_authenticated_patients"
on "public"."patients"
as permissive
for all
to authenticated
using (true)
with check (true);


create policy "all_authenticated_profiles"
on "public"."profiles"
as permissive
for all
to authenticated
using (true)
with check (true);


create policy "all_authenticated_tests"
on "public"."tests"
as permissive
for all
to authenticated
using (true)
with check (true);


create policy "all_authenticated_therapists"
on "public"."therapists"
as permissive
for all
to authenticated
using (true)
with check (true);


create policy "all_authenticated_units"
on "public"."units"
as permissive
for all
to authenticated
using (true)
with check (true);


create policy "all_authenticated_units_and_exercises"
on "public"."units_and_exercises"
as permissive
for all
to authenticated
using (true)
with check (true);
