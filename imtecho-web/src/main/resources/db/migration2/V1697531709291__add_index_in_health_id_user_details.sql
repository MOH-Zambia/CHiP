CREATE INDEX IF NOT EXISTS ndhm_health_id_user_details_health_id_idx
ON public.ndhm_health_id_user_details USING btree (health_id);

CREATE INDEX IF NOT EXISTS ndhm_health_id_user_details_health_id_number_idx
ON public.ndhm_health_id_user_details USING btree (health_id_number);

CREATE INDEX IF NOT exists ndhm_health_id_user_details_member_id_idx
ON public.ndhm_health_id_user_details USING btree (member_id);