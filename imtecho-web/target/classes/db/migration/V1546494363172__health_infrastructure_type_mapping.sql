
CREATE TABLE IF not exists public.health_infrastructure_type_location
(
   id bigserial, 
   health_infra_type_id bigint, 
   location_level integer
) 
WITH (
  OIDS = FALSE
);


DELETE FROM public.query_master
 WHERE code='retrieve_location_level_for_infra_type';

INSERT INTO public.query_master(
            created_by, created_on, code, params, 
            query, returns_result_set, state, description)
    VALUES (1, now(),'retrieve_location_level_for_infra_type', '', 
            'select location_level as level, health_infra_type_id as infraid from health_infrastructure_type_location ', true, 'ACTIVE', 'Retrieves location level allowed for all health type');
/*
New fields added
*/
ALTER TABLE public.health_infrastructure_details
  ADD COLUMN latitude character varying(100);
ALTER TABLE public.health_infrastructure_details
  ADD COLUMN longitude character varying(100);
ALTER TABLE public.health_infrastructure_details
  ADD COLUMN nin character varying(100);
ALTER TABLE public.health_infrastructure_details
  ADD COLUMN emamta_id bigint;
ALTER TABLE public.health_infrastructure_details
  ADD COLUMN is_blood_bank boolean;
ALTER TABLE public.health_infrastructure_details
  ADD COLUMN is_gynaec boolean;
ALTER TABLE public.health_infrastructure_details
  ADD COLUMN is_pediatrician boolean;
ALTER TABLE public.health_infrastructure_details
  ADD COLUMN postal_code character varying(100);
ALTER TABLE public.health_infrastructure_details
  ADD COLUMN landline_number character varying(100);
ALTER TABLE public.health_infrastructure_details
  ADD COLUMN mobile_number character varying(100);
ALTER TABLE public.health_infrastructure_details
  ADD COLUMN email character varying(256);
ALTER TABLE public.health_infrastructure_details
  ADD COLUMN name_in_gujarati character varying(1000);

