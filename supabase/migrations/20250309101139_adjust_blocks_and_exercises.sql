alter table "public"."training_block_exercises" add column "therapist_uid" uuid not null;

alter table "public"."training_block_exercises" add column "training_unit_id" bigint not null;

alter table "public"."training_blocks" alter column "therapist_uid" set not null;

alter table "public"."training_block_exercises" add constraint "public_training_block_exercises_therapist_uid_fkey" FOREIGN KEY (therapist_uid) REFERENCES therapists(uid) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."training_block_exercises" validate constraint "public_training_block_exercises_therapist_uid_fkey";

alter table "public"."training_block_exercises" add constraint "public_training_block_exercises_training_unit_id_fkey" FOREIGN KEY (training_unit_id) REFERENCES training_units(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."training_block_exercises" validate constraint "public_training_block_exercises_training_unit_id_fkey";

create policy "Enable insert for users based on therapist_uid"
on "public"."training_block_exercises"
as permissive
for insert
to public
with check ((auth.uid() = therapist_uid));


create policy "Enable select for users based on therapist_uid"
on "public"."training_block_exercises"
as permissive
for select
to public
using ((auth.uid() = therapist_uid));