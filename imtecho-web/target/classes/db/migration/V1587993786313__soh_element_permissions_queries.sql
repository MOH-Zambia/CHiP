drop table if exists soh_element_permissions;
create table soh_element_permissions (
    id serial primary key,
    element_id integer,
    permission_type character varying(30),
    reference_id integer
);


DELETE FROM QUERY_MASTER WHERE CODE='insert_soh_element_permissions';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
74909,  current_date , 74909,  current_date , 'insert_soh_element_permissions',
'elementId,permissionType,ref_ids',
'delete
from
	soh_element_permissions
where
	element_id = #elementId#
	and permission_type = ''ALL'';
insert
	into
		soh_element_permissions( element_id, permission_type, reference_id )
	values(#elementId#, ''#permissionType#'',
unnest( array#ref_ids#))',
null,
false, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='fetch_soh_element_permissions_details';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
74909,  current_date , 74909,  current_date , 'fetch_soh_element_permissions_details',
'element_id',
'with role_ids as ( select
	id,reference_id, permission_type
from
	soh_element_permissions
where
	permission_type = ''ROLE''
	and element_id = #element_id#),
user_ids as ( select
	id,reference_id, permission_type
from
	soh_element_permissions
where
	permission_type = ''USER''
	and element_id = #element_id#) select
	role_ids.id,
	um_role_master.name,
	role_ids.permission_type
from
	um_role_master
inner join role_ids on
	um_role_master.id = role_ids.reference_id
union all select
	user_ids.id,
	concat( um_user.first_name, '' '', um_user.last_name ) as "name",
	user_ids.permission_type
from
	um_user
inner join user_ids on
	um_user.id = user_ids.reference_id
union all select
	id,
	permission_type,
	permission_type
from
	soh_element_permissions
where
	reference_id is null and element_id = #element_id#',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='delete_soh_element_permissions_detail';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
74909,  current_date , 74909,  current_date , 'delete_soh_element_permissions_detail',
'ref_id',
'delete
from
	soh_element_permissions
where
	id = #ref_id#',
null,
false, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='insert_all_soh_element_permissions';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
74909,  current_date , 74909,  current_date , 'insert_all_soh_element_permissions',
'elementId,permissionType',
'delete
from
	soh_element_permissions
where
	element_id = #elementId#
	and reference_id is not null;
insert
	into
		soh_element_permissions( element_id, permission_type)
	values(#elementId#, ''#permissionType#'')',
null,
false, 'ACTIVE');