alter table "public"."training_block_exercises" add column "name" text default 'Exercise'::text;

alter table "public"."training_block_exercises" add column "order_position" smallint not null;

create policy "Enable update for users based on therapist_uid"
on "public"."training_block_exercises"
as permissive
for update
to public
using ((auth.uid() = therapist_uid));


create policy "Enable update for users based on therapist_uid"
on "public"."training_blocks"
as permissive
for update
to public
using ((auth.uid() = therapist_uid));


create policy "Enable update for users based on therapist_uid"
on "public"."training_units"
as permissive
for update
to public
using ((auth.uid() = therapist_uid));