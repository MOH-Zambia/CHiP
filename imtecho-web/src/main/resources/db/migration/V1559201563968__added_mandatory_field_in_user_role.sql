ALTER TABLE public.um_role_master
  ADD COLUMN is_convox_id_mandatory boolean;

ALTER TABLE public.um_user
  ADD COLUMN convox_id text;