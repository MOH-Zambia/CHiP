drop table if exists wt_high_risk_member_detail;
CREATE TABLE public.wt_high_risk_member_detail
(
  id bigserial primary key,
  member_id bigint,
  family_id bigint,
  pregnancy_reg_id bigint,
  location_id bigint,
  diseases_type text,
  high_risk_diseases text,
  high_risk_diseases_detail text,
  service_date date,
  state text,
  created_on timestamp without time zone,
  modified_by bigint,
  modified_on timestamp without time zone
);

delete from system_configuration where system_key = 'mo_high_risk_dashboard_last_scheduler_date';
insert into system_configuration(system_key,key_value)
values('mo_high_risk_dashboard_last_scheduler_date','03/15/2019 00:00.000');

INSERT INTO public.listvalue_field_master(
            field_key, field, is_active, field_type, form, role_type)
    VALUES ('high_risk_notification_mo','High Risk Vefication MO',TRUE,'T','WEB_DASHBOARD',null);