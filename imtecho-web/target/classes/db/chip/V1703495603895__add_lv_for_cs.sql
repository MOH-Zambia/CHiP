insert into listvalue_field_master(field_key, field, is_active, field_type, form, role_type)
values('referalReasonCS', 'referalReasonCS', true, 'T', 'FHW_ANC', 'A,F');

insert into listvalue_field_form_relation(field, form_id)
select 'referalReasonCS', id from mobile_form_details where form_name = 'FHW_CS';



insert into listvalue_field_master(field_key, field, is_active, field_type, form, role_type)
values('childPhysicalDisabilities', 'childPhysicalDisabilities', true, 'T', 'FHW_ANC', 'A,F');

insert into listvalue_field_form_relation(field, form_id)
select 'childPhysicalDisabilities', id from mobile_form_details where form_name = 'FHW_CS';
