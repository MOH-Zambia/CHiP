DELETE FROM QUERY_MASTER WHERE CODE='retrival_listvalues_mobile';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'789c459f-dabd-4c09-8327-44323becd39f', 97104,  current_date , 97104,  current_date , 'retrival_listvalues_mobile',
'roleId,lastUpdatedOn',
'with features as (
	select cast(CAST(jsonb_array_elements(CAST(config_json AS jsonb)) as jsonb)->>''mobile_constant'' as text) as const
	from mobile_menu_master mmm
	inner join mobile_menu_role_relation mmrr on mmm.id = mmrr.menu_id
	inner join um_role_master urm on mmrr.role_id  = urm.id
	where urm.id = #roleId#
), field_list as (
	select distinct lffr.field
	from features f
	inner join mobile_feature_master mfm on mfm.mobile_constant = f.const
	inner join mobile_form_feature_rel mffr on f.const = mffr.mobile_constant
	inner join mobile_form_details mfd on mfd.id = mffr.form_id
	inner join listvalue_field_form_relation lffr on lffr.form_id = mfd.id
	where mfm.state = ''ACTIVE''
)
select values.id as "idOfValue", fields.form as "formCode",
	fields.field as "field", fields.field_type as "fieldType",values.constant as constant, values.value as value, values.list_order as order,
    values.last_modified_on as "lastUpdateOfFieldValue", values.is_active as "isActive"
from listvalue_field_value_detail values
join listvalue_field_master fields on fields.field_key = values.field_key
where fields.field in (select * from field_list)
	and values.last_modified_on >= cast((case when ''#lastUpdatedOn#'' = ''null'' then ''1970-01-01 05:30:00.0'' else ''#lastUpdatedOn#'' end) as timestamp);',
null,
true, 'ACTIVE');