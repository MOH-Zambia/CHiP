DELETE FROM query_master where code='health_infrastructure_retrieval';

INSERT INTO public.query_master
(created_by, created_on, code, params, query, returns_result_set, state, description)
VALUES(1, now(), 'health_infrastructure_retrieval', 'offset,locationId,name,limit,type', 'with hospital_data as
(
	SELECT type as hospitalType,
	name as name,
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
 	id as id,
 	address as address,
 	is_cpconfirmationcenter as isconfirmationcenter,
 	is_balsakha1 as isBalsakha1,
 	is_balsakha3 as isBalsakha3,
 	is_usg_facility as isUsgFacility,
 	is_referral_facility as isReferralFacility,
 	is_ma_yojna as isMaYojna,
 	is_npcb as isNpcb,
	is_no_reporting_unit as isNoReportingUnit
 	FROM public.health_infrastructure_details
  	where 
  		(location_id IN (select d.child_id from location_master  m,
 		location_hierchy_closer_det d where m.id=d.child_id and (''#locationId#''= ''null'' or parent_id in (#locationId#))
 		order by depth asc) 
 		or ''#locationId#'' = ''null'' or ''#locationId#'' = '''') and (''#name#'' = ''null'' or name ilike ''%#name#%'')
	and (''#type#'' = ''null'' or type = #type#)
  	limit #limit# offset #offset#
)
select string_agg(location_master.name,'' > '' order by depth desc) as locationname,
hospitalType,
locationId,
isNrc,
isCmtc,
isFru,
forncd,
isSncu,
isHwc,
hospital_data.name,
isBloodBank,
isGynaec,
ispediatrician,
ischiranjeevischeme,
isBalsaka,
ispmjy,
isBalsakha1,
isBalsakha3,
isUsgFacility,
isReferralFacility,
isMaYojna,
isNpcb,
isNoReportingUnit,
hospital_data.id, 
isconfirmationcenter,
hospital_data.address
from hospital_data,location_hierchy_closer_det,location_master
where location_hierchy_closer_det.child_id = hospital_data.locationid
and location_master.id = location_hierchy_closer_det.parent_id
group by hospitalType,locationid, isNrc,  isCmtc,  isFru,  isSncu, isHwc,hospital_data.name,
ischiranjeevischeme,isBalsaka,ispmjy,hospital_data.id,hospital_data.address,isBloodBank,isGynaec,forncd,ispediatrician,isconfirmationcenter,
isBalsakha1,isBalsakha3,isUsgFacility,isReferralFacility,isMaYojna,isNpcb, isNoReportingUnit', true, 'ACTIVE', 'Retrieve health infrastructures');
