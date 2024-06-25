DROP INDEX if exists um_user_aadhar_number_idx;

DROP INDEX if exists um_user_contact_number_idx;

DROP INDEX if exists um_user_role_id_idx;

DROP INDEX if exists um_user_search_text_idx;

--Drop EXTENSION if exists pg_trgm;

--CREATE EXTENSION pg_trgm;

--CREATE INDEX um_user_search_text_idx ON um_user USING gin (search_text gin_trgm_ops);

DROP INDEX if exists um_user_role_id_state_idx;

CREATE INDEX um_user_role_id_state_idx
   ON public.um_user (role_id ASC NULLS LAST, state ASC NULLS LAST);

DROP INDEX if exists public.um_user_user_id_idx;

DROP INDEX if exists um_user_location_user_id_state_idx;

CREATE INDEX um_user_location_user_id_state_idx
   ON public.um_user_location (user_id ASC NULLS LAST, state ASC NULLS LAST);
