delete from query_master where code='health_infrastructure_create';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state,description)
values(1,now(),'health_infrastructure_create','issncu,isfru,iscmtc,ispmjy,address,locationid,name,isnrc,type,ischiranjeevischeme,isbalsaka','
INSERT INTO public.health_infrastructure_details(
            hospital_type, name, location_id, is_nrc, is_cmtc, is_fru, is_sncu, 
            is_chiranjeevi_scheme, is_balsaka, is_pmjy,  address)
    VALUES (''#type#'',''#name#'',#locationid#,#isnrc#,#iscmtc#,#isfru#,#issncu#,
#ischiranjeevischeme#,#isbalsaka#,#ispmjy#,''#address#''
);',false,'ACTIVE','Add health infrastructure details');

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
		,CASE WHEN (is_balsaka ) THEN ''Balasaka Available'' ELSE null END 

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
  
delete from query_master where code='health_infrastructure_update';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state,description)
values(1,now(),'health_infrastructure_update','issncu,isfru,iscmtc,ispmjy,address,locationid,name,isnrc,id,type,ischiranjeevischeme,isbalsaka','
UPDATE public.health_infrastructure_details
   SET hospital_type=''#type#'', name=''#name#'', location_id=#locationid#, is_nrc=#isnrc#, is_cmtc=#iscmtc#, 
       is_fru=#isfru#, is_sncu=#issncu#, is_chiranjeevi_scheme=#ischiranjeevischeme#, is_balsaka=#isbalsaka#, is_pmjy=#ispmjy#, 
        address=''#address#''
 WHERE id=#id#;',false,'ACTIVE','Update Health Infrastructure');



delete from query_master where code='health_infrastructure_retrieve_by_id';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state,description)
values(1,now(),'health_infrastructure_retrieve_by_id','id','
with hd as (select id as id,hospital_type as type, name as name,location_id as locationid,address as address, is_nrc as isnrc , is_fru as isfru, is_cmtc as iscmtc, is_pmjy as ispmjy,is_sncu as issncu,is_balsaka as isbalsaka, is_chiranjeevi_scheme as ischiranjeevischeme from  health_infrastructure_details where id=#id#)
select * from hd h, (select child_id,string_agg(location_master.name,'' > '' order by depth desc) as locationname
from location_hierchy_closer_det,location_master, hd where child_id = hd.locationid
and location_master.id = location_hierchy_closer_det.parent_id
group by child_id) as t1',true,'ACTIVE','Retrieve Health Infrastructure by id');
