alter table "public"."exercises" drop column "record_type";

alter table "public"."exercises" add column "focus_type" record_types not null default 'strength'::record_types;

alter table "public"."patient_exercise_records" drop column "type";

alter table "public"."patient_exercise_records" add column "focus_type" record_types not null;