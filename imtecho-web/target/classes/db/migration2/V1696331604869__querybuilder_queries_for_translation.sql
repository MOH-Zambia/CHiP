DELETE FROM QUERY_MASTER WHERE CODE='labels_get_all_ibm_languages';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'713d96aa-6445-46bf-a96a-22d19fecca72', -1,  current_date , -1,  current_date , 'labels_get_all_ibm_languages',
 null,
'select lfvd.* from listvalue_field_value_detail lfvd left join language_master lm on lfvd.code = lm.language_key where field_key = ''translation_language'' and lm.id is null;',
null,
true, 'ACTIVE');

-----------------------------------

DELETE FROM QUERY_MASTER WHERE CODE='labels_app_data_for_prepopulating';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'24354241-f008-48da-aae2-36281d77a378', -1,  current_date , -1,  current_date , 'labels_app_data_for_prepopulating',
'appValue,key',
'select
	tm.*,am.app_value as appValue,lm.language_value  as languageValue
from
	translation_master tm
inner join app_master am on
	am.id = tm.app
inner join language_master lm on
	lm.id = tm.language
where
	am.app_value = ''#appValue#'' and tm.key = ''#key#'' and lm.is_active',
null,
true, 'ACTIVE');

-----------------------------------

DELETE FROM QUERY_MASTER WHERE CODE='labels_fetch_translations';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'6cc07b96-bf5d-451f-a4d0-3154f842364e', -1,  current_date , -1,  current_date , 'labels_fetch_translations',
'searchString,offset,appId,showInactive,limit,startsWith',
'with appsList as (
    select
    	string_agg(distinct am2.app_value,'','') as appValue,
    	tm.key
    from
    	translation_master tm,
    	app_master am2
    where
        am2.id = tm.app
    	and key in (select distinct key from translation_master where
    		    	value ilike ''%#searchString#%'' and value ilike ''#startsWith#%'' and case when #appId# is null then true else app = #appId# end)
    group by
    	tm.key),
key_app_pair as (
	select
		distinct app,key
	from translation_master tm
	where case when #showInactive# then true else is_active end),
labels_in_all_langs as (
	select
		app,key,lm.language_value,lm.id
	from language_master lm
	left join key_app_pair tm on true
        where lm.is_active),
labels as (
    select
    tm.id,lm.key,lm.id as language,lm.language_value ,am.app_value,lm.app,tm.is_active,tm.value
    from
    	labels_in_all_langs lm
    left join translation_master tm on lm.app=tm.app and lm.key = tm.key and tm.language = lm.id
	inner join app_master am on am.id = lm.app and am.is_active
        where lm.key in (select distinct key from translation_master tm2 where tm2.value ilike ''%#searchString#%'' and tm2.value ilike ''#startsWith#%'' and case when #appId# is null then true else app = #appId# end)
        	  and case when #appId# is null then true else lm.app = #appId# end
    )
select distinct on (lb.key,lb.app_value,lb.language_value)
lb.id,
                lb.language as languageId,
		lb.language_value as language ,
                lb.app as appId,
		lb.app_value as App ,
		lb.key,
		lb.value as Value,
		al.appValue,
		lb2.value as englishValue,
                lb.is_active
from
	 labels lb
left join appsList al on al.key = lb.key
left join labels lb2 on lb.key = lb2.key and lb.app=lb2.app and lb2.language = 65
order by lb.key,lb.app_value desc, lb.language_value
limit #limit# offset #offset#',
null,
true, 'ACTIVE');

-----------------------------------

DELETE FROM QUERY_MASTER WHERE CODE='labels_selected_apps_for_editing';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'1c1c0868-0d1d-4a67-9e9b-00ef45028837', 97084,  current_date , 97084,  current_date , 'labels_selected_apps_for_editing',
'key',
'with apps as(
	select am.app_value as appValue,app
	from translation_master tm
	inner join app_master am on tm.app = am.id
	where key = ''#key#'' and tm.is_active and am.is_active)
select
	distinct
        tm.id,
	apps.app as app,
	apps.appValue as appValue,
	lm.id as language,
    lm.language_key as languageKey,
    lm.language_value as languageValue,
    tm.key,
    tm.value,
    tm.is_active
from language_master lm
left join apps on true
left join translation_master tm on lm.id = tm.language and tm.key = ''#key#'' and tm.app = apps.app
where
 lm.is_active
order by
    apps.appValue,
    lm.language_value asc;',
null,
true, 'ACTIVE');
