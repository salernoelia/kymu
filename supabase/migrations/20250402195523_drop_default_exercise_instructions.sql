revoke delete on table "public"."default_exercise_instructions" from "anon";

revoke insert on table "public"."default_exercise_instructions" from "anon";

revoke references on table "public"."default_exercise_instructions" from "anon";

revoke select on table "public"."default_exercise_instructions" from "anon";

revoke trigger on table "public"."default_exercise_instructions" from "anon";

revoke truncate on table "public"."default_exercise_instructions" from "anon";

revoke update on table "public"."default_exercise_instructions" from "anon";

revoke delete on table "public"."default_exercise_instructions" from "authenticated";

revoke insert on table "public"."default_exercise_instructions" from "authenticated";

revoke references on table "public"."default_exercise_instructions" from "authenticated";

revoke select on table "public"."default_exercise_instructions" from "authenticated";

revoke trigger on table "public"."default_exercise_instructions" from "authenticated";

revoke truncate on table "public"."default_exercise_instructions" from "authenticated";

revoke update on table "public"."default_exercise_instructions" from "authenticated";

revoke delete on table "public"."default_exercise_instructions" from "service_role";

revoke insert on table "public"."default_exercise_instructions" from "service_role";

revoke references on table "public"."default_exercise_instructions" from "service_role";

revoke select on table "public"."default_exercise_instructions" from "service_role";

revoke trigger on table "public"."default_exercise_instructions" from "service_role";

revoke truncate on table "public"."default_exercise_instructions" from "service_role";

revoke update on table "public"."default_exercise_instructions" from "service_role";

alter table "public"."default_exercise_instructions" drop constraint "default_exercise_instructions_id_key";

alter table "public"."default_exercise_instructions" drop constraint "default_exercise_instructions_name_key";

alter table "public"."default_exercise_instructions" drop constraint "default_exercise_instructions_pkey";

drop index if exists "public"."default_exercise_instructions_id_key";

drop index if exists "public"."default_exercise_instructions_name_key";

drop index if exists "public"."default_exercise_instructions_pkey";

drop table "public"."default_exercise_instructions";