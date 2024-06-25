update system_configuration set key_value = '32' where system_key = 'MOBILE_FORM_VERSION';

ALTER TABLE public.ncd_member_mental_health_detail
  ALTER COLUMN observation TYPE text;


insert into notification_type_role_rel(role_id, notification_type_id)
select 30, id from notification_type_master where code in
('NCD_CLINIC_VISIT','NCD_HOME_VISIT');