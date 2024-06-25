
insert into menu_config (menu_name, menu_type, active, navigation_state, feature_json, only_admin, group_id)
select 'Form Configurator', 'admin', TRUE, 'techo.admin.systemConstraints', '{}', true, (select id from menu_group where group_name = 'Application Management' and group_type = 'admin')
where not exists (select id from menu_config where navigation_state = 'techo.admin.systemConstraints' and menu_type = 'admin');

--

DELETE FROM QUERY_MASTER WHERE CODE='get_all_menus_for_system_constraint_form_config';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'22d70262-7d0a-44ad-abe5-73d649f58c35', 78434,  current_date , 78434,  current_date , 'get_all_menus_for_system_constraint_form_config',
 null,
'select
	mc.id as "id",
	mc.group_id as "groupId",
	mc.menu_name as "menuName",
	mc.menu_type as "menuType",
	concat(mc.menu_name, '' ('', mc.menu_type, (case when mc.group_id is not null then '' > '' else '''' end), mg.group_name, '')'') as "menuDisplayName"
from
	menu_config mc
left join
	menu_group mg on mg.id = mc.group_id and mg.group_type = mc.menu_type and mg.active is true
where
	mc.active is true
	and mc.is_dynamic_report is not true
order by
	mc.menu_name',
'Get all menus for system constraint form configurations.',
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='retrieve_system_constraint_field_masters';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'0c87c87a-3611-4ade-806a-29b24b444027', 60512,  current_date , 60512,  current_date , 'retrieve_system_constraint_field_masters',
'form_uuid',
'select cast(uuid as text) as uuid,
cast(form_master_uuid as text) as form_master_uuid,
field_key,field_name,field_type,ng_model,app_name,
cast(standard_field_master_uuid as text) as standard_field_master_uuid,
created_by,modified_by
from system_constraint_field_master
where form_master_uuid = cast(#form_uuid# as uuid)',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='retrieve_system_constraint_field_value_masters';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'4aa13957-5131-45af-9bbb-87fab686c0ba', 60512,  current_date , 60512,  current_date , 'retrieve_system_constraint_field_value_masters',
'form_uuid',
'select cast(system_constraint_field_value_master.uuid as text) as uuid,
cast(system_constraint_field_value_master.field_master_uuid as text) as field_master_uuid,
system_constraint_field_value_master.value_type,
system_constraint_field_value_master.key,
system_constraint_field_value_master.value,
system_constraint_field_value_master.default_value,
system_constraint_field_value_master.created_by,
system_constraint_field_value_master.modified_by
from system_constraint_field_value_master
inner join system_constraint_field_master on system_constraint_field_value_master.field_master_uuid = system_constraint_field_master.uuid
where system_constraint_field_master.form_master_uuid = cast(#form_uuid# as uuid)',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='retrieve_system_constraint_translation_labels';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'a900bd68-4af0-4ff9-9d3f-3660ded9105a', 60512,  current_date , 60512,  current_date , 'retrieve_system_constraint_translation_labels',
'fieldKeys',
'select *
from internationalization_label_master
where key in (#fieldKeys#)',
null,
true, 'ACTIVE');

--

delete from listvalue_field_value_detail where field_key  = 'system_constraint_standard_field_categories';
delete from listvalue_field_master where field_key = 'system_constraint_standard_field_categories';

insert into listvalue_field_master (field_key, field, is_active, field_type, form, role_type)
values
('system_constraint_standard_field_categories','Categories of System Constraint Standard Fields',TRUE,'T','WEB',null);

insert into listvalue_field_value_detail (is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size)
values
(true,false,'superadmin',now(),'TEST_CATEGORY_1','system_constraint_standard_field_categories',0),
(true,false,'superadmin',now(),'TEST_CATEGORY_2','system_constraint_standard_field_categories',0);

--

DELETE FROM system_configuration where system_key = 'SYSTEM_CONSTRAINT_ACTIVE_STANDARD_ID';
INSERT INTO system_configuration (system_key, is_active, key_value)
VALUES
('SYSTEM_CONSTRAINT_ACTIVE_STANDARD_ID', true, (select id from listvalue_field_value_detail where field_key = 'system_codes_supported_types' and value = 'ICD_10'));
