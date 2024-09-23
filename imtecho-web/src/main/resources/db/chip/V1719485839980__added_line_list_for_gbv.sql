insert into listvalue_field_master(field_key, field, is_active, field_type, form, role_type)
values('gbvTypeList', 'gbvTypeList', true, 'T', 'FHW_ANC', 'A,F');


INSERT INTO public.listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code, list_order, additional_detail, constant)
VALUES( true, false, 'sbashyam', now(), 'A', 'gbvTypeList', 0, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.listvalue_field_value_detail
( is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code, list_order, additional_detail, constant)
VALUES( true, false, 'sbashyam', now(), 'B', 'gbvTypeList', 0, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.listvalue_field_value_detail
( is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code, list_order, additional_detail, constant)
VALUES( true, false, 'sbashyam', now(), 'C', 'gbvTypeList', 0, NULL, NULL, NULL, NULL, NULL);


insert into listvalue_field_form_relation (field,form_id)
values ('gbvTypeList',(select id from mobile_form_details mfd where form_name ilike '%gbv%'));

