DELETE FROM QUERY_MASTER WHERE CODE='health_infrastructure_retrieval';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'45330558-bae8-41d7-9525-938469640fb3', 60512,  current_date , 60512,  current_date , 'health_infrastructure_retrieval',
'offset,locationId,name,limit,type',
'select type as hospitalType,
name as name,
get_location_hierarchy(location_id) as locationname,
location_id as locationid,
is_blood_bank as isBloodBank,
is_gynaec as isGynaec,
is_pediatrician as ispediatrician,
for_ncd as forncd,
is_nrc as isNrc,
is_cmtc as isCmtc,
is_fru as isFru,
is_sncu as isSncu,
is_hwc as isHwc,
is_chiranjeevi_scheme as ischiranjeevischeme,
is_balsaka as isBalsaka,
is_pmjy as ispmjy,
is_idsp as isidsp,
id as id,
address as address,
is_cpconfirmationcenter as isconfirmationcenter,
is_balsakha1 as isBalsakha1,
is_balsakha3 as isBalsakha3,
is_usg_facility as isUsgFacility,
is_referral_facility as isReferralFacility,
is_ma_yojna as isMaYojna,
is_npcb as isNpcb,
is_no_reporting_unit as isNoReportingUnit,
is_covid_hospital as isCovidHospital,
is_covid_lab as isCovidLab,
has_ventilators as hasVentilators,
has_defibrillators as hasDefibrillators,
has_oxygen_cylinders as hasOxygenCylinders,
hfr_facility_id as hfrFacilityId
from health_infrastructure_details
where (
	#locationId# is null
	or location_id in (
		select child_id
		from location_hierchy_closer_det
		where parent_id = #locationId#
	)
)
and (
	#name# is null
	or #name# = ''''
	or #name# = ''null''
	or name ilike ''%#name#%''
)
and (
	#type# is null
	or type = #type#
)
order by state,id
limit #limit# offset #offset#',
'Retrieve health infrastructures',
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='my_health_infrastructure_retrieval';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state, uuid )
VALUES (
1,  current_date , 1,  current_date , 'my_health_infrastructure_retrieval',
'offset,limit,loggedInUserId',
'
    select
    hid.hfr_facility_id as hfrFacilityId,
    hid.*,
    get_location_hierarchy(hid.location_id) as "locationHierarchy"
    from user_health_infrastructure uhi
    inner join health_infrastructure_details hid on uhi.health_infrastrucutre_id = hid.id
    where uhi.user_id = #loggedInUserId#
    and uhi.state = ''ACTIVE''
    limit #limit# offset #offset#
',
'Retrieve My Health Infrastructures',
true, 'ACTIVE', '3b1c4098-14e4-4418-b33f-34e9fd2864f2');