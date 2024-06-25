ALTER TABLE public.um_user
  ADD COLUMN imei_number character varying(100);
ALTER TABLE public.um_user
  ADD COLUMN techo_phone_number character varying(100);
UPDATE public.menu_config
   SET feature_json='{"canAdd":true,"canEdit":true}'
 WHERE navigation_state='techo.manage.users';