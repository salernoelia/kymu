alter type "public"."exercise_modality" rename to "exercise_modality__old_version_to_be_dropped";

create type "public"."exercise_modality" as enum ('uninstructed', 'virtual-reality', 'video-instruction', 'other');

alter table "public"."default_exercises" alter column modality type "public"."exercise_modality" using modality::text::"public"."exercise_modality";

alter table "public"."exercises" alter column modality type "public"."exercise_modality" using modality::text::"public"."exercise_modality";

drop type "public"."exercise_modality__old_version_to_be_dropped";

alter table "public"."default_exercise_instructions" alter column "id" drop default;

alter table "public"."default_tests" alter column "test_focus" set not null;

alter table "public"."default_tests" alter column "test_focus" set data type record_types using "test_focus"::record_types;

alter table "public"."patient_sessions" alter column "id" drop default;

CREATE UNIQUE INDEX default_exercise_instructions_id_key ON public.default_exercise_instructions USING btree (id);

alter table "public"."default_exercise_instructions" add constraint "default_exercise_instructions_id_key" UNIQUE using index "default_exercise_instructions_id_key";