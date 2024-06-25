update system_configuration
    set key_value = '6'
    where system_key = 'MOBILE_FORM_VERSION';


----------------

insert into mobile_form_feature_rel (form_id,mobile_constant)
select mfd.id, mfm.mobile_constant from mobile_form_details mfd, mobile_feature_master mfm
where mfd.file_name
in (
	'ANCMORB',
	'CCMORB',
	'PNCMORB'
) and mfm.mobile_constant in ('ASHA_NOTIFICATION', 'ASHA_MY_PEOPLE');


-- =========================

delete from user_menu_item where menu_config_id = (select id from menu_config where menu_name = 'Mobile Feature Management');

delete from menu_config where id in (select id from menu_config where menu_name = 'Mobile Feature Management');

INSERT INTO menu_config
(feature_json, group_id, active, is_dynamic_report, menu_name, navigation_state, sub_group_id, menu_type, only_admin, menu_display_order, uuid)
VALUES(NULL, null, true, true, 'Mobile Feature Management', 'techo.manage.mobileFeatureManagement', NULL, 'admin', NULL, NULL, NULL);

--------------------------------------

DELETE FROM QUERY_MASTER WHERE CODE='mobile_features';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'77c2809a-1024-435a-b965-f0c149b23267', 80222,  current_date , 80222,  current_date , 'mobile_features',
'search,offset,limit',
'---- mobile_features
select mobile_constant , mobile_display_name, feature_name, state from mobile_feature_master mfm
where case when ''#search#'' = ''null'' or mfm.mobile_display_name ilike ''%#search#%'' then
true else false end
order by mfm.feature_name
limit #limit# offset #offset#;',
null,
true, 'ACTIVE');

--------------------------------------

DELETE FROM QUERY_MASTER WHERE CODE='mobile_form_list';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'4d10a891-146a-4096-bbd9-e716e6627410', 97051,  current_date , 97051,  current_date , 'mobile_form_list',
 null,
'--- mobile_form_list
select id, form_name, file_name from mobile_form_details mfd;',
null,
true, 'ACTIVE');

----------------------------------------

DELETE FROM QUERY_MASTER WHERE CODE='mobile_bean_list';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'0a9f4981-1d3c-4cb8-9ae0-4be5024d83ec', 97051,  current_date , 97051,  current_date , 'mobile_bean_list',
 null,
'--- mobile_bean_list
select bean from mobile_beans_master mbm;',
null,
true, 'ACTIVE');

----------------------------------------

DELETE FROM QUERY_MASTER WHERE CODE='mobile_feature_details';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'7b43cf49-fb47-42a5-baa4-9d5507612310', 97051,  current_date , 97051,  current_date , 'mobile_feature_details',
'feature',
'--- mobile_feature_details
with beans as (
	select feature as mobile_constant, array_agg(mbfr.bean) as bean
	from mobile_beans_feature_rel mbfr
	group by feature
), forms as (
	select mobile_constant, array_agg(mffr.form_id) as form
	from mobile_form_feature_rel mffr
	group by mobile_constant
)
select mfm.mobile_constant, mfm.feature_name, mfm.mobile_display_name, cast(b.bean as text), cast(f.form as text)
from beans b
right join mobile_feature_master mfm on mfm.mobile_constant = b.mobile_constant
left join forms f on mfm.mobile_constant = f.mobile_constant
where mfm.mobile_constant = #feature#;',
null,
true, 'ACTIVE');

----------------------------------------

DELETE FROM QUERY_MASTER WHERE CODE='insert_update_mobile_feature';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'e572ac55-d377-4ce2-9aea-6d6e6062b1a9', 97051,  current_date , 97051,  current_date , 'insert_update_mobile_feature',
'mobileDisplayName,featureName,beans,userId,mobileConstant,forms',
'-- insert_update_mobile_feature

update mobile_feature_master
set feature_name = #featureName#, mobile_display_name = #mobileDisplayName#, modified_by = #userId#, modified_on =now()
where mobile_constant = #mobileConstant#;

insert into mobile_feature_master (mobile_constant, feature_name, mobile_display_name, state, created_by, created_on, modified_by, modified_on)
select #mobileConstant#, #featureName#, #mobileDisplayName#, ''ACTIVE'', #userId#, now(), #userId#, now()
where not exists (select 1 from mobile_feature_master where mobile_constant = #mobileConstant#);

delete from mobile_beans_feature_rel
where feature = #mobileConstant#;

insert into mobile_beans_feature_rel(feature, bean)
select #mobileConstant#, unnest(string_to_array(#beans#, '',''))
where #beans# is not null;

delete from mobile_form_feature_rel
where mobile_constant = #mobileConstant#;

insert into mobile_form_feature_rel (mobile_constant, form_id)
select #mobileConstant#, cast(unnest(string_to_array(#forms#, '','')) as integer)
where #forms# is not null;

with features_of_menu as (
	select jsonb_array_elements(CAST(config_json AS jsonb))->>''mobile_constant'' as menu_constant, id
	from mobile_menu_master mmm
	inner join mobile_menu_role_relation mmrr on mmrr.menu_id = mmm.id
)
update mobile_menu_master
set modified_on = now(), modified_by = #userId#
where id in (
	select id from features_of_menu where menu_constant = #mobileConstant#
);',
null,
false, 'ACTIVE');

--------------------------------------

DELETE FROM QUERY_MASTER WHERE CODE='update_mobile_feature_state';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'da0f4b07-fd63-470c-9b38-10d02599b7da', 80222,  current_date , 80222,  current_date , 'update_mobile_feature_state',
'feature,state',
'--- update_mobile_feature_state

update mobile_feature_master
set state = ''#state#'', modified_on = now()
where mobile_constant = ''#feature#'';


with features_of_menu as (
	select jsonb_array_elements(CAST(config_json AS jsonb))->>''mobile_constant'' as menu_constant, id
	from mobile_menu_master mmm
	inner join mobile_menu_role_relation mmrr on mmrr.menu_id = mmm.id
)
update mobile_menu_master
set modified_on = now()
where id in (
	select id from features_of_menu where menu_constant = ''#feature#''
);',
null,
false, 'ACTIVE');

--------------------------------------


-- ====================================


delete from mobile_beans_feature_rel where bean = 'CovidTravellersInfoBean';

delete from mobile_beans_master where bean = 'CovidTravellersInfoBean';

insert into mobile_beans_master(bean, depends_on_last_sync)
values ('CovidTravellersInfoBean', true);

insert into mobile_beans_feature_rel(bean, feature)
select bean, feature
from (
	values
		('FHW_MY_PEOPLE', 'CovidTravellersInfoBean'),
		('FHW_NOTIFICATION', 'CovidTravellersInfoBean')
) as f(feature, bean);