delete from query_master where code='child_cmtc_nrc_referred_list';
delete from query_master where code='child_cmtc_nrc_screening_details';
delete from query_master where code='update_cmtc_archive_status';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'child_cmtc_nrc_referred_list','userId,limit,offset','
with assigned_hids as (
	select id from health_infrastructure_details where id in 
	(select health_infrastrucutre_id from user_health_infrastructure where user_id = #userId# and state = ''ACTIVE'')
	and (is_cmtc = true or is_nrc = true)
),childIds as(
	select csd.id,csd.child_id from child_cmtc_nrc_screening_detail csd
	where csd.referred_from is not null and csd.referred_to is not null
	and (
			(
				csd.referred_from in (select id from assigned_hids)
				and csd.is_archive is null
			)
		or
                (
                    csd.referred_to in (select id from assigned_hids)
                    and csd.state=''REFERRED''
                )
	)
	limit 100 offset 0
),rchServiceIds as (
	select rch_child_service_master.member_id,max(rch_child_service_master.id)
	from rch_child_service_master inner join childIds on childIds.child_id = rch_child_service_master.member_id
	group by rch_child_service_master.member_id
)
select csd.id,
case 
	when to_hid.id in 
		(select id from assigned_hids)
                and csd.state=''REFERRED'' then ''referredToPending''
        when to_hid.id in 
		(select id from assigned_hids)
                and csd.state!=''REFERRED'' then ''referredToComplete''
	when from_hid.id in 
		(select id from assigned_hids) then ''referredFrom''
	end as "referredType",
from_hid.name as "referredFromScreeningCenter",to_hid.name as "referredToScreeningCenter",
rch_child_service_master.mid_arm_circumference,rch_child_service_master.sd_score,rch_child_service_master.have_pedal_edema,
concat(m.first_name,'' '',m.middle_name,'' '',m.last_name) as "Child Name",
m.unique_health_id as childUniqueHealthId,
m.family_id as childFamilyId,
m.dob as childDob,
m.gender as childGender,
f.bpl_flag,
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
inner join imt_family f on m.family_id = f.family_id
left join imt_member m2 on m.mother_id = m2.id
inner join location_master l on f.area_id = l.id
inner join location_master l1 on l1.id = f.location_id
inner join um_user u on u.id = csd.created_by
left join health_infrastructure_details from_hid on csd.referred_from = from_hid.id
left join health_infrastructure_details to_hid on csd.referred_to = to_hid.id
left join rchServiceIds on childIds.child_id = rchServiceIds.member_id
left join rch_child_service_master on rchServiceIds.max = rch_child_service_master.id
left join listvalue_field_value_detail on f.caste = cast(listvalue_field_value_detail.id as character varying)
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'child_cmtc_nrc_screening_details','childId','
select row_number() over (ORDER BY csd.id)as "Sr. No", csd.id,csd.screening_center,hid.name,
concat(m.first_name,'' '',m.middle_name,'' '',m.last_name) as "Child Name",
m2.first_name || '' '' || m2.middle_name || '' '' || m2.last_name as "Mother Name",
m2.mobile_number as "mobileNumber",
l.name as "Asha Area", l1.name as "Village",
u.first_name || '' '' || u.last_name as "Referred By",
csd.child_id, csd.screened_on, csd.state,csd.admission_id,csd.discharge_id, csd.created_by,
csd.referred_from,csd.referred_to,csd.referred_date
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
values(1,current_date,'update_cmtc_archive_status','screeningId','
update child_cmtc_nrc_screening_detail
set is_archive = true where id = #screeningId#
',false,'ACTIVE');