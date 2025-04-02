create type "public"."unit_modality" as enum ('virtual-reality', 'television', 'other');

revoke delete on table "public"."test" from "anon";

revoke insert on table "public"."test" from "anon";

revoke references on table "public"."test" from "anon";

revoke select on table "public"."test" from "anon";

revoke trigger on table "public"."test" from "anon";

revoke truncate on table "public"."test" from "anon";

revoke update on table "public"."test" from "anon";

revoke delete on table "public"."test" from "authenticated";

revoke insert on table "public"."test" from "authenticated";

revoke references on table "public"."test" from "authenticated";

revoke select on table "public"."test" from "authenticated";

revoke trigger on table "public"."test" from "authenticated";

revoke truncate on table "public"."test" from "authenticated";

revoke update on table "public"."test" from "authenticated";

revoke delete on table "public"."test" from "service_role";

revoke insert on table "public"."test" from "service_role";

revoke references on table "public"."test" from "service_role";

revoke select on table "public"."test" from "service_role";

revoke trigger on table "public"."test" from "service_role";

revoke truncate on table "public"."test" from "service_role";

revoke update on table "public"."test" from "service_role";

alter table "public"."test" drop constraint "test_pkey";

drop index if exists "public"."test_pkey";

drop table "public"."test";

alter table "public"."exercises" alter column "focus_type" drop default;

alter type "public"."focus_types" rename to "focus_types__old_version_to_be_dropped";

create type "public"."focus_types" as enum ('strength', 'balance', 'endurance', 'coordination', 'motor-function', 'range-of-motion', 'other');

alter table "public"."default_exercises" alter column focus_type type "public"."focus_types" using focus_type::text::"public"."focus_types";

alter table "public"."exercises" alter column focus_type type "public"."focus_types" using focus_type::text::"public"."focus_types";

alter table "public"."exercises" alter column "focus_type" set default 'strength'::focus_types;

drop type "public"."focus_types__old_version_to_be_dropped";