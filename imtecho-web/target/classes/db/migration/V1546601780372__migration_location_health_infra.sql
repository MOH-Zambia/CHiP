 insert into health_infrastructure_details   (location_id,  name,type)
  select l.id,name,h.id from listvalue_field_value_detail  h, location_master l where h.field_key='infra_type' and h.code=l.type  and (type='P' or type='SC' or type='U') ;

delete from query_master where code='health_infrastructure_retrieval';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state,description)
values(1,now(),'health_infrastructure_retrieval','locationId,type,name,limit,offset','
with hospital_data as(SELECT type as hospitalType, name as name, location_id as locationid,
 is_nrc as isNrc, is_cmtc as isCmtc, is_fru as isFru, is_sncu as isScnu,  is_chiranjeevi_scheme as isChiranjeeviScheme, is_balsaka as isBalsaka, is_pmjy as isPmjy, id as id, address as address
 FROM public.health_infrastructure_details
  where (location_id IN (select d.child_id from location_master  m,
 location_hierchy_closer_det d where m.id=d.child_id and (''#locationId#''= ''null'' or parent_id in (#locationId#))
 order by depth asc
 ) or ''#locationId#'' = ''null'' or ''#locationId#'' = '''') and (''#name#'' = ''null'' or name ilike ''%#name#%'')
and (''#type#'' = ''null'' or type = #type#)
  limit #limit# offset #offset#
)
select string_agg(location_master.name,'' > '' order by depth desc) as locationname,hospitalType,locationId, isNrc,  isCmtc,  isFru,  isScnu,hospital_data.name
 ,   isChiranjeeviScheme, isBalsaka, isPmjy,  hospital_data.id, hospital_data.address from hospital_data,location_hierchy_closer_det,location_master
  
  where location_hierchy_closer_det.child_id = hospital_data.locationid
and location_master.id = location_hierchy_closer_det.parent_id
	group by hospitalType,locationid, isNrc,  isCmtc,  isFru,  isScnu,hospital_data.name
 ,   isChiranjeeviScheme, isBalsaka, isPmjy,  hospital_data.id, hospital_data.address
',true,'ACTIVE','Retrieve health infrastructures');