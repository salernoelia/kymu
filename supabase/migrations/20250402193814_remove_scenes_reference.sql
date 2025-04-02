drop policy "Enable read access for all users" on "public"."default_scenes";

revoke delete on table "public"."default_scenes" from "anon";

revoke insert on table "public"."default_scenes" from "anon";

revoke references on table "public"."default_scenes" from "anon";

revoke select on table "public"."default_scenes" from "anon";

revoke trigger on table "public"."default_scenes" from "anon";

revoke truncate on table "public"."default_scenes" from "anon";

revoke update on table "public"."default_scenes" from "anon";

revoke delete on table "public"."default_scenes" from "authenticated";

revoke insert on table "public"."default_scenes" from "authenticated";

revoke references on table "public"."default_scenes" from "authenticated";

revoke select on table "public"."default_scenes" from "authenticated";

revoke trigger on table "public"."default_scenes" from "authenticated";

revoke truncate on table "public"."default_scenes" from "authenticated";

revoke update on table "public"."default_scenes" from "authenticated";

revoke delete on table "public"."default_scenes" from "service_role";

revoke insert on table "public"."default_scenes" from "service_role";

revoke references on table "public"."default_scenes" from "service_role";

revoke select on table "public"."default_scenes" from "service_role";

revoke trigger on table "public"."default_scenes" from "service_role";

revoke truncate on table "public"."default_scenes" from "service_role";

revoke update on table "public"."default_scenes" from "service_role";

alter table "public"."default_exercises" drop constraint "public_default_exercises_default_scene_id_fkey";

alter table "public"."default_scenes" drop constraint "default_scenes_pkey";

drop index if exists "public"."default_scenes_pkey";

drop table "public"."default_scenes";

alter table "public"."default_exercises" drop column "default_scene_id";

alter table "public"."default_exercises" add column "image_urls" text[];

alter table "public"."default_exercises" add column "video_urls" text[];

alter table "public"."exercises" add column "therapist_added_image_urls" text[];

alter table "public"."exercises" add column "therapist_added_video_urls" text[];