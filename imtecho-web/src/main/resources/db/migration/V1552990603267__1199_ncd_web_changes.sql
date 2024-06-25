--insert query master for type retrival
delete from query_master  where code='health_infra_retrival_by_type';
INSERT INTO public.query_master(
             
            query, returns_result_set, state, description, created_by, created_on, code, params)
    VALUES ('select h.id as id , h.name as name from health_infrastructure_details h where h.type=#type#', true, 'ACTIVE', 
'Basic Health Infrastructure retrival list according to type', 1, now(), 'health_infra_retrival_by_type','type'
           );
--added column
/*ALTER TABLE public.ncd_member_referral
  ADD COLUMN health_infrastructure_id bigint;*/
--Migration script for referred_from and referred_to changed for accomodating health infrastructure id
Update ncd_member_referral
 set referred_from=(
case when referred_from='PHC' then 'P'
 when referred_from='CHC' then 'C'
 when referred_from='DIST_HOSP'then 'D' end),
 referred_to=(
 case when referred_to='PHC' then 'P'
 when referred_to='CHC' then 'C'
 when referred_to='DIST_HOSP'then 'D' end
 )
 where id in (
 select id from ncd_member_referral  where referred_from IN('PHC','CHC','DIST_HOSP') or referred_to IN('PHC','CHC','DIST_HOSP'));
--Updated menu config with rights
UPDATE public.menu_config
   SET feature_json='{"canExamine":true}'
       
 WHERE navigation_state='techo.ncd.members({type:''P''})' or navigation_state='techo.ncd.members({type:''C''})' or navigation_state='techo.ncd.members({type:''D''})';
--Added Medicine
INSERT INTO public.medicine_master(
             name)
    VALUES ('Tablet Glipizide 5 mg');
--Audit fields updated
UPDATE public.medicine_master
   SET created_by=1, created_on=now();

--For ncd Attribute in the health infrastructure
ALTER TABLE public.health_infrastructure_details
  ADD COLUMN for_ncd boolean;

--scripts for health infra changes

