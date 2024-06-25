insert into listvalue_field_master(field_key, field, is_active, field_type, form, role_type)
values('referalReasonNonRch', 'referalReasonNonRch', true, 'T', 'FHW_ANC', 'A,F');

insert into listvalue_field_form_relation(field, form_id)
select 'referalReasonNonRch', id from mobile_form_details where form_name = 'ACTIVE_MALARIA';


insert into listvalue_field_master(field_key, field, is_active, field_type, form, role_type)
values('referalReasonRch', 'referalReasonRch', true, 'T', 'FHW_ANC', 'A,F');

insert into listvalue_field_form_relation(field, form_id)
select 'referalReasonRch', id from mobile_form_details where form_name = 'ACTIVE_MALARIA';

update system_configuration set key_value = '106' where system_key = 'MOBILE_FORM_VERSION';