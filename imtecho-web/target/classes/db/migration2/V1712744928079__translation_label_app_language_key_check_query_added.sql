DELETE FROM QUERY_MASTER WHERE CODE='translation_label_app_language_key_check';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'77f99d0b-3810-404a-8dc4-21e15c5d7605', 97080,  current_date , 97080,  current_date , 'translation_label_app_language_key_check',
'app,language,key',
'select app,language,key
	from translation_master
where app = #app# and language = #language# and key = #key#',
'checks for existing labels with same app,language and key in translation_master table.',
true, 'ACTIVE');