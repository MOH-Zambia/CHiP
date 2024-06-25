insert into mobile_form_details(form_name,file_name,created_on,created_by,modified_on,modified_by)
values ('ACTIVE_MALARIA', 'ACTIVE_MALARIA', now(), -1, now(), -1);

insert into mobile_form_feature_rel (form_id, mobile_constant)
select id, 'CBV_MY_PEOPLE' from mobile_form_details where form_name = 'ACTIVE_MALARIA';

insert into listvalue_field_master(field_key, field, is_active, field_type, form, role_type)
values('malariaSymptoms', 'malariaSymptoms', true, 'T', 'FHW_ANC', 'A,F');

insert into listvalue_field_form_relation(field, form_id)
select 'malariaSymptoms', id from mobile_form_details where form_name = 'ACTIVE_MALARIA';



insert into mobile_form_details(form_name,file_name,created_on,created_by,modified_on,modified_by)
values ('PASSIVE_MALARIA', 'PASSIVE_MALARIA', now(), -1, now(), -1);

insert into mobile_form_feature_rel (form_id, mobile_constant)
select id, 'CBV_MY_PEOPLE' from mobile_form_details where form_name = 'PASSIVE_MALARIA';



insert into mobile_form_details(form_name,file_name,created_on,created_by,modified_on,modified_by)
values ('CHIP_TB', 'CHIP_TB', now(), -1, now(), -1);

insert into mobile_form_feature_rel (form_id, mobile_constant)
select id, 'CBV_MY_PEOPLE' from mobile_form_details where form_name = 'CHIP_TB';

insert into listvalue_field_master(field_key, field, is_active, field_type, form, role_type)
values('tuberculosisSymptoms', 'tuberculosisSymptoms', true, 'T', 'FHW_ANC', 'A,F');

insert into listvalue_field_form_relation(field, form_id)
select 'tuberculosisSymptoms', id from mobile_form_details where form_name = 'CHIP_TB';

insert into listvalue_field_master(field_key, field, is_active, field_type, form, role_type)
values('tbTestType', 'tbTestType', true, 'T', 'FHW_ANC', 'A,F');

insert into listvalue_field_form_relation(field, form_id)
select 'tbTestType', id from mobile_form_details where form_name = 'CHIP_TB';




insert into mobile_form_details(form_name,file_name,created_on,created_by,modified_on,modified_by)
values ('CHIP_TB_FOLLOW_UP', 'CHIP_TB_FOLLOW_UP', now(), -1, now(), -1);

insert into mobile_form_feature_rel (form_id, mobile_constant)
select id, 'CBV_MY_PEOPLE' from mobile_form_details where form_name = 'CHIP_TB_FOLLOW_UP';

insert into mobile_form_details(form_name,file_name,created_on,created_by,modified_on,modified_by)
values ('CHIP_COVID', 'CHIP_COVID', now(), -1, now(), -1);

insert into mobile_form_feature_rel (form_id, mobile_constant)
select id, 'CBV_MY_PEOPLE' from mobile_form_details where form_name = 'CHIP_COVID';