delete from query_master where code='health_infrastructure_retrieve_by_id';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state,description)
values(1,now(),'health_infrastructure_retrieve_by_id','id','
with hd as (select health_infrastructure_details.id as id,health_infrastructure_details.type as type, health_infrastructure_details.name as name,
location_id as locationid,health_infrastructure_details.address as address, is_nrc as isnrc ,for_ncd as forncd,
 is_fru as isfru, is_cmtc as iscmtc,is_sncu as issncu,is_blood_bank as isbloodbank,
is_gynaec as isgynaec,is_pediatrician as ispediatrician,
is_cpconfirmationcenter as iscpconfirmationcenter,
(case when postal_code=''null'' then '''' else postal_code end)  as postalcode,
(case when landline_number=''null'' then '''' else landline_number end) as landlinenumber, 
(case when mobile_number=''null'' then '''' else mobile_number end) as mobilenumber,
(case when email=''null'' then '''' else email end) as email,
(case when name_in_english=''null'' then '''' else name_in_english end) as nameinenglish,
(case when latitude=''null'' then '''' else latitude end) as latitude,
(case when longitude=''null'' then '''' else longitude end) as longitude, 
emamta_id as emamtaid,
(case when nin=''null'' then '''' else nin end) as nin,
location_master.type as locationtype
 from  health_infrastructure_details,location_master   where health_infrastructure_details.location_id = location_master.id
 and health_infrastructure_details.id=#id#)
select * from hd h, (select child_id,string_agg(location_master.name,'' > '' order by depth desc) as locationname
from location_hierchy_closer_det,location_master, hd where child_id = hd.locationid
and location_master.id = location_hierchy_closer_det.parent_id
group by child_id) as t1
',true,'ACTIVE','Retrieve Health Infrastructure by id');


delete from query_master where code='health_infrastructure_update';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state,description)
values(1,now(),'health_infrastructure_update','type,name,isfru,issncu,ischiranjeevischeme,isbalsaka,ispmjy,address,lattitude,longitude,nin,emamtaid,postalcode,ispediatrician,nameinenglish,email,mobilenumber,landlinenumber,isbloodbank,isgynaec,iscpconfirmationcenter,isnrc,iscmtc,latitude,locationid','
UPDATE public.health_infrastructure_details
   SET type=#type#, name=''#name#'', location_id=#locationid#, 
for_ncd=#forncd#,
is_nrc=#isnrc#, is_cmtc=#iscmtc#, 
       is_fru=#isfru#, is_sncu=#issncu#, is_chiranjeevi_scheme=#ischiranjeevischeme#, is_balsaka=#isbalsaka#, is_pmjy=#ispmjy#, 
        address=''#address#'',
latitude=''#latitude#'', longitude=''#longitude#'', nin=''#nin#'', emamta_id=#emamtaid#, 
       is_blood_bank=#isbloodbank#, is_gynaec=#isgynaec#, is_pediatrician=#ispediatrician#, postal_code=''#postalcode#'', 
       landline_number=''#landlinenumber#'', mobile_number=''#mobilenumber#'', email=''#email#'', name_in_english=''#nameinenglish#'',
       is_cpconfirmationcenter=#iscpconfirmationcenter#

 WHERE id=#id#;',false,'ACTIVE','Update Health Infrastructure');

Delete from query_master 
where code='health_infrastructure_retrieval';

INSERT INTO public.query_master(
             created_by, created_on,  code, params, 
            query, returns_result_set, state, description)
    VALUES (1, now(), 'health_infrastructure_retrieval','locationId,type,limit,offset,name', 
'
with hospital_data as(SELECT type as hospitalType, name as name, location_id as locationid, is_blood_bank as isBloodBank, is_gynaec as isGynaec, is_pediatrician as ispediatrician,
for_ncd as forncd,
 is_nrc as isNrc, is_cmtc as isCmtc, is_fru as isFru, is_sncu as isScnu,  is_chiranjeevi_scheme as isChiranjeeviScheme, is_balsaka as isBalsaka, is_pmjy as isPmjy, id as id, address as address,is_cpconfirmationcenter as isconfirmationcenter
 FROM public.health_infrastructure_details
  where (location_id IN (select d.child_id from location_master  m,
 location_hierchy_closer_det d where m.id=d.child_id and (''#locationId#''= ''null'' or parent_id in (#locationId#))
 order by depth asc
 ) or ''#locationId#'' = ''null'' or ''#locationId#'' = '''') and (''#name#'' = ''null'' or name ilike ''%#name#%'')
and (''#type#'' = ''null'' or type = #type#)
  limit #limit# offset #offset#
)
select string_agg(location_master.name,'' > '' order by depth desc) as locationname,hospitalType,locationId, isNrc,  isCmtc,  isFru,  forncd,isScnu,hospital_data.name, isBloodBank, isGynaec, ispediatrician
 ,   isChiranjeeviScheme, isBalsaka, isPmjy,  hospital_data.id, 
 isconfirmationcenter,hospital_data.address from hospital_data,location_hierchy_closer_det,location_master
  
  where location_hierchy_closer_det.child_id = hospital_data.locationid
and location_master.id = location_hierchy_closer_det.parent_id
	group by hospitalType,locationid, isNrc,  isCmtc,  isFru,  isScnu,hospital_data.name
 ,   isChiranjeeviScheme, isBalsaka, isPmjy,  hospital_data.id, hospital_data.address,  isBloodBank, isGynaec, forncd,ispediatrician,isconfirmationcenter',
true,'ACTIVE','Retrieve health infrastructures');

delete from query_master where code='health_infrastructure_create';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state,description)
values(1,now(),'health_infrastructure_create','type,name,isfru,issncu,ischiranjeevischeme,isbalsaka,ispmjy,address,lattitude,longitude,nin,emamtaid,postalcode,ispediatrician,nameinenglish,email,mobilenumber,landlinenumber,isbloodbank,isgynaec,iscpconfirmationcenter,isnrc,iscmtc,latitude,locationid','
INSERT INTO public.health_infrastructure_details(
            type, name, location_id, is_nrc, is_cmtc, is_fru, is_sncu, for_ncd,

            is_chiranjeevi_scheme, is_balsaka, is_pmjy,  address,latitude, 
            longitude, nin, emamta_id, is_blood_bank, is_gynaec, is_pediatrician, 
            postal_code, landline_number, mobile_number, email, name_in_english,is_cpconfirmationcenter)
    VALUES (#type#,''#name#'',#locationid#,#isnrc#,#iscmtc#,#isfru#,#issncu#,#forncd#,
#ischiranjeevischeme#,#isbalsaka#,#ispmjy#,''#address#'',''#latitude#'',''#longitude#'',''#nin#'',#emamtaid#,#isbloodbank#,
#isgynaec#,#ispediatrician#,''#postalcode#'',''#landlinenumber#'',''#mobilenumber#'',''#email#'',''#nameinenglish#'',#iscpconfirmationcenter#
);',false,'ACTIVE','Add health infrastructure details');

--Added column for follow up
ALTER TABLE public.ncd_member_disesase_followup
  ADD COLUMN health_infrastructure_id bigint;


