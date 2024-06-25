DELETE FROM listvalue_form_master WHERE form_key = 'RCH';
INSERT INTO listvalue_form_master(form_key, form, is_active, is_training_req, query_for_training_completed)
VALUES('RCH', 'Reproductive Child Health', true, true, 'select cast(''RCH'' as text) as form_code, false as result');