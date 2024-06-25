DELETE FROM QUERY_MASTER WHERE CODE='state_of_health_covid_mild';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
74841,  current_date , 74841,  current_date , 'state_of_health_covid_mild', 
'offset,limit,location_id,health_infra_id', 
'with analytics as(
select 
concat_ws(''/'', member_det, (case when caad.gender = ''F'' then ''F'' else ''M'' end), age, 
SUBSTRING(case when hid.name_in_english is null then hid.name else hid.name_in_english end from 1 for 10), 
case when mobidity != '''' then mobidity else  ''-'' end) as "primaryVal_Member Details",
m.unique_health_id as "uniqueHealthId",
caad.member_id as member_id,
m.family_id as family_id,
caad.contact_number as "primaryVal_mobile_Contact Number",
caad.address as "primaryVal_Address",
case when admission_date is not null then to_char(caad.admission_date,''DD/MM/YYYY'') else ''-'' end as "primaryVal_Admission Date",
case when last_lab_result_entry_on is not null then to_char(caad.last_lab_result_entry_on,''DD/MM/YYYY'') else ''-'' end as "Last Lab Test date",
health_state as "primaryVal_Current Status",
discharge_date as "val_Discharge Date",
case when death_date is not null then to_char(caad.death_date,''DD/MM/YYYY'') else null end as "val_Death Date",
case when hid.name_in_english is null then hid.name else hid.name_in_english end as "val_Facility Name",
caad.contact_number as "val_Contact Number",
case_no as  "val_Case No",
caad.location_id as loc_id
from covid19_admission_analytics_details caad
left join imt_member m on m.id = caad.member_id
left join health_infrastructure_details hid on hid.id = caad.health_infra_id
where case when ''#health_infra_id#'' != ''null'' then caad.health_infra_id = #health_infra_id# else 
caad.location_id in (select child_id from location_hierchy_closer_det where parent_id = #location_id#) end
and positive_member = 1 and cad_status not in (''DISCHARGE'',''DEATH'')   and health_state in (''Mild'',''Stable-Mild'')
order by caad.admission_id desc
limit #limit# offset #offset#),
family_head as (
	select distinct a.member_id as member_id,
	concat(im.first_name,'' '',im.middle_name,'' '',im.last_name) as FamilyHead,
	im.mobile_number as FamilyHeadMobileNo
	from imt_member im inner join analytics a on a.family_id = im.family_id
inner join imt_family imf on imf.family_id = a.family_id and imf.hof_id = im.id 
	where family_head = true and 
        im.basic_state in (''VERIFIED'',''NEW'',''REVERIFICATION'',''TEMPORARY'')
),
contact_person as (
	select distinct a.member_id, 
	concat(im.first_name,'' '',im.middle_name,'' '',im.last_name) as contactPersonName,
	im.mobile_number as contactPersonMobileNo  
	from imt_member im 
	inner join analytics a on a.family_id = im.family_id 
	inner join imt_family ifm on ifm.family_id = im.family_id and ifm.contact_person_id = im.id
)
select a.*,fh.FamilyHead as "familyHead",
fh.FamilyHeadMobileNo as "familyHeadMobileNo",
cp.contactPersonMobileNo as "contactPersonMobileNo",
cp.contactPersonName as "contactPersonName"
--case when a.is_any_illness_or_discomfort then ''Yes'' when a.is_any_illness_or_discomfort is false then ''No'' else ''-'' end as "val_Any illness or discomfort"

from analytics a 
left join family_head fh on a.member_id = fh.member_id
left join contact_person cp on cp.member_id = a.member_id', 
null, 
true, 'ACTIVE');