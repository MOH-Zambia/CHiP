
update
	internationalization_label_master
set
	app_name = 'WEB'
where
	custom3b = false
	or custom3b is null;


update
	internationalization_label_master
set
	app_name = 'TECHO_MOBILE_APP'
where
	custom3b = true;


alter table internationalization_label_master drop constraint internationalization_label_master_pkey;
alter table internationalization_label_master add constraint internationalization_label_master_pkey primary key (country, key, language, app_name);



DELETE FROM QUERY_MASTER WHERE CODE='translation_label_retrival_1';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'ce779c6c-4927-4103-b694-c403149360cb', 74909,  current_date , 74909,  current_date , 'translation_label_retrival_1',
'searchText,offset,limit,startsWith',
'select
	labelMaster1.key as key,
	labelMaster1.language as language ,
	labelMaster2.text as label ,
	labelMaster1.text ,
	case
		when labelMaster1.language = ''EN'' then ''English''
		else ''Gujarati''
	end as languageToDisplay,
	labelMaster1.translation_pending as "isTranslationPending",
	labelMaster1.app_name as "appName"
from
	internationalization_label_master as labelMaster1
join internationalization_label_master as labelMaster2 on
	labelMaster2.key = labelMaster1.key
where
	labelMaster2.language = ''EN''
	and (#startsWith# = null
	or labelMaster2.text ilike concat(#startsWith# , ''%'' ))
	and (#searchText# = null
	or labelMaster2.text ilike concat( ''%'',#searchText# , ''%'' ))
order by
	labelMaster1.key
limit #limit# offset #offset#',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='translation_label_update_1';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'a8dbf62c-788b-449e-8ae5-589daacb8398', 74909,  current_date , 74909,  current_date , 'translation_label_update_1',
'oldKey,appName,isTranslationPending,language,text',
'UPDATE internationalization_label_master SET app_name=#appName#, text =#text#, translation_pending=#isTranslationPending#,modified_on=now()
 WHERE key = #oldKey# and language=#language#;',
null,
false, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='translation_label_add_1';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'36155a13-3c9b-4981-bd38-f24bbbe30ff9', 74909,  current_date , 74909,  current_date , 'translation_label_add_1',
'appName,language,label,loggedInUserId,text',
'INSERT INTO internationalization_label_master(country, key, language, created_by, created_on, app_name, text, translation_pending)
VALUES (''IN'', REPLACE(#label#,'' '',''''), #language#, #loggedInUserId# , now(), #appName# , #text# ,false );',
null,
false, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='translation_label_check_1';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'57a1db17-cae4-4749-9890-a8c0be1b5f35', 74909,  current_date , 74909,  current_date , 'translation_label_check_1',
'appName,key',
'select * from internationalization_label_master where key = #key# and app_name=#appName#',
null,
true, 'ACTIVE');
