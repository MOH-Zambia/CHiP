DELETE FROM QUERY_MASTER WHERE CODE='lms_dashboard_retrieve_total_users_v2';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'ea37fd8f-cbba-443d-ac6a-49fc4d4256ef', 97070,  current_date , 97070,  current_date , 'lms_dashboard_retrieve_total_users_v2',
'locationId',
'select count(distinct uu.id) as "totalUsers",
	count(distinct uuld.user_id) as "appInstalled"
from location_hierchy_closer_det lhcd
	inner join um_user_location uul on uul.loc_id = lhcd.child_id
	and uul.state = ''ACTIVE''
	inner join um_user uu on uu.id = uul.user_id
	and uu.state = ''ACTIVE''
	left join um_user_login_det uuld on uuld.user_id = uu.id
where lhcd.parent_id = #locationId# and uu.role_id = (select id from um_role_master where name=''ANM'')',
null,
true, 'ACTIVE');