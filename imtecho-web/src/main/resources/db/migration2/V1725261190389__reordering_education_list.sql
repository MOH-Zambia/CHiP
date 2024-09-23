delete from listvalue_field_value_detail where field_key='1010';

INSERT INTO public.listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code, list_order, additional_detail, constant)
VALUES( true, false, 'sbashyam', now(), 'No education', '1010', 0, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.listvalue_field_value_detail
( is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code, list_order, additional_detail, constant)
VALUES( true, false, 'sbashyam', now(), 'Preschool', '1010', 0, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.listvalue_field_value_detail
( is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code, list_order, additional_detail, constant)
VALUES( true, false, 'sbashyam', now(), 'Grade 1 - 4', '1010', 0, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.listvalue_field_value_detail
( is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code, list_order, additional_detail, constant)
VALUES( true, false, 'sbashyam', now(), 'Grade 5 - 7', '1010', 0, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.listvalue_field_value_detail
( is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code, list_order, additional_detail, constant)
VALUES( true, false, 'sbashyam',now(), 'Grade 8 - 9', '1010', 0, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.listvalue_field_value_detail
( is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code, list_order, additional_detail, constant)
VALUES( true, false, 'sbashyam',now(), 'Grade 10 - 12', '1010', 0, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.listvalue_field_value_detail
( is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code, list_order, additional_detail, constant)
VALUES( true, false, 'sbashyam',now(), 'Tertiary (College/University)', '1010', 0, NULL, NULL, NULL, NULL, NULL);


insert into listvalue_field_master (field_key,field,is_active,field_type ,form,role_type)
values('educationStatusChildrenList','educationStatusChildrenList',true,'T','FHS','F');

insert into listvalue_field_form_relation (field,form_id)
select 'educationStatusChildrenList',id from mobile_form_details where form_name='MEMBER_UPDATE';

insert into listvalue_field_form_relation (field,form_id)
select 'educationStatusChildrenList',id from mobile_form_details where form_name='HOUSE_HOLD_LINE_LIST';





INSERT INTO public.listvalue_field_value_detail
( is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code, list_order, additional_detail, constant)
VALUES( true, false, 'sbashyam', now(), 'Preschool', 'educationStatusChildrenList', 0, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.listvalue_field_value_detail
( is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code, list_order, additional_detail, constant)
VALUES( true, false, 'sbashyam', now(), 'Grade 1 - 4', 'educationStatusChildrenList', 0, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.listvalue_field_value_detail
( is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code, list_order, additional_detail, constant)
VALUES( true, false, 'sbashyam', now(), 'Grade 5 - 7', 'educationStatusChildrenList', 0, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.listvalue_field_value_detail
( is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code, list_order, additional_detail, constant)
VALUES( true, false, 'sbashyam',now(), 'Grade 8 - 9', 'educationStatusChildrenList', 0, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.listvalue_field_value_detail
( is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code, list_order, additional_detail, constant)
VALUES( true, false, 'sbashyam',now(), 'Grade 10 - 12', 'educationStatusChildrenList', 0, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.listvalue_field_value_detail
( is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code, list_order, additional_detail, constant)
VALUES( true, false, 'sbashyam',now(), 'Tertiary (College/University)', 'educationStatusChildrenList', 0, NULL, NULL, NULL, NULL, NULL);
