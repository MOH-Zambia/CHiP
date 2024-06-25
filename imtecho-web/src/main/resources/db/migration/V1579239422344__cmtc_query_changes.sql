drop table if exists child_cmtc_nrc_cmam_master;
drop table if exists child_nutrition_cmam_master;
drop table if exists child_nutrition_sam_screening_master;
drop table if exists child_nutrition_cmam_followup;
drop table if exists child_nutrition_cmam_followup_complication_rel;
drop table IF EXISTS child_nutrition_sam_screening_diseases_rel;

create table child_nutrition_cmam_master
(
	id serial primary key,
	child_id integer not null,
	location_id integer not null,
	state text not null,
	service_date timestamp without time zone not null,
	identified_from text not null,
	reference_id integer not null,
	cured_on timestamp without time zone,
	cured_muac numeric(6,2),
	cured_visit_id integer,
	is_case_completed boolean,
	created_on timestamp without time zone not null,
	created_by integer not null,
	modified_on timestamp without time zone not null,
	modified_by integer not null
);

create TABLE child_nutrition_sam_screening_master
(
  id serial primary key,
  member_id integer,
  family_id integer,
  location_id integer,
  notification_id integer,
  height integer,
  weight numeric(7,3),
  muac numeric(6,2),
  have_pedal_edema boolean,
  sd_score character varying(10),
  created_by integer,
  created_on timestamp without time zone,
  modified_by integer,
  modified_on timestamp without time zone,
  appetite_test boolean,
  referral_done boolean,
  role_id integer,
  service_date date,
  breast_feeding_done boolean,
  breast_sucking_problems boolean,
  reference_id integer,
  referral_place integer,
  medical_complications_present boolean,
  other_diseases text,
  done_from character varying(15),
  done_by integer
);

create table child_nutrition_cmam_followup (
    id serial primary key,
    member_id integer,
    family_id integer,
    location_id integer,
    notification_id integer,
    service_date date,
    height integer,
    weight numeric(7,3),
    muac numeric(6,2),
    given_sachets integer,
    consumed_sachets integer,
    other_medical_complication text,
    created_by integer,
    created_on timestamp without time zone,
    modified_by integer,
    modified_on timestamp without time zone,
    referral_place integer,
    cmam_master_id integer
);

create TABLE child_nutrition_cmam_followup_complication_rel
(
    cmam_id integer NOT NULL,
    medical_complications text NOT NULL,
    PRIMARY KEY (cmam_id, medical_complications),
    FOREIGN KEY (cmam_id)
        REFERENCES child_nutrition_cmam_followup (id) MATCH SIMPLE
        ON update NO ACTION ON delete NO ACTION
);

create TABLE child_nutrition_sam_screening_diseases_rel(
    sam_screening_id integer NOT NULL,
    diseases integer NOT NULL,
    PRIMARY KEY (sam_screening_id, diseases),
    FOREIGN KEY (sam_screening_id)
        REFERENCES child_nutrition_sam_screening_master (id) MATCH SIMPLE
        ON update NO ACTION ON delete NO ACTION
);

create table child_cmtc_nrc_referral_detail
(
	id serial primary key,
	child_id integer not null,
	admission_id integer not null,
	referred_from integer not null,
	referred_to integer not null,
	referred_date timestamp without time zone not null
);

alter table child_cmtc_nrc_screening_detail
drop column if exists identified_from,
drop column if exists reference_id,
add column identified_from text,
add column reference_id integer;

alter table child_cmtc_nrc_admission_detail
drop column if exists problem_in_breast_feeding,
drop column if exists problem_in_milk_injection,
drop column if exists visible_wasting,
drop column if exists kmc_provided,
drop column if exists no_of_times_kmc_done,
drop column if exists no_of_times_amoxicillin_given,
drop column if exists consecutive_3_days_weight_gain,
add column problem_in_breast_feeding boolean,
add column problem_in_milk_injection boolean,
add column visible_wasting boolean,
add column kmc_provided boolean,
add column no_of_times_kmc_done integer,
add column no_of_times_amoxicillin_given integer,
add column consecutive_3_days_weight_gain boolean;

alter table child_cmtc_nrc_weight_detail
drop column if exists kmc_provided,
drop column if exists no_of_times_kmc_done,
drop column if exists weight_gain_5_gm_1_day,
drop column if exists weight_gain_5_gm_2_day,
drop column if exists weight_gain_5_gm_3_day,
drop column if exists child_id,
add column kmc_provided boolean,
add column no_of_times_kmc_done integer,
add column weight_gain_5_gm_1_day boolean,
add column weight_gain_5_gm_2_day boolean,
add column weight_gain_5_gm_3_day boolean,
add column child_id integer;

delete from notification_type_master where code = 'ASHA_SAM_SCREENING';
insert into notification_type_master (created_by, created_on, modified_by, modified_on, code, name, type, role_id, state, notification_for)
values(-1, now(), -1, now(), 'ASHA_SAM_SCREENING', 'ASHA Sam screening', 'MO', 24, 'ACTIVE', 'MEMBER');

delete from notification_type_master where code = 'FHW_SAM_SCREENING_REF';
insert into notification_type_master (created_by, created_on, modified_by, modified_on, code, name, type, role_id, state, notification_for)
values(-1, now(), -1, now(), 'FHW_SAM_SCREENING_REF', 'FHW Sam screening Referral', 'MO', 30, 'ACTIVE', 'MEMBER');

delete from notification_type_master where code = 'CMAM_FOLLOWUP';
insert into notification_type_master (created_by, created_on, modified_by, modified_on, code, name, type, role_id, state, notification_for)
values(-1, now(), -1, now(), 'CMAM_FOLLOWUP', 'CMAM Followup', 'MO', 24, 'ACTIVE', 'MEMBER');

