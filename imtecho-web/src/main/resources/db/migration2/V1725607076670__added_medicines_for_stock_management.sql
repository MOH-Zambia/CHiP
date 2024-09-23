delete from listvalue_field_value_detail where field_key='childSymptomsFhwCs' and value ='Chest in-drawn!';

INSERT INTO public.listvalue_field_value_detail
( is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code, list_order, additional_detail, constant)
VALUES( true, false, 'srbashyam', now(), 'Chest in-drawn', 'childSymptomsFhwCs', 0, NULL, NULL, NULL, NULL, NULL);
