ALTER TABLE public.notification_type_master
  ADD COLUMN notification_for character varying(255);
ALTER TABLE public.event_configuration_type
  ADD COLUMN user_field_name character varying(255);
ALTER TABLE public.event_configuration_type
  ADD COLUMN family_field_name character varying(255);
ALTER TABLE public.event_configuration_type
  ADD COLUMN member_field_name character varying(255);