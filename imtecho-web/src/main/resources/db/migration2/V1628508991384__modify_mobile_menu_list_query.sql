DELETE FROM QUERY_MASTER WHERE CODE='mobile_menu_list';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'68b5486f-42aa-40c1-ba8a-00a00750ee64', 74841,  current_date , 74841,  current_date , 'mobile_menu_list', 
'search,offset,limit', 
'with menu_mobile as (
	select 
	mm.id, 
	jsonb_array_elements(cast(mm.config_json as jsonb) ) ->> ''mobile_constant'' as  mobile_constant
	from mobile_menu_master mm),
mobile_features as (
	select 
	mm.id, 
	string_agg(mfm.feature_name, '', '') as features 
	from menu_mobile mm
	inner join mobile_feature_master mfm on mfm.mobile_constant = mm.mobile_constant
	group by mm.id
)
select
mr.role_id as id,
mm.menu_name, ur."name" as role_name ,
mf.features 
from mobile_menu_role_relation mr
left join mobile_menu_master mm on mm.id = mr.menu_id
left join um_role_master ur on ur.id = mr.role_id
left join mobile_features mf on mf.id = mm.id
where case when ''#search#'' = ''null'' or mm.menu_name ilike ''%#search#%'' then
true else false end
order by mr.menu_id
limit #limit# offset #offset#', 
null, 
true, 'ACTIVE');