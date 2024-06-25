DELETE FROM query_master WHERE code='move_to_production_ncd_form';
INSERT INTO query_master(created_by, created_on, code,params, query, returns_result_set, state)
values(1, current_date, 'move_to_production_ncd_form', 'userId',
'select cast(''NCD'' as text) as form_code, false as result', true, 'ACTIVE');

UPDATE listvalue_form_master SET query_for_training_completed = 'move_to_production_ncd_form'
WHERE form_key = 'NCD';