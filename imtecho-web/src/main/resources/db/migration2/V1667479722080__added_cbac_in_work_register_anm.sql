
--change rch_member_services event


DELETE FROM QUERY_MASTER WHERE CODE='mob_work_register_detail';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'0b0c0b87-4e79-4791-ba46-6fef54f4ba86', 97072,  current_date , 97072,  current_date , 'mob_work_register_detail', 
'from_date,to_date,offset,limit,location_id', 
'with loc as (
	select child_id as loc_id from location_hierchy_closer_det where parent_id = #location_id#
), dates as (
	select to_date(case when ''#from_date#'' = ''null'' then null else ''#from_date#'' end,''MM/DD/YYYY'') as from_date,
	to_date(case when ''#to_date#'' = ''null'' then null else ''#to_date#'' end,''MM/DD/YYYY'') + interval ''1 day'' - interval ''1 millisecond'' as to_date
), service_type as (
	select ''FHW_LMP'' as type, ''LMP Follow Up'' as name
	union
	select ''FHW_ANC'', ''ANC''
	union
	select ''FHW_MOTHER_WPD'', ''WPD''
	union
	select ''FHW_PNC'', ''PNC''
	union
	select ''FHW_CS'', ''Child Service''
	union
	select ''NCD_HYPERTENSION'', ''Hypertension Screening''
	union
	select ''NCD_DIABETES'', ''Diabetes Screening''
	union
	select ''NCD_ORAL'', ''Oral Screening''
	union
	select ''NCD_BREAST'', ''Breast Screening''
	union
	select ''NCD_CERVICAL'', ''Cervical Screening''
	union
	select ''COWIN_REGISTRATION'', ''CoWIN Registration''
	union
	select ''COWIN_APPOINTMENT'', ''CoWIN Appointment''
	union
	select ''NCD_CBAC'', ''CBAC Entry''
), det as (
	select * from rch_member_services
	inner join loc on rch_member_services.location_id = loc.loc_id
	inner join dates on rch_member_services.service_date between dates.from_date and dates.to_date
	order by service_date desc
	limit #limit# offset #offset#
)
select
to_char(det.service_date, ''DD/MM/YYYY'') as "Service Date",
service_type.name as "Service Provided",
case when service_type.type in (''COWIN_REGISTRATION'', ''COWIN_APPOINTMENT'') then
concat(cmm.first_name, '' '', cmm.middle_name, '' '', cmm.last_name)
else concat(m.first_name, '' '', m.middle_name, '' '', m.last_name) end as "Member Name",
case when service_type.type in (''COWIN_REGISTRATION'', ''COWIN_APPOINTMENT'') then
''N/A'' else m.unique_health_id end as "Health Id",
case when service_type.type in (''COWIN_REGISTRATION'', ''COWIN_APPOINTMENT'') then
''N/A'' else m.family_id end as "Family Id",
det.service_type as "hiddenServiceType",
det.visit_id as "hiddenVisitId"
from det
left join imt_member m on m.id = det.member_id
left join cowin_member_master cmm on cmm.id = det.member_id
inner join service_type on det.service_type = service_type.type', 
null, 
true, 'ACTIVE');