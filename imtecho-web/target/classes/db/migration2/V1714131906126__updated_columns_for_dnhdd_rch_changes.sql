ALTER TABLE rch_lmp_follow_up
ADD COLUMN if not exists prev_anc_date timestamp without time zone,
ADD COLUMN if not exists prev_anc_infra_id integer;

ALTER TABLE rch_vaccine_adverse_effect
ADD COLUMN if not exists vaccination_infra_id integer;

ALTER TABLE rch_anc_master
ADD COLUMN if not exists pref_place_infra_id integer;

delete from listvalue_field_form_relation lffr where field = 'stateList' and
form_id = (select id from mobile_form_details where form_name = 'FHW_ANC');

delete from listvalue_field_form_relation lffr where field = 'states' and
form_id = (select id from mobile_form_details where form_name = 'FHW_ANC');

delete from listvalue_field_value_detail where field_key = 'stateList';

delete from listvalue_field_master lfm where field_key = 'stateList' and form = 'FHW_ANC';

insert into listvalue_field_master(field_key, field, is_active, field_type, form, role_type)
values('indianStateList', 'indianStateList', true, 'T', 'FHW_ANC', 'A,F');

insert into listvalue_field_form_relation(field, form_id)
select 'indianStateList', id from mobile_form_details where form_name = 'FHW_ANC';

delete from public.listvalue_field_value_detail where field_key = 'indianStateList';
INSERT INTO public.listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code, list_order, additional_detail, constant)
VALUES
(true, false, 'pparida', now(), 'Gujarat', 'indianStateList', 0, NULL, NULL, 1, NULL, 'GUJARAT'),
(true, false, 'pparida', now(), 'Maharashtra', 'indianStateList', 0, NULL, NULL, 2, NULL, 'MAHARASHTRA'),
(true, false, 'pparida', now(), 'Uttar Pradesh', 'indianStateList', 0, NULL, NULL, 3, NULL, 'UP'),
(true, false, 'pparida', now(), 'Bihar', 'indianStateList', 0, NULL, NULL, 4, NULL, 'BIHAR'),
(true, false, 'pparida', now(), 'Andhra Pradesh', 'indianStateList', 0, NULL, NULL, 5, NULL, 'ANDHRA_PRADESH'),
(true, false, 'pparida', now(), 'Arunachal Pradesh', 'indianStateList', 0, NULL, NULL, 6, NULL, 'ARUNACHAL_PRADESH'),
(true, false, 'pparida', now(), 'Assam', 'indianStateList', 0, NULL, NULL, 7, NULL, 'ASSAM'),
(true, false, 'pparida', now(), 'Chhattisgarh', 'indianStateList', 0, NULL, NULL, 8, NULL, 'CHHATTISGARH'),
(true, false, 'pparida', now(), 'Goa', 'indianStateList', 0, NULL, NULL, 9, NULL, 'GOA'),
(true, false, 'pparida', now(), 'Haryana', 'indianStateList', 0, NULL, NULL, 10, NULL, 'HARYANA'),
(true, false, 'pparida', now(), 'Himachal Pradesh', 'indianStateList', 0, NULL, NULL, 11, NULL, 'HIMACHAL_PRADESH'),
(true, false, 'pparida', now(), 'Jharkhand', 'indianStateList', 0, NULL, NULL, 12, NULL, 'JHARKHAND'),
(true, false, 'pparida', now(), 'Karnataka', 'indianStateList', 0, NULL, NULL, 13, NULL, 'KARNATAKA'),
(true, false, 'pparida', now(), 'Kerala', 'indianStateList', 0, NULL, NULL, 14, NULL, 'KERALA'),
(true, false, 'pparida', now(), 'Madhya Pradesh', 'indianStateList', 0, NULL, NULL, 15, NULL, 'MADHYA_PRADESH'),
(true, false, 'pparida', now(), 'Manipur', 'indianStateList', 0, NULL, NULL, 16, NULL, 'MANIPUR'),
(true, false, 'pparida', now(), 'Meghalaya', 'indianStateList', 0, NULL, NULL, 17, NULL, 'MEGHALAYA'),
(true, false, 'pparida', now(), 'Mizoram', 'indianStateList', 0, NULL, NULL, 18, NULL, 'MIZORAM'),
(true, false, 'pparida', now(), 'Nagaland', 'indianStateList', 0, NULL, NULL, 19, NULL, 'NAGALAND'),
(true, false, 'pparida', now(), 'Odisha', 'indianStateList', 0, NULL, NULL, 20, NULL, 'ODISHA'),
(true, false, 'pparida', now(), 'Punjab', 'indianStateList', 0, NULL, NULL, 21, NULL, 'PUNJAB'),
(true, false, 'pparida', now(), 'Rajasthan', 'indianStateList', 0, NULL, NULL, 22, NULL, 'RAJASTHAN'),
(true, false, 'pparida', now(), 'Sikkim', 'indianStateList', 0, NULL, NULL, 23, NULL, 'SIKKIM'),
(true, false, 'pparida', now(), 'Tamil Nadu', 'indianStateList', 0, NULL, NULL, 24, NULL, 'TAMIL_NADU'),
(true, false, 'pparida', now(), 'Telangana', 'indianStateList', 0, NULL, NULL, 25, NULL, 'TELANGANA'),
(true, false, 'pparida', now(), 'Tripura', 'indianStateList', 0, NULL, NULL, 26, NULL, 'TRIPURA'),
(true, false, 'pparida', now(), 'Uttarakhand', 'indianStateList', 0, NULL, NULL, 27, NULL, 'UTTARAKHAND'),
(true, false, 'pparida', now(), 'West Bengal', 'indianStateList', 0, NULL, NULL, 28, NULL, 'WEST_BENGAL');

--renamed order to listOrder in returning dto
DELETE FROM QUERY_MASTER WHERE CODE='retrival_listvalues_mobile';

INSERT INTO QUERY_MASTER (created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (-1,  current_date , -1,  current_date , 'retrival_listvalues_mobile',
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
	fields.field as "field", fields.field_type as "fieldType",values.constant as constant, values.value as value, values.list_order as "listOrder",
    values.last_modified_on as "lastUpdateOfFieldValue", values.is_active as "isActive"
from listvalue_field_value_detail values
join listvalue_field_master fields on fields.field_key = values.field_key
where fields.field in (select * from field_list)
	and values.last_modified_on >= cast((case when ''#lastUpdatedOn#'' = ''null'' then ''1970-01-01 05:30:00.0'' else ''#lastUpdatedOn#'' end) as timestamp);',
'retrieves list values for mobile based on lastModifiedOn',
true, 'ACTIVE');