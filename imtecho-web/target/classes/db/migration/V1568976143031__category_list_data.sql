
INSERT INTO public.listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'stank', now(), 'Health', 'card_category', 0, 'null', NULL);


INSERT INTO public.listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'kkpatel', now(), 'Diet', 'card_category', 0, 'null', NULL);

INSERT INTO public.listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'kkpatel', now(), 'Fitness', 'card_category', 0, 'null', NULL);

INSERT INTO public.listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'stank', now(), 'Mental Emotional', 'card_category', 0, 'null', NULL);


-- To chage isActive of timeline
INSERT INTO public.query_master
(created_by, created_on, code, params, query, returns_result_set, state, description)
VALUES(409, now(), 'mytecho_timeline_update_isactive', 'id,isActive', 'UPDATE public.mytecho_timeline_config_det 
   SET is_active=#isActive#
 WHERE id=#id#;', false, 'ACTIVE', NULL);
