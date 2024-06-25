DO $$
BEGIN
BEGIN
alter table location_type_master
drop constraint location_type_master_pkey,
add column id serial primary key,
add column is_active boolean not null default true;

EXCEPTION
WHEN duplicate_column THEN RAISE NOTICE 'Already exists';
END;
END;
$$;

DELETE FROM QUERY_MASTER WHERE CODE='retrieve_location_type_by_id';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'56c03b5a-cd2d-4764-b123-31fd89634efc', 60512,  current_date , 60512,  current_date , 'retrieve_location_type_by_id',
'id',
'select id as "id",
type as "type",
name as "name",
level as "level",
is_soh_enable as "isSohEnable",
is_active as "isActive"
from location_type_master
where id = cast(#id# as integer)',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='create_location_type';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'386799aa-1e30-4ae7-ab6f-93cdd9ce6042', 60512,  current_date , 60512,  current_date , 'create_location_type',
'level,name,isSohEnable,loggedInUserId,type',
'insert into location_type_master
(type,name,level,is_soh_enable,is_active,created_by,created_on,modified_by,modified_on)
values (#type#,#name#,#level#,#isSohEnable#,true,#loggedInUserId#,now(),#loggedInUserId#,now());',
null,
false, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='update_location_type';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'4321cba3-50e7-40b0-8786-483438d77aa0', 60512,  current_date , 60512,  current_date , 'update_location_type',
'level,name,isSohEnable,loggedInUserId,id,type',
'update location_type_master
set type = #type#,
name = #name#,
level = #level#,
is_soh_enable  = #isSohEnable#,
modified_by = #loggedInUserId#,
modified_on = now()
where id = #id#;',
null,
false, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='toggle_location_type_status';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'e2db2cf7-280d-43c6-a513-ad29d98c25fd', 60512,  current_date , 60512,  current_date , 'toggle_location_type_status',
'id',
'update location_type_master
set is_active = not is_active
where id = #id#',
null,
false, 'ACTIVE');