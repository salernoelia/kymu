alter table "public"."patients" add column "uid" uuid not null;

alter table "public"."therapists" drop column "email";

alter table "public"."therapists" add column "uid" uuid not null;

alter table "public"."therapists" alter column "specialist_type" drop not null;

CREATE UNIQUE INDEX patients_uid_key ON public.patients USING btree (uid);

CREATE UNIQUE INDEX therapists_uid_key ON public.therapists USING btree (uid);

alter table "public"."patients" add constraint "patients_uid_fkey" FOREIGN KEY (uid) REFERENCES auth.users(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."patients" validate constraint "patients_uid_fkey";

alter table "public"."patients" add constraint "patients_uid_key" UNIQUE using index "patients_uid_key";

alter table "public"."therapists" add constraint "therapists_uid_fkey" FOREIGN KEY (uid) REFERENCES auth.users(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."therapists" validate constraint "therapists_uid_fkey";

alter table "public"."therapists" add constraint "therapists_uid_key" UNIQUE using index "therapists_uid_key";


