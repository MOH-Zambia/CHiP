drop table if exists sickle_cell_screening;

create table sickle_cell_screening
(
	id serial primary key,
	member_id bigint not null,
	location_id bigint not null,
	anemia_test_done boolean not null,
	dtt_test_result character varying(10),
	hplc_test_done boolean,
	hplc_test_result character varying(100),
	created_by bigint not null,
	created_on timestamp without time zone not null,
	modified_by bigint not null,
	modified_on timestamp without time zone not null
);

delete from query_master where code = 'sickle_cell_search_by_member_id';
delete from query_master where code = 'sickle_cell_search_by_family_id';
delete from query_master where code = 'sickle_cell_search_by_mobile_number';
delete from query_master where code = 'sickle_cell_search_by_family_mobile_number';
delete from query_master where code = 'sickle_cell_search_by_location_id';
delete from query_master where code = 'sickle_cell_search_by_name';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'sickle_cell_search_by_member_id','uniqueHealthId,limit,offSet','
select imt_member.unique_health_id as "uniqueHealthId",
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
left join listvalue_field_value_detail rel on cast(imt_family.religion as bigint) = rel.id
left join listvalue_field_value_detail cas on cast(imt_family.caste as bigint) = cas.id
where unique_health_id in (''#uniqueHealthId#'')
and ((imt_member.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'')) or (imt_member.state = ''com.argusoft.imtecho.member.state.temporary''))
limit #limit# offset #offSet#
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'sickle_cell_search_by_family_id','familyId,limit,offSet','
select imt_member.unique_health_id as "uniqueHealthId",
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
left join listvalue_field_value_detail rel on cast(imt_family.religion as bigint) = rel.id
left join listvalue_field_value_detail cas on cast(imt_family.caste as bigint) = cas.id
where imt_member.family_id = ''#familyId#''
and ((imt_member.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'')) or (imt_member.state = ''com.argusoft.imtecho.member.state.temporary''))
limit #limit# offset #offSet#
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'sickle_cell_search_by_mobile_number','mobileNumber,limit,offSet','
select imt_member.unique_health_id as "uniqueHealthId",
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
left join listvalue_field_value_detail rel on cast(imt_family.religion as bigint) = rel.id
left join listvalue_field_value_detail cas on cast(imt_family.caste as bigint) = cas.id
where imt_member.mobile_number = ''#mobileNumber#''
and ((imt_member.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'')) or (imt_member.state = ''com.argusoft.imtecho.member.state.temporary''))
limit #limit# offset #offSet#
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'sickle_cell_search_by_family_mobile_number','mobileNumber,limit,offSet','
select imt_member.unique_health_id as "uniqueHealthId",
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
left join listvalue_field_value_detail rel on cast(imt_family.religion as bigint) = rel.id
left join listvalue_field_value_detail cas on cast(imt_family.caste as bigint) = cas.id
where imt_member.family_id in (select family_id from imt_member where mobile_number = ''#mobileNumber#'')
and ((imt_member.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'')) or (imt_member.state = ''com.argusoft.imtecho.member.state.temporary''))
limit #limit# offset #offSet#
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'sickle_cell_search_by_location_id','locationId,limit,offSet','
select imt_member.unique_health_id as "uniqueHealthId",
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
and ((imt_member.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'')) or (imt_member.state = ''com.argusoft.imtecho.member.state.temporary''))
limit #limit# offset #offSet#
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'sickle_cell_search_by_name','firstName,lastName,middleName,locationId,limit,offSet','
select imt_member.unique_health_id as "uniqueHealthId",
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
and similarity(''#firstName#'',imt_member.first_name)>=0.50
and similarity(''#lastName#'',imt_member.last_name)>=0.60
and case when ''#middleName#'' != ''null'' and ''#middleName#'' !='''' then similarity(''#middleName#'',imt_member.middle_name)>=0.50 else 1=1 end
and ((imt_member.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'')) or (imt_member.state = ''com.argusoft.imtecho.member.state.temporary''))
limit #limit# offset #offSet#
',true,'ACTIVE');

delete from menu_config where menu_name = 'Sickle Cell Screening';

insert into menu_config
(group_id,active,menu_name,navigation_state,menu_type)
values((select id from menu_group where group_name = 'Facility Data Entry'),true,'Sickle Cell Screening','techo.manage.sicklecellSearch','manage');