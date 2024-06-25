ALTER TABLE public.health_infrastructure_details
  DROP COLUMN IF EXISTS  hospital_type;
ALTER TABLE public.health_infrastructure_details
  ADD COLUMN type bigint;

ALTER TABLE public.role_health_infrastructure RENAME health_infrastructure_id  TO health_infrastructure__type_id;
ALTER TABLE public.role_health_infrastructure
  RENAME TO role_health_infrastructure_type;

delete from listvalue_form_master where form_key = 'WEB';
INSERT INTO public.listvalue_form_master(
           form_key, form, is_active, is_training_req, query_for_training_completed)
   VALUES ('WEB','WEB',TRUE,FALSE,null);

delete from listvalue_field_master where field_key = 'infra_type';
INSERT INTO public.listvalue_field_master(
           field_key, field, is_active, field_type, form, role_type)
VALUES ('infra_type','Health Infrastructure Type',TRUE,'T','WEB',null);

delete from query_master where code= 'retrieve_field_values_for_form_field';
INSERT INTO public.query_master(
             created_by, created_on,code, params, 
            query, returns_result_set, state, description)
    VALUES (1,now(), 'retrieve_field_values_for_form_field', 'form, fieldKey', 
            'select value as value , v.id as id from listvalue_field_master f , listvalue_field_value_detail  v
where f.field_key=v.field_key and f.form = ''#form#'' and v.field_key=''#fieldKey#''', true, 'ACTIVE', 'Retrieve field values for particular field key and form ');

delete from query_master where code='health_infrastructure_create';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state,description)
values(1,now(),'health_infrastructure_create','issncu,isfru,iscmtc,ispmjy,address,locationid,name,isnrc,type,ischiranjeevischeme,isbalsaka','
INSERT INTO public.health_infrastructure_details(
            type, name, location_id, is_nrc, is_cmtc, is_fru, is_sncu, 
            is_chiranjeevi_scheme, is_balsaka, is_pmjy,  address)
    VALUES (''#type#'',''#name#'',#locationid#,#isnrc#,#iscmtc#,#isfru#,#issncu#,
#ischiranjeevischeme#,#isbalsaka#,#ispmjy#,''#address#''
);',false,'ACTIVE','Add health infrastructure details');

delete from query_master where code='health_infrastructure_retrieval';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state,description)
values(1,now(),'health_infrastructure_retrieval','locationId,type,name,limit,offset','
with hospital_data as(SELECT type as hospitalType, name as name, location_id as locationId,
 is_nrc as isNrc, is_cmtc as isCmtc, is_fru as isFru, is_sncu as isScnu,  is_chiranjeevi_scheme as isChiranjeeviScheme, is_balsaka as isBalsaka, is_pmjy as isPmjy, id as id, address as address
	,concat_ws('' ,'',CASE WHEN (is_sncu ) THEN ''SCNU Available'' ELSE null END ,
	CASE WHEN (is_nrc ) THEN ''Nrc Available'' ELSE null END ,
	CASE WHEN (is_pmjy ) THEN ''PMJY Available'' ELSE null END
		,CASE WHEN (is_cmtc ) THEN ''CMTC Available'' ELSE null END 
		,CASE WHEN (is_fru ) THEN ''FRU Available'' ELSE null END 
		,CASE WHEN (is_chiranjeevi_scheme ) THEN ''Chiranjeevi Scheme Available'' ELSE null END 
		,CASE WHEN (is_balsaka ) THEN ''Balasaka Available'' ELSE null END 

	 ) as facilities


  FROM public.health_infrastructure_details
  where (location_id= #locationId# or ''#locationId#'' = ''null'' or ''#locationId#'' = '''') and (''#name#'' = ''null'' or name ilike ''%#name#%'')
and (''#type#'' = ''null'' or type = #type#)
  limit #limit# offset #offset#
)
select string_agg(location_master.name,'' > '' order by depth desc) as locationname,hospitalType,locationId,facilities, isNrc,  isCmtc,  isFru,  isScnu,hospital_data.name
 ,   isChiranjeeviScheme, isBalsaka, isPmjy,  hospital_data.id, hospital_data.address from hospital_data,location_hierchy_closer_det,location_master
  
  where location_hierchy_closer_det.child_id = hospital_data.locationid
and location_master.id = location_hierchy_closer_det.parent_id
	group by hospitalType,locationId,facilities, isNrc,  isCmtc,  isFru,  isScnu,hospital_data.name
 ,   isChiranjeeviScheme, isBalsaka, isPmjy,  hospital_data.id, hospital_data.address
',true,'ACTIVE','Retrieve health infrastructures');
  
delete from query_master where code='health_infrastructure_update';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state,description)
values(1,now(),'health_infrastructure_update','issncu,isfru,iscmtc,ispmjy,address,locationid,name,isnrc,id,type,ischiranjeevischeme,isbalsaka','
UPDATE public.health_infrastructure_details
   SET type=#type#, name=''#name#'', location_id=#locationid#, is_nrc=#isnrc#, is_cmtc=#iscmtc#, 
       is_fru=#isfru#, is_sncu=#issncu#, is_chiranjeevi_scheme=#ischiranjeevischeme#, is_balsaka=#isbalsaka#, is_pmjy=#ispmjy#, 
        address=''#address#''
 WHERE id=#id#;',false,'ACTIVE','Update Health Infrastructure');


delete from query_master where code='health_infrastructure_retrieve_by_id';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state,description)
values(1,now(),'health_infrastructure_retrieve_by_id','id','
with hd as (select id as id,type as type, name as name,location_id as locationid,address as address, is_nrc as isnrc , is_fru as isfru, is_cmtc as iscmtc, is_pmjy as ispmjy,is_sncu as issncu,is_balsaka as isbalsaka, is_chiranjeevi_scheme as ischiranjeevischeme from  health_infrastructure_details where id=#id#)
select * from hd h, (select child_id,string_agg(location_master.name,'' > '' order by depth desc) as locationname
from location_hierchy_closer_det,location_master, hd where child_id = hd.locationid
and location_master.id = location_hierchy_closer_det.parent_id
group by child_id) as t1',true,'ACTIVE','Retrieve Health Infrastructure by id');