insert into notification_type_role_rel(role_id, notification_type_id)
select 30, id from notification_type_master where code in
('MO','MI','FHW_WPD','FHW_CS','FHW_PNC','FHW_ANC','LMPFU','DISCHARGE','APPETITE','TT2_ALERT','IRON_SUCROSE_ALERT','SAM_SCREENING','READ_ONLY',
'FHW_PREG_CONF','FHW_DEATH_CONF','FHW_DELIVERY_CONF','FHW_MEMBER_MIGRATION','FHW_FAMILY_MIGRATION','FHW_FAMILY_SPLIT','FMI','FHW_SAM_SCREENING_REF','CMAM_FOLLOWUP');

insert into notification_type_role_rel(role_id, notification_type_id)
select 24, id from notification_type_master where code in
('ASHA_ANC','ASHA_WPD','ASHA_LMPFU','ASHA_PNC','ASHA_CS','ASHA_READ_ONLY','ASHA_SAM_SCREENING','CMAM_FOLLOWUP');

update child_cmtc_nrc_screening_detail
set identified_from = 'DIRECT'
where is_direct_admission;

update child_cmtc_nrc_screening_detail
set identified_from = 'FHW'
where identified_from is null;

update child_cmtc_nrc_weight_detail
set child_id = child_cmtc_nrc_admission_detail.child_id
from child_cmtc_nrc_admission_detail
where child_cmtc_nrc_admission_detail.id = child_cmtc_nrc_weight_detail.admission_id
and child_cmtc_nrc_weight_detail.child_id is null;

begin;
insert into child_cmtc_nrc_referral_detail
(child_id,admission_id,referred_from,referred_to,referred_date)
select child_id,admission_id,referred_from,referred_to,referred_date
from child_cmtc_nrc_screening_detail
where referred_from is not null;
commit;

begin;
with grouping_details as (
	select case_id,
	screening_center,
	min(id) as admission_id
	from child_cmtc_nrc_admission_detail
	group by case_id,screening_center
	order by case_id,admission_id
),row_wise_details as (
	select row_number() over(partition by case_id) as "srno",
	grouping_details.*
	from grouping_details
),previous_admission_details as (
	select child_id,id,screening_center,case_id
	from child_cmtc_nrc_admission_detail
	where id in (select admission_id from row_wise_details where srno = 1)
),next_admission_details as (
	select child_id,id,screening_center,admission_date,case_id
	from child_cmtc_nrc_admission_detail
	where id in (select admission_id from row_wise_details where srno = 2)
)
insert into child_cmtc_nrc_referral_detail
(child_id,admission_id,referred_from,referred_to,referred_date)
select next_admission_details.child_id,
next_admission_details.id,
previous_admission_details.screening_center,
next_admission_details.screening_center,
next_admission_details.admission_date
from next_admission_details
inner join previous_admission_details on next_admission_details.case_id = previous_admission_details.case_id
where previous_admission_details.screening_center is not null
and next_admission_details.screening_center is not null;
commit;

