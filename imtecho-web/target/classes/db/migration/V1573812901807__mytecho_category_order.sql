INSERT INTO public.listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'stank', now(), 'Key Category', 'card_category', 0, 'null', 1);

UPDATE listvalue_field_value_detail
set code = 2
where value = 'Health' and field_key='card_category' ;

UPDATE listvalue_field_value_detail
set code = 3
where value = 'Diet' and field_key='card_category' ;

UPDATE listvalue_field_value_detail
set code = 4
where value = 'Fitness' and field_key='card_category' ;

UPDATE listvalue_field_value_detail
set code = 5
where value = 'Mental Emotional' and field_key='card_category' ;