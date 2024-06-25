delete from listvalue_field_value_detail where field_key = 'vision_values';
delete from listvalue_field_value_detail where field_key = 'minor_elements';
delete from listvalue_field_value_detail where field_key = 'eye_diseases';
delete from listvalue_field_master where field_key = 'vision_values';
delete from listvalue_field_master where field_key = 'minor_elements';
delete from listvalue_field_master where field_key = 'eye_diseases';
delete from listvalue_form_master where form_key = 'WEB_NPCB';

insert into listvalue_form_master(form_key,form,is_active) values ('WEB_NPCB','WEB NPCB',true);

insert into listvalue_field_master(field_key,field,is_active,field_type,form) values ('eye_diseases','eyeDiseases',true,'T','WEB_NPCB');

insert into listvalue_field_value_detail(is_active,is_archive,last_modified_by,last_modified_on,value,field_key,file_size) values (true,false,'spanchal',now(),'Retinopathy (E11.319)','eye_diseases',0);
insert into listvalue_field_value_detail(is_active,is_archive,last_modified_by,last_modified_on,value,field_key,file_size) values (true,false,'spanchal',now(),'Glaucoma (H40.9)','eye_diseases',0);
insert into listvalue_field_value_detail(is_active,is_archive,last_modified_by,last_modified_on,value,field_key,file_size) values (true,false,'spanchal',now(),'Cornea (H18.829)','eye_diseases',0);
insert into listvalue_field_value_detail(is_active,is_archive,last_modified_by,last_modified_on,value,field_key,file_size) values (true,false,'spanchal',now(),'Squint (H50.9)','eye_diseases',0);
insert into listvalue_field_value_detail(is_active,is_archive,last_modified_by,last_modified_on,value,field_key,file_size) values (true,false,'spanchal',now(),'Congenital (Q15.9)','eye_diseases',0);
insert into listvalue_field_value_detail(is_active,is_archive,last_modified_by,last_modified_on,value,field_key,file_size) values (true,false,'spanchal',now(),'ROP (H35.109)','eye_diseases',0);

insert into listvalue_field_master(field_key,field,is_active,field_type,form) values ('minor_elements','minorElements',true,'T','WEB_NPCB');

insert into listvalue_field_value_detail(is_active,is_archive,last_modified_by,last_modified_on,value,field_key,file_size) values (true,false,'spanchal',now(),'Conjunctivitis','minor_elements',0);
insert into listvalue_field_value_detail(is_active,is_archive,last_modified_by,last_modified_on,value,field_key,file_size) values (true,false,'spanchal',now(),'F.B.','minor_elements',0);
insert into listvalue_field_value_detail(is_active,is_archive,last_modified_by,last_modified_on,value,field_key,file_size) values (true,false,'spanchal',now(),'Epilation','minor_elements',0);
insert into listvalue_field_value_detail(is_active,is_archive,last_modified_by,last_modified_on,value,field_key,file_size) values (true,false,'spanchal',now(),'Follow Up','minor_elements',0);

insert into listvalue_field_master(field_key,field,is_active,field_type,form) values ('vision_values','visionValues',true,'T','WEB_NPCB');

insert into listvalue_field_value_detail(is_active,is_archive,last_modified_by,last_modified_on,value,field_key,file_size) values (true,false,'spanchal',now(),'6/6','vision_values',0);
insert into listvalue_field_value_detail(is_active,is_archive,last_modified_by,last_modified_on,value,field_key,file_size) values (true,false,'spanchal',now(),'6/9','vision_values',0);
insert into listvalue_field_value_detail(is_active,is_archive,last_modified_by,last_modified_on,value,field_key,file_size) values (true,false,'spanchal',now(),'6/12','vision_values',0);
insert into listvalue_field_value_detail(is_active,is_archive,last_modified_by,last_modified_on,value,field_key,file_size) values (true,false,'spanchal',now(),'6/18','vision_values',0);
insert into listvalue_field_value_detail(is_active,is_archive,last_modified_by,last_modified_on,value,field_key,file_size) values (true,false,'spanchal',now(),'6/24','vision_values',0);
insert into listvalue_field_value_detail(is_active,is_archive,last_modified_by,last_modified_on,value,field_key,file_size) values (true,false,'spanchal',now(),'6/36','vision_values',0);
insert into listvalue_field_value_detail(is_active,is_archive,last_modified_by,last_modified_on,value,field_key,file_size) values (true,false,'spanchal',now(),'6/60','vision_values',0);

alter table npcb_member_examination_detail
drop column if exists disability,
drop column if exists re_dist_va,
drop column if exists le_dist_va,
drop column if exists re_near_va,
drop column if exists le_near_va,
drop column if exists re_dist_sph,
drop column if exists le_dist_sph,
drop column if exists re_near_sph,
drop column if exists le_near_sph,
drop column if exists cataract_health_infrastructure_id,
drop column if exists other_issues_health_infrastructure_id,
drop column if exists other_issues_referral,
drop column if exists other_diseases_details,
drop column if exists images_taken,
drop column if exists on_the_spot_treatment,
drop column if exists on_the_spot_treatment_comment,
drop column if exists service_date,
drop column if exists spectacles_given_date,
drop column if exists referral_health_infrastructure,
drop column if exists other_eye_disease,
drop column if exists eye_disease,
drop column if exists other_disease_detail,
drop column if exists minor_elements_treatment,
drop column if exists minor_elements,
drop column if exists minor_elements_comment,
add column disability boolean,
add column re_dist_va bigint,
add column le_dist_va bigint,
add column re_near_va bigint,
add column le_near_va bigint,
add column re_dist_sph text,
add column le_dist_sph text,
add column re_near_sph text,
add column le_near_sph text,
add column referral_health_infrastructure bigint,
add column other_eye_disease boolean,
add column eye_disease bigint,
add column other_disease_detail text,
add column images_taken boolean,
add column minor_elements_treatment boolean,
add column minor_elements bigint,
add column minor_elements_comment text,
add column service_date timestamp without time zone,
add column spectacles_given_date timestamp without time zone;

