delete from query_master where code = 'dynamic_form_select_by_code';

INSERT INTO public.query_master
(created_by, created_on, modified_by, modified_on, code, params, query, returns_result_set, state, description, is_public)
VALUES(75398, now(), 75398, now(), 'dynamic_form_select_by_code', 'code', 'select * from system_form_master where form_code ilike ''#code#''', true, 'ACTIVE', NULL, NULL);
