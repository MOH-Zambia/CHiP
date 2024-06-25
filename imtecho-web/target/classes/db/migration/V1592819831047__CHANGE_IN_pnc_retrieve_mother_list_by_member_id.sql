DELETE FROM QUERY_MASTER WHERE CODE='pnc_retrieve_mother_list_by_member_id';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'47ef4d50-2897-4144-8216-15a238154861', 75398,  current_date , 75398,  current_date , 'pnc_retrieve_mother_list_by_member_id', 
'memberId', 
'select * from imt_member where id in 
(select member_id from rch_pregnancy_registration_det where delivery_date > now() - interval ''60 days''
and state = ''DELIVERY_DONE''
and member_id in (select id from imt_member where unique_health_id in (#memberId#)))
and ((imt_member.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'')) or (imt_member.state = ''com.argusoft.imtecho.member.state.temporary''))', 
null, 
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='pnc_retrieve_mother_list_by_family_id';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'ca1ab66c-e15a-4316-8095-f265e649433d', 75398,  current_date , 75398,  current_date , 'pnc_retrieve_mother_list_by_family_id', 
'familyId', 
'select * from imt_member where id in 
(select member_id from rch_pregnancy_registration_det where delivery_date > now() - interval ''60 days''
and state = ''DELIVERY_DONE''
and member_id in (select id from imt_member where family_id = #familyId#))
and ((imt_member.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'')) or (imt_member.state = ''com.argusoft.imtecho.member.state.temporary''))', 
null, 
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='pnc_retrieve_mother_list_by_name';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'a182a2aa-c705-4c5a-9224-b2df50219ae0', 75398,  current_date , 75398,  current_date , 'pnc_retrieve_mother_list_by_name', 
'firstName,lastName,offSet,limit,middleName', 
'select * from imt_member where id in 
(select member_id from rch_pregnancy_registration_det where delivery_date > now() - interval ''60 days''
and state = ''DELIVERY_DONE''
and member_id in (select id from imt_member where similarity(#firstName#,first_name)>=0.50 and similarity(#lastName#,last_name)>=0.60
and case when #middleName# != null and #middleName# !='''' then similarity(#middleName#,middle_name)>=0.50 else 1=1 end) limit #limit# offset #offSet#)
and ((imt_member.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'')) or (imt_member.state = ''com.argusoft.imtecho.member.state.temporary''))', 
null, 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='pnc_retrieve_mother_list_by_mobile_number';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'dbdb23e3-356d-455e-9922-de4b32363c8c', 75398,  current_date , 75398,  current_date , 'pnc_retrieve_mother_list_by_mobile_number', 
'offSet,mobileNumber,limit', 
'select * from imt_member where id in 
(select member_id from rch_pregnancy_registration_det where delivery_date > now() - interval ''60 days''
and state = ''DELIVERY_DONE''
and member_id in (select id from imt_member where mobile_number = #mobileNumber#) limit #limit# offset #offSet#)
and ((imt_member.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'')) or (imt_member.state = ''com.argusoft.imtecho.member.state.temporary''))', 
null, 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='pnc_retrieve_mother_list_by_family_mobile_number';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'fdf94c16-cd74-484e-b8cb-8256919c6055', 75398,  current_date , 75398,  current_date , 'pnc_retrieve_mother_list_by_family_mobile_number', 
'offSet,mobileNumber,limit', 
'select * from imt_member where id in 
(select member_id from rch_pregnancy_registration_det where delivery_date > now() - interval ''60 days''
and state = ''DELIVERY_DONE''
and member_id in (select id from imt_member where family_id in 
(select family_id from imt_member where mobile_number = #mobileNumber#) and ((imt_member.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'')) or (imt_member.state = ''com.argusoft.imtecho.member.state.temporary''))))
limit #limit# offset #offSet#', 
null, 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='pnc_retrieve_mother_list_by_woman_id';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'cb1c0474-044a-49b5-b9e1-d2c411989ff9', 75398,  current_date , 75398,  current_date , 'pnc_retrieve_mother_list_by_woman_id', 
'womanId', 
'select * from imt_member where id in 
(select member_id from rch_pregnancy_registration_det where delivery_date > now() - interval ''60 days''
and state = ''DELIVERY_DONE''
and mthr_reg_no = #womanId#)
and ((imt_member.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'')) or (imt_member.state = ''com.argusoft.imtecho.member.state.temporary''))', 
null, 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='sickle_cell_search_by_family_id';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'7e74f1b4-c627-4291-ad03-ee7e2e96f503', 75398,  current_date , 75398,  current_date , 'sickle_cell_search_by_family_id', 
'familyId,offSet,limit', 
'select imt_member.unique_health_id as "uniqueHealthId",
imt_member.id as "memberId",
imt_member.family_id as "familyId",
imt_member.mobile_number as "mobileNumber",
concat(imt_family.address1,'', '',imt_family.address2) as "address",
imt_family.location_id as "locationId",
get_location_hierarchy(imt_family.location_id) as "locationHierarchy",
concat(imt_member.first_name,'' '',imt_member.middle_name,'' '',imt_member.last_name) as "name",
imt_member.gender as "gender",
rel.value as "religion",
cas.value as "caste",
imt_member.dob as "dob",
cast(age(imt_member.dob)as text) as "age",
extract(year from age(imt_member.dob)) as "ageInYears"
from imt_member
inner join imt_family on imt_member.family_id = imt_family.family_id
left join listvalue_field_value_detail rel on cast(imt_family.religion as bigint) = rel.id
left join listvalue_field_value_detail cas on cast(imt_family.caste as bigint) = cas.id
where imt_member.family_id = #familyId#
and ((imt_member.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'')) or (imt_member.state = ''com.argusoft.imtecho.member.state.temporary''))
limit #limit# offset #offSet#', 
null, 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='sickle_cell_search_by_member_id';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'f2b3d249-13d7-4ae5-9c1f-6ee05455a709', 75398,  current_date , 75398,  current_date , 'sickle_cell_search_by_member_id', 
'offSet,limit,uniqueHealthId', 
'select imt_member.unique_health_id as "uniqueHealthId",
imt_member.id as "memberId",
imt_member.family_id as "familyId",
imt_member.mobile_number as "mobileNumber",
concat(imt_family.address1,'', '',imt_family.address2) as "address",
imt_family.location_id as "locationId",
get_location_hierarchy(imt_family.location_id) as "locationHierarchy",
concat(imt_member.first_name,'' '',imt_member.middle_name,'' '',imt_member.last_name) as "name",
imt_member.gender as "gender",
rel.value as "religion",
cas.value as "caste",
imt_member.dob as "dob",
cast(age(imt_member.dob)as text) as "age",
extract(year from age(imt_member.dob)) as "ageInYears"
from imt_member
inner join imt_family on imt_member.family_id = imt_family.family_id
left join listvalue_field_value_detail rel on cast(imt_family.religion as bigint) = rel.id
left join listvalue_field_value_detail cas on cast(imt_family.caste as bigint) = cas.id
where unique_health_id in (#uniqueHealthId#)
and ((imt_member.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'')) or (imt_member.state = ''com.argusoft.imtecho.member.state.temporary''))
limit #limit# offset #offSet#', 
null, 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='sickle_cell_search_by_name';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'd5065289-c1d0-4d11-b8f2-c31d25f9bd5d', 75398,  current_date , 75398,  current_date , 'sickle_cell_search_by_name', 
'firstName,lastName,offSet,locationId,limit,middleName', 
'select imt_member.unique_health_id as "uniqueHealthId",
imt_member.id as "memberId",
imt_member.family_id as "familyId",
imt_family.location_id as "locationId",
get_location_hierarchy(imt_family.location_id) as "locationHierarchy",
concat(imt_member.first_name,'' '',imt_member.middle_name,'' '',imt_member.last_name) as "name",
imt_member.gender as "gender",
rel.value as "religion",
cas.value as "caste",
imt_member.dob as "dob",
cast(age(imt_member.dob)as text) as "age"
from imt_member
inner join imt_family on imt_member.family_id = imt_family.family_id
inner join location_hierchy_closer_det on imt_family.location_id = location_hierchy_closer_det.child_id
left join listvalue_field_value_detail rel on cast(imt_family.religion as bigint) = rel.id
left join listvalue_field_value_detail cas on cast(imt_family.caste as bigint) = cas.id
where location_hierchy_closer_det.parent_id = #locationId#
and similarity(#firstName#,imt_member.first_name)>=0.50
and similarity(#lastName#,imt_member.last_name)>=0.60
and case when #middleName# != null  and  #middleName# !='''' then similarity(#middleName#,imt_member.middle_name)>=0.50 else 1=1 end
and ((imt_member.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'')) or (imt_member.state = ''com.argusoft.imtecho.member.state.temporary''))
limit #limit# offset #offSet#', 
null, 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='sickle_cell_search_by_mobile_number';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'1454599d-dd27-495f-bfa4-ea656936ba99', 75398,  current_date , 75398,  current_date , 'sickle_cell_search_by_mobile_number', 
'offSet,mobileNumber,limit', 
'select imt_member.unique_health_id as "uniqueHealthId",
imt_member.id as "memberId",
imt_member.family_id as "familyId",
imt_member.mobile_number as "mobileNumber",
concat(imt_family.address1,'', '',imt_family.address2) as "address",
imt_family.location_id as "locationId",
get_location_hierarchy(imt_family.location_id) as "locationHierarchy",
concat(imt_member.first_name,'' '',imt_member.middle_name,'' '',imt_member.last_name) as "name",
imt_member.gender as "gender",
rel.value as "religion",
cas.value as "caste",
imt_member.dob as "dob",
cast(age(imt_member.dob)as text) as "age",
extract(year from age(imt_member.dob)) as "ageInYears"
from imt_member
inner join imt_family on imt_member.family_id = imt_family.family_id
left join listvalue_field_value_detail rel on cast(imt_family.religion as bigint) = rel.id
left join listvalue_field_value_detail cas on cast(imt_family.caste as bigint) = cas.id
where imt_member.mobile_number = #mobileNumber#
and ((imt_member.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'')) or (imt_member.state = ''com.argusoft.imtecho.member.state.temporary''))
limit #limit# offset #offSet#', 
null, 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='sickle_cell_search_by_family_mobile_number';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'ca4cee88-1713-4ed2-b017-5bd12e3c7ba4', 75398,  current_date , 75398,  current_date , 'sickle_cell_search_by_family_mobile_number', 
'offSet,mobileNumber,limit', 
'select imt_member.unique_health_id as "uniqueHealthId",
imt_member.id as "memberId",
imt_member.family_id as "familyId",
imt_member.mobile_number as "mobileNumber",
concat(imt_family.address1,'', '',imt_family.address2) as "address",
imt_family.location_id as "locationId",
get_location_hierarchy(imt_family.location_id) as "locationHierarchy",
concat(imt_member.first_name,'' '',imt_member.middle_name,'' '',imt_member.last_name) as "name",
imt_member.gender as "gender",
rel.value as "religion",
cas.value as "caste",
imt_member.dob as "dob",
cast(age(imt_member.dob)as text) as "age",
extract(year from age(imt_member.dob)) as "ageInYears"
from imt_member
inner join imt_family on imt_member.family_id = imt_family.family_id
left join listvalue_field_value_detail rel on cast(imt_family.religion as bigint) = rel.id
left join listvalue_field_value_detail cas on cast(imt_family.caste as bigint) = cas.id
where imt_member.family_id in (select family_id from imt_member where mobile_number = #mobileNumber#)
and ((imt_member.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'')) or (imt_member.state = ''com.argusoft.imtecho.member.state.temporary''))
limit #limit# offset #offSet#', 
null, 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='retrieve_health_infra_by_level';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'9235fa0f-53c4-44ad-9fa6-b2868ed62a8c', 75398,  current_date , 75398,  current_date , 'retrieve_health_infra_by_level', 
'filter,infrastructureType', 
'with details as (
	select location_level from health_infrastructure_type_location where health_infra_type_id = #infrastructureType#
)select health_infra_type_id 
from health_infrastructure_type_location,details where 
case when #filter# = ''U'' then health_infrastructure_type_location.location_level <= details.location_level
	 when #filter# = ''L'' then health_infrastructure_type_location.location_level >= details.location_level
end;', 
null, 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='child_service_retrieve_child_list_by_member_id';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'947fd387-9c47-4a2b-90c4-66c334a1a379', 75398,  current_date , 75398,  current_date , 'child_service_retrieve_child_list_by_member_id', 
'offSet,limit,memberId', 
'select imt_member.id,
imt_member.unique_health_id,
imt_member.family_id,
imt_member.first_name,imt_member.middle_name,imt_member.last_name,
imt_member.dob,m2.mobile_number from imt_member
left join imt_member m2 on imt_member.mother_id = m2.id
inner join imt_family on imt_member.family_id = imt_family.family_id 
where imt_member.dob > now()-interval ''5 years''
and imt_member.unique_health_id = #memberId#
and ((imt_member.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'')) or (imt_member.state = ''com.argusoft.imtecho.member.state.temporary''))
limit #limit# offset #offSet#', 
null, 
true, 'ACTIVE');