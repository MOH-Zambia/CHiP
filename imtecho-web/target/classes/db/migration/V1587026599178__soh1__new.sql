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
case_no as  "val_Case No",
caad.location_id as loc_id
from covid19_admission_analytics_details caad
left join imt_member m on m.id = caad.member_id
left join health_infrastructure_details hid on hid.id = caad.health_infra_id
where case when ''#health_infra_id#'' != ''null'' then caad.health_infra_id = #health_infra_id# else 
caad.location_id in (select child_id from location_hierchy_closer_det where parent_id = #location_id#) end
and positive_member = 1 and cad_status not in (''DISCHARGE'',''DEATH'')   and health_state in (''Mild'',''Stable-Mild'')
and case when ''#search_text#'' = ''null'' then true else case when caad.search_text ilike ''%#search_text#%'' then true else false end end
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

DELETE FROM QUERY_MASTER WHERE CODE='state_of_health_covid_total_death_case';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
74841,  current_date , 74841,  current_date , 'state_of_health_covid_total_death_case', 
'offset,limit,location_id,health_infra_id', 
'with analytics as(
select 
concat_ws(''/'', member_det, (case when caad.gender = ''F'' then ''F'' else ''M'' end), age, 
SUBSTRING(case when hid.name_in_english is null then hid.name else hid.name_in_english end from 1 for 10), 
case when mobidity != '''' then mobidity else  ''-'' end) as "primaryVal_Member Details",
m.unique_health_id as "uniqueHealthId",
caad.member_id as member_id,
--case when idsp.is_any_illness_or_discomfort then ''Yes'' when idsp.is_any_illness_or_discomfort is false then ''No'' else ''-'' end as "val_Any illness or discomfort",
m.family_id as family_id,
caad.contact_number as "primaryVal_mobile_Contact Number",
caad.address as "primaryVal_Address",
case when admission_date is not null then to_char(caad.admission_date,''DD/MM/YYYY'') else ''-'' end as "primaryVal_Admission Date",
case when last_lab_result_entry_on is not null then to_char(caad.last_lab_result_entry_on,''DD/MM/YYYY'') else ''-'' end as "Last Lab Test date",
case when discharge_date is not null then to_char(caad.discharge_date,''DD/MM/YYYY'') else null end as "primaryVal_Death Date",
case_no as  "val_Case No",
caad.location_id as loc_id
from covid19_admission_analytics_details caad
left join imt_member m on m.id = caad.member_id
left join health_infrastructure_details hid on hid.id = caad.health_infra_id
where case when ''#health_infra_id#'' != ''null'' then caad.health_infra_id = #health_infra_id# else 
caad.location_id in (select child_id from location_hierchy_closer_det where parent_id = #location_id#) end
and  positive_member = 1 and cad_status = ''DEATH''
and case when ''#search_text#'' = ''null'' then true else case when caad.search_text ilike ''%#search_text#%'' then true else false end end
order by caad.discharge_date desc
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

DELETE FROM QUERY_MASTER WHERE CODE='state_of_health_covid_today_deaths';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
74841,  current_date , 74841,  current_date , 'state_of_health_covid_today_deaths', 
'offset,limit,location_id', 
'with analytics as(
select 
concat_ws(''/'', member_det, (case when caad.gender = ''F'' then ''F'' else ''M'' end), age, 
SUBSTRING(case when hid.name_in_english is null then hid.name else hid.name_in_english end from 1 for 10), 
case when mobidity != '''' then mobidity else  ''-'' end) as "primaryVal_Member Details",
m.unique_health_id as "uniqueHealthId",
caad.member_id as member_id,
--case when idsp.is_any_illness_or_discomfort then ''Yes'' when idsp.is_any_illness_or_discomfort is false then ''No'' else ''-'' end as "val_Any illness or discomfort",
m.family_id as family_id,
caad.contact_number as "primaryVal_mobile_Contact Number",
caad.address as "primaryVal_Address",
case when admission_date is not null then to_char(caad.admission_date,''DD/MM/YYYY'') else ''-'' end as "primaryVal_Admission Date",
case when last_lab_result_entry_on is not null then to_char(caad.last_lab_result_entry_on,''DD/MM/YYYY'') else ''-'' end as "Last Lab Test date",
discharge_date as "val_Discharge Date",
case when death_date is not null then to_char(caad.death_date,''DD/MM/YYYY'') else null end as "val_Death Date",
case_no as  "val_Case No",
caad.location_id as loc_id
from covid19_admission_analytics_details caad
left join imt_member m on m.id = caad.member_id
left join health_infrastructure_details hid on hid.id = caad.health_infra_id
where caad.location_id in (select child_id from location_hierchy_closer_det where parent_id = #location_id#)
and positive_member = 1 and cast( caad.discharge_date  as date) = cast(now() as date) and cad_status = ''DEATH''
and case when ''#search_text#'' = ''null'' then true else case when caad.search_text ilike ''%#search_text#%'' then true else false end end
order by caad.discharge_date desc
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

DELETE FROM QUERY_MASTER WHERE CODE='state_of_health_covid_today_positive';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
74841,  current_date , 74841,  current_date , 'state_of_health_covid_today_positive', 
'offset,limit,location_id', 
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
case_no as  "val_Case No",
caad.location_id as loc_id
from covid19_admission_analytics_details caad
left join imt_member m on m.id = caad.member_id
left join health_infrastructure_details hid on hid.id = caad.health_infra_id
where caad.location_id in (select child_id from location_hierchy_closer_det where parent_id = #location_id#)
and positive_member = 1 and cast(postive_date as date) = cast(now() as date)
and case when ''#search_text#'' = ''null'' then true else case when caad.search_text ilike ''%#search_text#%'' then true else false end end
order by caad.admission_date desc
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

DELETE FROM QUERY_MASTER WHERE CODE='state_of_health_covid_treatment';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
74841,  current_date , 74841,  current_date , 'state_of_health_covid_treatment', 
'offset,limit,location_id', 
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
health_state as "val_Current Status",
discharge_date as "val_Discharge Date",
case when death_date is not null then to_char(caad.death_date,''DD/MM/YYYY'') else null end as "val_Death Date",
case_no as  "val_Case No",
caad.location_id as loc_id
from covid19_admission_analytics_details caad
left join imt_member m on m.id = caad.member_id
left join health_infrastructure_details hid on hid.id = caad.health_infra_id
where caad.location_id in (select child_id from location_hierchy_closer_det where parent_id = #location_id#)
and positive_member = 1 and discharge_date is null
and case when ''#search_text#'' = ''null'' then true else case when caad.search_text ilike ''%#search_text#%'' then true else false end end
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

DELETE FROM QUERY_MASTER WHERE CODE='state_of_health_covid_today_test';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
74841,  current_date , 74841,  current_date , 'state_of_health_covid_today_test', 
'offset,limit,location_id', 
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
case when death_date is not null then to_char(caad.death_date,''DD/MM/YYYY'') else null end as "val_Death Date",
case_no as  "val_Case No",
caad.location_id as loc_id
from covid19_admission_analytics_details caad
left join imt_member m on m.id = caad.member_id
left join health_infrastructure_details hid on hid.id = caad.health_infra_id
where caad.location_id in (select child_id from location_hierchy_closer_det where parent_id = #location_id#)
and cast( last_test_before_admission  as date) = cast(now() as date)
and case when ''#search_text#'' = ''null'' then true else case when caad.search_text ilike ''%#search_text#%'' then true else false end end
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

DELETE FROM QUERY_MASTER WHERE CODE='state_of_health_covid_total_test';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
74841,  current_date , 74841,  current_date , 'state_of_health_covid_total_test', 
'offset,limit,location_id', 
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
case when lab_result_entry_on is not null then to_char(lab_result_entry_on,''DD/MM/YYYY'') else ''-'' end as "Lab Test date",
health_state as "val_Current Status",
case when death_date is not null then to_char(caad.death_date,''DD/MM/YYYY'') else null end as "val_Death Date",
case_no as  "val_Case No",
caad.location_id as loc_id
from covid19_admission_analytics_details caad
inner join covid19_lab_test_detail cltd on cltd.covid_admission_detail_id = caad.admission_id
left join imt_member m on m.id = caad.member_id
left join health_infrastructure_details hid on hid.id = caad.health_infra_id
where caad.location_id in (select child_id from location_hierchy_closer_det where parent_id = #location_id#) and lab_result_entry_on is not null
and case when ''#search_text#'' = ''null'' then true else case when caad.search_text ilike ''%#search_text#%'' then true else false end end
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

DELETE FROM QUERY_MASTER WHERE CODE='state_of_health_covid_today_recovered';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
74841,  current_date , 74841,  current_date , 'state_of_health_covid_today_recovered', 
'offset,limit,location_id', 
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
health_state as "Current Status",
case when discharge_date is not null then to_char(caad.discharge_date,''DD/MM/YYYY'') else null end as "primaryVal_Discharge Date",
case when death_date is not null then to_char(caad.death_date,''DD/MM/YYYY'') else null end as "val_Death Date",
case_no as  "val_Case No",
caad.location_id as loc_id
from covid19_admission_analytics_details caad
left join imt_member m on m.id = caad.member_id
left join health_infrastructure_details hid on hid.id = caad.health_infra_id
where caad.location_id in (select child_id from location_hierchy_closer_det where parent_id = #location_id#)
and positive_member = 1 and  cad_status = ''DISCHARGE'' and cast(discharge_date as date) = cast(now() as date)
and case when ''#search_text#'' = ''null'' then true else case when caad.search_text ilike ''%#search_text#%'' then true else false end end
order by caad.discharge_date desc
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

DELETE FROM QUERY_MASTER WHERE CODE='state_of_health_covid_asymptomatic';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
74841,  current_date , 74841,  current_date , 'state_of_health_covid_asymptomatic', 
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
case when death_date is not null then to_char(caad.death_date,''DD/MM/YYYY'') else null end as "val_Death Date"
case_no as  "val_Case No",
caad.location_id as loc_id
from covid19_admission_analytics_details caad
left join imt_member m on m.id = caad.member_id
left join health_infrastructure_details hid on hid.id = caad.health_infra_id
where case when ''#health_infra_id#'' != ''null'' then caad.health_infra_id = #health_infra_id# else 
caad.location_id in (select child_id from location_hierchy_closer_det where parent_id = #location_id#) end 
and positive_member = 1 and cad_status not in (''DISCHARGE'',''DEATH'')   and health_state = ''Asymptomatic''
and case when ''#search_text#'' = ''null'' then true else case when caad.search_text ilike ''%#search_text#%'' then true else false end end
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

DELETE FROM QUERY_MASTER WHERE CODE='state_of_health_covid_critical';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
74841,  current_date , 74841,  current_date , 'state_of_health_covid_critical', 
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
case_no as  "val_Case No",
caad.location_id as loc_id
from covid19_admission_analytics_details caad
left join imt_member m on m.id = caad.member_id
left join health_infrastructure_details hid on hid.id = caad.health_infra_id
where case when ''#health_infra_id#'' != ''null'' then caad.health_infra_id = #health_infra_id# else 
caad.location_id in (select child_id from location_hierchy_closer_det where parent_id = #location_id#) end 
and positive_member = 1 and cad_status not in (''DISCHARGE'',''DEATH'')  and health_state = ''Critical''
and case when ''#search_text#'' = ''null'' then true else case when caad.search_text ilike ''%#search_text#%'' then true else false end end
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

DELETE FROM QUERY_MASTER WHERE CODE='state_of_health_covid_stable';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
74841,  current_date , 74841,  current_date , 'state_of_health_covid_stable', 
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
case when last_lab_result_entry_on is not null then to_char(caad.last_lab_result_entry_on,''DD/MM/YYYY'') else ''-'' end as "Last Lab Test date",
health_state as "primaryVal_Current Status",
discharge_date as "val_Discharge Date",
case when death_date is not null then to_char(caad.death_date,''DD/MM/YYYY'') else null end as "val_Death Date"
case_no as  "val_Case No",
caad.location_id as loc_id
from covid19_admission_analytics_details caad
left join imt_member m on m.id = caad.member_id
left join health_infrastructure_details hid on hid.id = caad.health_infra_id
where case when ''#health_infra_id#'' != ''null'' then caad.health_infra_id = #health_infra_id# else 
caad.location_id in (select child_id from location_hierchy_closer_det where parent_id = #location_id#) end 
and positive_member = 1 and cad_status not in (''DISCHARGE'',''DEATH'')  and health_state in(''Stable'',''Stable-Moderate'')
and case when ''#search_text#'' = ''null'' then true else case when caad.search_text ilike ''%#search_text#%'' then true else false end end
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

DELETE FROM QUERY_MASTER WHERE CODE='state_of_health_covid_total_positive_case';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
74841,  current_date , 74841,  current_date , 'state_of_health_covid_total_positive_case', 
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
health_state as "val_Current Status",
case when discharge_date is not null then to_char(caad.discharge_date,''DD/MM/YYYY'') else null end as "val_Discharge Date",
case when death_date is not null then to_char(caad.death_date,''DD/MM/YYYY'') else null end as "val_Death Date",
case_no as  "val_Case No",
caad.location_id as loc_id
from covid19_admission_analytics_details caad
left join imt_member m on m.id = caad.member_id
left join health_infrastructure_details hid on hid.id = caad.health_infra_id
where case when ''#health_infra_id#'' != ''null'' then caad.health_infra_id = #health_infra_id# else 
caad.location_id in (select child_id from location_hierchy_closer_det where parent_id = #location_id#) end
and positive_member = 1
and case when ''#search_text#'' = ''null'' then true else case when caad.search_text ilike ''%#search_text#%'' then true else false end end
order by caad.admission_date desc
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

DELETE FROM QUERY_MASTER WHERE CODE='state_of_health_covid_total_recover_case';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
74841,  current_date , 74841,  current_date , 'state_of_health_covid_total_recover_case', 
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
health_state as "Current Status",
case when discharge_date is not null then to_char(caad.discharge_date,''DD/MM/YYYY'') else null end as "primaryVal_Discharge Date",
case when death_date is not null then to_char(caad.death_date,''DD/MM/YYYY'') else null end as "val_Death Date",
case_no as  "val_Case No",
caad.location_id as loc_id
from covid19_admission_analytics_details caad
left join imt_member m on m.id = caad.member_id
left join health_infrastructure_details hid on hid.id = caad.health_infra_id
where case when ''#health_infra_id#'' != ''null'' then caad.health_infra_id = #health_infra_id# else 
caad.location_id in (select child_id from location_hierchy_closer_det where parent_id = #location_id#) end
and positive_member = 1 and discharge_date is not null and caad.cad_status = ''DISCHARGE''
and case when ''#search_text#'' = ''null'' then true else case when caad.search_text ilike ''%#search_text#%'' then true else false end end
order by caad.discharge_date desc
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

DELETE FROM QUERY_MASTER WHERE CODE='soh_covid19_infrastructure_wise_results';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
1,  current_date , 1,  current_date , 'soh_covid19_infrastructure_wise_results', 
 null, 
'select 0 as health_infra_id,
sum(det.member_tested) "PeopleTested",
sum(det.total_member_tested) as "TotalMemberTested",
sum(det.tests) as "TestsFromFacility",
sum(det.total_sample_tested) "Tests",
sum(det.positive) "Positive",
sum(det.death) "Death",
sum(det.member_with_no_infra) "PositiveWithNoHealthInfra",
sum(det.suspected) as "Suspected",
sum(det.discharge) "Discharge",
sum(det.stable_moderate) "Stable",
sum(det.mild) "Mild",
sum(det.critical) "Critical",
sum(det.asymptomatic) "Asymptomatic",
sum(det.active_cases) activecases,
sum(det.on_vantiltor_cases) onVantiltorCases,
sum(det.in_patinets) as "InPatinets",
''Total'' as "Name",
null as "IsCovid19Lab",
null as "IsCovid19Hospital",
sum(det.total_sample_tested) as "TotalSampleTested",
sum(det.total_sample_tested_today) as "TotalSampleTestedToday",
sum(det.total_beds) "TotalBeds",
case when sum(det.total_beds) = 0 then 0 else  round(cast(((sum(det.active_cases)*100/cast(sum(det.total_beds) as float))) as numeric),2) end as "BedsRatio",
sum(det.occupied_bed) "OccupiedBed",
sum(det.available_bed) "AvailableBed",
sum(det.new_added_bed) "NewAddedBed",
sum(det.total_ventilator) "TotalVentilator",
sum(det.new_added_ppe) "NewAddedPPE",
sum(det.new_ppe) "NewPPE",
sum(det.consumed_ppe) "ConsumedPPE",
case when sum(det.total_ventilator) = 0 then 0 else  round(cast(((sum(det.on_vantiltor_cases)*100/cast(sum(det.total_ventilator) as float))) as numeric),2) end as "VentilatorRatio",
sum(det.occupied_ventilator) "OccupiedVentilator",
sum(det.available_ventilator) "AvailableVentilator",
sum(det.new_added_ventilator) "NewAddedVentilator"
from covid19_healthinfra_wise_analytics_details det
union all

select
health_infra_id,
coalesce(hwad.member_tested,0) "PeopleTested",
coalesce(hwad.total_member_tested,0) as "TotalMemberTested",
coalesce(hwad.tests,0) "TestsFromFacility",
coalesce(hwad.total_sample_tested,0) "Tests",
coalesce(hwad.positive,0) "Positive",
coalesce(hwad.member_with_no_infra,0) "PositiveWithNoHealthInfra",
coalesce(hwad.death,0) "Death",
coalesce(hwad.suspected ,0)as "Suspected",
coalesce(hwad.discharge,0) "Discharge",
coalesce(hwad.stable_moderate,0) "Stable",
coalesce(hwad.mild,0) "Mild",
coalesce(hwad.critical,0) "Critical",
coalesce(hwad.asymptomatic,0) "Asymptomatic",
coalesce(hwad.active_cases,0) activecases,
coalesce(hwad.on_vantiltor_cases,0) onVantiltorCases,
coalesce(hwad.in_patinets,0) as "InPatinets",
name as "Name",
is_covid19_lab as "IsCovid19Lab",
is_covid19_hospital as "IsCovid19Hospital",
coalesce(hwad.total_sample_tested, 0) as "TotalSampleTested",
coalesce(hwad.total_sample_tested_today, 0) as "TotalSampleTestedToday",
hwad.total_beds "TotalBeds",
case when (hwad.total_beds) = 0 then 0 else  round(cast((((hwad.active_cases)*100/cast((hwad.total_beds) as float))) as numeric),2) end as "BedsRatio",
coalesce(hwad.occupied_bed,0) "OccupiedBed",
coalesce(hwad.available_bed,0) "AvailableBed",
coalesce(hwad.new_added_bed,0) "NewAddedBed",
coalesce(hwad.total_ventilator,0) "TotalVentilator",
coalesce(hwad.new_added_ppe,0) "NewAddedPPE",
coalesce(hwad.new_ppe,0) "NewPPE",
coalesce(hwad.consumed_ppe,0) "ConsumedPPE",
coalesce(case when hwad.total_ventilator = 0 then 0 else  round(cast((((hwad.on_vantiltor_cases)*100/cast((hwad.total_ventilator) as float))) as numeric),2) end,0) as "VentilatorRatio",
coalesce(hwad.occupied_ventilator,0) "OccupiedVentilator",
coalesce(hwad.available_ventilator,0) "AvailableVentilator",
coalesce(hwad.new_added_ventilator,0) "NewAddedVentilator"
from covid19_healthinfra_wise_analytics_details hwad', 
null, 
true, 'ACTIVE');