delete from query_master where code= 'health_infrastructure_retrieve_by_id';
insert into query_master(created_by,created_on,code,params,query,returns_result_set,state,description)
values(1,now(),'health_infrastructure_retrieve_by_id','id','
with hd as (select select id as id,type as type, name as name,location_id as locationid,address as address, is_nrc as isnrc , is_fru as isfru, is_cmtc as iscmtc,is_sncu as issncu,is_blood_bank as isbloodbank,is_gynaec as isgynaec,is_pediatrician as ispediatrician, postal_code as postalcode,landline_number as landlinenumber, mobile_number as mobilenumber,email as email,name_in_gujarati as nameingujarati,latitude as latitude,longitude as longitude, emamta_id as emamtaid, nin as nin from  health_infrastructure_details where id=#id#)
select * from hd h, (select child_id,string_agg(location_master.name,'' > '' order by depth desc) as locationname
from location_hierchy_closer_det,location_master, hd where child_id = hd.locationid
and location_master.id = location_hierchy_closer_det.parent_id
group by child_id) as t1',true,'ACTIVE','Retrieve Health Infrastructure by id');

delete from query_master where code='health_infrastructure_update';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state,description)
values(1,now(),'health_infrastructure_update','issncu,isfru,iscmtc,ispmjy,address,locationid,name,isnrc,id,type,ischiranjeevischeme,isbalsaka','
UPDATE public.health_infrastructure_details
   SET hospital_type=''#type#'', name=''#name#'', location_id=#locationid#, is_nrc=#isnrc#, is_cmtc=#iscmtc#, 
       is_fru=#isfru#, is_sncu=#issncu#, is_chiranjeevi_scheme=#ischiranjeevischeme#, is_balsaka=#isbalsaka#, is_pmjy=#ispmjy#, 
        address=''#address#'',
latitude=''#latitude#'', longitude=''#longitude#'', nin=''#nin#'', emamta_id=#emamtaid#, 
       is_blood_bank=#isbloodbank#, is_gynaec=#isgynaec#, is_pediatrician=#ispediatrician#, postal_code=''#postalcode#'', 
       landline_number=''#landlinenumber#'', mobile_number=''#mobilenumber#'', email=''#email#'', name_in_gujarati=''#nameingujarati#''


 WHERE id=#id#;',false,'ACTIVE','Update Health Infrastructure');

delete from query_master where code='health_infrastructure_retrieval';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state,description)
values(1,now(),'health_infrastructure_retrieval','locationId,type,name,limit,offset','
with hospital_data as(SELECT hospital_type as hospitalType, name as name, location_id as locationId,
 is_nrc as isNrc, is_cmtc as isCmtc, is_fru as isFru, is_sncu as isScnu,  is_chiranjeevi_scheme as isChiranjeeviScheme, is_balsaka as isBalsaka, is_pmjy as isPmjy, id as id, address as address
	,concat_ws('' ,'',CASE WHEN (is_sncu ) THEN ''SCNU Available'' ELSE null END ,
	CASE WHEN (is_nrc ) THEN ''Nrc Available'' ELSE null END ,
	CASE WHEN (is_pmjy ) THEN ''PMJY Available'' ELSE null END
		,CASE WHEN (is_cmtc ) THEN ''CMTC Available'' ELSE null END 
		,CASE WHEN (is_fru ) THEN ''FRU Available'' ELSE null END 
		,CASE WHEN (is_chiranjeevi_scheme ) THEN ''Chiranjeevi Scheme Available'' ELSE null END 
		,CASE WHEN (is_balsaka ) THEN ''Balasaka Available'' ELSE null END ,
CASE WHEN (is_pediatrician ) THEN ''Full Time Pediatrician Available'' ELSE null END,
CASE WHEN (is_gynaec ) THEN ''Full Time Gynaecologist Available'' ELSE null END,
CASE WHEN (is_blood_bank ) THEN ''Blood Bank Available'' ELSE null END
	 

	 ) as facilities


  FROM public.health_infrastructure_details
  where (location_id= #locationId# or ''#locationId#'' = ''null'' or ''#locationId#'' = '''') and (''#name#'' = ''null'' or name ilike ''%#name#%'')
and (''#type#'' = ''null'' or hospital_type = ''#type#'')
  limit #limit# offset #offset#
)
select string_agg(location_master.name,'' > '' order by depth desc) as locationname,hospitalType,locationId,facilities, isNrc,  isCmtc,  isFru,  isScnu,hospital_data.name
 ,   isChiranjeeviScheme, isBalsaka, isPmjy,  hospital_data.id, hospital_data.address from hospital_data,location_hierchy_closer_det,location_master
  
  where location_hierchy_closer_det.child_id = hospital_data.locationid
and location_master.id = location_hierchy_closer_det.parent_id
	group by hospitalType,locationId,facilities, isNrc,  isCmtc,  isFru,  isScnu,hospital_data.name
 ,   isChiranjeeviScheme, isBalsaka, isPmjy,  hospital_data.id, hospital_data.address
',true,'ACTIVE','Retrieve health infrastructures');

delete from query_master where code='health_infrastructure_create';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state,description)
values(1,now(),'health_infrastructure_create','issncu,isfru,iscmtc,ispmjy,address,locationid,name,isnrc,type,ischiranjeevischeme,isbalsaka','
INSERT INTO public.health_infrastructure_details(
            hospital_type, name, location_id, is_nrc, is_cmtc, is_fru, is_sncu, 
            is_chiranjeevi_scheme, is_balsaka, is_pmjy,  address,latitude, 
            longitude, nin, emamta_id, is_blood_bank, is_gynaec, is_pediatrician, 
            postal_code, landline_number, mobile_number, email, name_in_gujarati)
    VALUES (''#type#'',''#name#'',#locationid#,#isnrc#,#iscmtc#,#isfru#,#issncu#,
#ischiranjeevischeme#,#isbalsaka#,#ispmjy#,''#address#'',''#latitude#'',''#longitude#'',''#nin#'',#emamtaid#,#isbloodbank#,
#isgynaec#,#ispediatrician#,''#postalcode#'',''#landlinenumber#'',''#mobilenumber#'',''#email#'',''#nameingujarati#''
);',false,'ACTIVE','Add health infrastructure details');

/*
INSERT INTO public.listvalue_field_value_detail(
            is_active, is_archive, last_modified_by,last_modified_on,file_size,
            value, field_key, code)
    VALUES (true, false,'superadmin',now(), 0 ,
            'PHC', 'infra_type', 'P');

INSERT INTO public.listvalue_field_value_detail(
            is_active, is_archive,  last_modified_by,last_modified_on,file_size,
            value, field_key, code)
    VALUES (true, false,  'superadmin',now(),0,
            'SC', 'infra_type', 'SC');

INSERT INTO public.listvalue_field_value_detail(
            is_active, is_archive,  last_modified_by,last_modified_on,file_size,
            value, field_key, code)
    VALUES (true, false, 'superadmin',now(),0,
            'UPHC', 'infra_type', 'U');
*/

UPDATE public.menu_config
   SET feature_json ='{
   "canAdd":true,"canEditBloodBank":true,"canEdit":true,"canChangeLocation":true,"canEditFru":true,"canEditPediatrician":true,"canEditCmtc":true,"canEditNrc":true,"canEditGynaec":true,"canEditSncu":true}',
menu_name='Health Facility Mapping'
 where navigation_state='techo.manage.healthinfrastructures';