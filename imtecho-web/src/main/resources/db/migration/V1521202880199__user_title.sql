ALTER TABLE public.um_user
  ADD COLUMN title character varying(10);
ALTER TABLE public.um_user
   ALTER COLUMN contact_number DROP NOT NULL;