delete from query_master where code='npcb_examined_list_retrieve';
delete from query_master where code='npcb_screened_details_retrieve';
delete from query_master where code='npcb_examined_details_retrieve';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'npcb_examined_list_retrieve','healthInfrastructureId,limit,offSet','
with member_ids as (
	select id,member_id,screening_id from npcb_member_examination_detail
	where referral_health_infrastructure = #healthInfrastructureId#
	and examine_id is null
	limit #limit# offset #offSet#
)
select
member_ids.id as "id",
member_ids.screening_id as "screeningId",
imt_member.id as "memberId",
imt_member.unique_health_id as "uniqueHealthId",
concat(imt_member.first_name,'' '',imt_member.middle_name,'' '',imt_member.last_name) as "memberName",
imt_member.family_id as "familyId",
get_location_hierarchy(imt_family.area_id) as "locationHierarchy",
concat(um_user.first_name,'' '',um_user.last_name) as "ashaName",
um_user.contact_number as "ashaContactNumber"
from member_ids
inner join imt_member on imt_member.id = member_ids.member_id
inner join imt_family on imt_member.family_id = imt_family.family_id
inner join um_user_location on imt_family.area_id = um_user_location.loc_id and um_user_location.state = ''ACTIVE''
inner join um_user on um_user_location.user_id = um_user.id and role_id = 24 and um_user.state = ''ACTIVE''
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'npcb_screened_details_retrieve','id','
select
imt_member.id as "memberId",
imt_member.unique_health_id as "uniqueHealthId",
imt_member.dob as "dob",
imt_family.bpl_flag as "bplFlag",
concat(imt_member.first_name,'' '',imt_member.middle_name,'' '',imt_member.last_name) as "memberName",
imt_member.family_id as "familyId",
get_location_hierarchy(imt_family.area_id) as "locationHierarchy",
concat(um_user.first_name,'' '',um_user.last_name) as "ashaName",
um_user.contact_number as "ashaContactNumber",
ncd_member_hypertension_detail.member_id as "hypertensionId",
ncd_member_diabetes_detail.member_id as "diabetesId",
npcb_member_screening_master.*
from npcb_member_screening_master 
inner join imt_member on npcb_member_screening_master.member_id = imt_member.id
inner join imt_family on imt_member.family_id = imt_family.family_id
inner join um_user_location on imt_family.area_id = um_user_location.loc_id and um_user_location.state = ''ACTIVE''
inner join um_user on um_user_location.user_id = um_user.id and role_id = 24 and um_user.state = ''ACTIVE''
left join ncd_member_hypertension_detail on npcb_member_screening_master.member_id = ncd_member_hypertension_detail.member_id
and (ncd_member_hypertension_detail.systolic_bp>=140 or ncd_member_hypertension_detail.diastolic_bp >=90)
left join ncd_member_diabetes_detail on npcb_member_screening_master.member_id = ncd_member_diabetes_detail.member_id
and ncd_member_diabetes_detail.blood_sugar>140
where npcb_member_screening_master.id = #id#
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'npcb_examined_details_retrieve','id','
select
imt_member.id as "memberId",
imt_member.dob as "dob",
imt_family.bpl_flag as "bplFlag",
imt_member.unique_health_id as "uniqueHealthId",
concat(imt_member.first_name,'' '',imt_member.middle_name,'' '',imt_member.last_name) as "memberName",
imt_member.family_id as "familyId",
get_location_hierarchy(imt_family.area_id) as "locationHierarchy",
concat(um_user.first_name,'' '',um_user.last_name) as "ashaName",
um_user.contact_number as "ashaContactNumber",
ncd_member_hypertension_detail.member_id as "hypertensionId",
ncd_member_diabetes_detail.member_id as "diabetesId",
npcb_member_examination_detail.screening_id,
npcb_member_examination_detail.id as "previousExamineId",
npcb_member_screening_master.*
from npcb_member_examination_detail
inner join npcb_member_screening_master on npcb_member_examination_detail.screening_id = npcb_member_screening_master.id
inner join imt_member on npcb_member_examination_detail.member_id = imt_member.id
inner join imt_family on imt_member.family_id = imt_family.family_id
inner join um_user_location on imt_family.area_id = um_user_location.loc_id and um_user_location.state = ''ACTIVE''
inner join um_user on um_user_location.user_id = um_user.id and role_id = 24 and um_user.state = ''ACTIVE''
left join ncd_member_hypertension_detail on npcb_member_examination_detail.member_id = ncd_member_hypertension_detail.member_id
and (ncd_member_hypertension_detail.systolic_bp>=140 or ncd_member_hypertension_detail.diastolic_bp >=90)
left join ncd_member_diabetes_detail on npcb_member_examination_detail.member_id = ncd_member_diabetes_detail.member_id
and ncd_member_diabetes_detail.blood_sugar>140
where npcb_member_examination_detail.id = #id#
',true,'ACTIVE');