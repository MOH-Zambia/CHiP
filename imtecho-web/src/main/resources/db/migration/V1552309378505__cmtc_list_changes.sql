delete from query_master where code='child_cmtc_nrc_screened_list';
delete from query_master where code='child_cmtc_nrc_screening_details';
delete from query_master where code='child_cmtc_nrc_admission_list';
delete from query_master where code='child_cmtc_nrc_defaulter_list';
delete from query_master where code='child_cmtc_nrc_discharge_list';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'child_cmtc_nrc_screened_list','userId,limit,offset','
with childIds as(
	select csd.id,csd.child_id from child_cmtc_nrc_screening_detail csd
	inner join imt_member m on csd.child_id = m.id
	inner join location_master l on csd.location_id = l.id
	inner join location_master l1 on l1.id = l.parent
	inner join um_user u on u.id = csd.created_by
	where csd.state = ''ACTIVE'' and csd.admission_id is null and
	((csd.screening_center is not null and csd.screening_center in
	(select id from health_infrastructure_details where id in
	(select health_infrastrucutre_id from user_health_infrastructure where user_id = #userId# and state = ''ACTIVE'')
	and (is_cmtc = true or is_nrc = true)))
	or
	(csd.screening_center is null and csd.location_id in
	(select child_id from location_hierchy_closer_det where parent_id in
	(select loc_id from um_user_location where user_id = #userId# and state = ''ACTIVE''))))
	limit #limit# offset #offset#
),rchServiceIds as (
	select rch_child_service_master.member_id,max(rch_child_service_master.id)
	from rch_child_service_master inner join childIds on childIds.child_id = rch_child_service_master.member_id
	group by rch_child_service_master.member_id
)
select csd.id,
rch_child_service_master.mid_arm_circumference,rch_child_service_master.sd_score,rch_child_service_master.have_pedal_edema,
csd.screening_center,
hid.name,
concat(m.first_name,'' '',m.middle_name,'' '',m.last_name) as "Child Name",
m.unique_health_id as childUniqueHealthId,
m.family_id as childFamilyId,
m.dob as childDob,
m.gender as childGender,
imt_family.bpl_flag,
listvalue_field_value_detail.value as caste,
m2.first_name || '' '' || m2.middle_name || '' '' || m2.last_name as "Mother Name",
m2.mobile_number as motherPhoneNumber,
l.name as "Asha Area",
l1.name as "Village",
u.first_name || '' '' || u.last_name as "Referred By",
u.contact_number as referredByContact,
csd.child_id,
csd.screened_on,
csd.state,
csd.admission_id,
csd.discharge_id,
csd.created_by,
(
	select concat(um_user.first_name, '' '',um_user.middle_name,'' '',um_user.last_name, '' ('', um_user.contact_number,'')'') as ashaDetails
	from um_user_location inner join um_user on um_user_location.user_id = um_user.id
	where um_user_location.loc_id = csd.location_id limit 1
)
from childIds
inner join child_cmtc_nrc_screening_detail csd on childIds.id = csd.id
inner join imt_member m on csd.child_id = m.id
left join imt_member m2 on m.mother_id = m2.id
inner join location_master l on csd.location_id = l.id
inner join location_master l1 on l1.id = l.parent
inner join um_user u on u.id = csd.created_by
left join health_infrastructure_details hid on csd.screening_center = hid.id
left join imt_family on m.family_id = imt_family.family_id
left join rchServiceIds on childIds.child_id = rchServiceIds.member_id
left join rch_child_service_master on rchServiceIds.max = rch_child_service_master.id
left join listvalue_field_value_detail on imt_family.caste = cast(listvalue_field_value_detail.id as character varying)
group by csd.id,csd.screening_center,hid.name,imt_family.bpl_flag,listvalue_field_value_detail.value,
concat(m.first_name,'' '',m.middle_name,'' '',m.last_name),
m.unique_health_id,m.family_id,m.dob,m.gender,
m2.first_name || '' '' || m2.middle_name || '' '' || m2.last_name,
l.name , l1.name,
u.first_name || '' '' || u.last_name,
u.contact_number,
csd.child_id, csd.screened_on, csd.state,csd.admission_id,csd.discharge_id, csd.created_by,
rch_child_service_master.mid_arm_circumference,rch_child_service_master.sd_score,rch_child_service_master.have_pedal_edema,
m2.mobile_number
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'child_cmtc_nrc_screening_details','childId','
select row_number() over (ORDER BY csd.id)as "Sr. No", csd.id,csd.screening_center,hid.name,
concat(m.first_name,'' '',m.middle_name,'' '',m.last_name) as "Child Name",
m2.first_name || '' '' || m2.middle_name || '' '' || m2.last_name as "Mother Name",
l.name as "Asha Area", l1.name as "Village",
u.first_name || '' '' || u.last_name as "Referred By",
csd.child_id, csd.screened_on, csd.state,csd.admission_id,csd.discharge_id, csd.created_by
from child_cmtc_nrc_screening_detail csd inner join imt_member m on csd.child_id = m.id
left join imt_member m2 on m.mother_id = m2.id
inner join location_master l on csd.location_id = l.id
inner join location_master l1 on l1.id = l.parent
inner join um_user u on u.id = csd.created_by
left join health_infrastructure_details hid on csd.screening_center = hid.id
where
csd.child_id = #childId# and csd.is_case_completed is null
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'child_cmtc_nrc_admission_list','userId,limit,offset','

with childIds as(
	select csd.id,csd.child_id from child_cmtc_nrc_screening_detail csd
	inner join imt_member m on csd.child_id = m.id
	inner join location_master l on csd.location_id = l.id
	inner join location_master l1 on l1.id = l.parent
	inner join um_user u on u.id = csd.created_by
	where csd.state = ''ACTIVE'' and csd.admission_id is not null and
	((csd.screening_center is not null and csd.screening_center in
	(select id from health_infrastructure_details where id in
	(select health_infrastrucutre_id from user_health_infrastructure where user_id = #userId# and state = ''ACTIVE'')
	and (is_cmtc = true or is_nrc = true)))
	or
	(csd.screening_center is null and csd.location_id in
	(select child_id from location_hierchy_closer_det where parent_id in
	(select loc_id from um_user_location where user_id = #userId# and state = ''ACTIVE''))))
	limit #limit# offset #offset#
),rchServiceIds as (
	select rch_child_service_master.member_id,max(rch_child_service_master.id)
	from rch_child_service_master inner join childIds on childIds.child_id = rch_child_service_master.member_id
	group by rch_child_service_master.member_id
)
select csd.id,cad.admission_date,
rch_child_service_master.mid_arm_circumference,rch_child_service_master.sd_score,rch_child_service_master.have_pedal_edema,
csd.screening_center,
hid.name,
concat(m.first_name,'' '',m.middle_name,'' '',m.last_name) as "Child Name",
m.unique_health_id as childUniqueHealthId,
m.family_id as childFamilyId,
m.dob as childDob,
m.gender as childGender,
imt_family.bpl_flag,
listvalue_field_value_detail.value as caste,
m2.first_name || '' '' || m2.middle_name || '' '' || m2.last_name as "Mother Name",
m2.mobile_number as motherPhoneNumber,
l.name as "Asha Area",
l1.name as "Village",
u.first_name || '' '' || u.last_name as "Referred By",
u.contact_number as referredByContact,
csd.child_id,
csd.screened_on,
csd.state,
csd.admission_id,
csd.discharge_id,
csd.created_by,
(
	select concat(um_user.first_name, '' '',um_user.middle_name,'' '',um_user.last_name, '' ('', um_user.contact_number,'')'') as ashaDetails
	from um_user_location inner join um_user on um_user_location.user_id = um_user.id
	where um_user_location.loc_id = csd.location_id limit 1
)
from childIds
inner join child_cmtc_nrc_screening_detail csd on childIds.id = csd.id
inner join child_cmtc_nrc_admission_detail cad on csd.admission_id = cad.id
inner join imt_member m on csd.child_id = m.id
left join imt_member m2 on m.mother_id = m2.id
inner join location_master l on csd.location_id = l.id
inner join location_master l1 on l1.id = l.parent
inner join um_user u on u.id = csd.created_by
left join health_infrastructure_details hid on csd.screening_center = hid.id
left join imt_family on m.family_id = imt_family.family_id
left join rchServiceIds on childIds.child_id = rchServiceIds.member_id
left join rch_child_service_master on rchServiceIds.max = rch_child_service_master.id
left join listvalue_field_value_detail on imt_family.caste = cast(listvalue_field_value_detail.id as character varying)
group by csd.id,cad.admission_date,csd.screening_center,hid.name,imt_family.bpl_flag,listvalue_field_value_detail.value,
concat(m.first_name,'' '',m.middle_name,'' '',m.last_name),
m.unique_health_id,m.family_id,m.dob,m.gender,
m2.first_name || '' '' || m2.middle_name || '' '' || m2.last_name,
l.name , l1.name,
u.first_name || '' '' || u.last_name,
u.contact_number,
csd.child_id, csd.screened_on, csd.state,csd.admission_id,csd.discharge_id, csd.created_by,
rch_child_service_master.mid_arm_circumference,rch_child_service_master.sd_score,rch_child_service_master.have_pedal_edema,
m2.mobile_number
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'child_cmtc_nrc_defaulter_list','userId,limit,offset','
with childIds as(
	select csd.id,csd.child_id from child_cmtc_nrc_screening_detail csd
	inner join imt_member m on csd.child_id = m.id
	inner join location_master l on csd.location_id = l.id
	inner join location_master l1 on l1.id = l.parent
	inner join um_user u on u.id = csd.created_by
	where csd.state = ''DEFAULTER'' and
	((csd.screening_center is not null and csd.screening_center in
	(select id from health_infrastructure_details where id in
	(select health_infrastrucutre_id from user_health_infrastructure where user_id = #userId# and state = ''ACTIVE'')
	and (is_cmtc = true or is_nrc = true)))
	or
	(csd.screening_center is null and csd.location_id in
	(select child_id from location_hierchy_closer_det where parent_id in
	(select loc_id from um_user_location where user_id = #userId# and state = ''ACTIVE''))))
	limit #limit# offset #offset#
),rchServiceIds as (
	select rch_child_service_master.member_id,max(rch_child_service_master.id)
	from rch_child_service_master inner join childIds on childIds.child_id = rch_child_service_master.member_id
	group by rch_child_service_master.member_id
)
select csd.id,
rch_child_service_master.mid_arm_circumference,rch_child_service_master.sd_score,rch_child_service_master.have_pedal_edema,
csd.screening_center,
hid.name,
concat(m.first_name,'' '',m.middle_name,'' '',m.last_name) as "Child Name",
m.unique_health_id as childUniqueHealthId,
m.family_id as childFamilyId,
m.dob as childDob,
m.gender as childGender,
imt_family.bpl_flag,
listvalue_field_value_detail.value as caste,
m2.first_name || '' '' || m2.middle_name || '' '' || m2.last_name as "Mother Name",
m2.mobile_number as motherPhoneNumber,
l.name as "Asha Area",
l1.name as "Village",
u.first_name || '' '' || u.last_name as "Referred By",
u.contact_number as referredByContact,
csd.child_id,
csd.screened_on,
csd.state,
csd.admission_id,
csd.discharge_id,
csd.created_by,
(
	select concat(um_user.first_name, '' '',um_user.middle_name,'' '',um_user.last_name, '' ('', um_user.contact_number,'')'') as ashaDetails
	from um_user_location inner join um_user on um_user_location.user_id = um_user.id
	where um_user_location.loc_id = csd.location_id limit 1
)
from childIds
inner join child_cmtc_nrc_screening_detail csd on childIds.id = csd.id
inner join imt_member m on csd.child_id = m.id
left join imt_member m2 on m.mother_id = m2.id
inner join location_master l on csd.location_id = l.id
inner join location_master l1 on l1.id = l.parent
inner join um_user u on u.id = csd.created_by
left join health_infrastructure_details hid on csd.screening_center = hid.id
left join imt_family on m.family_id = imt_family.family_id
left join rchServiceIds on childIds.child_id = rchServiceIds.member_id
left join rch_child_service_master on rchServiceIds.max = rch_child_service_master.id
left join listvalue_field_value_detail on imt_family.caste = cast(listvalue_field_value_detail.id as character varying)
group by csd.id,csd.screening_center,hid.name,imt_family.bpl_flag,listvalue_field_value_detail.value,
concat(m.first_name,'' '',m.middle_name,'' '',m.last_name),
m.unique_health_id,m.family_id,m.dob,m.gender,
m2.first_name || '' '' || m2.middle_name || '' '' || m2.last_name,
l.name , l1.name,
u.first_name || '' '' || u.last_name,
u.contact_number,
csd.child_id, csd.screened_on, csd.state,csd.admission_id,csd.discharge_id, csd.created_by,
rch_child_service_master.mid_arm_circumference,rch_child_service_master.sd_score,rch_child_service_master.have_pedal_edema,
m2.mobile_number
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'child_cmtc_nrc_discharge_list','userId,limit,offset','
with childIds as(
	select csd.id,csd.child_id,csd.admission_id from child_cmtc_nrc_screening_detail csd
	inner join imt_member m on csd.child_id = m.id
	inner join location_master l on csd.location_id = l.id
	inner join location_master l1 on l1.id = l.parent
	inner join um_user u on u.id = csd.created_by
	where csd.state = ''DISCHARGE'' and
	((csd.screening_center is not null and csd.screening_center in
	(select id from health_infrastructure_details where id in
	(select health_infrastrucutre_id from user_health_infrastructure where user_id = #userId# and state = ''ACTIVE'')
	and (is_cmtc = true or is_nrc = true)))
	or
	(csd.screening_center is null and csd.location_id in
	(select child_id from location_hierchy_closer_det where parent_id in
	(select loc_id from um_user_location where user_id = #userId# and state = ''ACTIVE''))))
	limit #limit# offset #offset#
),rchServiceIds as (
	select rch_child_service_master.member_id,max(rch_child_service_master.id)
	from rch_child_service_master inner join childIds on childIds.child_id = rch_child_service_master.member_id
	group by rch_child_service_master.member_id
),followup_id as (
	select child_cmtc_nrc_follow_up.child_id,max(child_cmtc_nrc_follow_up.id)
	from child_cmtc_nrc_follow_up inner join childIds on childIds.admission_id = child_cmtc_nrc_follow_up.admission_id
	group by child_cmtc_nrc_follow_up.child_id
)
select csd.id,
rch_child_service_master.mid_arm_circumference,rch_child_service_master.sd_score,rch_child_service_master.have_pedal_edema,
child_cmtc_nrc_follow_up.follow_up_visit,child_cmtc_nrc_follow_up.follow_up_date,
csd.screening_center,
hid.name,
concat(m.first_name,'' '',m.middle_name,'' '',m.last_name) as "Child Name",
m.unique_health_id as childUniqueHealthId,
m.family_id as childFamilyId,
m.dob as childDob,
m.gender as childGender,
imt_family.bpl_flag,
listvalue_field_value_detail.value as caste,
m2.first_name || '' '' || m2.middle_name || '' '' || m2.last_name as "Mother Name",
m2.mobile_number as motherPhoneNumber,
l.name as "Asha Area",
l1.name as "Village",
u.first_name || '' '' || u.last_name as "Referred By",
u.contact_number as referredByContact,
csd.child_id,
csd.screened_on,
csd.state,
csd.admission_id,
csd.discharge_id,
csd.created_by,
(
	select concat(um_user.first_name, '' '',um_user.middle_name,'' '',um_user.last_name, '' ('', um_user.contact_number,'')'') as ashaDetails
	from um_user_location inner join um_user on um_user_location.user_id = um_user.id
	where um_user_location.loc_id = csd.location_id limit 1
)
from childIds
inner join child_cmtc_nrc_screening_detail csd on childIds.id = csd.id
inner join imt_member m on csd.child_id = m.id
left join imt_member m2 on m.mother_id = m2.id
inner join location_master l on csd.location_id = l.id
inner join location_master l1 on l1.id = l.parent
inner join um_user u on u.id = csd.created_by
left join health_infrastructure_details hid on csd.screening_center = hid.id
left join imt_family on m.family_id = imt_family.family_id
left join rchServiceIds on childIds.child_id = rchServiceIds.member_id
left join rch_child_service_master on rchServiceIds.max = rch_child_service_master.id
left join followup_id on childIds.child_id = followup_id.child_id
left join child_cmtc_nrc_follow_up on followup_id.max = child_cmtc_nrc_follow_up.id
left join listvalue_field_value_detail on imt_family.caste = cast(listvalue_field_value_detail.id as character varying)
group by csd.id,csd.screening_center,hid.name,imt_family.bpl_flag,listvalue_field_value_detail.value,
concat(m.first_name,'' '',m.middle_name,'' '',m.last_name),
m.unique_health_id,m.family_id,m.dob,m.gender,
m2.first_name || '' '' || m2.middle_name || '' '' || m2.last_name,
l.name , l1.name,
u.first_name || '' '' || u.last_name,
u.contact_number,
csd.child_id, csd.screened_on, csd.state,csd.admission_id,csd.discharge_id, csd.created_by,
rch_child_service_master.mid_arm_circumference,rch_child_service_master.sd_score,rch_child_service_master.have_pedal_edema,
m2.mobile_number,child_cmtc_nrc_follow_up.follow_up_visit,child_cmtc_nrc_follow_up.follow_up_date
',true,'ACTIVE');