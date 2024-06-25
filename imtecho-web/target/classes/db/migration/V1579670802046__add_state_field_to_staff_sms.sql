ALTER TABLE public.sms_staff_sms_master
  ADD COLUMN state character varying(255);
ALTER TABLE public.sms_staff_sms_master
  ADD COLUMN user_list text;
ALTER TABLE public.sms_staff_sms_master
  DROP COLUMN excel_url ;
ALTER TABLE public.sms_staff_sms_master
  ADD COLUMN document_id int;
ALTER TABLE public.sms_staff_sms_excel_config_detail ALTER COLUMN sms_template drop not null;
