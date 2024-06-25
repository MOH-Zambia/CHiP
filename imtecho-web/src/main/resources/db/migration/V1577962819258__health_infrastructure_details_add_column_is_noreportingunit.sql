ALTER TABLE health_infrastructure_details ADD COLUMN is_no_reporting_unit BOOLEAN;

update query_master
    set query = 'with hd as (select health_infrastructure_details.id as id,health_infrastructure_details.type as type, health_infrastructure_details.name as name,
location_id as locationid,health_infrastructure_details.address as address, is_nrc as isnrc ,for_ncd as forncd,is_hwc as ishwc,
 is_fru as isfru, is_cmtc as iscmtc,is_sncu as issncu,is_blood_bank as isbloodbank,
is_gynaec as isgynaec,is_pediatrician as ispediatrician,
is_cpconfirmationcenter as iscpconfirmationcenter,
is_chiranjeevi_scheme as "ischiranjeevischeme",
is_balsakha1 as "isBalsakha1",
is_balsakha3 as "isBalsakha3",
is_usg_facility as "isUsgFacility",
is_referral_facility as "isReferralFacility",
is_ma_yojna as "isMaYojna",
is_pmjy as "ispmjy",
is_npcb as "isNpcb",
is_no_reporting_unit as "isNoReportingUnit",
no_of_beds as "noOfBeds",
(case when postal_code=''null'' then '' else postal_code end)  as postalcode,
(case when landline_number=''null'' then '' else landline_number end) as landlinenumber, 
(case when mobile_number=''null'' then '' else mobile_number end) as mobilenumber,
(case when email=''null'' then '' else email end) as email,
(case when name_in_english=''null'' then '' else name_in_english end) as nameinenglish,
(case when latitude=''null'' then '' else latitude end) as latitude,
(case when longitude=''null'' then '' else longitude end) as longitude, 
emamta_id as emamtaid,
(case when nin=''null'' then '' else nin end) as nin,
location_master.type as locationtype,
health_infrastructure_details.created_by,
health_infrastructure_details.created_on
 from  health_infrastructure_details,location_master   where health_infrastructure_details.location_id = location_master.id
 and health_infrastructure_details.id=#id#)
select * from hd h, (select child_id,string_agg(location_master.name,' > ' order by depth desc) as locationname
from location_hierchy_closer_det,location_master, hd where child_id = hd.locationid
and location_master.id = location_hierchy_closer_det.parent_id
group by child_id) as t1'
where code = 'health_infrastructure_retrieve_by_id';



update query_master
set
params = 'issncu,isfru,ispmjy,mobilenumber,emamtaid,latitude,isnrc,isBalsakha3,isgynaec,ispediatrician,noOfBeds,isNoReportingUnit,type,isNpcb,isbalsaka,isMaYojna,nin,postalcode,email,longitude,address,isbloodbank,nameinenglish,iscpconfirmationcenter,iscmtc,createdBy,locationid,landlinenumber,isBalsakha1,isReferralFacility,name,forncd,isUsgFacility,ischiranjeevischeme,ishwc', 
query = 'INSERT INTO public.health_infrastructure_details(
            type, name, location_id, is_nrc, is_cmtc, is_fru, is_sncu, for_ncd,is_hwc,
            is_chiranjeevi_scheme, is_balsaka, is_pmjy,  address,latitude, 
            longitude, nin, emamta_id, is_blood_bank, is_gynaec, is_pediatrician, 
            postal_code, landline_number, mobile_number, email, name_in_english,is_cpconfirmationcenter,created_by,created_on,state,
modified_on,modified_by,is_balsakha1,is_balsakha3,is_usg_facility,is_referral_facility,is_ma_yojna,is_npcb,is_no_reporting_unit,no_of_beds)
    VALUES (#type#,''#name#'',#locationid#,#isnrc#,#iscmtc#,#isfru#,#issncu#,#forncd#,#ishwc#,
#ischiranjeevischeme#,#isbalsaka#,#ispmjy#,''#address#'',''#latitude#'',''#longitude#'',''#nin#'',#emamtaid#,#isbloodbank#,
#isgynaec#,#ispediatrician#,''#postalcode#'',''#landlinenumber#'',''#mobilenumber#'',''#email#'',''#nameinenglish#'',#iscpconfirmationcenter#,#createdBy#,now(),''ACTIVE'',
now(),#createdBy#,#isBalsakha1#,#isBalsakha3#,#isUsgFacility#,#isReferralFacility#,#isMaYojna#,#isNpcb#,#isNoReportingUnit#,#noOfBeds#
)'
where code = 'health_infrastructure_create';


update query_master
set 
params = 'issncu,isfru,ispmjy,mobilenumber,emamtaid,latitude,isnrc,isBalsakha3,isgynaec,ispediatrician,noOfBeds,isNoReportingUnit,type,isNpcb,isbalsaka,isMaYojna,nin,postalcode,modifiedBy,id,email,longitude,address,isbloodbank,created_by,nameinenglish,iscpconfirmationcenter,iscmtc,created_on,locationid,landlinenumber,isBalsakha1,isReferralFacility,name,forncd,isUsgFacility,ischiranjeevischeme,ishwc',
query = 'UPDATE public.health_infrastructure_details
   SET type=#type#, name=''#name#'', location_id=#locationid#, 
