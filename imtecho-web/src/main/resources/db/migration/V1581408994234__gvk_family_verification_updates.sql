alter table gvk_verification
drop column if exists reverification_list_for_family_verification,
add column reverification_list_for_family_verification text;

alter table gvk_verification
drop column if exists family_verification_id,
add column family_verification_id integer;

-- get family ids which having given mobile number

delete from query_master where code='family_id_retrieval_by_mobile_number';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, now(),
'family_id_retrieval_by_mobile_number','mobileNumber','
    select family_id from imt_member im where mobile_number = ''#mobileNumber#'' group by family_id;
', true, 'ACTIVE', 'Get family ids which having given mobile number');

-- update phone number by member id

delete from query_master where code='update_mobile_number_by_member_id';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, now(),
'update_mobile_number_by_member_id','memberId,mobileNumber','
    update imt_member im set mobile_number = ''#mobileNumber#'' where id = #memberId#;
', false, 'ACTIVE', 'Update phone number by member id');

-- by subhash sir

alter table imt_family_verification
drop column if exists survey_type,
add column survey_type character varying (55);

insert into system_configuration (system_key,key_value,is_active) values ('CFHC_DEATH_MEMBER_FAMILY_VERIFICATION_LAST_EXECUTION','2020-01-15',true);

update imt_family_verification set survey_type = 'FHS' WHERE survey_type IS NULL;