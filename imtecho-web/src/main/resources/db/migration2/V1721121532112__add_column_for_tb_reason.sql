alter table tuberculosis_screening_details
add column reason_for_not_testing TEXT;


-- deleting previously added list value for gbv type --
delete from listvalue_field_value_detail lfvd where field_key ='gbvTypeList';

INSERT INTO public.listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code, list_order, additional_detail, constant)
VALUES( true, false, 'sbashyam', now(), 'Physical', 'gbvTypeList', 0, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.listvalue_field_value_detail
( is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code, list_order, additional_detail, constant)
VALUES( true, false, 'sbashyam', now(), 'Emotional', 'gbvTypeList', 0, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.listvalue_field_value_detail
( is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code, list_order, additional_detail, constant)
VALUES( true, false, 'sbashyam', now(), 'Financial', 'gbvTypeList', 0, NULL, NULL, NULL, NULL, NULL);
