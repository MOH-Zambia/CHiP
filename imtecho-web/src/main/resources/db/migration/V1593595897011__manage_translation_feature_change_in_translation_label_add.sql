DELETE FROM QUERY_MASTER WHERE CODE='translation_label_add';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'ef3a751e-377b-4113-8016-5d97f4100baa', -1,  current_date , -1,  current_date , 'translation_label_add', 
'createdBy,language,label,isMobileLabel,text', 
'INSERT INTO internationalization_label_master(country, key, language, created_by, created_on, custom3b, text, translation_pending) 
VALUES (''IN'', REPLACE(''#label#'','' '',''''), ''#language#'', #createdBy# , now(), #isMobileLabel# , ''#text#'' ,false );', 
null, 
false, 'ACTIVE');