SET session_replication_role = replica;

--
-- PostgreSQL database dump
--

-- Dumped from database version 15.8
-- Dumped by pg_dump version 15.5 (Ubuntu 15.5-1.pgdg20.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."audit_log_entries" ("instance_id", "id", "payload", "created_at", "ip_address") VALUES
	('00000000-0000-0000-0000-000000000000', '8d5205f0-93cf-421b-b3b5-f7bec4d84f9e', '{"action":"user_signedup","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"elia@salerno.com","user_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","user_phone":""}}', '2025-02-26 18:16:46.376884+00', ''),
	('00000000-0000-0000-0000-000000000000', 'fd68c796-acf6-4c4f-b09f-396bb8fd6448', '{"action":"login","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-02-26 19:32:04.547184+00', ''),
	('00000000-0000-0000-0000-000000000000', '36593c85-31c7-4ee3-a426-e65eabf420b1', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-03 12:33:49.176608+00', ''),
	('00000000-0000-0000-0000-000000000000', '9d424333-ce03-447c-aefe-0127480a0c88', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-03 12:33:49.17764+00', ''),
	('00000000-0000-0000-0000-000000000000', 'fcf15f2f-9911-4134-b9a6-860e20dcd6f9', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-03 23:26:01.993887+00', ''),
	('00000000-0000-0000-0000-000000000000', '7197cb2a-d95b-4473-88e7-9f48fef6fd0e', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-03 23:26:01.996334+00', ''),
	('00000000-0000-0000-0000-000000000000', 'ba628271-0e84-4857-a05d-fd740fa9b837', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-04 06:29:13.774938+00', ''),
	('00000000-0000-0000-0000-000000000000', 'd759562d-d651-44e5-9e90-817ad11bfa2a', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-04 06:29:13.77577+00', ''),
	('00000000-0000-0000-0000-000000000000', 'b6a6e160-c771-4b8b-932c-c6b8cbafa00b', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-06 07:43:52.667201+00', ''),
	('00000000-0000-0000-0000-000000000000', 'c727a384-1bd1-4562-a6b3-8b52ee19cf78', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-06 07:43:52.66807+00', ''),
	('00000000-0000-0000-0000-000000000000', 'd2964e48-bd69-4900-bd37-4d5aae396e81', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-06 09:25:19.103753+00', ''),
	('00000000-0000-0000-0000-000000000000', 'e4b9ae5b-6dec-458b-b63f-2d5dd086abc4', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-06 09:25:19.104698+00', ''),
	('00000000-0000-0000-0000-000000000000', '9e0b0f11-2447-4106-9ae9-8f9108d04911', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-06 11:22:43.829982+00', ''),
	('00000000-0000-0000-0000-000000000000', 'bd2f4128-3ac0-471f-8ca3-d0f74bcd8cfc', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-06 11:22:43.831871+00', ''),
	('00000000-0000-0000-0000-000000000000', '84d0c8a0-8236-47c7-9dcf-be48a53060ce', '{"action":"login","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-03-06 11:34:52.775072+00', ''),
	('00000000-0000-0000-0000-000000000000', '1958c5b9-4bef-43a9-bcff-5939868d7040', '{"action":"login","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-03-07 19:28:47.044474+00', ''),
	('00000000-0000-0000-0000-000000000000', 'bcd96aac-1bc4-42b1-b412-be3c3b8dd90f', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-07 20:31:18.162261+00', ''),
	('00000000-0000-0000-0000-000000000000', '13aecc5b-d3bf-4b41-b412-eca4c138880b', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-07 20:31:18.16287+00', ''),
	('00000000-0000-0000-0000-000000000000', '12568954-ae99-4377-b654-4acbfb15a186', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-07 23:12:16.243077+00', ''),
	('00000000-0000-0000-0000-000000000000', '0678ec00-201a-4cc8-a448-bd73121fbe8e', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-07 23:12:16.245099+00', ''),
	('00000000-0000-0000-0000-000000000000', 'ee92d262-d62c-4011-a63f-6737b597f095', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-08 17:31:39.358472+00', ''),
	('00000000-0000-0000-0000-000000000000', 'dfedce99-1f3a-42b1-9c8f-ca9c9cc6e25f', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-08 17:31:39.360957+00', ''),
	('00000000-0000-0000-0000-000000000000', '2f40dc47-2253-4c12-88b6-a476b5e3f1f7', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-08 18:32:11.193785+00', ''),
	('00000000-0000-0000-0000-000000000000', '51312612-cc96-486b-ae34-90210e32e85e', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-08 18:32:11.195116+00', ''),
	('00000000-0000-0000-0000-000000000000', 'cb508c3f-a8a5-4e01-9432-cf6a4eb1af8f', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-08 19:31:24.203696+00', ''),
	('00000000-0000-0000-0000-000000000000', '23357f1f-0f30-4448-a213-2a6f46a67684', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-08 19:31:24.206263+00', ''),
	('00000000-0000-0000-0000-000000000000', 'e25f9a1d-09b2-4dbc-9b21-6aeeb6e37b0c', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-08 22:29:23.748628+00', ''),
	('00000000-0000-0000-0000-000000000000', 'd480bb04-9c9c-43b3-9827-b7f9e2a1b7c6', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-08 22:29:23.749572+00', ''),
	('00000000-0000-0000-0000-000000000000', 'cb4ae2bb-23df-4b04-89a9-3264b5c50f8d', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-08 22:29:25.755992+00', ''),
	('00000000-0000-0000-0000-000000000000', 'bfef24ea-7055-4a96-92f0-06014cf6182c', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-08 23:27:41.901789+00', ''),
	('00000000-0000-0000-0000-000000000000', '0eab351e-d54b-49af-b713-999a88955095', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-08 23:27:41.902898+00', ''),
	('00000000-0000-0000-0000-000000000000', '4b97e05d-3601-4aae-839f-ec88e26ad659', '{"action":"user_signedup","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"doskf@fksod.co","user_id":"4f9aa889-a4d1-4cda-bb8f-5190c1bbd959","user_phone":""}}', '2025-03-09 00:15:52.427567+00', ''),
	('00000000-0000-0000-0000-000000000000', '34a490c3-4a5e-4fa8-8406-ad76bc6507e5', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-09 00:27:56.361553+00', ''),
	('00000000-0000-0000-0000-000000000000', '344b83af-5b07-4c48-a90e-42648a910166', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-09 00:27:56.362064+00', ''),
	('00000000-0000-0000-0000-000000000000', 'a4a5008d-48b7-4d86-b2e6-f73225f72e2d', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-09 07:39:43.499089+00', ''),
	('00000000-0000-0000-0000-000000000000', '8eadf77a-211d-4a2f-92ae-5e5cc08fe12f', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-09 07:39:43.499891+00', ''),
	('00000000-0000-0000-0000-000000000000', '80ea024f-b489-4faa-87fe-b43a1e6bc7ea', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-09 08:38:12.65942+00', ''),
	('00000000-0000-0000-0000-000000000000', '228a67f7-f485-4d78-9b16-7d0e02390991', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-09 08:38:12.660118+00', ''),
	('00000000-0000-0000-0000-000000000000', '7b60c9cb-8636-4a69-be69-fb93f2fe09f6', '{"action":"user_signedup","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"user@2.com","user_id":"daf1b32e-91b7-4a6c-961e-439b78b81b20","user_phone":""}}', '2025-03-09 08:44:57.535186+00', ''),
	('00000000-0000-0000-0000-000000000000', '9186daa7-6034-4a32-a94d-64052678af5d', '{"action":"logout","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"account"}', '2025-03-09 08:45:04.036162+00', ''),
	('00000000-0000-0000-0000-000000000000', '0db505f3-28ab-4ce2-976e-58107ace80b8', '{"action":"login","actor_id":"daf1b32e-91b7-4a6c-961e-439b78b81b20","actor_username":"user@2.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-03-09 08:45:10.694757+00', ''),
	('00000000-0000-0000-0000-000000000000', 'f241b0d7-e48a-46ad-8c3f-73c5b64a6f44', '{"action":"logout","actor_id":"daf1b32e-91b7-4a6c-961e-439b78b81b20","actor_username":"user@2.com","actor_via_sso":false,"log_type":"account"}', '2025-03-09 08:49:35.472723+00', ''),
	('00000000-0000-0000-0000-000000000000', 'cf0a34c8-bafb-4218-9f5e-d9874686e872', '{"action":"login","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-03-09 08:49:41.801828+00', ''),
	('00000000-0000-0000-0000-000000000000', '8eac4301-8150-40bf-9a4a-8f5d44efeff9', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-09 09:47:59.260928+00', ''),
	('00000000-0000-0000-0000-000000000000', 'be01dc69-e1a7-4df0-ad78-980f631355f3', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-09 09:47:59.26185+00', ''),
	('00000000-0000-0000-0000-000000000000', 'feb60ade-7585-47e9-9be9-b9df18e5d2c2', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-09 17:19:33.345532+00', ''),
	('00000000-0000-0000-0000-000000000000', '500bd054-ec44-463d-b383-98cb7e5b1a3d', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-09 17:19:33.346907+00', ''),
	('00000000-0000-0000-0000-000000000000', 'cecc727f-4ce0-4d42-95d0-dee8a517f2cc', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-09 23:44:53.727428+00', ''),
	('00000000-0000-0000-0000-000000000000', 'd7844759-7ef9-4e97-ab7a-613447d9dddb', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-09 23:44:53.729575+00', ''),
	('00000000-0000-0000-0000-000000000000', '917f1675-c3d7-42c5-9779-7299996d378c', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-10 00:43:10.474398+00', ''),
	('00000000-0000-0000-0000-000000000000', '79d8e4f7-70a1-41d7-bb3c-e97148e1ea29', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-10 00:43:10.475025+00', ''),
	('00000000-0000-0000-0000-000000000000', '45ee8d19-e101-4b8e-8060-36bdc791899c', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-10 01:41:48.018101+00', ''),
	('00000000-0000-0000-0000-000000000000', 'ea4e95e9-2877-4267-b9ed-b894c4714ae9', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-10 01:41:48.021179+00', ''),
	('00000000-0000-0000-0000-000000000000', '8c992d19-6de4-4f32-b378-61a107984433', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-10 09:15:35.228407+00', ''),
	('00000000-0000-0000-0000-000000000000', 'c9bdea3a-98ef-4f8c-a259-95de116e6f24', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-10 09:15:35.229907+00', ''),
	('00000000-0000-0000-0000-000000000000', 'bb81cdd0-f3a3-450c-a353-a5176335e37d', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-10 10:18:54.109449+00', ''),
	('00000000-0000-0000-0000-000000000000', '5da14a94-f10d-4618-8b9b-2065d1c5f0d9', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-10 10:18:54.113297+00', ''),
	('00000000-0000-0000-0000-000000000000', 'cac40cf0-3760-4e95-8ca2-50a739a45250', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-10 11:16:56.133227+00', ''),
	('00000000-0000-0000-0000-000000000000', 'dff24fa7-de49-45b2-bf5b-e40608254c10', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-10 11:16:56.136026+00', ''),
	('00000000-0000-0000-0000-000000000000', '54bbc6d3-cb20-4db6-8bda-e9d7ebe9f271', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-10 12:15:14.801976+00', ''),
	('00000000-0000-0000-0000-000000000000', 'e6d8d398-d5e9-4a7c-99f3-3614114b86a2', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-10 12:15:14.804643+00', ''),
	('00000000-0000-0000-0000-000000000000', '78593b2f-eab4-4771-8dcd-ed79934890f2', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-10 13:13:33.871151+00', ''),
	('00000000-0000-0000-0000-000000000000', '2643d576-2740-4264-a008-6de1d0b0f8a8', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-10 13:13:33.872873+00', ''),
	('00000000-0000-0000-0000-000000000000', 'bfc1ef2c-cdc4-409f-bbb7-cafbac9fec26', '{"action":"login","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-03-10 13:22:24.916614+00', ''),
	('00000000-0000-0000-0000-000000000000', '6fa86df7-330b-4f4f-b9a3-5221bbf7f4b2', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-10 14:11:46.105355+00', ''),
	('00000000-0000-0000-0000-000000000000', '0d8e1ee3-c5d0-457e-94b2-102027511f21', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-10 14:11:46.107054+00', ''),
	('00000000-0000-0000-0000-000000000000', '53e95293-1231-426f-afef-618312351d52', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-10 14:52:02.945253+00', ''),
	('00000000-0000-0000-0000-000000000000', 'a1b2c745-96dc-4729-b8bf-47e9492af17b', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-10 14:52:02.947674+00', ''),
	('00000000-0000-0000-0000-000000000000', '876a4bbe-60a9-4b48-b862-a0ddebbea20e', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-10 15:09:54.915718+00', ''),
	('00000000-0000-0000-0000-000000000000', '8b18b5d2-f066-415f-8614-6f6f175fc426', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-10 15:09:54.917105+00', ''),
	('00000000-0000-0000-0000-000000000000', 'ec175b20-3316-4c7b-8a7d-3a22bf51849d', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-10 15:50:03.164812+00', ''),
	('00000000-0000-0000-0000-000000000000', 'd3a83f7b-f180-4cae-9ec6-7c4222d83ca6', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-10 15:50:03.165632+00', ''),
	('00000000-0000-0000-0000-000000000000', 'f222c04d-98df-41b1-ab83-17b2467bd2ea', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-10 18:23:14.341138+00', ''),
	('00000000-0000-0000-0000-000000000000', '6f257846-4289-4789-b6a8-ea8edb245fa6', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-10 18:23:14.371285+00', ''),
	('00000000-0000-0000-0000-000000000000', '317ffd31-d16e-43cf-85d7-3405ca699cc9', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-10 18:23:14.698928+00', ''),
	('00000000-0000-0000-0000-000000000000', 'aad40371-89eb-4bd1-90d3-0b289ce70224', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-10 18:23:14.707237+00', ''),
	('00000000-0000-0000-0000-000000000000', '0749fbc7-94f3-40c9-9ad9-7fff163d4fc6', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-10 20:48:42.134773+00', ''),
	('00000000-0000-0000-0000-000000000000', '85f430a8-a663-4801-8e38-e14c39eb0087', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-10 20:48:42.155037+00', ''),
	('00000000-0000-0000-0000-000000000000', 'db170b97-1059-4fd4-9a5b-64083662365e', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-10 22:47:23.978841+00', ''),
	('00000000-0000-0000-0000-000000000000', 'd3979b6d-7ece-4c08-bb29-e21a688952a4', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-10 22:47:23.980451+00', ''),
	('00000000-0000-0000-0000-000000000000', '82e193c7-3a48-4076-b9f0-c61d4f9555bf', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-10 23:26:02.446673+00', ''),
	('00000000-0000-0000-0000-000000000000', '1729dfa1-fee9-418b-8ea5-aea00a375732', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-10 23:26:02.447604+00', ''),
	('00000000-0000-0000-0000-000000000000', 'ba0cc4f4-e395-429b-bf9d-4ddd923a5785', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-11 10:29:31.743209+00', ''),
	('00000000-0000-0000-0000-000000000000', '49377855-2d49-4ec8-8e92-be7fecf4a37c', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-11 10:29:31.746778+00', ''),
	('00000000-0000-0000-0000-000000000000', 'e5e8e0bd-9e91-4af3-b6f5-d820109e0bc7', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-11 13:19:03.237528+00', ''),
	('00000000-0000-0000-0000-000000000000', 'b5f6a992-9a85-4f4a-a15d-2541a1112d21', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-11 13:19:03.239491+00', ''),
	('00000000-0000-0000-0000-000000000000', '3f4f9e1a-5230-494a-9ea2-bdb42f4598ed', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-11 20:28:47.63853+00', ''),
	('00000000-0000-0000-0000-000000000000', '0f65eb94-e510-4129-b931-ea054f41f27b', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-11 20:28:47.644383+00', ''),
	('00000000-0000-0000-0000-000000000000', '4a19614f-1c8d-4465-a0b2-c27d10db37f0', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-11 22:42:27.209321+00', ''),
	('00000000-0000-0000-0000-000000000000', 'b25f0e71-015c-4662-b8cc-b2fdb410d824', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-11 22:42:27.21115+00', ''),
	('00000000-0000-0000-0000-000000000000', 'f917500e-5e67-466b-b7df-8f49d8829724', '{"action":"login","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-03-11 23:19:37.117745+00', ''),
	('00000000-0000-0000-0000-000000000000', '54ad423d-c7c6-4f8f-801a-1e2731a44881', '{"action":"logout","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"account"}', '2025-03-11 23:29:15.364437+00', ''),
	('00000000-0000-0000-0000-000000000000', '240c2f73-ff8a-4a22-8cd8-f192fccb78e2', '{"action":"login","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-03-11 23:29:24.129044+00', ''),
	('00000000-0000-0000-0000-000000000000', '94a439af-4b61-4a66-93ef-d5830c5869c4', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-12 00:27:33.035646+00', ''),
	('00000000-0000-0000-0000-000000000000', '89b03209-9f5f-4379-be16-1052f76c1c0c', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-12 00:27:33.040583+00', ''),
	('00000000-0000-0000-0000-000000000000', '4b5d7e87-11f4-4b25-89dd-f77f8c469f09', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-12 09:14:53.27363+00', ''),
	('00000000-0000-0000-0000-000000000000', 'c6546107-40a2-4d40-b8c3-425fab655ec7', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-12 09:14:53.27675+00', ''),
	('00000000-0000-0000-0000-000000000000', '8d15127c-0b9c-43e3-8aca-b2dbe0e3f260', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-12 10:13:11.014716+00', ''),
	('00000000-0000-0000-0000-000000000000', 'cb0ac3a0-6b3b-49aa-a472-658034cac352', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-12 10:13:11.015594+00', ''),
	('00000000-0000-0000-0000-000000000000', 'e65b5d42-a09a-43ff-842d-37f19d1069f2', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-12 11:11:34.588708+00', ''),
	('00000000-0000-0000-0000-000000000000', '987bda6e-892b-4fe3-a6b2-479ac543793d', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-12 11:11:34.59042+00', ''),
	('00000000-0000-0000-0000-000000000000', '176d2670-0ff3-4351-a3e6-f21226687b86', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-12 12:10:29.739316+00', ''),
	('00000000-0000-0000-0000-000000000000', '40618158-583c-407d-8802-9a026af5b074', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-12 12:10:29.746521+00', ''),
	('00000000-0000-0000-0000-000000000000', '8b68ebeb-edc0-43a5-a32a-99c3ecb1bdf2', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-12 12:32:12.988318+00', ''),
	('00000000-0000-0000-0000-000000000000', 'dc3d3e9a-e029-4d9d-80ad-e4d49f4441ba', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-12 12:32:12.989939+00', ''),
	('00000000-0000-0000-0000-000000000000', 'bf2e3d89-6122-42df-aaec-3951f6805279', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-12 13:30:37.786079+00', ''),
	('00000000-0000-0000-0000-000000000000', 'eed626d3-1376-4a3c-91c6-c20dbe3b068f', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-12 13:30:37.78701+00', ''),
	('00000000-0000-0000-0000-000000000000', 'dfaa0679-0991-49f2-b15a-08407e232ee6', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-12 14:28:38.28335+00', ''),
	('00000000-0000-0000-0000-000000000000', '5d505d3d-a641-4829-8c22-82a8889f3f61', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-12 14:28:38.285103+00', ''),
	('00000000-0000-0000-0000-000000000000', '6873d4a5-0c0f-4121-872e-0b5b8e400232', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-12 15:26:52.092598+00', ''),
	('00000000-0000-0000-0000-000000000000', 'fb08a9f4-9fdc-4a63-8c3a-48c3160f1160', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-12 15:26:52.094624+00', ''),
	('00000000-0000-0000-0000-000000000000', '5a8271ca-ca86-4ade-b793-8d2624a8102b', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-12 16:24:52.655809+00', ''),
	('00000000-0000-0000-0000-000000000000', '0211d54a-63cb-489b-8334-c093d8833895', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-12 16:24:52.656997+00', ''),
	('00000000-0000-0000-0000-000000000000', '86ff017d-ced2-4340-89ec-417945898114', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-12 17:23:12.565961+00', ''),
	('00000000-0000-0000-0000-000000000000', '0d5d04ae-c4c0-42e2-81aa-80ec598d9c7b', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-12 17:23:12.568223+00', ''),
	('00000000-0000-0000-0000-000000000000', '777dc449-792a-45d3-aee5-e1806c7e90a8', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-12 19:01:07.066364+00', ''),
	('00000000-0000-0000-0000-000000000000', '5a17eae1-c5c3-4b73-88ef-860fb795565e', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-12 19:01:07.069095+00', ''),
	('00000000-0000-0000-0000-000000000000', '3d5fa781-0e11-4db1-abdd-75c0a43f4b07', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-12 21:14:57.16597+00', ''),
	('00000000-0000-0000-0000-000000000000', '305b631e-f2da-4132-84bf-bf625855dccd', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-12 21:14:57.172389+00', ''),
	('00000000-0000-0000-0000-000000000000', '685d27e6-fd5d-426b-82f9-d1105d4fd09b', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-12 22:13:15.705537+00', ''),
	('00000000-0000-0000-0000-000000000000', '84eda2d6-382d-4224-b3b3-cbca9aa2334a', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-12 22:13:15.706887+00', ''),
	('00000000-0000-0000-0000-000000000000', '7a4a8beb-fd81-4768-94da-ea722bbf2708', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-12 23:52:25.350473+00', ''),
	('00000000-0000-0000-0000-000000000000', '3dc2a37c-85b0-4a65-acb5-f70661411347', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-12 23:52:25.352304+00', ''),
	('00000000-0000-0000-0000-000000000000', '066865f4-464b-455c-9ef6-beeaf6197354', '{"action":"login","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-03-13 00:45:28.749704+00', ''),
	('00000000-0000-0000-0000-000000000000', '022e55e6-afa5-49c5-a96a-af6bae55ccac', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-13 00:50:33.791129+00', ''),
	('00000000-0000-0000-0000-000000000000', 'f9ce544a-c977-4e80-a589-329dd10f170a', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-13 00:50:33.792103+00', ''),
	('00000000-0000-0000-0000-000000000000', '66e5b497-efa6-49f3-a3b1-cfcb99177dd5', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-13 01:43:55.205226+00', ''),
	('00000000-0000-0000-0000-000000000000', '1d87dbb7-15bf-49f3-8ec8-1cc81dcf9d87', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-13 01:43:55.207847+00', ''),
	('00000000-0000-0000-0000-000000000000', '98a2e4dc-adc8-4011-9f8f-6f77cf9b10ea', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-13 01:49:49.645896+00', ''),
	('00000000-0000-0000-0000-000000000000', '064a68aa-b797-457a-a656-3bac94be50bb', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-13 01:49:49.647194+00', ''),
	('00000000-0000-0000-0000-000000000000', '759ae726-68af-449d-9ec3-8b4d3bbcc764', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-13 15:44:31.574232+00', ''),
	('00000000-0000-0000-0000-000000000000', 'f171cc01-1a69-4176-af63-b1eb04bc125a', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-13 15:44:31.575698+00', ''),
	('00000000-0000-0000-0000-000000000000', 'dca04583-2ab8-40e4-ba52-9dec67f00c79', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-13 16:05:44.507769+00', ''),
	('00000000-0000-0000-0000-000000000000', '35fbeba8-23d4-4699-83bf-b515685e294c', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-13 16:05:44.50838+00', ''),
	('00000000-0000-0000-0000-000000000000', '28c7f91c-5472-4b26-9055-18fb22bd1774', '{"action":"login","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-03-16 22:20:23.419111+00', ''),
	('00000000-0000-0000-0000-000000000000', '366c5cb4-6de2-42af-b90b-078e78aa3219', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-17 08:43:46.631312+00', ''),
	('00000000-0000-0000-0000-000000000000', '1b9ae2d5-d976-4716-82dd-b799e9308ad8', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-17 08:43:46.633022+00', ''),
	('00000000-0000-0000-0000-000000000000', '45bfa366-0902-4e44-9f88-f8f347807fda', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-17 13:29:39.810149+00', ''),
	('00000000-0000-0000-0000-000000000000', '90c5ea16-412e-4f76-95c1-591af53a170f', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-17 13:29:39.814716+00', ''),
	('00000000-0000-0000-0000-000000000000', 'fe34b7ff-62c1-44bf-8f81-85deec7a01d8', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-17 16:23:09.664641+00', ''),
	('00000000-0000-0000-0000-000000000000', '095377c0-40fd-4f63-aea7-5187f745b9b3', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-17 16:23:09.666131+00', ''),
	('00000000-0000-0000-0000-000000000000', '3e1e4f5d-2490-4142-8efd-d2f4421d7e3a', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-17 17:24:17.05349+00', ''),
	('00000000-0000-0000-0000-000000000000', 'b6c9de7f-3e8c-4a7a-bf49-b671a2c6a5bb', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-17 17:24:17.055608+00', ''),
	('00000000-0000-0000-0000-000000000000', '2cb81a58-d01e-4db1-96ec-d7ab940362ca', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-17 18:29:41.727726+00', ''),
	('00000000-0000-0000-0000-000000000000', '99f7289a-1c23-4c9c-9379-94574e496521', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-17 18:29:41.728602+00', ''),
	('00000000-0000-0000-0000-000000000000', 'acefca32-75fa-4f1c-a61d-3ed01bb7ffb4', '{"action":"login","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-03-18 12:10:56.062971+00', ''),
	('00000000-0000-0000-0000-000000000000', '11ce42bb-96ae-44db-95ef-bf5fe1c22f30', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-18 13:09:40.916689+00', ''),
	('00000000-0000-0000-0000-000000000000', '755fe929-eeb7-467a-b019-3943aea1e08b', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-18 13:09:40.917276+00', ''),
	('00000000-0000-0000-0000-000000000000', '14d137bc-0262-42c8-90a8-44f80b6a7cb8', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-18 16:32:40.364507+00', ''),
	('00000000-0000-0000-0000-000000000000', 'b2100173-a499-49fa-8900-9cbcfb6024ca', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-18 16:32:40.365892+00', ''),
	('00000000-0000-0000-0000-000000000000', '24fa4990-e9a6-40f6-b7d0-23f01a590a36', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-18 17:33:46.777746+00', ''),
	('00000000-0000-0000-0000-000000000000', 'ab730ceb-46d2-4ca6-90ab-a2fbcfeb1bcb', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-18 17:33:46.778538+00', ''),
	('00000000-0000-0000-0000-000000000000', 'd2f7840c-5be2-455b-b02a-9456402ac3ed', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-18 18:31:48.835161+00', ''),
	('00000000-0000-0000-0000-000000000000', 'd6281730-cc66-4eac-a5c9-c131df28873c', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-18 18:31:48.836668+00', ''),
	('00000000-0000-0000-0000-000000000000', '05e9ab81-417a-4fb6-a7e1-8021e4e2eb29', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-19 15:31:32.584629+00', ''),
	('00000000-0000-0000-0000-000000000000', 'e3d8d0e4-69ac-4c36-a8f5-c84bda1f7d0e', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-19 15:31:32.598267+00', ''),
	('00000000-0000-0000-0000-000000000000', 'afb94de6-afe9-4eb3-99b3-cba584ab1427', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-19 16:28:48.961907+00', ''),
	('00000000-0000-0000-0000-000000000000', 'c44938ff-9454-4430-8534-793c0af1d597', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-19 16:28:48.966577+00', ''),
	('00000000-0000-0000-0000-000000000000', '911c6a87-a237-47c0-854d-35a16c677e19', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-19 17:27:16.669857+00', ''),
	('00000000-0000-0000-0000-000000000000', '1cf1a994-471f-41ca-a418-a74ee4da9d94', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-19 17:27:16.671614+00', ''),
	('00000000-0000-0000-0000-000000000000', 'a169d941-5007-4048-b8fe-6a7891d42592', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-19 20:56:00.040459+00', ''),
	('00000000-0000-0000-0000-000000000000', '04ed0d1c-0a44-4377-ad80-30e656944157', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-19 20:56:00.042375+00', ''),
	('00000000-0000-0000-0000-000000000000', '56fab5aa-af70-4e58-b68a-0129e6f2b270', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-19 21:54:08.346105+00', ''),
	('00000000-0000-0000-0000-000000000000', '427141d7-b2e3-4a32-b9f8-336080493d26', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-19 21:54:08.347363+00', ''),
	('00000000-0000-0000-0000-000000000000', '852344e7-fa1d-4bad-ac19-8beb25040552', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-19 22:52:27.390018+00', ''),
	('00000000-0000-0000-0000-000000000000', '785d0dd2-9865-4289-9cc5-be27043b2afa', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-19 22:52:27.391223+00', ''),
	('00000000-0000-0000-0000-000000000000', 'a97ecaa3-719b-4893-853f-180cf202479b', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-19 23:50:42.550337+00', ''),
	('00000000-0000-0000-0000-000000000000', 'c3207eff-d072-4818-96bc-f411c7178140', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-19 23:50:42.552055+00', ''),
	('00000000-0000-0000-0000-000000000000', '6fb05410-7918-4973-ad7d-8b7874231281', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-20 04:08:55.433331+00', ''),
	('00000000-0000-0000-0000-000000000000', 'b58342f7-08ca-402a-a19b-0a3dd5aae2c0', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-20 04:08:55.442819+00', ''),
	('00000000-0000-0000-0000-000000000000', '4673d974-0279-4442-8e8d-31dec58c8430', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-20 13:11:10.087621+00', ''),
	('00000000-0000-0000-0000-000000000000', 'bbfd3795-1c58-4d8c-af46-070c6d437023', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-20 13:11:10.09023+00', ''),
	('00000000-0000-0000-0000-000000000000', '0df18bcb-e304-431f-998c-252a2c8d6f07', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-20 14:09:51.829874+00', ''),
	('00000000-0000-0000-0000-000000000000', '189e6d90-22ed-4100-b40b-03194431151a', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-20 14:09:51.83124+00', ''),
	('00000000-0000-0000-0000-000000000000', '2ef0bfd5-0c91-480b-be96-f0759ada119d', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-20 15:05:21.752996+00', ''),
	('00000000-0000-0000-0000-000000000000', '65109bb2-f834-42fb-847f-0de580832ef8', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-20 15:05:21.75478+00', ''),
	('00000000-0000-0000-0000-000000000000', 'fda76a41-f1cb-4111-97dc-11e37a7be4d9', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-20 17:22:54.259607+00', ''),
	('00000000-0000-0000-0000-000000000000', '45979ac4-0f26-4422-b37f-110c4f41a3cc', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-20 17:22:54.260899+00', ''),
	('00000000-0000-0000-0000-000000000000', 'c1f5ddf3-b3d6-4cc9-a318-4eac4c6bde76', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-20 21:48:26.150806+00', ''),
	('00000000-0000-0000-0000-000000000000', '31022db5-a711-45d5-ab0d-5906c27df49f', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-20 21:48:26.152023+00', ''),
	('00000000-0000-0000-0000-000000000000', 'bc3a88f2-0a48-4cc3-8503-b92c86ff3fcc', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-20 21:48:26.166346+00', ''),
	('00000000-0000-0000-0000-000000000000', '155f8653-7922-4b3f-bac4-1ac17822db2e', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-21 10:53:51.962499+00', ''),
	('00000000-0000-0000-0000-000000000000', 'a6a5f1b6-d393-4eb6-961c-ebce3a2909d6', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-21 10:53:51.964817+00', ''),
	('00000000-0000-0000-0000-000000000000', '44278d68-7b5b-433c-9b80-1184413b25a8', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-23 23:19:51.520262+00', ''),
	('00000000-0000-0000-0000-000000000000', 'b75fc631-ed1c-4bbf-9b81-e8426cca1cac', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-23 23:19:51.522029+00', ''),
	('00000000-0000-0000-0000-000000000000', 'c84a74f7-e962-4fa9-80c2-f683781742e2', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-24 12:12:50.070553+00', ''),
	('00000000-0000-0000-0000-000000000000', '5fb5497d-c19c-4678-ab3d-7d84b4809a42', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-24 12:12:50.071605+00', ''),
	('00000000-0000-0000-0000-000000000000', 'c65e1fa2-6797-4def-be11-6dc3529b0cb2', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-25 15:47:50.363667+00', ''),
	('00000000-0000-0000-0000-000000000000', 'aeba1e5a-c82c-46ba-b1d3-1416b4e611bd', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-25 15:47:50.364756+00', ''),
	('00000000-0000-0000-0000-000000000000', '76fd9302-d26f-4eee-be45-a2fb386dd3ba', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-25 17:24:01.710037+00', ''),
	('00000000-0000-0000-0000-000000000000', 'd29dbd80-023d-4bf4-89c7-190c406aa55c', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-25 17:24:01.710809+00', ''),
	('00000000-0000-0000-0000-000000000000', 'bf9a45a8-a97a-44d6-a07a-64171ca8e6d9', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-25 17:55:40.24768+00', ''),
	('00000000-0000-0000-0000-000000000000', '8a6a752a-60b5-49cf-b618-faf947c549c9', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-25 17:55:40.249201+00', ''),
	('00000000-0000-0000-0000-000000000000', '9f7a5a06-62c7-43f8-914c-30b8a8bae9f1', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-25 18:22:08.514741+00', ''),
	('00000000-0000-0000-0000-000000000000', '768c18d2-cba9-41dc-948d-326306428025', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-25 18:22:08.515725+00', ''),
	('00000000-0000-0000-0000-000000000000', '43824a79-67c9-4c14-8d4c-3d34e2e770ff', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-25 22:28:31.603918+00', ''),
	('00000000-0000-0000-0000-000000000000', 'd71c36e7-e743-4638-8a9e-87d564463c72', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-25 22:28:31.606637+00', ''),
	('00000000-0000-0000-0000-000000000000', '54814734-0236-4634-9836-f40c50300d98', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-26 07:37:31.155849+00', ''),
	('00000000-0000-0000-0000-000000000000', '8e6254fc-e0ca-4858-8b83-e1bf52b0e16a', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-26 07:37:31.158717+00', ''),
	('00000000-0000-0000-0000-000000000000', '81fbf3ac-909b-4884-aed8-513976d7fb1a', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-29 00:30:32.160041+00', ''),
	('00000000-0000-0000-0000-000000000000', '589a3435-02a5-41e2-a8ee-902d9b63f647', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-29 00:30:32.16841+00', ''),
	('00000000-0000-0000-0000-000000000000', '31a0327f-3cca-41b3-9655-bd28bc94c78c', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-29 01:17:49.046114+00', ''),
	('00000000-0000-0000-0000-000000000000', '8f0a74a9-7064-4e6d-ad55-2eb2f04c0552', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-29 01:17:49.04863+00', ''),
	('00000000-0000-0000-0000-000000000000', '6b7171ee-811c-44d6-b053-43c86dae1801', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-29 01:17:49.160904+00', ''),
	('00000000-0000-0000-0000-000000000000', 'e8d96bec-0c5d-41a7-9a66-55ad0bc8cd2b', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-29 01:17:49.162884+00', ''),
	('00000000-0000-0000-0000-000000000000', 'c3fd9c11-a301-41f2-a964-b34093de144b', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-29 10:25:45.083319+00', ''),
	('00000000-0000-0000-0000-000000000000', '40a61d6e-1e2f-453c-883f-111e9a3cba44', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-29 10:25:45.087077+00', ''),
	('00000000-0000-0000-0000-000000000000', '3527a07f-7715-4cfd-ad45-e3de02e6282c', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-29 11:51:59.050241+00', ''),
	('00000000-0000-0000-0000-000000000000', '3b3901e4-849c-4e87-9748-f16504c66ff7', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-29 11:51:59.054726+00', ''),
	('00000000-0000-0000-0000-000000000000', 'f2d987d3-411d-40fb-9df1-da176cb46180', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-29 12:30:24.845595+00', ''),
	('00000000-0000-0000-0000-000000000000', 'e0e62077-cf3a-453c-97ae-12833b5fcaa6', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-29 12:30:24.852734+00', ''),
	('00000000-0000-0000-0000-000000000000', '7fc030bb-5b77-4b7a-bd54-db669a82c6b5', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-29 13:28:35.400063+00', ''),
	('00000000-0000-0000-0000-000000000000', '86db2490-0da9-4dbe-b3cd-5f971c2ee180', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-29 13:28:35.403706+00', ''),
	('00000000-0000-0000-0000-000000000000', '519a91bf-afe4-4cdc-8794-f31b6000016f', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-29 14:07:44.704283+00', ''),
	('00000000-0000-0000-0000-000000000000', '9e9875a3-411e-4ce1-bb81-dc69ebeb113a', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-29 14:07:44.708975+00', ''),
	('00000000-0000-0000-0000-000000000000', '61567872-3747-4902-968e-8a6598d3806d', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-29 14:26:51.823065+00', ''),
	('00000000-0000-0000-0000-000000000000', '207506cf-4c63-4be3-ace6-82a176a79e9d', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-29 14:26:51.83864+00', ''),
	('00000000-0000-0000-0000-000000000000', 'ad34c387-6ab0-4999-8ba6-7a6c85e16e7b', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-29 15:25:01.371683+00', ''),
	('00000000-0000-0000-0000-000000000000', 'be7cbba7-3e5a-4fdb-bf4e-281e6ab44be7', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-29 15:25:01.375283+00', ''),
	('00000000-0000-0000-0000-000000000000', '9684709f-06fb-490a-869b-8a5b084aea7c', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-29 16:11:00.973261+00', ''),
	('00000000-0000-0000-0000-000000000000', '842a4e56-fcc2-4d55-9367-30be5c87a151', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-29 16:11:00.978547+00', ''),
	('00000000-0000-0000-0000-000000000000', '3e2379e9-99b5-4d58-b1c6-3be7239c87d2', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-29 17:20:59.323494+00', ''),
	('00000000-0000-0000-0000-000000000000', '0022ac83-bb1f-458f-80dc-9df61e56c09a', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-29 17:20:59.330838+00', ''),
	('00000000-0000-0000-0000-000000000000', '3950d9a9-1da3-45ef-88a6-3abfdeffcd6f', '{"action":"logout","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"account"}', '2025-03-29 18:10:58.258715+00', ''),
	('00000000-0000-0000-0000-000000000000', '69b5bf76-ac05-425f-a30f-7bf63947f66b', '{"action":"user_signedup","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"1@2.com","user_id":"ac212d00-2d74-42d3-84a4-0cbcf4b0e20c","user_phone":""}}', '2025-03-29 18:11:26.046072+00', ''),
	('00000000-0000-0000-0000-000000000000', '5dd54e46-44b2-4f0c-82c9-85a31f3a23ab', '{"action":"login","actor_id":"ac212d00-2d74-42d3-84a4-0cbcf4b0e20c","actor_username":"1@2.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-03-29 18:11:57.067157+00', ''),
	('00000000-0000-0000-0000-000000000000', '3ff531db-beb0-4aa3-8a61-2b1502b20336', '{"action":"token_refreshed","actor_id":"ac212d00-2d74-42d3-84a4-0cbcf4b0e20c","actor_username":"1@2.com","actor_via_sso":false,"log_type":"token"}', '2025-03-29 18:55:14.384063+00', ''),
	('00000000-0000-0000-0000-000000000000', '586324a5-12c6-4cc9-b455-98769230132d', '{"action":"token_revoked","actor_id":"ac212d00-2d74-42d3-84a4-0cbcf4b0e20c","actor_username":"1@2.com","actor_via_sso":false,"log_type":"token"}', '2025-03-29 18:55:14.39221+00', ''),
	('00000000-0000-0000-0000-000000000000', 'cd7eeb0a-d92f-41f0-bb2d-1408641baaf3', '{"action":"token_refreshed","actor_id":"ac212d00-2d74-42d3-84a4-0cbcf4b0e20c","actor_username":"1@2.com","actor_via_sso":false,"log_type":"token"}', '2025-03-29 18:55:16.284677+00', ''),
	('00000000-0000-0000-0000-000000000000', '7faa7fa7-a3e4-4e74-a35a-95b542b4aa7d', '{"action":"token_refreshed","actor_id":"ac212d00-2d74-42d3-84a4-0cbcf4b0e20c","actor_username":"1@2.com","actor_via_sso":false,"log_type":"token"}', '2025-03-29 19:53:28.873466+00', ''),
	('00000000-0000-0000-0000-000000000000', '2153c1d0-1792-4fd5-b1b6-6d2fe14d27c7', '{"action":"token_revoked","actor_id":"ac212d00-2d74-42d3-84a4-0cbcf4b0e20c","actor_username":"1@2.com","actor_via_sso":false,"log_type":"token"}', '2025-03-29 19:53:28.87661+00', ''),
	('00000000-0000-0000-0000-000000000000', 'd183b76a-a49c-42b4-b45e-92e066c1285b', '{"action":"login","actor_id":"ac212d00-2d74-42d3-84a4-0cbcf4b0e20c","actor_username":"1@2.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-03-29 20:11:25.352966+00', ''),
	('00000000-0000-0000-0000-000000000000', '026e52a5-a6fc-47ca-b94d-773229d2762b', '{"action":"logout","actor_id":"ac212d00-2d74-42d3-84a4-0cbcf4b0e20c","actor_username":"1@2.com","actor_via_sso":false,"log_type":"account"}', '2025-03-29 20:17:21.849673+00', ''),
	('00000000-0000-0000-0000-000000000000', 'b53172c0-53dd-4b11-98a7-232ad861673a', '{"action":"login","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-03-29 20:17:25.618139+00', ''),
	('00000000-0000-0000-0000-000000000000', '3b96247c-9092-41ab-84e7-b9837858efdd', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-31 21:02:21.776341+00', ''),
	('00000000-0000-0000-0000-000000000000', '0f8b23eb-4369-499c-a60e-a1cb7d75806a', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-31 21:02:21.778352+00', ''),
	('00000000-0000-0000-0000-000000000000', 'dce909e1-b463-4655-b883-49ab3f603535', '{"action":"login","actor_id":"ac212d00-2d74-42d3-84a4-0cbcf4b0e20c","actor_username":"1@2.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-03-31 21:29:56.656025+00', ''),
	('00000000-0000-0000-0000-000000000000', 'd02a6531-acfa-4ebc-994b-8de6201a4c06', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-31 22:00:34.737915+00', ''),
	('00000000-0000-0000-0000-000000000000', '048d393e-371b-4b33-9eed-e017ee71376f', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-31 22:00:34.740671+00', ''),
	('00000000-0000-0000-0000-000000000000', 'c1507727-cf1e-4b1d-b035-26e0d073224e', '{"action":"token_refreshed","actor_id":"ac212d00-2d74-42d3-84a4-0cbcf4b0e20c","actor_username":"1@2.com","actor_via_sso":false,"log_type":"token"}', '2025-03-31 22:28:07.056669+00', ''),
	('00000000-0000-0000-0000-000000000000', 'ff020232-0197-4f87-9291-02092640260f', '{"action":"token_revoked","actor_id":"ac212d00-2d74-42d3-84a4-0cbcf4b0e20c","actor_username":"1@2.com","actor_via_sso":false,"log_type":"token"}', '2025-03-31 22:28:07.057855+00', ''),
	('00000000-0000-0000-0000-000000000000', '833e7a49-6a92-408a-8a9c-f3a47a89594c', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-31 22:58:56.47166+00', ''),
	('00000000-0000-0000-0000-000000000000', '627d66db-8ff1-477c-a5b2-a5c8b94e1d5a', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-03-31 22:58:56.472849+00', ''),
	('00000000-0000-0000-0000-000000000000', '80297905-5368-448c-855e-5c9ebd804ca9', '{"action":"token_refreshed","actor_id":"ac212d00-2d74-42d3-84a4-0cbcf4b0e20c","actor_username":"1@2.com","actor_via_sso":false,"log_type":"token"}', '2025-03-31 23:26:33.239576+00', ''),
	('00000000-0000-0000-0000-000000000000', '9010a4cc-58e8-43e7-af18-4c36f62b37b9', '{"action":"token_revoked","actor_id":"ac212d00-2d74-42d3-84a4-0cbcf4b0e20c","actor_username":"1@2.com","actor_via_sso":false,"log_type":"token"}', '2025-03-31 23:26:33.240708+00', ''),
	('00000000-0000-0000-0000-000000000000', 'a9affddf-5ad0-4672-9a2f-e4ff4810d388', '{"action":"token_refreshed","actor_id":"ac212d00-2d74-42d3-84a4-0cbcf4b0e20c","actor_username":"1@2.com","actor_via_sso":false,"log_type":"token"}', '2025-04-01 09:09:35.959177+00', ''),
	('00000000-0000-0000-0000-000000000000', '666b6a60-3a14-4568-8f70-4bdacce0efbd', '{"action":"token_revoked","actor_id":"ac212d00-2d74-42d3-84a4-0cbcf4b0e20c","actor_username":"1@2.com","actor_via_sso":false,"log_type":"token"}', '2025-04-01 09:09:36.111437+00', ''),
	('00000000-0000-0000-0000-000000000000', '41ed3077-b84b-4adf-865e-6038edc35591', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-04-01 09:09:36.384684+00', ''),
	('00000000-0000-0000-0000-000000000000', '83adfdc0-5b29-4564-9f9a-2e404afc6cae', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-04-01 09:09:36.387432+00', ''),
	('00000000-0000-0000-0000-000000000000', '92436cab-b2c4-4167-8ce5-11e4835816f9', '{"action":"logout","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"account"}', '2025-04-01 09:24:34.065749+00', ''),
	('00000000-0000-0000-0000-000000000000', 'fe89798d-5af2-416c-881a-59fa501fe4c1', '{"action":"login","actor_id":"4f9aa889-a4d1-4cda-bb8f-5190c1bbd959","actor_username":"doskf@fksod.co","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-04-01 09:24:39.796968+00', ''),
	('00000000-0000-0000-0000-000000000000', 'a1f01f27-05e3-4f1f-a6a2-c3e671e8487d', '{"action":"logout","actor_id":"4f9aa889-a4d1-4cda-bb8f-5190c1bbd959","actor_username":"doskf@fksod.co","actor_via_sso":false,"log_type":"account"}', '2025-04-01 09:46:35.091611+00', ''),
	('00000000-0000-0000-0000-000000000000', 'f1d08f27-1ae0-4eb8-9cf7-51ba51fb0f50', '{"action":"login","actor_id":"ac212d00-2d74-42d3-84a4-0cbcf4b0e20c","actor_username":"1@2.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-04-01 09:46:53.854631+00', ''),
	('00000000-0000-0000-0000-000000000000', '3ffa63f0-c419-41de-ad6c-03c03e6f2f43', '{"action":"token_refreshed","actor_id":"ac212d00-2d74-42d3-84a4-0cbcf4b0e20c","actor_username":"1@2.com","actor_via_sso":false,"log_type":"token"}', '2025-04-01 10:34:18.672356+00', ''),
	('00000000-0000-0000-0000-000000000000', '8e246154-2ac0-41b8-92f8-59c3d16f9e01', '{"action":"token_revoked","actor_id":"ac212d00-2d74-42d3-84a4-0cbcf4b0e20c","actor_username":"1@2.com","actor_via_sso":false,"log_type":"token"}', '2025-04-01 10:34:18.678924+00', ''),
	('00000000-0000-0000-0000-000000000000', 'e258e913-47d8-433f-886c-6a851a7fa969', '{"action":"token_refreshed","actor_id":"ac212d00-2d74-42d3-84a4-0cbcf4b0e20c","actor_username":"1@2.com","actor_via_sso":false,"log_type":"token"}', '2025-04-01 10:45:08.585631+00', ''),
	('00000000-0000-0000-0000-000000000000', 'cdff6208-c1e8-446b-9f13-e9af00537bd9', '{"action":"token_revoked","actor_id":"ac212d00-2d74-42d3-84a4-0cbcf4b0e20c","actor_username":"1@2.com","actor_via_sso":false,"log_type":"token"}', '2025-04-01 10:45:08.587363+00', ''),
	('00000000-0000-0000-0000-000000000000', 'cfef7524-8217-4a2c-995d-0d9625514125', '{"action":"token_refreshed","actor_id":"ac212d00-2d74-42d3-84a4-0cbcf4b0e20c","actor_username":"1@2.com","actor_via_sso":false,"log_type":"token"}', '2025-04-01 11:54:57.824551+00', ''),
	('00000000-0000-0000-0000-000000000000', 'a85961a1-ad2b-4b3d-92eb-84ae0ec24e63', '{"action":"token_revoked","actor_id":"ac212d00-2d74-42d3-84a4-0cbcf4b0e20c","actor_username":"1@2.com","actor_via_sso":false,"log_type":"token"}', '2025-04-01 11:54:57.83012+00', ''),
	('00000000-0000-0000-0000-000000000000', '6a058acc-e46e-4ac3-b053-86b0d2519257', '{"action":"token_refreshed","actor_id":"ac212d00-2d74-42d3-84a4-0cbcf4b0e20c","actor_username":"1@2.com","actor_via_sso":false,"log_type":"token"}', '2025-04-01 11:54:58.022322+00', ''),
	('00000000-0000-0000-0000-000000000000', '7851a130-3af9-4caa-9aa7-fcf341cd7b03', '{"action":"token_revoked","actor_id":"ac212d00-2d74-42d3-84a4-0cbcf4b0e20c","actor_username":"1@2.com","actor_via_sso":false,"log_type":"token"}', '2025-04-01 11:54:58.023622+00', ''),
	('00000000-0000-0000-0000-000000000000', 'ade82d92-35fc-4eba-9223-7725a32a8d6e', '{"action":"logout","actor_id":"ac212d00-2d74-42d3-84a4-0cbcf4b0e20c","actor_username":"1@2.com","actor_via_sso":false,"log_type":"account"}', '2025-04-01 12:23:24.840743+00', ''),
	('00000000-0000-0000-0000-000000000000', '2e5ca616-608f-43ac-a0ff-54fdc07614d2', '{"action":"login","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-04-01 12:23:39.908191+00', ''),
	('00000000-0000-0000-0000-000000000000', '7b9d3720-db05-4ceb-b3f3-3867fa5c5f0c', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-04-01 14:00:42.346337+00', ''),
	('00000000-0000-0000-0000-000000000000', 'a6662ce0-0119-4f5e-8249-19210222d17e', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-04-01 14:00:42.348577+00', ''),
	('00000000-0000-0000-0000-000000000000', 'f2919566-2c0d-49d3-b578-3ce74267378b', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-04-01 21:25:43.580921+00', ''),
	('00000000-0000-0000-0000-000000000000', 'd3f4a976-434f-4f47-86da-fc580808d5bf', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-04-01 21:25:43.583873+00', ''),
	('00000000-0000-0000-0000-000000000000', '997524b8-04cb-48cf-9630-ee726db5c123', '{"action":"login","actor_id":"ac212d00-2d74-42d3-84a4-0cbcf4b0e20c","actor_username":"1@2.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-04-01 22:18:09.563648+00', ''),
	('00000000-0000-0000-0000-000000000000', 'da4c7a73-7e7a-4c22-876f-ca0849b50b18', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-04-01 22:25:05.568088+00', ''),
	('00000000-0000-0000-0000-000000000000', 'cc3bfd8a-01a9-4704-9741-1778d525ceda', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-04-01 22:25:05.570363+00', ''),
	('00000000-0000-0000-0000-000000000000', '505960b4-4aec-4e07-8813-aa087b1ca807', '{"action":"login","actor_id":"ac212d00-2d74-42d3-84a4-0cbcf4b0e20c","actor_username":"1@2.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-04-01 22:38:55.639817+00', ''),
	('00000000-0000-0000-0000-000000000000', '053829a0-e6a9-46ab-8dd4-2d76aa475c28', '{"action":"login","actor_id":"ac212d00-2d74-42d3-84a4-0cbcf4b0e20c","actor_username":"1@2.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-04-01 22:41:54.258433+00', ''),
	('00000000-0000-0000-0000-000000000000', '9d974fce-b6b2-446b-af7f-e72f2c27b248', '{"action":"token_refreshed","actor_id":"ac212d00-2d74-42d3-84a4-0cbcf4b0e20c","actor_username":"1@2.com","actor_via_sso":false,"log_type":"token"}', '2025-04-01 23:39:58.077844+00', ''),
	('00000000-0000-0000-0000-000000000000', '52ca0bfa-5c26-4352-88d2-b890f1b97548', '{"action":"token_revoked","actor_id":"ac212d00-2d74-42d3-84a4-0cbcf4b0e20c","actor_username":"1@2.com","actor_via_sso":false,"log_type":"token"}', '2025-04-01 23:39:58.079551+00', ''),
	('00000000-0000-0000-0000-000000000000', 'c8a771ac-77a6-4464-be60-ea6f933e8ad9', '{"action":"token_refreshed","actor_id":"ac212d00-2d74-42d3-84a4-0cbcf4b0e20c","actor_username":"1@2.com","actor_via_sso":false,"log_type":"token"}', '2025-04-02 09:51:30.15445+00', ''),
	('00000000-0000-0000-0000-000000000000', 'af53aa6e-03bd-43a9-b908-54148fadbd00', '{"action":"token_revoked","actor_id":"ac212d00-2d74-42d3-84a4-0cbcf4b0e20c","actor_username":"1@2.com","actor_via_sso":false,"log_type":"token"}', '2025-04-02 09:51:30.158773+00', ''),
	('00000000-0000-0000-0000-000000000000', '79bba9a7-6155-4437-b222-630dbd1f0c4a', '{"action":"token_refreshed","actor_id":"ac212d00-2d74-42d3-84a4-0cbcf4b0e20c","actor_username":"1@2.com","actor_via_sso":false,"log_type":"token"}', '2025-04-02 17:22:28.145447+00', ''),
	('00000000-0000-0000-0000-000000000000', 'd20bc6f6-d35e-4302-b0ad-a5ecda3bef13', '{"action":"token_revoked","actor_id":"ac212d00-2d74-42d3-84a4-0cbcf4b0e20c","actor_username":"1@2.com","actor_via_sso":false,"log_type":"token"}', '2025-04-02 17:22:28.146818+00', ''),
	('00000000-0000-0000-0000-000000000000', '4937df61-8a6a-4acb-bbaf-f99ae19fd23f', '{"action":"login","actor_id":"ac212d00-2d74-42d3-84a4-0cbcf4b0e20c","actor_username":"1@2.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-04-02 17:24:47.479058+00', ''),
	('00000000-0000-0000-0000-000000000000', 'b2614c7f-f5b3-456d-863c-99b9011ac7eb', '{"action":"logout","actor_id":"ac212d00-2d74-42d3-84a4-0cbcf4b0e20c","actor_username":"1@2.com","actor_via_sso":false,"log_type":"account"}', '2025-04-02 17:25:36.927435+00', ''),
	('00000000-0000-0000-0000-000000000000', '42f0ded7-0aa9-4c0b-9bf2-f8ac0cdc22d3', '{"action":"login","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-04-02 17:25:40.594154+00', ''),
	('00000000-0000-0000-0000-000000000000', '23a03a33-579b-492e-bc3c-b5009222bbcc', '{"action":"logout","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"account"}', '2025-04-02 17:26:05.732707+00', ''),
	('00000000-0000-0000-0000-000000000000', '948e67b5-9b8e-412b-b8c6-b5643641f56f', '{"action":"login","actor_id":"ac212d00-2d74-42d3-84a4-0cbcf4b0e20c","actor_username":"1@2.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-04-02 17:26:09.616152+00', ''),
	('00000000-0000-0000-0000-000000000000', '2b0906e2-d0fe-41c0-8fd6-05ba00ea60a0', '{"action":"logout","actor_id":"ac212d00-2d74-42d3-84a4-0cbcf4b0e20c","actor_username":"1@2.com","actor_via_sso":false,"log_type":"account"}', '2025-04-02 17:32:39.7634+00', ''),
	('00000000-0000-0000-0000-000000000000', '50c65d2c-781d-425e-9690-bdc4a1544a3a', '{"action":"login","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-04-02 17:32:43.772602+00', ''),
	('00000000-0000-0000-0000-000000000000', '9daec817-bb41-47a8-8a3a-fb793f1704e2', '{"action":"logout","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"account"}', '2025-04-02 17:32:58.597358+00', ''),
	('00000000-0000-0000-0000-000000000000', 'c5a8ac06-e579-4fe0-ac33-886c25d2d620', '{"action":"login","actor_id":"ac212d00-2d74-42d3-84a4-0cbcf4b0e20c","actor_username":"1@2.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-04-02 17:33:02.773941+00', ''),
	('00000000-0000-0000-0000-000000000000', '2d2bf119-f078-4b68-9597-949ea6718593', '{"action":"logout","actor_id":"ac212d00-2d74-42d3-84a4-0cbcf4b0e20c","actor_username":"1@2.com","actor_via_sso":false,"log_type":"account"}', '2025-04-02 17:33:05.540859+00', ''),
	('00000000-0000-0000-0000-000000000000', '783b2b3b-e58e-4374-84d6-31b6f11f166d', '{"action":"login","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-04-02 17:33:09.09951+00', ''),
	('00000000-0000-0000-0000-000000000000', '02bcd2d2-b408-45cf-aed9-8dcf0604c2b0', '{"action":"logout","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"account"}', '2025-04-02 17:33:11.397612+00', ''),
	('00000000-0000-0000-0000-000000000000', '763f8e1d-5140-4994-af4f-47f4cb62b14e', '{"action":"login","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-04-02 17:33:56.761014+00', ''),
	('00000000-0000-0000-0000-000000000000', 'd6c7d991-4d3a-42fe-8cc1-1ebc9a5173f7', '{"action":"logout","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"account"}', '2025-04-02 18:20:24.392895+00', ''),
	('00000000-0000-0000-0000-000000000000', '6c7ff772-1a31-4534-9d60-8cde32e071cd', '{"action":"user_signedup","actor_id":"eb661745-1813-4e54-acbd-9bb71e9e2260","actor_username":"123@123.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}', '2025-04-02 18:21:49.888712+00', ''),
	('00000000-0000-0000-0000-000000000000', '25d2b31b-c3b3-4c77-85cc-1200c6d761f6', '{"action":"login","actor_id":"eb661745-1813-4e54-acbd-9bb71e9e2260","actor_username":"123@123.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-04-02 18:21:49.892926+00', ''),
	('00000000-0000-0000-0000-000000000000', '05566a58-ea4b-4aa2-bb24-df80a7504c77', '{"action":"login","actor_id":"ac212d00-2d74-42d3-84a4-0cbcf4b0e20c","actor_username":"1@2.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-04-02 18:23:23.160902+00', ''),
	('00000000-0000-0000-0000-000000000000', 'b0d6f6fb-43bc-496f-b8f7-911fec605b25', '{"action":"login","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-04-02 18:52:41.932622+00', ''),
	('00000000-0000-0000-0000-000000000000', '60bf73c1-f9c5-4e0b-b42f-670b3b066953', '{"action":"token_refreshed","actor_id":"ac212d00-2d74-42d3-84a4-0cbcf4b0e20c","actor_username":"1@2.com","actor_via_sso":false,"log_type":"token"}', '2025-04-02 19:21:45.169482+00', ''),
	('00000000-0000-0000-0000-000000000000', '3fd02ea2-937c-4299-8b48-b8e5c39f8410', '{"action":"token_revoked","actor_id":"ac212d00-2d74-42d3-84a4-0cbcf4b0e20c","actor_username":"1@2.com","actor_via_sso":false,"log_type":"token"}', '2025-04-02 19:21:45.172165+00', ''),
	('00000000-0000-0000-0000-000000000000', '4c69199f-2599-44ec-9447-63e16776e28d', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-04-02 20:09:51.746291+00', ''),
	('00000000-0000-0000-0000-000000000000', '8348c216-6206-4076-a8fc-eacbb7433515', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-04-02 20:09:51.748172+00', ''),
	('00000000-0000-0000-0000-000000000000', 'f1ae36a6-3dd6-4a96-bc9b-04dfaa1eee36', '{"action":"token_refreshed","actor_id":"ac212d00-2d74-42d3-84a4-0cbcf4b0e20c","actor_username":"1@2.com","actor_via_sso":false,"log_type":"token"}', '2025-04-02 20:20:12.346795+00', ''),
	('00000000-0000-0000-0000-000000000000', '2366de6d-e0c0-42cf-889d-0bd01da9165f', '{"action":"token_revoked","actor_id":"ac212d00-2d74-42d3-84a4-0cbcf4b0e20c","actor_username":"1@2.com","actor_via_sso":false,"log_type":"token"}', '2025-04-02 20:20:12.348264+00', ''),
	('00000000-0000-0000-0000-000000000000', '5741056b-b597-4f27-b03e-02acb9d0fe80', '{"action":"token_refreshed","actor_id":"ac212d00-2d74-42d3-84a4-0cbcf4b0e20c","actor_username":"1@2.com","actor_via_sso":false,"log_type":"token"}', '2025-04-02 21:12:44.505832+00', ''),
	('00000000-0000-0000-0000-000000000000', '8cc73045-e117-4424-aacf-f291b36402bd', '{"action":"token_revoked","actor_id":"ac212d00-2d74-42d3-84a4-0cbcf4b0e20c","actor_username":"1@2.com","actor_via_sso":false,"log_type":"token"}', '2025-04-02 21:12:44.50983+00', ''),
	('00000000-0000-0000-0000-000000000000', 'd68c6209-0aa8-4d14-80e7-8592de8475d8', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-04-02 21:12:44.557801+00', ''),
	('00000000-0000-0000-0000-000000000000', '11eefd80-4c30-4921-be7c-801dca685246', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-04-02 21:12:44.559259+00', ''),
	('00000000-0000-0000-0000-000000000000', 'df091e78-db50-4bf1-bf06-96aa0f97298c', '{"action":"login","actor_id":"ac212d00-2d74-42d3-84a4-0cbcf4b0e20c","actor_username":"1@2.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-04-02 21:49:54.592969+00', ''),
	('00000000-0000-0000-0000-000000000000', 'e75cb5a3-480c-470d-aa54-603520ae240e', '{"action":"logout","actor_id":"ac212d00-2d74-42d3-84a4-0cbcf4b0e20c","actor_username":"1@2.com","actor_via_sso":false,"log_type":"account"}', '2025-04-02 21:50:09.735706+00', ''),
	('00000000-0000-0000-0000-000000000000', '4207e1a5-957d-4691-91c2-1df82d99e0b2', '{"action":"login","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-04-02 21:50:13.892492+00', ''),
	('00000000-0000-0000-0000-000000000000', '42472a17-da64-4b07-a36f-cc712808d7d3', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-04-02 23:00:27.926942+00', ''),
	('00000000-0000-0000-0000-000000000000', '7e5d87fd-8841-4aee-8e12-7a31ca2415be', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-04-02 23:00:27.928135+00', ''),
	('00000000-0000-0000-0000-000000000000', '3c1b9041-032f-41b9-9a44-23fa3f52bde0', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-04-02 23:58:53.235236+00', ''),
	('00000000-0000-0000-0000-000000000000', '6ef6a5c5-c619-4ce6-b64a-8f40565a8a44', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-04-02 23:58:53.236865+00', ''),
	('00000000-0000-0000-0000-000000000000', '21568577-18a8-4052-a8bb-79b672502e44', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-04-03 08:49:01.234569+00', ''),
	('00000000-0000-0000-0000-000000000000', '8be18872-3458-4608-a619-3d79bea83adc', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-04-03 08:49:01.238379+00', ''),
	('00000000-0000-0000-0000-000000000000', 'cd22d058-dd7b-423c-8274-69bcda91ad0b', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-04-03 09:50:11.759867+00', ''),
	('00000000-0000-0000-0000-000000000000', 'cbbb9caa-b3a4-470e-9678-9f19bdc19446', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-04-03 09:50:11.761659+00', ''),
	('00000000-0000-0000-0000-000000000000', '0c4cf466-e93b-415b-b070-184dbb80ad7e', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-04-03 10:48:16.324456+00', ''),
	('00000000-0000-0000-0000-000000000000', 'f300f9b3-00a1-43fc-af19-41c498626d29', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-04-03 10:48:16.327513+00', ''),
	('00000000-0000-0000-0000-000000000000', '6240dee6-81d8-4827-bdca-d7a8127f5966', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-04-03 12:17:01.710057+00', ''),
	('00000000-0000-0000-0000-000000000000', '028735ec-e839-413d-8b49-51691c94c466', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-04-03 12:17:01.712189+00', ''),
	('00000000-0000-0000-0000-000000000000', '0486d41e-0a5c-422a-bb7e-fe00f90760ec', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-04-03 13:18:24.000047+00', ''),
	('00000000-0000-0000-0000-000000000000', '83c56ac6-4c87-4595-a479-b2e118152ad1', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-04-03 13:18:24.001051+00', ''),
	('00000000-0000-0000-0000-000000000000', 'ca05c998-f0ec-4981-b5c7-76e61562c778', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-04-03 14:50:48.506702+00', ''),
	('00000000-0000-0000-0000-000000000000', '2d94619c-95fb-4631-8239-a2f2568ee2a2', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-04-03 14:50:48.507826+00', ''),
	('00000000-0000-0000-0000-000000000000', '3f960cf2-6e0e-433a-b522-6e952e4072dc', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-04-03 14:50:50.421772+00', ''),
	('00000000-0000-0000-0000-000000000000', '8f2c01a5-d5ea-49bd-8e41-09b41b3b966a', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-04-03 15:49:03.43119+00', ''),
	('00000000-0000-0000-0000-000000000000', '72340a39-6662-4cc8-b11f-c0a79663b6bf', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-04-03 15:49:03.433186+00', ''),
	('00000000-0000-0000-0000-000000000000', 'acfb0171-3ecd-46ed-8045-b6c8e7e04a79', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-04-03 16:47:06.073239+00', ''),
	('00000000-0000-0000-0000-000000000000', '9991463b-b3b9-405d-a628-8476c3c221ea', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-04-03 16:47:06.080289+00', ''),
	('00000000-0000-0000-0000-000000000000', '1bd5780f-5c85-44f7-ba7d-a4177271b913', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-04-03 19:44:24.809774+00', ''),
	('00000000-0000-0000-0000-000000000000', 'ea1f451f-e777-488f-a870-7d4cdce822cb', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-04-03 19:44:24.813263+00', ''),
	('00000000-0000-0000-0000-000000000000', 'c4fca2cd-f1ae-4efc-ad18-b5a1a5d15f61', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-04-04 10:16:39.498239+00', ''),
	('00000000-0000-0000-0000-000000000000', 'ca99f293-8223-4979-a047-a2d18acf7be0', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-04-04 10:16:39.502064+00', ''),
	('00000000-0000-0000-0000-000000000000', '1a171897-0c68-49e9-b7f8-86698ac384c2', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-04-04 11:15:18.562422+00', ''),
	('00000000-0000-0000-0000-000000000000', 'aed052f4-815e-4804-93f2-3239371e403e', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-04-04 11:15:18.56488+00', ''),
	('00000000-0000-0000-0000-000000000000', '235d6007-d166-4b0b-b99c-2981ec20c524', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-04-04 12:13:31.940086+00', ''),
	('00000000-0000-0000-0000-000000000000', 'f747a8cf-35fe-4cfc-b444-d899df23d017', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-04-04 12:13:31.941091+00', ''),
	('00000000-0000-0000-0000-000000000000', '8398d2a8-b22e-4d9d-b901-1471be80f9c5', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-04-04 13:14:35.968905+00', ''),
	('00000000-0000-0000-0000-000000000000', '3b27b2a3-d2f2-40c5-a817-89fa2c0e0a6d', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-04-04 13:14:35.972652+00', ''),
	('00000000-0000-0000-0000-000000000000', 'fd743144-a7d5-4fad-82c7-8b910f190b76', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-04-04 16:12:36.202803+00', ''),
	('00000000-0000-0000-0000-000000000000', 'e749db06-27c5-4052-9e30-7928e1802674', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-04-04 16:12:36.208126+00', ''),
	('00000000-0000-0000-0000-000000000000', '88365506-eaed-402e-91e9-10cf0e579435', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-04-04 17:10:58.319306+00', ''),
	('00000000-0000-0000-0000-000000000000', '584d12ac-a667-4501-9509-c4cb802674f8', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-04-04 17:10:58.32054+00', ''),
	('00000000-0000-0000-0000-000000000000', '2ab577e7-6515-47e8-be89-1dbe81c901b5', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-04-04 20:35:39.393261+00', ''),
	('00000000-0000-0000-0000-000000000000', '2c1c56a2-155c-4614-bfbd-d3b98362f582', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-04-04 20:35:39.394631+00', ''),
	('00000000-0000-0000-0000-000000000000', '998dc238-591c-461a-841d-213637a3d0cc', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-04-04 21:34:15.509977+00', ''),
	('00000000-0000-0000-0000-000000000000', 'f179f6a1-2fd5-4a92-a83a-b6c9a87538ff', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-04-04 21:34:15.512023+00', ''),
	('00000000-0000-0000-0000-000000000000', '5cd8b9e5-9dbd-41d2-a3d8-f2942ad8ac2c', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-04-05 12:14:02.235741+00', ''),
	('00000000-0000-0000-0000-000000000000', 'febc87b3-7ee0-4ec9-99e6-af7862550fd2', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-04-05 12:14:02.236713+00', ''),
	('00000000-0000-0000-0000-000000000000', '1e9c2e9b-6bea-474b-89a5-c5d5a150582f', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-04-05 12:14:03.533865+00', ''),
	('00000000-0000-0000-0000-000000000000', '99138591-4f32-4d00-83c3-679b8eef0b57', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-04-05 13:12:35.908312+00', ''),
	('00000000-0000-0000-0000-000000000000', '640a5f91-c51c-4b46-9658-aec5a37f68ef', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-04-05 13:12:35.913266+00', ''),
	('00000000-0000-0000-0000-000000000000', 'd793e4e5-4aaa-4cf3-b7e2-d4524042bca3', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-04-05 14:10:57.1745+00', ''),
	('00000000-0000-0000-0000-000000000000', '0feddb16-a98f-4093-a0b5-5e133c2b37e6', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-04-05 14:10:57.176044+00', ''),
	('00000000-0000-0000-0000-000000000000', '8c8374e4-91bb-4dfe-bfc2-627cc999ec85', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-04-05 21:59:10.307653+00', ''),
	('00000000-0000-0000-0000-000000000000', '4314161b-8abb-4967-bdda-61fd6865401d', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-04-05 21:59:10.309647+00', ''),
	('00000000-0000-0000-0000-000000000000', '26d9bce8-83b5-481a-9974-24a367da7dbd', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-04-05 23:14:49.652765+00', ''),
	('00000000-0000-0000-0000-000000000000', '7138cc34-8581-467c-ab0a-60e26c32e622', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-04-05 23:14:49.655115+00', ''),
	('00000000-0000-0000-0000-000000000000', '589b9d59-3d0c-40fb-8be2-7160959d8d54', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-04-07 10:42:52.42069+00', ''),
	('00000000-0000-0000-0000-000000000000', '426238c5-5155-460d-9993-99b47986f83d', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-04-07 10:42:52.425902+00', ''),
	('00000000-0000-0000-0000-000000000000', 'a084e4d2-98f5-4baa-ac6f-3cde0b9142fe', '{"action":"token_refreshed","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-04-07 12:12:56.169517+00', ''),
	('00000000-0000-0000-0000-000000000000', 'e2739e72-0b7c-43df-af3c-ae3fc6a1b3e9', '{"action":"token_revoked","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"token"}', '2025-04-07 12:12:56.173281+00', ''),
	('00000000-0000-0000-0000-000000000000', '30edfe34-f4d6-4e6f-a703-880fafff0449', '{"action":"login","actor_id":"ac212d00-2d74-42d3-84a4-0cbcf4b0e20c","actor_username":"1@2.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-04-07 13:02:19.547558+00', ''),
	('00000000-0000-0000-0000-000000000000', '9968f181-1d3f-406e-88d3-aa2c87a87e9b', '{"action":"logout","actor_id":"ac212d00-2d74-42d3-84a4-0cbcf4b0e20c","actor_username":"1@2.com","actor_via_sso":false,"log_type":"account"}', '2025-04-07 13:02:45.901052+00', ''),
	('00000000-0000-0000-0000-000000000000', '6ad36012-7d2d-4c44-a476-5ed0f346d58f', '{"action":"login","actor_id":"ac212d00-2d74-42d3-84a4-0cbcf4b0e20c","actor_username":"1@2.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-04-07 13:02:49.94176+00', ''),
	('00000000-0000-0000-0000-000000000000', '506b0b98-46ba-4a1d-b73b-6ac9122dd32f', '{"action":"login","actor_id":"ac212d00-2d74-42d3-84a4-0cbcf4b0e20c","actor_username":"1@2.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-04-07 13:03:52.279282+00', ''),
	('00000000-0000-0000-0000-000000000000', '49d96285-4ada-4c65-b15d-bfc4af458a15', '{"action":"logout","actor_id":"ac212d00-2d74-42d3-84a4-0cbcf4b0e20c","actor_username":"1@2.com","actor_via_sso":false,"log_type":"account"}', '2025-04-07 13:06:17.922865+00', ''),
	('00000000-0000-0000-0000-000000000000', '2bcb65ba-3b99-4938-a452-030e87983020', '{"action":"login","actor_id":"ac212d00-2d74-42d3-84a4-0cbcf4b0e20c","actor_username":"1@2.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-04-07 13:06:25.992966+00', ''),
	('00000000-0000-0000-0000-000000000000', '07ad9213-d375-4250-a1c1-03a1afefcf80', '{"action":"login","actor_id":"ac212d00-2d74-42d3-84a4-0cbcf4b0e20c","actor_username":"1@2.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-04-07 13:12:46.341051+00', ''),
	('00000000-0000-0000-0000-000000000000', '7d09ec41-cb31-4200-b42a-235f36ffca75', '{"action":"login","actor_id":"ac212d00-2d74-42d3-84a4-0cbcf4b0e20c","actor_username":"1@2.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-04-07 13:58:45.062901+00', ''),
	('00000000-0000-0000-0000-000000000000', 'e19d428e-e51c-44dc-866e-0a6bb3fb24d9', '{"action":"login","actor_id":"11e00036-b5b2-4eef-8002-95cdc9a2e06f","actor_username":"elia@salerno.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-04-07 13:59:01.096172+00', ''),
	('00000000-0000-0000-0000-000000000000', '09fd43f3-94ab-47cd-a6bc-cc3c2fa31b71', '{"action":"login","actor_id":"365a3487-0b98-4443-be87-df78c3bb5537","actor_username":"therapist@kymu.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-04-07 23:15:03.864277+00', ''),
	('00000000-0000-0000-0000-000000000000', '6e2c49da-bcc5-4dee-a7c5-423afc3a7ccd', '{"action":"user_signedup","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"patient@user.com","user_id":"ac4c62c5-98d0-492d-a604-45523ea25b6a","user_phone":""}}', '2025-04-07 14:00:03.766279+00', ''),
	('00000000-0000-0000-0000-000000000000', '756ff367-90a8-4133-92d5-994257de9a19', '{"action":"user_signedup","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"patient@kymu.com","user_id":"05319e6c-17f0-497f-b704-da39611115ca","user_phone":""}}', '2025-04-07 14:05:23.243197+00', ''),
	('00000000-0000-0000-0000-000000000000', 'f2df7b40-49bc-4bd9-be23-f311793b5dd1', '{"action":"user_signedup","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"therapist@kymu.com","user_id":"365a3487-0b98-4443-be87-df78c3bb5537","user_phone":""}}', '2025-04-07 14:05:34.25848+00', ''),
	('00000000-0000-0000-0000-000000000000', '702d6ea7-bff3-4673-9897-83b16252cf67', '{"action":"login","actor_id":"365a3487-0b98-4443-be87-df78c3bb5537","actor_username":"therapist@kymu.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-04-07 14:32:51.295679+00', ''),
	('00000000-0000-0000-0000-000000000000', '8d3e62c8-411a-4bdd-8912-fc7f8b8fe29e', '{"action":"logout","actor_id":"365a3487-0b98-4443-be87-df78c3bb5537","actor_username":"therapist@kymu.com","actor_via_sso":false,"log_type":"account"}', '2025-04-07 14:33:05.952266+00', ''),
	('00000000-0000-0000-0000-000000000000', '275c2774-2403-4753-a00c-d417a6ddce7a', '{"action":"login","actor_id":"05319e6c-17f0-497f-b704-da39611115ca","actor_username":"patient@kymu.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-04-07 14:33:11.887647+00', ''),
	('00000000-0000-0000-0000-000000000000', '5cf1f96e-c1b3-4b72-ab83-83c1dba847e3', '{"action":"logout","actor_id":"05319e6c-17f0-497f-b704-da39611115ca","actor_username":"patient@kymu.com","actor_via_sso":false,"log_type":"account"}', '2025-04-07 14:36:18.252284+00', ''),
	('00000000-0000-0000-0000-000000000000', '05b99142-81c9-4201-845b-6c3f7198ca01', '{"action":"login","actor_id":"05319e6c-17f0-497f-b704-da39611115ca","actor_username":"patient@kymu.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-04-07 14:36:26.461148+00', ''),
	('00000000-0000-0000-0000-000000000000', 'd78305b3-4634-42bf-952e-ad7051b6a02b', '{"action":"logout","actor_id":"05319e6c-17f0-497f-b704-da39611115ca","actor_username":"patient@kymu.com","actor_via_sso":false,"log_type":"account"}', '2025-04-07 14:37:55.709301+00', ''),
	('00000000-0000-0000-0000-000000000000', '328bd7d4-94b5-470e-a6a2-efbc7bbe5969', '{"action":"login","actor_id":"05319e6c-17f0-497f-b704-da39611115ca","actor_username":"patient@kymu.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-04-07 14:37:58.879546+00', ''),
	('00000000-0000-0000-0000-000000000000', '4e91a25b-45cd-465b-9e60-db4745c6f970', '{"action":"login","actor_id":"05319e6c-17f0-497f-b704-da39611115ca","actor_username":"patient@kymu.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-04-07 14:42:48.257073+00', ''),
	('00000000-0000-0000-0000-000000000000', '88773a7a-144f-4048-be28-e34c2ba9945c', '{"action":"token_refreshed","actor_id":"05319e6c-17f0-497f-b704-da39611115ca","actor_username":"patient@kymu.com","actor_via_sso":false,"log_type":"token"}', '2025-04-07 14:59:03.541308+00', ''),
	('00000000-0000-0000-0000-000000000000', 'c7fd517f-11e9-446c-ae50-f277e5d91e58', '{"action":"token_revoked","actor_id":"05319e6c-17f0-497f-b704-da39611115ca","actor_username":"patient@kymu.com","actor_via_sso":false,"log_type":"token"}', '2025-04-07 14:59:03.54515+00', ''),
	('00000000-0000-0000-0000-000000000000', '41604662-ec5d-437e-b41d-de038f310287', '{"action":"token_refreshed","actor_id":"05319e6c-17f0-497f-b704-da39611115ca","actor_username":"patient@kymu.com","actor_via_sso":false,"log_type":"token"}', '2025-04-07 16:05:52.094756+00', ''),
	('00000000-0000-0000-0000-000000000000', 'cbac92c6-db27-4278-8b7a-fdf31aed2be0', '{"action":"token_revoked","actor_id":"05319e6c-17f0-497f-b704-da39611115ca","actor_username":"patient@kymu.com","actor_via_sso":false,"log_type":"token"}', '2025-04-07 16:05:52.095827+00', ''),
	('00000000-0000-0000-0000-000000000000', '27602a2c-4c70-450b-a824-29868fab319c', '{"action":"token_refreshed","actor_id":"05319e6c-17f0-497f-b704-da39611115ca","actor_username":"patient@kymu.com","actor_via_sso":false,"log_type":"token"}', '2025-04-07 16:50:21.884089+00', ''),
	('00000000-0000-0000-0000-000000000000', 'd15ba8cd-a130-4280-8ee5-5cbd56010ff7', '{"action":"token_revoked","actor_id":"05319e6c-17f0-497f-b704-da39611115ca","actor_username":"patient@kymu.com","actor_via_sso":false,"log_type":"token"}', '2025-04-07 16:50:21.886399+00', ''),
	('00000000-0000-0000-0000-000000000000', 'eda1510e-929b-4cc6-b2e8-6e8bc091ac10', '{"action":"token_refreshed","actor_id":"05319e6c-17f0-497f-b704-da39611115ca","actor_username":"patient@kymu.com","actor_via_sso":false,"log_type":"token"}', '2025-04-07 17:50:48.58518+00', ''),
	('00000000-0000-0000-0000-000000000000', 'b5b7df09-a49f-4f2d-bd00-b942ecd444b4', '{"action":"token_revoked","actor_id":"05319e6c-17f0-497f-b704-da39611115ca","actor_username":"patient@kymu.com","actor_via_sso":false,"log_type":"token"}', '2025-04-07 17:50:48.586805+00', ''),
	('00000000-0000-0000-0000-000000000000', 'a16e74d7-3c88-46c1-9928-bc09a51c2f25', '{"action":"token_refreshed","actor_id":"05319e6c-17f0-497f-b704-da39611115ca","actor_username":"patient@kymu.com","actor_via_sso":false,"log_type":"token"}', '2025-04-07 20:04:00.928224+00', ''),
	('00000000-0000-0000-0000-000000000000', 'fade6eca-32c9-4a72-858c-f89bac7c0277', '{"action":"token_revoked","actor_id":"05319e6c-17f0-497f-b704-da39611115ca","actor_username":"patient@kymu.com","actor_via_sso":false,"log_type":"token"}', '2025-04-07 20:04:00.931248+00', ''),
	('00000000-0000-0000-0000-000000000000', 'c3811bae-8084-4de0-8595-62a4943d801f', '{"action":"logout","actor_id":"05319e6c-17f0-497f-b704-da39611115ca","actor_username":"patient@kymu.com","actor_via_sso":false,"log_type":"account"}', '2025-04-07 20:18:42.819455+00', ''),
	('00000000-0000-0000-0000-000000000000', 'e9a4bd1d-2539-4bec-86a7-3c93b3a81de7', '{"action":"login","actor_id":"365a3487-0b98-4443-be87-df78c3bb5537","actor_username":"therapist@kymu.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-04-07 20:18:46.392655+00', ''),
	('00000000-0000-0000-0000-000000000000', 'b8453c4a-2b76-4f4c-82ef-83ea3aaa30ca', '{"action":"logout","actor_id":"365a3487-0b98-4443-be87-df78c3bb5537","actor_username":"therapist@kymu.com","actor_via_sso":false,"log_type":"account"}', '2025-04-07 20:20:04.282896+00', ''),
	('00000000-0000-0000-0000-000000000000', '38f23351-2ce6-4346-a2f4-6b6d995a7998', '{"action":"login","actor_id":"365a3487-0b98-4443-be87-df78c3bb5537","actor_username":"therapist@kymu.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-04-07 20:20:07.494984+00', ''),
	('00000000-0000-0000-0000-000000000000', '34a027ce-07e7-45b8-8f1f-6e98cf27c310', '{"action":"token_refreshed","actor_id":"365a3487-0b98-4443-be87-df78c3bb5537","actor_username":"therapist@kymu.com","actor_via_sso":false,"log_type":"token"}', '2025-04-07 22:15:28.776698+00', ''),
	('00000000-0000-0000-0000-000000000000', 'd7302cde-f35c-43c7-8241-48000f4c1cea', '{"action":"token_revoked","actor_id":"365a3487-0b98-4443-be87-df78c3bb5537","actor_username":"therapist@kymu.com","actor_via_sso":false,"log_type":"token"}', '2025-04-07 22:15:28.78134+00', ''),
	('00000000-0000-0000-0000-000000000000', '492ed635-6381-408f-8869-04f8f214db09', '{"action":"logout","actor_id":"365a3487-0b98-4443-be87-df78c3bb5537","actor_username":"therapist@kymu.com","actor_via_sso":false,"log_type":"account"}', '2025-04-07 23:10:12.979674+00', ''),
	('00000000-0000-0000-0000-000000000000', '87fc8d55-1fb5-4e79-ac55-7275f42d154c', '{"action":"login","actor_id":"05319e6c-17f0-497f-b704-da39611115ca","actor_username":"patient@kymu.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-04-07 23:10:15.880005+00', ''),
	('00000000-0000-0000-0000-000000000000', '01177e47-056d-49d4-9d3e-9987a7bd9d4b', '{"action":"logout","actor_id":"05319e6c-17f0-497f-b704-da39611115ca","actor_username":"patient@kymu.com","actor_via_sso":false,"log_type":"account"}', '2025-04-07 23:12:48.015386+00', ''),
	('00000000-0000-0000-0000-000000000000', '0d87eb14-92b6-4f58-9d9d-cb319592efa2', '{"action":"login","actor_id":"365a3487-0b98-4443-be87-df78c3bb5537","actor_username":"therapist@kymu.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-04-07 23:12:51.105697+00', ''),
	('00000000-0000-0000-0000-000000000000', '8eba463c-e2c7-4ab8-87e4-d6a4cd559b14', '{"action":"logout","actor_id":"365a3487-0b98-4443-be87-df78c3bb5537","actor_username":"therapist@kymu.com","actor_via_sso":false,"log_type":"account"}', '2025-04-07 23:13:13.863241+00', ''),
	('00000000-0000-0000-0000-000000000000', '920f403f-c2f2-4398-8868-a4e11f8e893d', '{"action":"logout","actor_id":"365a3487-0b98-4443-be87-df78c3bb5537","actor_username":"therapist@kymu.com","actor_via_sso":false,"log_type":"account"}', '2025-04-07 23:15:12.628999+00', ''),
	('00000000-0000-0000-0000-000000000000', 'e93acc03-e6e0-4e94-899c-010c0e535ff2', '{"action":"login","actor_id":"365a3487-0b98-4443-be87-df78c3bb5537","actor_username":"therapist@kymu.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-04-07 23:15:18.302297+00', ''),
	('00000000-0000-0000-0000-000000000000', 'dec5bf6d-1972-4b71-ac75-d2c0a9a6ffe5', '{"action":"token_refreshed","actor_id":"365a3487-0b98-4443-be87-df78c3bb5537","actor_username":"therapist@kymu.com","actor_via_sso":false,"log_type":"token"}', '2025-04-08 12:01:14.909658+00', ''),
	('00000000-0000-0000-0000-000000000000', 'e87d481f-2901-4158-aa1f-67ec1253b25e', '{"action":"token_revoked","actor_id":"365a3487-0b98-4443-be87-df78c3bb5537","actor_username":"therapist@kymu.com","actor_via_sso":false,"log_type":"token"}', '2025-04-08 12:01:14.911421+00', ''),
	('00000000-0000-0000-0000-000000000000', 'e9503b4c-77a0-4375-9feb-71a39261a317', '{"action":"logout","actor_id":"365a3487-0b98-4443-be87-df78c3bb5537","actor_username":"therapist@kymu.com","actor_via_sso":false,"log_type":"account"}', '2025-04-08 12:23:29.105825+00', ''),
	('00000000-0000-0000-0000-000000000000', '1984e5cb-976b-4274-8bc3-443d9097df1f', '{"action":"login","actor_id":"05319e6c-17f0-497f-b704-da39611115ca","actor_username":"patient@kymu.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-04-08 12:23:32.430661+00', ''),
	('00000000-0000-0000-0000-000000000000', '955955c1-0f95-4b2a-9c27-905325dd0398', '{"action":"token_refreshed","actor_id":"05319e6c-17f0-497f-b704-da39611115ca","actor_username":"patient@kymu.com","actor_via_sso":false,"log_type":"token"}', '2025-04-08 14:08:40.184285+00', ''),
	('00000000-0000-0000-0000-000000000000', '9d258aae-0e16-4c0c-a9f7-c4609500b19b', '{"action":"token_revoked","actor_id":"05319e6c-17f0-497f-b704-da39611115ca","actor_username":"patient@kymu.com","actor_via_sso":false,"log_type":"token"}', '2025-04-08 14:08:40.189098+00', ''),
	('00000000-0000-0000-0000-000000000000', '8e9c53f8-58fc-4daf-a0d9-9ffe50fc31a4', '{"action":"token_refreshed","actor_id":"05319e6c-17f0-497f-b704-da39611115ca","actor_username":"patient@kymu.com","actor_via_sso":false,"log_type":"token"}', '2025-04-09 10:00:12.352657+00', ''),
	('00000000-0000-0000-0000-000000000000', 'a2ca1270-d2db-4c0b-becb-b1669796733e', '{"action":"token_revoked","actor_id":"05319e6c-17f0-497f-b704-da39611115ca","actor_username":"patient@kymu.com","actor_via_sso":false,"log_type":"token"}', '2025-04-09 10:00:12.35785+00', ''),
	('00000000-0000-0000-0000-000000000000', '935165ed-6fd1-4ead-9638-fa8b2925ba37', '{"action":"login","actor_id":"365a3487-0b98-4443-be87-df78c3bb5537","actor_username":"therapist@kymu.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-04-09 10:00:47.539155+00', ''),
	('00000000-0000-0000-0000-000000000000', 'e57b21bc-de26-4062-ab62-ad28c408f79e', '{"action":"logout","actor_id":"365a3487-0b98-4443-be87-df78c3bb5537","actor_username":"therapist@kymu.com","actor_via_sso":false,"log_type":"account"}', '2025-04-09 10:03:07.702493+00', ''),
	('00000000-0000-0000-0000-000000000000', '1db1fdbb-cdc4-4ebf-889b-94b29a679a30', '{"action":"login","actor_id":"05319e6c-17f0-497f-b704-da39611115ca","actor_username":"patient@kymu.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-04-09 10:03:11.68283+00', ''),
	('00000000-0000-0000-0000-000000000000', '3fef96a9-1632-4494-8220-60c856692ae7', '{"action":"token_refreshed","actor_id":"05319e6c-17f0-497f-b704-da39611115ca","actor_username":"patient@kymu.com","actor_via_sso":false,"log_type":"token"}', '2025-04-09 12:04:47.129125+00', ''),
	('00000000-0000-0000-0000-000000000000', '84e60ccc-2d65-4f07-9c71-8ae724b1f852', '{"action":"token_revoked","actor_id":"05319e6c-17f0-497f-b704-da39611115ca","actor_username":"patient@kymu.com","actor_via_sso":false,"log_type":"token"}', '2025-04-09 12:04:47.132085+00', ''),
	('00000000-0000-0000-0000-000000000000', '9502900b-c4c7-46fa-be2b-be868a261bd9', '{"action":"login","actor_id":"05319e6c-17f0-497f-b704-da39611115ca","actor_username":"patient@kymu.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-04-09 12:08:23.527064+00', ''),
	('00000000-0000-0000-0000-000000000000', 'b213fab9-60f5-43f7-b0b7-4450a0517c43', '{"action":"token_refreshed","actor_id":"05319e6c-17f0-497f-b704-da39611115ca","actor_username":"patient@kymu.com","actor_via_sso":false,"log_type":"token"}', '2025-04-09 17:56:25.787641+00', ''),
	('00000000-0000-0000-0000-000000000000', '63b456f8-e04c-4332-a8cd-147060ebcfb6', '{"action":"token_revoked","actor_id":"05319e6c-17f0-497f-b704-da39611115ca","actor_username":"patient@kymu.com","actor_via_sso":false,"log_type":"token"}', '2025-04-09 17:56:25.790779+00', ''),
	('00000000-0000-0000-0000-000000000000', 'c4238ff8-1e02-4936-86fe-514e1f7519c9', '{"action":"token_refreshed","actor_id":"05319e6c-17f0-497f-b704-da39611115ca","actor_username":"patient@kymu.com","actor_via_sso":false,"log_type":"token"}', '2025-04-12 17:20:13.661168+00', ''),
	('00000000-0000-0000-0000-000000000000', 'a1615eea-576d-46a7-b0ee-b8269f423c60', '{"action":"token_revoked","actor_id":"05319e6c-17f0-497f-b704-da39611115ca","actor_username":"patient@kymu.com","actor_via_sso":false,"log_type":"token"}', '2025-04-12 17:20:13.664191+00', ''),
	('00000000-0000-0000-0000-000000000000', 'e6dd8736-fe01-430f-83e9-265312b89e3a', '{"action":"logout","actor_id":"05319e6c-17f0-497f-b704-da39611115ca","actor_username":"patient@kymu.com","actor_via_sso":false,"log_type":"account"}', '2025-04-12 17:20:32.016839+00', ''),
	('00000000-0000-0000-0000-000000000000', '88da4da0-fad1-4bf4-8856-8f6a561802b1', '{"action":"login","actor_id":"365a3487-0b98-4443-be87-df78c3bb5537","actor_username":"therapist@kymu.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-04-12 17:20:34.881797+00', ''),
	('00000000-0000-0000-0000-000000000000', '2517eae0-4e0f-4e8c-b4b2-72437c75a88d', '{"action":"token_refreshed","actor_id":"365a3487-0b98-4443-be87-df78c3bb5537","actor_username":"therapist@kymu.com","actor_via_sso":false,"log_type":"token"}', '2025-04-13 10:00:18.830389+00', ''),
	('00000000-0000-0000-0000-000000000000', '9f6f3415-f1a9-411d-8542-482fdb307f1c', '{"action":"token_revoked","actor_id":"365a3487-0b98-4443-be87-df78c3bb5537","actor_username":"therapist@kymu.com","actor_via_sso":false,"log_type":"token"}', '2025-04-13 10:00:18.83156+00', ''),
	('00000000-0000-0000-0000-000000000000', '81d1d6e4-88e5-4aee-b355-85a2cbaec461', '{"action":"token_refreshed","actor_id":"365a3487-0b98-4443-be87-df78c3bb5537","actor_username":"therapist@kymu.com","actor_via_sso":false,"log_type":"token"}', '2025-04-22 08:09:52.909783+00', ''),
	('00000000-0000-0000-0000-000000000000', '9a62a61e-ce72-441d-9ae0-b234d7f770f3', '{"action":"token_revoked","actor_id":"365a3487-0b98-4443-be87-df78c3bb5537","actor_username":"therapist@kymu.com","actor_via_sso":false,"log_type":"token"}', '2025-04-22 08:09:52.914777+00', ''),
	('00000000-0000-0000-0000-000000000000', '7ba4ea4f-edf3-425c-ba0c-5f7026a78bde', '{"action":"logout","actor_id":"365a3487-0b98-4443-be87-df78c3bb5537","actor_username":"therapist@kymu.com","actor_via_sso":false,"log_type":"account"}', '2025-04-22 08:10:58.399305+00', ''),
	('00000000-0000-0000-0000-000000000000', '836ec03a-bfcd-4720-91b5-12de3bc4699a', '{"action":"login","actor_id":"05319e6c-17f0-497f-b704-da39611115ca","actor_username":"patient@kymu.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-04-22 08:11:01.205528+00', ''),
	('00000000-0000-0000-0000-000000000000', '411c49d9-02a9-4641-bea1-d1765bb9817d', '{"action":"token_refreshed","actor_id":"05319e6c-17f0-497f-b704-da39611115ca","actor_username":"patient@kymu.com","actor_via_sso":false,"log_type":"token"}', '2025-04-22 09:37:15.262759+00', ''),
	('00000000-0000-0000-0000-000000000000', '4eb1d769-fe3d-477d-aa5c-3e6870d39736', '{"action":"token_revoked","actor_id":"05319e6c-17f0-497f-b704-da39611115ca","actor_username":"patient@kymu.com","actor_via_sso":false,"log_type":"token"}', '2025-04-22 09:37:15.265269+00', ''),
	('00000000-0000-0000-0000-000000000000', '39b100aa-3acc-4523-a1fa-151cdf689e7f', '{"action":"token_refreshed","actor_id":"05319e6c-17f0-497f-b704-da39611115ca","actor_username":"patient@kymu.com","actor_via_sso":false,"log_type":"token"}', '2025-04-22 11:28:58.613605+00', ''),
	('00000000-0000-0000-0000-000000000000', 'a3693273-7963-4a9d-b208-476152409859', '{"action":"token_revoked","actor_id":"05319e6c-17f0-497f-b704-da39611115ca","actor_username":"patient@kymu.com","actor_via_sso":false,"log_type":"token"}', '2025-04-22 11:28:58.614721+00', '');


--
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."users" ("instance_id", "id", "aud", "role", "email", "encrypted_password", "email_confirmed_at", "invited_at", "confirmation_token", "confirmation_sent_at", "recovery_token", "recovery_sent_at", "email_change_token_new", "email_change", "email_change_sent_at", "last_sign_in_at", "raw_app_meta_data", "raw_user_meta_data", "is_super_admin", "created_at", "updated_at", "phone", "phone_confirmed_at", "phone_change", "phone_change_token", "phone_change_sent_at", "email_change_token_current", "email_change_confirm_status", "banned_until", "reauthentication_token", "reauthentication_sent_at", "is_sso_user", "deleted_at", "is_anonymous") VALUES
	('00000000-0000-0000-0000-000000000000', '365a3487-0b98-4443-be87-df78c3bb5537', 'authenticated', 'authenticated', 'therapist@kymu.com', '$2a$10$1Dlg8Hz5dZKwWjepNKUas.bkZ0yWSN/aVDa3IfI733F66jfM9I2F.', '2025-04-07 14:05:34.260583+00', NULL, '', NULL, '', NULL, '', '', NULL, '2025-04-12 17:20:34.882201+00', '{"provider": "email", "providers": ["email"]}', '{"email_verified": true}', NULL, '2025-04-07 14:05:34.250572+00', '2025-04-22 08:09:52.91763+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL, false),
	('00000000-0000-0000-0000-000000000000', '05319e6c-17f0-497f-b704-da39611115ca', 'authenticated', 'authenticated', 'patient@kymu.com', '$2a$10$5bh79DetwxzlZyozOkActOdh6Op815sjvtwtKyJUQw1w8Rs/Q9.V.', '2025-04-07 14:05:23.243907+00', NULL, '', NULL, '', NULL, '', '', NULL, '2025-04-22 08:11:01.205931+00', '{"provider": "email", "providers": ["email"]}', '{"email_verified": true}', NULL, '2025-04-07 14:05:23.240398+00', '2025-04-22 11:28:58.616788+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL, false);


--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."identities" ("provider_id", "user_id", "identity_data", "provider", "last_sign_in_at", "created_at", "updated_at", "id") VALUES
	('05319e6c-17f0-497f-b704-da39611115ca', '05319e6c-17f0-497f-b704-da39611115ca', '{"sub": "05319e6c-17f0-497f-b704-da39611115ca", "email": "patient@kymu.com", "email_verified": false, "phone_verified": false}', 'email', '2025-04-07 14:05:23.24245+00', '2025-04-07 14:05:23.242477+00', '2025-04-07 14:05:23.242477+00', '0101e312-1bb1-4603-9bee-3bbb6a303791'),
	('365a3487-0b98-4443-be87-df78c3bb5537', '365a3487-0b98-4443-be87-df78c3bb5537', '{"sub": "365a3487-0b98-4443-be87-df78c3bb5537", "email": "therapist@kymu.com", "email_verified": false, "phone_verified": false}', 'email', '2025-04-07 14:05:34.255795+00', '2025-04-07 14:05:34.255852+00', '2025-04-07 14:05:34.255852+00', 'd4c8d3b7-dbbe-4ba4-97f9-292b72455daf');


--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."sessions" ("id", "user_id", "created_at", "updated_at", "factor_id", "aal", "not_after", "refreshed_at", "user_agent", "ip", "tag") VALUES
	('468d8be4-886e-4b07-ab21-51c0a83bd798', '05319e6c-17f0-497f-b704-da39611115ca', '2025-04-22 08:11:01.205971+00', '2025-04-22 11:28:58.618858+00', NULL, 'aal1', NULL, '2025-04-22 11:28:58.618757', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:137.0) Gecko/20100101 Firefox/137.0', '192.168.65.1', NULL);


--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."mfa_amr_claims" ("session_id", "created_at", "updated_at", "authentication_method", "id") VALUES
	('468d8be4-886e-4b07-ab21-51c0a83bd798', '2025-04-22 08:11:01.208302+00', '2025-04-22 08:11:01.208302+00', 'password', 'b9215b25-296b-49c2-90ee-8d3b51f6260c');


--
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."refresh_tokens" ("instance_id", "id", "token", "user_id", "revoked", "created_at", "updated_at", "parent", "session_id") VALUES
	('00000000-0000-0000-0000-000000000000', 319, 'turkgYwABadKocR9uxFTHA', '05319e6c-17f0-497f-b704-da39611115ca', true, '2025-04-22 08:11:01.207425+00', '2025-04-22 09:37:15.265815+00', NULL, '468d8be4-886e-4b07-ab21-51c0a83bd798'),
	('00000000-0000-0000-0000-000000000000', 320, 'ukOg5BQasgKFFqu1v0osrw', '05319e6c-17f0-497f-b704-da39611115ca', true, '2025-04-22 09:37:15.267392+00', '2025-04-22 11:28:58.615128+00', 'turkgYwABadKocR9uxFTHA', '468d8be4-886e-4b07-ab21-51c0a83bd798'),
	('00000000-0000-0000-0000-000000000000', 321, 'dTXfZGppHCCuyI6eTVGpuw', '05319e6c-17f0-497f-b704-da39611115ca', false, '2025-04-22 11:28:58.61598+00', '2025-04-22 11:28:58.61598+00', 'ukOg5BQasgKFFqu1v0osrw', '468d8be4-886e-4b07-ab21-51c0a83bd798');


--
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: key; Type: TABLE DATA; Schema: pgsodium; Owner: supabase_admin
--



--
-- Data for Name: default_assessments; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."default_assessments" ("id", "created_at", "name", "description") VALUES
	('4770ec18-8089-4305-8455-4c6df74c106a', '2025-04-02 23:22:08.452279+00', 'Strechy Day', 'A Description');


--
-- Data for Name: therapists; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."therapists" ("created_at", "first_name", "last_name", "prefix_phone_number", "phone_number", "country", "street", "street_number", "postal_code", "city", "uid", "avatar_url", "language", "therapist_type") VALUES
	('2025-04-07 14:07:45.020114+00', 'Therapist', 'Müller', '+41', '123123123', 'switzerland', 'strasse', '9', '8000', 'zürich', '365a3487-0b98-4443-be87-df78c3bb5537', NULL, 'de-CH', 'physio');


--
-- Data for Name: patients; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."patients" ("created_at", "patient_first_name", "patient_last_name", "uid", "caregiver_first_name", "caregiver_last_name", "therapist_uid") VALUES
	('2025-04-07 14:08:34.483864+00', 'Max', 'Heinrich', '05319e6c-17f0-497f-b704-da39611115ca', 'Caregiver', 'Heinrich', '365a3487-0b98-4443-be87-df78c3bb5537');


--
-- Data for Name: assessments; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."assessments" ("id", "created_at", "therapist_uid", "inherited_default_assessment_id", "name", "patient_uid", "description", "isTemplate") VALUES
	('a74419ae-3b6d-46aa-84c2-2195fd93435a', '2025-04-07 14:27:01.290093+00', '365a3487-0b98-4443-be87-df78c3bb5537', NULL, 'Assesment 1', '05319e6c-17f0-497f-b704-da39611115ca', 'Ein Assesment', false),
	('e734178e-a35a-4ea5-94f3-9cfc67c7835a', '2025-04-07 20:29:22.976771+00', '365a3487-0b98-4443-be87-df78c3bb5537', NULL, 'Another assesment', '05319e6c-17f0-497f-b704-da39611115ca', 'Anderes assesment', true);


--
-- Data for Name: default_test_instructions; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."default_test_instructions" ("created_at", "video_urls", "image_urls", "description", "id", "Name") VALUES
	('2025-04-02 23:17:28.80049+00', '["http://127.0.0.1:54321/storage/v1/object/sign/instruction_videos/default/mediapipe-rom%20Kopie.mp4?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1cmwiOiJpbnN0cnVjdGlvbl92aWRlb3MvZGVmYXVsdC9tZWRpYXBpcGUtcm9tIEtvcGllLm1wNCIsImlhdCI6MTc0MzY4NjI0NywiZXhwIjoxNzc1MjIyMjQ3fQ.y2L-ioc4isMlsOPtuX6D2MLEGw6Qa_CjZ022W7evx6s&t=2025-04-03T13%3A17%3A27.423Z"]', '["http://127.0.0.1:54321/storage/v1/object/sign/instruction_images/default/exercise.png?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1cmwiOiJpbnN0cnVjdGlvbl9pbWFnZXMvZGVmYXVsdC9leGVyY2lzZS5wbmciLCJpYXQiOjE3NDM2ODYxOTgsImV4cCI6MTc3NTIyMjE5OH0.VXthUWHHjmDhPAM2TZjatcXZ05lF12MZ31G5hr0AitA&t=2025-04-03T13%3A16%3A38.151Z"]', 'Shows how to flex an arm', '072e8b4a-2b1d-4098-94f5-1dc705b34f9a', 'Arm Flexion with a Strechband'),
	('2025-04-02 23:17:38.496801+00', '["http://127.0.0.1:54321/storage/v1/object/sign/instruction_videos/default/mediapipe-rom%20Kopie.mp4?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1cmwiOiJpbnN0cnVjdGlvbl92aWRlb3MvZGVmYXVsdC9tZWRpYXBpcGUtcm9tIEtvcGllLm1wNCIsImlhdCI6MTc0MzY4NjI0NywiZXhwIjoxNzc1MjIyMjQ3fQ.y2L-ioc4isMlsOPtuX6D2MLEGw6Qa_CjZ022W7evx6s&t=2025-04-03T13%3A17%3A27.423Z"]', '["http://127.0.0.1:54321/storage/v1/object/sign/instruction_images/default/exercise.png?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1cmwiOiJpbnN0cnVjdGlvbl9pbWFnZXMvZGVmYXVsdC9leGVyY2lzZS5wbmciLCJpYXQiOjE3NDM2ODYxOTgsImV4cCI6MTc3NTIyMjE5OH0.VXthUWHHjmDhPAM2TZjatcXZ05lF12MZ31G5hr0AitA&t=2025-04-03T13%3A16%3A38.151Z"]', 'Shows how to Arm a flex', 'acb4ce59-e404-4ee0-992b-dfb093c4415c', 'Flexing an Arm with the stretchy');


--
-- Data for Name: default_tests; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."default_tests" ("id", "created_at", "name", "description", "default_test_instruction_id", "test_focus", "data") VALUES
	('10d34477-bb59-450e-9e83-b3355f157de9', '2025-04-02 23:19:02.579995+00', 'Arm Flexion', NULL, '072e8b4a-2b1d-4098-94f5-1dc705b34f9a', 'range-of-motion', NULL),
	('57fd017d-e02d-4d37-a99c-95b0d4dc7771', '2025-04-02 23:19:17.332746+00', 'Flexing Arm', NULL, '072e8b4a-2b1d-4098-94f5-1dc705b34f9a', 'motor-function', NULL),
	('7b83228f-61b7-4f14-9dac-e626b9b6097e', '2025-04-02 23:19:32.72301+00', 'Armely Flexion', NULL, 'acb4ce59-e404-4ee0-992b-dfb093c4415c', 'endurance', NULL);


--
-- Data for Name: tests; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."tests" ("id", "created_at", "name", "description", "default_test_instruction_id", "test_focus", "data", "therapist_uid", "inherited_default_test_id") VALUES
	('a4033b08-4967-4ba9-b724-f3ea20bd8151', '2025-04-07 14:27:41.804783+00', 'Ein Test.', 'Eine Testbeschreibung', '072e8b4a-2b1d-4098-94f5-1dc705b34f9a', 'balance', NULL, '365a3487-0b98-4443-be87-df78c3bb5537', NULL),
	('c66c6c12-c548-4207-92a0-9d0196a9d381', '2025-04-07 14:30:32.555142+00', 'Zweiter Test.', 'Eine Test Beschreibung', '072e8b4a-2b1d-4098-94f5-1dc705b34f9a', 'balance', NULL, '365a3487-0b98-4443-be87-df78c3bb5537', '57fd017d-e02d-4d37-a99c-95b0d4dc7771');


--
-- Data for Name: assessments_and_tests; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."assessments_and_tests" ("assessment_id", "test_id", "prev_test_id") VALUES
	('a74419ae-3b6d-46aa-84c2-2195fd93435a', 'a4033b08-4967-4ba9-b724-f3ea20bd8151', NULL),
	('a74419ae-3b6d-46aa-84c2-2195fd93435a', 'c66c6c12-c548-4207-92a0-9d0196a9d381', 'a4033b08-4967-4ba9-b724-f3ea20bd8151');


--
-- Data for Name: connection_patient_and_therapists; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."connection_patient_and_therapists" ("created_at", "family_uid", "therapist_uid", "id") VALUES
	('2025-04-07 14:25:34.173633+00', '05319e6c-17f0-497f-b704-da39611115ca', '365a3487-0b98-4443-be87-df78c3bb5537', '69c67d0e-50a0-439d-a49a-3df40513551b');


--
-- Data for Name: default_assessments_and_tests; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: default_exercise_instructions; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: default_exercises; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: default_units; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."default_units" ("created_at", "name", "description", "id", "start_assessment_id", "end_assessment_id") VALUES
	('2025-03-12 15:44:13.492664+00', 'Test Unit', 'A test unit.', '37909294-e684-4d4f-9b55-6a3feeb62c08', '4770ec18-8089-4305-8455-4c6df74c106a', '4770ec18-8089-4305-8455-4c6df74c106a');


--
-- Data for Name: default_units_and_exercises; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: exercise_categories; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: exercise_instructions; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: exercises; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."exercises" ("created_at", "duration_seconds_goal", "repetitions_goal", "family_scene_adjustment_access", "therapist_uid", "name", "focus_type", "id", "inherited_default_exercise", "is_template", "description", "therapist_added_image_urls", "therapist_added_video_urls", "exercise_instruction_ids", "exercise_type", "data") VALUES
	('2025-04-07 20:25:01.494884+00', NULL, 5, false, '365a3487-0b98-4443-be87-df78c3bb5537', 'Hanteln linker Arm', 'balance', '575cd2db-bee3-41d0-adde-d1af310ae4fa', NULL, true, 'Bewege die Hantel fünf mal hoch und runter mit deinem Linken Arm.', NULL, NULL, NULL, 'exercise_screen', NULL),
	('2025-04-07 20:26:06.270166+00', NULL, 30, false, '365a3487-0b98-4443-be87-df78c3bb5537', 'VR Exercise', 'balance', '68e6cb92-49aa-4029-9147-7111ff09fc18', NULL, true, 'A description', NULL, NULL, NULL, 'exercise_screen', NULL);


--
-- Data for Name: patient_sessions; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: patient_records; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: units; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."units" ("created_at", "patient_uid", "therapist_uid", "name", "description", "is_template", "id", "inherited_default_unit", "isFocus", "start_assessment_id", "end_assessment_id") VALUES
	('2025-04-07 14:26:33.846397+00', '05319e6c-17f0-497f-b704-da39611115ca', '365a3487-0b98-4443-be87-df78c3bb5537', 'Unit 1', 'Schwerpunkt auf der Verbesserung des Körpergleichgewichts.', true, '34cac52f-8c90-479b-bf21-96fa40fdf3fd', NULL, true, 'a74419ae-3b6d-46aa-84c2-2195fd93435a', 'e734178e-a35a-4ea5-94f3-9cfc67c7835a'),
	('2025-04-09 10:19:25.835095+00', '05319e6c-17f0-497f-b704-da39611115ca', '365a3487-0b98-4443-be87-df78c3bb5537', 'Unit 2', 'Schwerpunkt auf der Verbesserung des Körpergleichgewichts.', true, 'cd4416ed-2dc2-4205-9acf-235ad42d3729', NULL, true, 'a74419ae-3b6d-46aa-84c2-2195fd93435a', 'e734178e-a35a-4ea5-94f3-9cfc67c7835a'),
	('2025-04-22 11:31:39.029485+00', '05319e6c-17f0-497f-b704-da39611115ca', '365a3487-0b98-4443-be87-df78c3bb5537', 'Unit 4', 'A Description', false, '820bdd18-9b3f-42cf-b624-561be0c817dc', '37909294-e684-4d4f-9b55-6a3feeb62c08', false, 'a74419ae-3b6d-46aa-84c2-2195fd93435a', 'e734178e-a35a-4ea5-94f3-9cfc67c7835a'),
	('2025-04-07 14:26:33.846397+00', '05319e6c-17f0-497f-b704-da39611115ca', '365a3487-0b98-4443-be87-df78c3bb5537', 'Unit 3', 'Schwerpunkt auf der Verbesserung des Körpergleichgewichts.', true, 'f50f9f38-776e-4e06-b151-45bc891bbcc4', NULL, true, 'a74419ae-3b6d-46aa-84c2-2195fd93435a', 'e734178e-a35a-4ea5-94f3-9cfc67c7835a');


--
-- Data for Name: units_and_exercises; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."units_and_exercises" ("exercise_id", "unit_id", "prev_exercise_id") VALUES
	('68e6cb92-49aa-4029-9147-7111ff09fc18', '34cac52f-8c90-479b-bf21-96fa40fdf3fd', NULL),
	('575cd2db-bee3-41d0-adde-d1af310ae4fa', '34cac52f-8c90-479b-bf21-96fa40fdf3fd', '68e6cb92-49aa-4029-9147-7111ff09fc18');


--
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

INSERT INTO "storage"."buckets" ("id", "name", "owner", "created_at", "updated_at", "public", "avif_autodetection", "file_size_limit", "allowed_mime_types", "owner_id") VALUES
	('instruction_videos', 'instruction_videos', NULL, '2025-04-03 11:52:01.464359+00', '2025-04-03 11:52:01.464359+00', false, false, NULL, '{video/mp4}', NULL),
	('instruction_images', 'instruction_images', NULL, '2025-04-03 11:53:04.082356+00', '2025-04-03 11:53:04.082356+00', false, false, NULL, '{image/*}', NULL);


--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

INSERT INTO "storage"."objects" ("id", "bucket_id", "name", "owner", "created_at", "updated_at", "last_accessed_at", "metadata", "version", "owner_id", "user_metadata") VALUES
	('604153ce-bc77-43da-b0b9-97703f498c6d', 'instruction_videos', 'default/mediapipe-rom Kopie.mp4', NULL, '2025-04-03 12:23:40.886021+00', '2025-04-03 12:23:40.886021+00', '2025-04-03 12:23:40.886021+00', '{"eTag": "\"faf76a17bde10cc4fd08dbc554d4ef7c\"", "size": 1075831, "mimetype": "video/mp4", "cacheControl": "max-age=3600", "lastModified": "2025-04-03T12:23:40.871Z", "contentLength": 1075831, "httpStatusCode": 200}', 'd9dad50c-e0d6-4958-aeb2-1f97ea670aec', NULL, '{}'),
	('d724a96c-67f7-4efd-9bb3-8cff4b46c620', 'instruction_images', 'default/exercise.png', NULL, '2025-04-03 12:23:50.130261+00', '2025-04-03 12:23:50.130261+00', '2025-04-03 12:23:50.130261+00', '{"eTag": "\"d17af622e106423ce797a92ef91d16a9\"", "size": 317661, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2025-04-03T12:23:50.123Z", "contentLength": 317661, "httpStatusCode": 200}', '97681783-07f2-425b-bf83-03fec995fca4', NULL, '{}');


--
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: hooks; Type: TABLE DATA; Schema: supabase_functions; Owner: supabase_functions_admin
--



--
-- Data for Name: secrets; Type: TABLE DATA; Schema: vault; Owner: supabase_admin
--



--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: supabase_auth_admin
--

SELECT pg_catalog.setval('"auth"."refresh_tokens_id_seq"', 321, true);


--
-- Name: key_key_id_seq; Type: SEQUENCE SET; Schema: pgsodium; Owner: supabase_admin
--

SELECT pg_catalog.setval('"pgsodium"."key_key_id_seq"', 1, false);


--
-- Name: exercise_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."exercise_categories_id_seq"', 1, false);


--
-- Name: hooks_id_seq; Type: SEQUENCE SET; Schema: supabase_functions; Owner: supabase_functions_admin
--

SELECT pg_catalog.setval('"supabase_functions"."hooks_id_seq"', 1, false);


--
-- PostgreSQL database dump complete
--

RESET ALL;
