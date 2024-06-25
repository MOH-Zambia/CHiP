UPDATE public.query_master 
SET query = 'select values.id as "idOfValue", fields.form as "formCode", 
    fields.field as "field", fields.field_type as "fieldType", values.value as value, 
    values.last_modified_on as "lastUpdateOfFieldValue", values.is_active as "isActive"
    from listvalue_field_value_detail values join listvalue_field_master fields
    on fields.field_key = values.field_key inner join  listvalue_field_role vr
    on values.field_key=vr.field_key where role_id=#roleId#
    and values.last_modified_on >= cast((case when ''#lastUpdatedOn#'' is null 
    then ''1970-01-01 05:30:00.0'' else ''#lastUpdatedOn#'' end) as timestamp)'
WHERE code = 'retrival_listvalues_mobile';