delete from query_master where code='retrieve_screening_centers_cmtc';
delete from query_master where code='retrieve_cmtc_centers_by_user_assigned_location';
delete from query_master where code='child_cmtc_nrc_screening_details';
delete from query_master where code='child_cmtc_nrc_screening_details_for_direct_admission';
delete from query_master where code='cmtc_nrc_unique_health_id_search';
delete from query_master where code='cmtc_nrc_family_id_search';
delete from query_master where code='cmtc_nrc_mobile_number_search';
delete from query_master where code='cmtc_nrc_organization_unit_search';
delete from query_master where code='cmtc_nrc_name_search';
delete from query_master where code='child_cmtc_nrc_screened_list';
delete from query_master where code='child_cmtc_nrc_admission_list';
delete from query_master where code='child_cmtc_nrc_defaulter_list';
delete from query_master where code='child_cmtc_nrc_discharge_list';
delete from query_master where code='child_cmtc_nrc_referred_list';
delete from query_master where code='child_cmtc_nrc_treatment_completed_list';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'retrieve_screening_centers_cmtc','userId','
select * from health_infrastructure_details
where id in (select health_infrastrucutre_id from user_health_infrastructure where user_id = #userId# and state = ''ACTIVE'')
and (is_cmtc = true or is_nrc = true or is_sncu = true)
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'retrieve_cmtc_centers_by_user_assigned_location','userId','
select * from health_infrastructure_details where location_id in
(select child_id from location_hierchy_closer_det where parent_id in
(select loc_id from um_user_location where user_id = #userId# and state = ''ACTIVE'')) and (is_cmtc = true or is_nrc = true or is_sncu = true)
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'child_cmtc_nrc_screening_details','childId','
with child_detail as (
	select child_cmtc_nrc_screening_detail.id as "screeningId",
	child_cmtc_nrc_screening_detail.child_id as "childId",
	child_cmtc_nrc_screening_detail.screened_on as "screenedOn",
	child_cmtc_nrc_screening_detail.location_id as "locationId",
	child_cmtc_nrc_screening_detail.location_hierarchy_id as "locationHierarchyId",
	child_cmtc_nrc_screening_detail.state,
	child_cmtc_nrc_screening_detail.appetite_test_done as "appetiteTestDone",
	child_cmtc_nrc_screening_detail.appetite_test_reported_on as "appetiteTestReportedOn",
	child_cmtc_nrc_screening_detail.admission_id as "admissionId",
	child_cmtc_nrc_screening_detail.discharge_id as "dischargeId",
	child_cmtc_nrc_screening_detail.is_direct_admission as "isDirectAdmission",
	child_cmtc_nrc_screening_detail.screening_center as "screeningCenter",
	child_cmtc_nrc_screening_detail.is_case_completed as "isCaseCompleted",
	child_cmtc_nrc_screening_detail.referred_from as "referredFrom",
	child_cmtc_nrc_screening_detail.referred_to as "referredTo",
	child_cmtc_nrc_screening_detail.referred_date as "referredDate",
	child_cmtc_nrc_screening_detail.is_archive as "isArchive",
	child_cmtc_nrc_screening_detail.created_by as "createdBy",
	health_infrastructure_details.name as "healthInfrastructureName",
	imt_member.unique_health_id as "uniqueHealthId",
	imt_member.family_id as "familyId",
	caste.value as "caste",
	imt_family.bpl_flag as "bpl",
	imt_member.gender as "gender",
	imt_member.dob as "dob",
	imt_member.immunisation_given as "immunisationGiven",
	concat(imt_member.first_name,'' '',imt_member.middle_name,'' '',imt_member.last_name) as "childName",
	concat(mother.first_name,'' '',mother.middle_name,'' '',mother.last_name) as "motherName",
	mother.mobile_number as "mobileNumber",
	get_location_hierarchy(case when imt_family.area_id is not null then imt_family.area_id else imt_family.location_id end) as "locationHierarchy",
	concat(creator.first_name,'' '',creator.middle_name,'' '',creator.last_name) as "referredBy"
	from child_cmtc_nrc_screening_detail
	inner join imt_member on child_cmtc_nrc_screening_detail.child_id = imt_member.id
	inner join imt_member mother on imt_member.mother_id = mother.id
	inner join imt_family on imt_member.family_id = imt_family.family_id
	inner join um_user creator on child_cmtc_nrc_screening_detail.created_by = creator.id
	left join health_infrastructure_details on child_cmtc_nrc_screening_detail.screening_center = health_infrastructure_details.id
	left join listvalue_field_value_detail caste on imt_family.caste = cast(caste.id as character varying)
	where child_cmtc_nrc_screening_detail.child_id = #childId#
	and child_cmtc_nrc_screening_detail.is_case_completed is null
),asha_detail as (
	select child_detail."childId",
	concat(um_user.first_name,'' '',um_user.middle_name,'' '',um_user.last_name) as "ashaName",
	um_user.contact_number as "ashaNumber"
	from child_detail
	left join um_user_location on child_detail."locationId" = um_user_location.loc_id
	and um_user_location.state = ''ACTIVE''
	left join um_user on um_user_location.user_id = um_user.id
	and um_user.state = ''ACTIVE''
	where um_user.role_id = 24
)select child_detail.*,asha_detail."ashaName",asha_detail."ashaNumber"
from child_detail
left join asha_detail on child_detail."childId" = asha_detail."childId"
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'child_cmtc_nrc_screening_details_for_direct_admission','childId','
with member_detail as (
	select imt_member.id as "childId",
	imt_member.unique_health_id as "uniqueHealthId",
	imt_member.family_id as "familyId",
	caste.value as "caste",
	imt_family.bpl_flag as "bpl",
	imt_member.gender as "gender",
	imt_member.dob as "dob",
	concat(imt_member.first_name,'' '',imt_member.middle_name,'' '',imt_member.last_name) as "childName",
	concat(mother.first_name,'' '',mother.middle_name,'' '',mother.last_name) as "motherName",
	mother.mobile_number as "mobileNumber",
	get_location_hierarchy(case when imt_family.area_id is not null then imt_family.area_id else imt_family.location_id end) as "locationHierarchy",
	case when imt_family.area_id is not null then imt_family.area_id else imt_family.location_id end as "locationId"
	from imt_member
	inner join imt_member mother on imt_member.mother_id = mother.id
	inner join imt_family on imt_member.family_id = imt_family.family_id
	left join listvalue_field_value_detail caste on imt_family.caste = cast(caste.id as character varying)
	where imt_member.id = #childId#
),asha_detail as (
	select member_detail."childId",
	concat(um_user.first_name,'' '',um_user.middle_name,'' '',um_user.last_name) as "ashaName",
	um_user.contact_number as "ashaNumber"
	from member_detail
	left join um_user_location on member_detail."locationId" = um_user_location.loc_id
	and um_user_location.state = ''ACTIVE''
	left join um_user on um_user_location.user_id = um_user.id
	and um_user.state = ''ACTIVE''
	where um_user.role_id = 24
)select member_detail.*,asha_detail."ashaName",asha_detail."ashaNumber"
from member_detail
left join asha_detail on member_detail."childId" = asha_detail."childId"
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'cmtc_nrc_unique_health_id_search','uniqueHealthId,limit,offSet','
select
imt_member.id,
imt_member.first_name as "firstName",
imt_member.middle_name as "middleName",
imt_member.last_name as "lastName",
imt_member.dob as dob,
string_agg(location_master.name,''>'' order by location_hierchy_closer_det.depth desc) as "locationHierarchy"
from imt_member
inner join imt_family on imt_member.family_id = imt_family.family_id
inner join location_hierchy_closer_det on location_hierchy_closer_det.child_id = imt_family.location_id
inner join location_master on location_master.id = location_hierchy_closer_det.parent_id
where imt_member.unique_health_id = ''#uniqueHealthId#''
and imt_member.dob >= (current_date - interval ''60 months'') and imt_member.dob <=(current_date)
group by
imt_member.id,
imt_member.first_name,
imt_member.middle_name,
imt_member.last_name,dob
limit #limit# offset #offSet#
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'cmtc_nrc_family_id_search','familyId,limit,offSet','
select
imt_member.id,
imt_member.first_name as "firstName",
imt_member.middle_name as "middleName",
imt_member.last_name as "lastName",
imt_member.dob as dob,
string_agg(location_master.name,''>'' order by location_hierchy_closer_det.depth desc) as "locationHierarchy"
from imt_member
inner join imt_family on imt_member.family_id = imt_family.family_id
inner join location_hierchy_closer_det on location_hierchy_closer_det.child_id = imt_family.location_id
inner join location_master on location_master.id = location_hierchy_closer_det.parent_id
where imt_member.family_id = ''#familyId#''
and imt_member.dob >= (current_date - interval ''60 months'') and imt_member.dob <=(current_date)
group by
imt_member.id,
imt_member.first_name,
imt_member.middle_name,
imt_member.last_name,dob
limit #limit# offset #offSet#
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'cmtc_nrc_mobile_number_search','mobileNumber,limit,offSet','
with ids as(
	select imt_member.id,string_agg(location_master.name,''>'' order by location_hierchy_closer_det.depth desc) as "locationHierarchy"
	from imt_member
	inner join imt_family on imt_member.family_id = imt_family.family_id
	inner join location_hierchy_closer_det on location_hierchy_closer_det.child_id = imt_family.location_id
	inner join location_master on location_master.id = location_hierchy_closer_det.parent_id
	inner join imt_member m2 on imt_member.mother_id = m2.id
	where m2.mobile_number = ''#mobileNumber#''
	and imt_member.dob >= (current_date - interval ''60 months'') and imt_member.dob <=(current_date)
	group by
	imt_member.id
	limit #limit# offset #offSet#
)select imt_member.id,
imt_member.first_name as "firstName",
imt_member.middle_name as "middleName",
imt_member.last_name as "lastName",
imt_member.dob as dob,
ids."locationHierarchy"
from ids inner join imt_member on imt_member.id = ids.id
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'cmtc_nrc_organization_unit_search','locationId,limit,offSet','
with members as (
	select
	imt_member.id,
	imt_member.first_name,
	imt_member.middle_name,
	imt_member.last_name,
	imt_member.dob as dob,
	imt_family.location_id
	from imt_member
	inner join imt_family on imt_member.family_id = imt_family.family_id
	inner join location_hierchy_closer_det on location_hierchy_closer_det.child_id = imt_family.location_id
	and location_hierchy_closer_det.parent_id = #locationId#
	where imt_member.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'')
	and imt_member.dob between (current_date - interval ''60 months'') and (current_date)
	limit #limit# offset #offSet#
)
select members.id,members.first_name as "firstName",members.middle_name as "middleName",members.last_name as "lastName",
string_agg(l.name,''>'' order by lhcd.depth desc) as "locationHierarchy"
from members inner join location_master dl on  members.location_id = dl.id
inner join location_hierchy_closer_det lhcd on lhcd.child_id = dl.id
inner join location_master l on l.id = lhcd.parent_id
group by dl.id, members.id, members.first_name,members.middle_name,members.last_name,members.dob,members.location_id
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'cmtc_nrc_name_search','locationId,firstName,lastName,limit,offSet','
with members as (
	select
	imt_member.id,
	imt_member.first_name,
	imt_member.middle_name,
	imt_member.last_name,
	imt_member.dob as dob,
	imt_family.location_id
	from imt_member
	inner join imt_family on imt_member.family_id = imt_family.family_id
	inner join location_hierchy_closer_det on location_hierchy_closer_det.child_id = imt_family.location_id
	and location_hierchy_closer_det.parent_id = #locationId#
	where imt_member.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'')
	and imt_member.dob between (current_date - interval ''60 months'') and (current_date)
	and imt_member.first_name ilike ''%#firstName#%'' and imt_member.last_name ilike ''%#lastName#%''
	limit #limit# offset #offSet#
)
select members.id,members.first_name as "firstName",members.middle_name as "middleName",members.last_name as "lastName",
string_agg(l.name,''>'' order by lhcd.depth desc) as "locationHierarchy"
from members inner join location_master dl on  members.location_id = dl.id
inner join location_hierchy_closer_det lhcd on lhcd.child_id = dl.id
inner join location_master l on l.id = lhcd.parent_id
group by dl.id, members.id, members.first_name,members.middle_name,members.last_name,members.dob,members.location_id
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'child_cmtc_nrc_screened_list','userId,limit,offset','
with child_ids as (
	select child_cmtc_nrc_screening_detail.id,child_cmtc_nrc_screening_detail.child_id
	from child_cmtc_nrc_screening_detail
	inner join user_health_infrastructure on child_cmtc_nrc_screening_detail.screening_center = user_health_infrastructure.health_infrastrucutre_id
	and user_health_infrastructure.state = ''ACTIVE''
	inner join health_infrastructure_details on user_health_infrastructure.health_infrastrucutre_id = health_infrastructure_details.id
	and (health_infrastructure_details.is_cmtc or health_infrastructure_details.is_nrc or health_infrastructure_details.is_sncu)
	where user_health_infrastructure.user_id = #userId#
	and child_cmtc_nrc_screening_detail.state = ''ACTIVE''
	and child_cmtc_nrc_screening_detail.is_case_completed is null
	and child_cmtc_nrc_screening_detail.admission_id is null
	limit #limit# offset #offset#
),asha_detail as (
	select child_ids.id,
	concat(asha.first_name,'' '',asha.middle_name,'' '',asha.last_name) as asha_name,
	asha.contact_number as asha_contact_number
	from child_ids
	inner join imt_member on child_ids.child_id = imt_member.id
	inner join imt_family on imt_member.family_id = imt_family.family_id
	inner join um_user_location asha_location on imt_family.area_id = asha_location.loc_id and asha_location.state = ''ACTIVE''
	inner join um_user asha on asha_location.user_id = asha.id and asha.state = ''ACTIVE'' and asha.role_id = 24
)
select child_cmtc_nrc_screening_detail.id,
child_cmtc_nrc_screening_detail.screening_center as "screeningCenter",
child_cmtc_nrc_screening_detail.child_id as "memberId",
child_cmtc_nrc_screening_detail.screened_on as "screenedOn",
child_cmtc_nrc_screening_detail.state as "state",
child_cmtc_nrc_screening_detail.admission_id as "admissionId",
child_cmtc_nrc_screening_detail.discharge_id as "dischargeId",
child_cmtc_nrc_screening_detail.created_by as "createdBy",
child_cmtc_nrc_screening_detail.identified_from as "identifiedFrom",
health_infrastructure_details.name as "healthInfrastructureName",
concat(imt_member.first_name,'' '',imt_member.middle_name,'' '',imt_member.last_name) as "memberName",
imt_member.unique_health_id as "uniqueHealthId",
imt_member.family_id as "familyId",
imt_member.dob as "dob",
imt_member.gender as "gender",
imt_family.bpl_flag as "bplFlag",
listvalue_field_value_detail.value as "caste",
concat(mother.first_name,'' '',mother.middle_name,'' '',mother.last_name) as "motherName",
mother.mobile_number as "motherContactNumber",
concat(um_user.first_name,'' '',um_user.middle_name,'' '',um_user.last_name) as "referredByName",
um_user.contact_number as "referredByContactNumber",
asha_detail.asha_name as "ashaName",
asha_detail.asha_contact_number as "ashaContactNumber",
location.name as "villageName",
area.name as "areaName",
case when child_cmtc_nrc_screening_detail.identified_from = ''FHW'' then child_nutrition_sam_screening_master.muac else null end as "muac",
case when child_cmtc_nrc_screening_detail.identified_from = ''FHW'' then child_nutrition_sam_screening_master.sd_score else null end as "sdScore",
case when child_cmtc_nrc_screening_detail.identified_from = ''FHW'' then child_nutrition_sam_screening_master.have_pedal_edema else null end as "pedalEdema"
from child_ids
inner join child_cmtc_nrc_screening_detail on child_ids.id = child_cmtc_nrc_screening_detail.id
left join child_nutrition_sam_screening_master on child_cmtc_nrc_screening_detail.reference_id = child_nutrition_sam_screening_master.id
and child_cmtc_nrc_screening_detail.identified_from = ''FHW''
left join health_infrastructure_details on child_cmtc_nrc_screening_detail.screening_center = health_infrastructure_details.id
inner join imt_member on child_cmtc_nrc_screening_detail.child_id = imt_member.id
inner join imt_member mother on imt_member.mother_id = mother.id
inner join imt_family on imt_member.family_id = imt_family.family_id
left join location_master location on imt_family.location_id = location.id
left join location_master area on imt_family.area_id = area.id
left join listvalue_field_value_detail on imt_family.caste = cast(listvalue_field_value_detail.id as character varying)
left join um_user on child_cmtc_nrc_screening_detail.created_by = um_user.id
left join asha_detail on child_cmtc_nrc_screening_detail.id = asha_detail.id
order by child_cmtc_nrc_screening_detail.id desc
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'child_cmtc_nrc_admission_list','userId,limit,offset','
with child_ids as (
	select child_cmtc_nrc_screening_detail.id,child_cmtc_nrc_screening_detail.child_id
	from child_cmtc_nrc_screening_detail
	inner join user_health_infrastructure on child_cmtc_nrc_screening_detail.screening_center = user_health_infrastructure.health_infrastrucutre_id
	and user_health_infrastructure.state = ''ACTIVE''
	inner join health_infrastructure_details on user_health_infrastructure.health_infrastrucutre_id = health_infrastructure_details.id
	and (health_infrastructure_details.is_cmtc or health_infrastructure_details.is_nrc or health_infrastructure_details.is_sncu)
	where user_health_infrastructure.user_id = #userId#
	and child_cmtc_nrc_screening_detail.state = ''ACTIVE''
	and child_cmtc_nrc_screening_detail.is_case_completed is null
	and child_cmtc_nrc_screening_detail.admission_id is not null
	limit #limit# offset #offset#
),asha_detail as (
	select child_ids.id,
	concat(asha.first_name,'' '',asha.middle_name,'' '',asha.last_name) as asha_name,
	asha.contact_number as asha_contact_number
	from child_ids
	inner join imt_member on child_ids.child_id = imt_member.id
	inner join imt_family on imt_member.family_id = imt_family.family_id
	inner join um_user_location asha_location on imt_family.area_id = asha_location.loc_id and asha_location.state = ''ACTIVE''
	inner join um_user asha on asha_location.user_id = asha.id and asha.state = ''ACTIVE'' and asha.role_id = 24
)
select imt_family.area_id,child_cmtc_nrc_screening_detail.id,
child_cmtc_nrc_screening_detail.screening_center as "screeningCenter",
child_cmtc_nrc_screening_detail.child_id as "memberId",
child_cmtc_nrc_screening_detail.screened_on as "screenedOn",
child_cmtc_nrc_screening_detail.state as "state",
child_cmtc_nrc_screening_detail.admission_id as "admissionId",
child_cmtc_nrc_screening_detail.discharge_id as "dischargeId",
child_cmtc_nrc_screening_detail.created_by as "createdBy",
child_cmtc_nrc_screening_detail.identified_from as "identifiedFrom",
health_infrastructure_details.name as "healthInfrastructureName",
concat(imt_member.first_name,'' '',imt_member.middle_name,'' '',imt_member.last_name) as "memberName",
imt_member.unique_health_id as "uniqueHealthId",
imt_member.family_id as "familyId",
imt_member.dob as "dob",
imt_member.gender as "gender",
imt_family.bpl_flag as "bplFlag",
listvalue_field_value_detail.value as "caste",
concat(mother.first_name,'' '',mother.middle_name,'' '',mother.last_name) as "motherName",
mother.mobile_number as "motherContactNumber",
concat(um_user.first_name,'' '',um_user.middle_name,'' '',um_user.last_name) as "referredByName",
um_user.contact_number as "referredByContactNumber",
asha_detail.asha_name as "ashaName",
asha_detail.asha_contact_number as "ashaContactNumber",
location.name as "villageName",
area.name as "areaName",
child_cmtc_nrc_admission_detail.admission_date as "admissionDate",
child_cmtc_nrc_admission_detail.no_of_times_amoxicillin_given as "noOfTimesAmoxicillinGiven",
child_cmtc_nrc_admission_detail.consecutive_3_days_weight_gain as "consecutive3DaysWeightGain"
from child_ids
inner join child_cmtc_nrc_screening_detail on child_ids.id = child_cmtc_nrc_screening_detail.id
inner join child_cmtc_nrc_admission_detail on child_cmtc_nrc_screening_detail.admission_id = child_cmtc_nrc_admission_detail.id
inner join health_infrastructure_details on child_cmtc_nrc_screening_detail.screening_center = health_infrastructure_details.id
inner join imt_member on child_cmtc_nrc_screening_detail.child_id = imt_member.id
left join imt_member mother on imt_member.mother_id = mother.id
inner join imt_family on imt_member.family_id = imt_family.family_id
left join location_master location on imt_family.location_id = location.id
left join location_master area on imt_family.area_id = area.id
left join listvalue_field_value_detail on imt_family.caste = cast(listvalue_field_value_detail.id as character varying)
left join um_user on child_cmtc_nrc_screening_detail.created_by = um_user.id
left join asha_detail on child_cmtc_nrc_screening_detail.id = asha_detail.id
order by child_cmtc_nrc_screening_detail.id desc
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'child_cmtc_nrc_defaulter_list','userId,limit,offset','
with child_ids as (
	select child_cmtc_nrc_screening_detail.id,child_cmtc_nrc_screening_detail.child_id
	from child_cmtc_nrc_screening_detail
	inner join user_health_infrastructure on child_cmtc_nrc_screening_detail.screening_center = user_health_infrastructure.health_infrastrucutre_id
	and user_health_infrastructure.state = ''ACTIVE''
	inner join health_infrastructure_details on user_health_infrastructure.health_infrastrucutre_id = health_infrastructure_details.id
	and (health_infrastructure_details.is_cmtc or health_infrastructure_details.is_nrc or health_infrastructure_details.is_sncu)
	where user_health_infrastructure.user_id = #userId#
	and child_cmtc_nrc_screening_detail.state = ''DEFAULTER''
	and child_cmtc_nrc_screening_detail.is_case_completed is null
	limit #limit# offset #offset#
)
,asha_detail as (
	select child_ids.id,
	concat(asha.first_name,'' '',asha.middle_name,'' '',asha.last_name) as asha_name,
	asha.contact_number as asha_contact_number
	from child_ids
	inner join imt_member on child_ids.child_id = imt_member.id
	inner join imt_family on imt_member.family_id = imt_family.family_id
	inner join um_user_location asha_location on imt_family.area_id = asha_location.loc_id and asha_location.state = ''ACTIVE''
	inner join um_user asha on asha_location.user_id = asha.id and asha.state = ''ACTIVE'' and asha.role_id = 24
)
select child_cmtc_nrc_screening_detail.id,
child_cmtc_nrc_screening_detail.screening_center as "screeningCenter",
child_cmtc_nrc_screening_detail.child_id as "memberId",
child_cmtc_nrc_screening_detail.screened_on as "screenedOn",
child_cmtc_nrc_screening_detail.state as "state",
child_cmtc_nrc_screening_detail.admission_id as "admissionId",
child_cmtc_nrc_screening_detail.discharge_id as "dischargeId",
child_cmtc_nrc_screening_detail.created_by as "createdBy",
child_cmtc_nrc_screening_detail.identified_from as "identifiedFrom",
health_infrastructure_details.name as "healthInfrastructureName",
concat(imt_member.first_name,'' '',imt_member.middle_name,'' '',imt_member.last_name) as "memberName",
imt_member.unique_health_id as "uniqueHealthId",
imt_member.family_id as "familyId",
imt_member.dob as "dob",
imt_member.gender as "gender",
imt_family.bpl_flag as "bplFlag",
listvalue_field_value_detail.value as "caste",
concat(mother.first_name,'' '',mother.middle_name,'' '',mother.last_name) as "motherName",
mother.mobile_number as "motherContactNumber",
concat(um_user.first_name,'' '',um_user.middle_name,'' '',um_user.last_name) as "referredByName",
um_user.contact_number as "referredByContactNumber",
asha_detail.asha_name as "ashaName",
asha_detail.asha_contact_number as "ashaContactNumber",
location.name as "villageName",
area.name as "areaName"
from child_ids
inner join child_cmtc_nrc_screening_detail on child_ids.id = child_cmtc_nrc_screening_detail.id
inner join health_infrastructure_details on child_cmtc_nrc_screening_detail.screening_center = health_infrastructure_details.id
inner join imt_member on child_cmtc_nrc_screening_detail.child_id = imt_member.id
left join imt_member mother on imt_member.mother_id = mother.id
inner join imt_family on imt_member.family_id = imt_family.family_id
left join location_master location on imt_family.location_id = location.id
left join location_master area on imt_family.area_id = area.id
left join listvalue_field_value_detail on imt_family.caste = cast(listvalue_field_value_detail.id as character varying)
left join um_user on child_cmtc_nrc_screening_detail.created_by = um_user.id
left join asha_detail on child_cmtc_nrc_screening_detail.id = asha_detail.id
order by child_cmtc_nrc_screening_detail.id desc
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'child_cmtc_nrc_discharge_list','userId,limit,offset','
with child_ids as (
	select child_cmtc_nrc_screening_detail.id,
	child_cmtc_nrc_screening_detail.child_id,
	child_cmtc_nrc_screening_detail.admission_id
	from child_cmtc_nrc_screening_detail
	inner join user_health_infrastructure on child_cmtc_nrc_screening_detail.screening_center = user_health_infrastructure.health_infrastrucutre_id
	and user_health_infrastructure.state = ''ACTIVE''
	inner join health_infrastructure_details on user_health_infrastructure.health_infrastrucutre_id = health_infrastructure_details.id
	and (health_infrastructure_details.is_cmtc or health_infrastructure_details.is_nrc or health_infrastructure_details.is_sncu)
	where user_health_infrastructure.user_id = #userId#
	and child_cmtc_nrc_screening_detail.state = ''DISCHARGE''
	and child_cmtc_nrc_screening_detail.is_case_completed is null
	and child_cmtc_nrc_screening_detail.discharge_id is not null
	limit #limit# offset #offset#
),asha_detail as (
	select child_ids.id,
	concat(asha.first_name,'' '',asha.middle_name,'' '',asha.last_name) as asha_name,
	asha.contact_number as asha_contact_number
	from child_ids
	inner join imt_member on child_ids.child_id = imt_member.id
	inner join imt_family on imt_member.family_id = imt_family.family_id
	inner join um_user_location asha_location on imt_family.area_id = asha_location.loc_id and asha_location.state = ''ACTIVE''
	inner join um_user asha on asha_location.user_id = asha.id and asha.state = ''ACTIVE'' and asha.role_id = 24
),follow_up_detail as (
	select child_cmtc_nrc_follow_up.admission_id,max(child_cmtc_nrc_follow_up.id) as follow_up_id
	from child_ids
	inner join child_cmtc_nrc_follow_up on child_ids.admission_id = child_cmtc_nrc_follow_up.admission_id
	group by child_cmtc_nrc_follow_up.admission_id
)
select child_cmtc_nrc_screening_detail.id,
child_cmtc_nrc_screening_detail.screening_center as "screeningCenter",
child_cmtc_nrc_screening_detail.child_id as "memberId",
child_cmtc_nrc_screening_detail.screened_on as "screenedOn",
child_cmtc_nrc_screening_detail.state as "state",
child_cmtc_nrc_screening_detail.admission_id as "admissionId",
child_cmtc_nrc_screening_detail.discharge_id as "dischargeId",
child_cmtc_nrc_screening_detail.created_by as "createdBy",
child_cmtc_nrc_screening_detail.identified_from as "identifiedFrom",
health_infrastructure_details.name as "healthInfrastructureName",
concat(imt_member.first_name,'' '',imt_member.middle_name,'' '',imt_member.last_name) as "memberName",
imt_member.unique_health_id as "uniqueHealthId",
imt_member.family_id as "familyId",
imt_member.dob as "dob",
imt_member.gender as "gender",
imt_family.bpl_flag as "bplFlag",
listvalue_field_value_detail.value as "caste",
concat(mother.first_name,'' '',mother.middle_name,'' '',mother.last_name) as "motherName",
mother.mobile_number as "motherContactNumber",
concat(um_user.first_name,'' '',um_user.middle_name,'' '',um_user.last_name) as "referredByName",
um_user.contact_number as "referredByContactNumber",
asha_detail.asha_name as "ashaName",
asha_detail.asha_contact_number as "ashaContactNumber",
location.name as "villageName",
area.name as "areaName",
child_cmtc_nrc_discharge_detail.discharge_date as "dischargeDate",
child_cmtc_nrc_follow_up.follow_up_visit as "lastFollowUpVisitNo"
from child_ids
inner join child_cmtc_nrc_screening_detail on child_ids.id = child_cmtc_nrc_screening_detail.id
inner join child_cmtc_nrc_discharge_detail on child_cmtc_nrc_screening_detail.discharge_id = child_cmtc_nrc_discharge_detail.id
left join follow_up_detail on child_cmtc_nrc_screening_detail.admission_id = follow_up_detail.admission_id
left join child_cmtc_nrc_follow_up on follow_up_detail.follow_up_id = child_cmtc_nrc_follow_up.id
inner join health_infrastructure_details on child_cmtc_nrc_screening_detail.screening_center = health_infrastructure_details.id
inner join imt_member on child_cmtc_nrc_screening_detail.child_id = imt_member.id
left join imt_member mother on imt_member.mother_id = mother.id
inner join imt_family on imt_member.family_id = imt_family.family_id
left join location_master location on imt_family.location_id = location.id
left join location_master area on imt_family.area_id = area.id
left join listvalue_field_value_detail on imt_family.caste = cast(listvalue_field_value_detail.id as character varying)
left join um_user on child_cmtc_nrc_screening_detail.created_by = um_user.id
left join asha_detail on child_cmtc_nrc_screening_detail.id = asha_detail.id
order by child_cmtc_nrc_screening_detail.id desc
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'child_cmtc_nrc_referred_list','userId,limit,offset','
with assigned_health_infrastructures as (
	select id from health_infrastructure_details where id in
	(select health_infrastrucutre_id from user_health_infrastructure where user_id = #userId# and state = ''ACTIVE'')
	and (is_cmtc or is_nrc or is_sncu)
),child_ids as (
	select child_cmtc_nrc_screening_detail.id,
	child_cmtc_nrc_screening_detail.child_id
	from child_cmtc_nrc_screening_detail
	where child_cmtc_nrc_screening_detail.referred_from is not null
	and child_cmtc_nrc_screening_detail.referred_to is not null
	and child_cmtc_nrc_screening_detail.is_case_completed is null
	and (
			(
				child_cmtc_nrc_screening_detail.referred_from in (select id from assigned_health_infrastructures)
				and child_cmtc_nrc_screening_detail.is_archive is null
			)
		or
                (
                    child_cmtc_nrc_screening_detail.referred_to in (select id from assigned_health_infrastructures)
                    and child_cmtc_nrc_screening_detail.state=''REFERRED''
                )
	)
	limit #limit# offset #offset#
)
,asha_detail as (
	select child_ids.id,
	concat(asha.first_name,'' '',asha.middle_name,'' '',asha.last_name) as asha_name,
	asha.contact_number as asha_contact_number
	from child_ids
	inner join imt_member on child_ids.child_id = imt_member.id
	inner join imt_family on imt_member.family_id = imt_family.family_id
	inner join um_user_location asha_location on imt_family.area_id = asha_location.loc_id and asha_location.state = ''ACTIVE''
	inner join um_user asha on asha_location.user_id = asha.id and asha.state = ''ACTIVE'' and asha.role_id = 24
)
select child_cmtc_nrc_screening_detail.id,
child_cmtc_nrc_screening_detail.screening_center as "screeningCenter",
child_cmtc_nrc_screening_detail.child_id as "memberId",
child_cmtc_nrc_screening_detail.screened_on as "screenedOn",
child_cmtc_nrc_screening_detail.state as "state",
child_cmtc_nrc_screening_detail.admission_id as "admissionId",
child_cmtc_nrc_screening_detail.discharge_id as "dischargeId",
child_cmtc_nrc_screening_detail.created_by as "createdBy",
child_cmtc_nrc_screening_detail.identified_from as "identifiedFrom",
case when to_hid.id in (select id from assigned_health_infrastructures) and child_cmtc_nrc_screening_detail.state=''REFERRED'' then ''referredToPending''
	when to_hid.id in (select id from assigned_health_infrastructures) and child_cmtc_nrc_screening_detail.state!=''REFERRED'' then ''referredToComplete''
	when from_hid.id in (select id from assigned_health_infrastructures) then ''referredFrom'' end as "referredType",
from_hid.name as "referredFromScreeningCenter",
to_hid.name as "referredToScreeningCenter",
child_cmtc_nrc_screening_detail.referred_date as "referredDate",
concat(imt_member.first_name,'' '',imt_member.middle_name,'' '',imt_member.last_name) as "memberName",
imt_member.unique_health_id as "uniqueHealthId",
imt_member.family_id as "familyId",
imt_member.dob as "dob",
imt_member.gender as "gender",
imt_family.bpl_flag as "bplFlag",
listvalue_field_value_detail.value as "caste",
concat(mother.first_name,'' '',mother.middle_name,'' '',mother.last_name) as "motherName",
mother.mobile_number as "motherContactNumber",
concat(um_user.first_name,'' '',um_user.middle_name,'' '',um_user.last_name) as "referredByName",
um_user.contact_number as "referredByContactNumber",
asha_detail.asha_name as "ashaName",
asha_detail.asha_contact_number as "ashaContactNumber",
location.name as "villageName",
area.name as "areaName"
from child_ids
inner join child_cmtc_nrc_screening_detail on child_ids.id = child_cmtc_nrc_screening_detail.id
inner join health_infrastructure_details from_hid on child_cmtc_nrc_screening_detail.referred_from = from_hid.id
inner join health_infrastructure_details to_hid on child_cmtc_nrc_screening_detail.referred_to = to_hid.id
inner join imt_member on child_cmtc_nrc_screening_detail.child_id = imt_member.id
left join imt_member mother on imt_member.mother_id = mother.id
inner join imt_family on imt_member.family_id = imt_family.family_id
left join location_master location on imt_family.location_id = location.id
left join location_master area on imt_family.area_id = area.id
left join listvalue_field_value_detail on imt_family.caste = cast(listvalue_field_value_detail.id as character varying)
left join um_user on child_cmtc_nrc_screening_detail.created_by = um_user.id
left join asha_detail on child_cmtc_nrc_screening_detail.id = asha_detail.id
order by child_cmtc_nrc_screening_detail.id desc
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'child_cmtc_nrc_treatment_completed_list','userId,limit,offset','
with child_ids as (
	select child_cmtc_nrc_screening_detail.id,
	child_cmtc_nrc_screening_detail.child_id
	from child_cmtc_nrc_screening_detail
	inner join user_health_infrastructure on child_cmtc_nrc_screening_detail.screening_center = user_health_infrastructure.health_infrastrucutre_id
	and user_health_infrastructure.state = ''ACTIVE''
	inner join health_infrastructure_details on user_health_infrastructure.health_infrastrucutre_id = health_infrastructure_details.id
	and (health_infrastructure_details.is_cmtc or health_infrastructure_details.is_nrc or health_infrastructure_details.is_sncu)
	where user_health_infrastructure.user_id = #userId#
	and child_cmtc_nrc_screening_detail.state = ''DISCHARGE''
	and child_cmtc_nrc_screening_detail.is_case_completed
	limit #limit# offset #offset#
),asha_detail as (
	select child_ids.id,
	concat(asha.first_name,'' '',asha.middle_name,'' '',asha.last_name) as asha_name,
	asha.contact_number as asha_contact_number
	from child_ids
	inner join imt_member on child_ids.child_id = imt_member.id
	inner join imt_family on imt_member.family_id = imt_family.family_id
	inner join um_user_location asha_location on imt_family.area_id = asha_location.loc_id and asha_location.state = ''ACTIVE''
	inner join um_user asha on asha_location.user_id = asha.id and asha.state = ''ACTIVE'' and asha.role_id = 24
)
select child_cmtc_nrc_screening_detail.id,
child_cmtc_nrc_screening_detail.screening_center as "screeningCenter",
child_cmtc_nrc_screening_detail.child_id as "memberId",
child_cmtc_nrc_screening_detail.screened_on as "screenedOn",
child_cmtc_nrc_screening_detail.state as "state",
child_cmtc_nrc_screening_detail.admission_id as "admissionId",
child_cmtc_nrc_screening_detail.discharge_id as "dischargeId",
child_cmtc_nrc_screening_detail.created_by as "createdBy",
child_cmtc_nrc_screening_detail.identified_from as "identifiedFrom",
health_infrastructure_details.name as "healthInfrastructureName",
concat(imt_member.first_name,'' '',imt_member.middle_name,'' '',imt_member.last_name) as "memberName",
imt_member.unique_health_id as "uniqueHealthId",
imt_member.family_id as "familyId",
imt_member.dob as "dob",
imt_member.gender as "gender",
imt_family.bpl_flag as "bplFlag",
listvalue_field_value_detail.value as "caste",
concat(mother.first_name,'' '',mother.middle_name,'' '',mother.last_name) as "motherName",
mother.mobile_number as "motherContactNumber",
concat(um_user.first_name,'' '',um_user.middle_name,'' '',um_user.last_name) as "referredByName",
um_user.contact_number as "referredByContactNumber",
asha_detail.asha_name as "ashaName",
asha_detail.asha_contact_number as "ashaContactNumber",
location.name as "villageName",
area.name as "areaName"
from child_ids
inner join child_cmtc_nrc_screening_detail on child_ids.id = child_cmtc_nrc_screening_detail.id
inner join health_infrastructure_details on child_cmtc_nrc_screening_detail.screening_center = health_infrastructure_details.id
inner join imt_member on child_cmtc_nrc_screening_detail.child_id = imt_member.id
left join imt_member mother on imt_member.mother_id = mother.id
inner join imt_family on imt_member.family_id = imt_family.family_id
left join location_master location on imt_family.location_id = location.id
left join location_master area on imt_family.area_id = area.id
left join listvalue_field_value_detail on imt_family.caste = cast(listvalue_field_value_detail.id as character varying)
left join um_user on child_cmtc_nrc_screening_detail.created_by = um_user.id
left join asha_detail on child_cmtc_nrc_screening_detail.id = asha_detail.id
order by child_cmtc_nrc_screening_detail.id desc
',true,'ACTIVE');

delete from form_master where code = 'FSAM_TO_CMAM';

insert into form_master (created_by,created_on,modified_by,modified_on,code,name) values (60512,now(),60512,now(),'FSAM_TO_CMAM','FSAM to CMAM Transfer');