for_ncd=#forncd#,
is_nrc=#isnrc#, is_cmtc=#iscmtc#, 
       is_fru=#isfru#, is_sncu=#issncu#,is_hwc=#ishwc# ,is_chiranjeevi_scheme=#ischiranjeevischeme#, is_balsaka=#isbalsaka#, is_pmjy=#ispmjy#, 
        address=''#address#'',
latitude=''#latitude#'', longitude=''#longitude#'', nin=''#nin#'', emamta_id=#emamtaid#, 
       is_blood_bank=#isbloodbank#, is_gynaec=#isgynaec#, is_pediatrician=#ispediatrician#, postal_code=''#postalcode#'', 
       landline_number=''#landlinenumber#'', mobile_number=''#mobilenumber#'', email=''#email#'', name_in_english=''#nameinenglish#'',
       is_cpconfirmationcenter=#iscpconfirmationcenter#,
       created_by=#created_by#,
created_on=''#created_on#'',
modified_on=now(),
modified_by=#modifiedBy#,
is_balsakha1=#isBalsakha1#,
is_balsakha3=#isBalsakha3#,
is_usg_facility=#isUsgFacility#,
is_referral_facility=#isReferralFacility#,
is_ma_yojna=#isMaYojna#,
is_npcb=#isNpcb#,
is_no_reporting_unit=#isNoReportingUnit#,
no_of_beds=#noOfBeds#
WHERE id=#id#'
where code = 'health_infrastructure_update';

update query_master
set 
query = '---------cm_dashboard_opd_ipd_report---------
 with healthinfradet as (
select
	health_infrastructure_details.id,
	listvalue.value,
	health_infrastructure_details.location_id as locid,
	health_infrastructure_details.name,
	l1.english_name as district,
	l1.location_code as dcode,
	l2.english_name as taluka,
	l2.location_code as tcode
from
	health_infrastructure_details
inner join listvalue_field_value_detail listvalue on
	health_infrastructure_details.type = listvalue.id
	and listvalue.value in (''PHC'',
	''UPHC'',
	''Community Health Center''
	,''Urban Community Health Center''
	,''District Hospital''
	,''Sub District Hospital''
	,''Medical College Hospital'')
    and health_infrastructure_details.is_no_reporting_unit is not true
left join location_hierchy_closer_det dis on
	health_infrastructure_details.location_id = dis.child_id
	and dis.parent_loc_type in (''D'',
	''C'')
left join location_master l1 on
	dis.parent_id = l1.id
left join location_hierchy_closer_det tal on
	health_infrastructure_details.location_id = tal.child_id
	and tal.parent_loc_type in (''B'',
	''Z'')
left join location_master l2 on
	tal.parent_id = l2.id 
where l1.name not ilike ''%delete%''
and (l2.name is null or l2.name not ilike ''%delete%'')),
fpdetails as (
select
	fpm.health_infrastrucutre_id as hid,
	fpm.no_of_opd_attended,
	fpm.no_of_ipd_attended,
	fpm.no_of_deliveres_conducted,
	fpm.no_of_csection_conducted,
	fpm.no_of_major_operation_conducted,
	fpm.no_of_minor_operation_conducted,
	fpm.no_of_laboratory_test_conducted,
	fpm.performance_date
from
	facility_performance_master fpm
where
	performance_date = cast(''#performanceDate#'' as date) ) select
	healthinfradet.dcode as "Dist_cd",
	healthinfradet.district as "Dist_Name",
	healthinfradet.tcode as "Tcode",
	coalesce(healthinfradet.taluka, ''N/A'') as "Tal_Name",
	healthinfradet.name as "Facility_Name",
	case
		when healthinfradet.value = ''PHC'' then 1
		when healthinfradet.value = ''UPHC'' then 3
		when healthinfradet.value in (''Community Health Center'',''Urban Community Health Center'') then 4
		when healthinfradet.value in (''Sub District Hospital'') then 5
		when healthinfradet.value in (''District Hospital'',''Medical College Hospital'') then 6
	end as "Facility_Type",
	coalesce(fpdetails.no_of_opd_attended, 0) as "No_Of_OPDs",
	coalesce(fpdetails.no_of_ipd_attended, 0) as "No_of_IPDs",
	coalesce(fpdetails.no_of_deliveres_conducted, 0) as "No_of_deliveries_conducted_at_facility",
	coalesce(fpdetails.no_of_csection_conducted, 0) as "No_of_c_section_conducted_at_facility",
	coalesce(fpdetails.no_of_major_operation_conducted, 0) as "No_of_Major_operations_conducted_at_facility",
	coalesce(fpdetails.no_of_minor_operation_conducted, 0) as "No_of_Minor_operations_conducted_at_facility",
	coalesce(fpdetails.no_of_laboratory_test_conducted, 0) as "No_of_laboratory_tests_conducted_at_facility",
	to_char(fpdetails.performance_date, ''MM/dd/yyyy'') as "Date"
from
	healthinfradet
left join fpdetails on
	healthinfradet.id = fpdetails.hid'
where code = 'cm_dashboard_opd_ipd_report';