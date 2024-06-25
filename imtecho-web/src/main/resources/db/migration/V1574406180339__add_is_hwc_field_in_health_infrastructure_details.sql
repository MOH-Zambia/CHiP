update menu_config
set feature_json = '{"canAdd":true,"canEditBloodBank":true,"canEdit":true,"canChangeLocation":true,"canEditFru":true,"canEditPediatrician":true,"canEditCmtc":true,"canEditNrc":true,"canEditGynaec":true,"canEditSncu":true,"canEditChiranjeevi":false,"canEditBalsakha1":false,"canEditBalsakha3":false,"canEditUsgFacility":false,"canEditReferralFacility":false,"canEditMaYojna":false,"canEditPmjayFacility":false,"canEditNpcb":false,"canEditNcd":false,"canEditHWC":false}'
where menu_name = 'Health Facility Mapping';

ALTER TABLE health_infrastructure_details 
DROP COLUMN IF EXISTS is_hwc ;

ALTER TABLE health_infrastructure_details 
ADD COLUMN is_hwc boolean;

update query_master set params = 'issncu,isfru,ispmjy,mobilenumber,emamtaid,latitude,isnrc,isBalsakha3,isgynaec,ispediatrician,noOfBeds,type,isNpcb,isbalsaka,isMaYojna,nin,postalcode,email,longitude,address,isbloodbank,nameinenglish,iscpconfirmationcenter,iscmtc,createdBy,locationid,landlinenumber,isBalsakha1,isReferralFacility,name,forncd,isUsgFacility,ischiranjeevischeme,ishwc' , 
 query = 'INSERT INTO public.health_infrastructure_details(
            type, name, location_id, is_nrc, is_cmtc, is_fru, is_sncu, for_ncd,is_hwc,
            is_chiranjeevi_scheme, is_balsaka, is_pmjy,  address,latitude, 
            longitude, nin, emamta_id, is_blood_bank, is_gynaec, is_pediatrician, 
            postal_code, landline_number, mobile_number, email, name_in_english,is_cpconfirmationcenter,created_by,created_on,state,
modified_on,modified_by,is_balsakha1,is_balsakha3,is_usg_facility,is_referral_facility,is_ma_yojna,is_npcb,no_of_beds)
    VALUES (#type#,''#name#'',#locationid#,#isnrc#,#iscmtc#,#isfru#,#issncu#,#forncd#,#ishwc#,
#ischiranjeevischeme#,#isbalsaka#,#ispmjy#,''#address#'',''#latitude#'',''#longitude#'',''#nin#'',#emamtaid#,#isbloodbank#,
#isgynaec#,#ispediatrician#,''#postalcode#'',''#landlinenumber#'',''#mobilenumber#'',''#email#'',''#nameinenglish#'',#iscpconfirmationcenter#,#createdBy#,now(),''ACTIVE'',
now(),#createdBy#,#isBalsakha1#,#isBalsakha3#,#isUsgFacility#,#isReferralFacility#,#isMaYojna#,#isNpcb#,#noOfBeds#
);' 
where code = 'health_infrastructure_create';



update query_master set params = 'issncu,isfru,ispmjy,mobilenumber,emamtaid,latitude,isnrc,isBalsakha3,isgynaec,ispediatrician,noOfBeds,type,isNpcb,isbalsaka,isMaYojna,nin,postalcode,modifiedBy,id,email,longitude,address,isbloodbank,created_by,nameinenglish,iscpconfirmationcenter,iscmtc,created_on,locationid,landlinenumber,isBalsakha1,isReferralFacility,name,forncd,isUsgFacility,ischiranjeevischeme,ishwc' ,
 query='UPDATE public.health_infrastructure_details
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
no_of_beds=#noOfBeds#
WHERE id=#id#;'
where code = 'health_infrastructure_update'; 

update query_master set query = 'with hd as (select health_infrastructure_details.id as id,health_infrastructure_details.type as type, health_infrastructure_details.name as name,
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
no_of_beds as "noOfBeds",
(case when postal_code=''null'' then '''' else postal_code end)  as postalcode,
(case when landline_number=''null'' then '''' else landline_number end) as landlinenumber, 
(case when mobile_number=''null'' then '''' else mobile_number end) as mobilenumber,
(case when email=''null'' then '''' else email end) as email,
(case when name_in_english=''null'' then '''' else name_in_english end) as nameinenglish,
(case when latitude=''null'' then '''' else latitude end) as latitude,
(case when longitude=''null'' then '''' else longitude end) as longitude, 
emamta_id as emamtaid,
(case when nin=''null'' then '''' else nin end) as nin,
location_master.type as locationtype,
health_infrastructure_details.created_by,
health_infrastructure_details.created_on
 from  health_infrastructure_details,location_master   where health_infrastructure_details.location_id = location_master.id
 and health_infrastructure_details.id=#id#)
select * from hd h, (select child_id,string_agg(location_master.name,'' > '' order by depth desc) as locationname
from location_hierchy_closer_det,location_master, hd where child_id = hd.locationid
and location_master.id = location_hierchy_closer_det.parent_id
group by child_id) as t1'
where code = 'health_infrastructure_retrieve_by_id';

update query_master set query = 'with hospital_data as
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
 	is_sncu as isScnu,
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
 	is_npcb as isNpcb
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
isScnu,
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
hospital_data.id, 
isconfirmationcenter,
hospital_data.address
from hospital_data,location_hierchy_closer_det,location_master
where location_hierchy_closer_det.child_id = hospital_data.locationid
and location_master.id = location_hierchy_closer_det.parent_id
group by hospitalType,locationid, isNrc,  isCmtc,  isFru,  isScnu, isHwc,hospital_data.name,
ischiranjeevischeme,isBalsaka,ispmjy,hospital_data.id,hospital_data.address,isBloodBank,isGynaec,forncd,ispediatrician,isconfirmationcenter,
isBalsakha1,isBalsakha3,isUsgFacility,isReferralFacility,isMaYojna,isNpcb
'
where code = 'health_infrastructure_retrieval';