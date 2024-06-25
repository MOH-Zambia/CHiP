update listvalue_field_value_detail  
Set code='G'
where id =(select id from listvalue_field_value_detail  where value='Grant in Aid' and field_key='infra_type' );
INSERT INTO listvalue_field_value_detail (value, code,is_active,last_modified_by,last_modified_on,file_size,is_archive,field_key)
       select 'Grant in Aid','G',true,'superadmin',now(),0,false,'infra_type'
       WHERE NOT EXISTS (select 1 from listvalue_field_value_detail  where value='Grant in Aid' and field_key='infra_type');

 Insert into health_infrastructure_type_location  (health_infra_type_id,location_level)
    select  (select id from listvalue_field_value_detail  where code = 'G' and value='Grant in Aid' and field_key='infra_type'  and is_active=true) ,3
    where not exists( select 1 from health_infrastructure_type_location  where health_infra_type_id =(select id from listvalue_field_value_detail  where code = 'G' and value='Grant in Aid' and field_key='infra_type'  and is_active=true) );


update listvalue_field_value_detail  
Set code='M'
where id =(select id from listvalue_field_value_detail  where value='Medical College Hospital' and field_key='infra_type');
INSERT INTO listvalue_field_value_detail (value, code,is_active,last_modified_by,last_modified_on,file_size,is_archive,field_key)
       select 'Medical College Hospital','M',true,'superadmin',now(),0,false,'infra_type'
       WHERE NOT EXISTS (select 1 from listvalue_field_value_detail  where value='Medical College Hospital' and field_key='infra_type');
Insert into health_infrastructure_type_location  (health_infra_type_id,location_level)
    select  (select id from listvalue_field_value_detail  where code = 'M' and value='Medical College Hospital' and field_key='infra_type'  and is_active=true) ,3
    where not exists( select 1 from health_infrastructure_type_location  where health_infra_type_id =(select id from listvalue_field_value_detail  where code = 'M'  and field_key='infra_type'  and is_active=true) );



update listvalue_field_value_detail  
Set code='D'
where id =(select id from listvalue_field_value_detail  where value='District Hospital' and field_key='infra_type');
INSERT INTO listvalue_field_value_detail (value, code,is_active,last_modified_by,last_modified_on,file_size,is_archive,field_key)
       select 'District Hospital','D',true,'superadmin',now(),0,false,'infra_type'
       WHERE NOT EXISTS (select 1 from listvalue_field_value_detail  where value='District Hospital' and field_key='infra_type');
Insert into health_infrastructure_type_location  (health_infra_type_id,location_level)
    select  (select id from listvalue_field_value_detail  where code = 'D' and value='District Hospital' and field_key='infra_type'  and is_active=true) ,3
    where not exists( select 1 from health_infrastructure_type_location  where health_infra_type_id =(select id from listvalue_field_value_detail  where code = 'D'  and field_key='infra_type'  and is_active=true) );

update listvalue_field_value_detail  
Set code='B'
where id =(select id from listvalue_field_value_detail  where value='Sub District Hospital' and field_key='infra_type');
INSERT INTO listvalue_field_value_detail (value, code,is_active,last_modified_by,last_modified_on,file_size,is_archive,field_key)
       select 'Sub District Hospital','B',true,'superadmin',now(),0,false,'infra_type'
       WHERE NOT EXISTS (select 1 from listvalue_field_value_detail  where value='Sub District Hospital' and field_key='infra_type' );

Insert into health_infrastructure_type_location  (health_infra_type_id,location_level)
    select  (select id from listvalue_field_value_detail  where code = 'B' and value='Sub District Hospital' and field_key='infra_type'  and is_active=true) ,3
    where not exists( select 1 from health_infrastructure_type_location  where health_infra_type_id =(select id from listvalue_field_value_detail  where code = 'B'  and field_key='infra_type'  and is_active=true) );

update listvalue_field_value_detail  
Set code='C'
where id =(select id from listvalue_field_value_detail  where value='Community Health Center' and field_key='infra_type');
INSERT INTO listvalue_field_value_detail (value, code,is_active,last_modified_by,last_modified_on,file_size,is_archive,field_key)
       select 'Community Health Center','C',true,'superadmin',now(),0,false,'infra_type'
       WHERE NOT EXISTS (select 1 from listvalue_field_value_detail  where value='Community Health Center' and field_key='infra_type' );

Insert into health_infrastructure_type_location  (health_infra_type_id,location_level)
    select  (select id from listvalue_field_value_detail  where code = 'C' and value='Community Health Center' and field_key='infra_type'  and is_active=true) ,3
    where not exists( select 1 from health_infrastructure_type_location  where health_infra_type_id =(select id from listvalue_field_value_detail  where code = 'C' and value='Community Health Center' and field_key='infra_type'  and is_active=true) );

update listvalue_field_value_detail  
Set code='T'
where id =(select id from listvalue_field_value_detail  where value='Trust Hospital' and field_key='infra_type');
INSERT INTO listvalue_field_value_detail (value, code,is_active,last_modified_by,last_modified_on,file_size,is_archive,field_key)
       select 'Trust Hospital','T',true,'superadmin',now(),0,false,'infra_type'
       WHERE NOT EXISTS (select 1 from listvalue_field_value_detail  where value='Trust Hospital' and field_key='infra_type');

Insert into health_infrastructure_type_location  (health_infra_type_id,location_level)
    select  (select id from listvalue_field_value_detail  where code = 'T' and value='Trust Hospital' and field_key='infra_type'  and is_active=true) ,3
    where not exists( select 1 from health_infrastructure_type_location  where health_infra_type_id =(select id from listvalue_field_value_detail  where code = 'T' and value='Trust Hospital' and field_key='infra_type'  and is_active=true) );

update listvalue_field_value_detail  
Set code='PVT'
where id =(select id from listvalue_field_value_detail  where value='Private Hospital' and field_key='infra_type');
INSERT INTO listvalue_field_value_detail (value, code,is_active,last_modified_by,last_modified_on,file_size,is_archive,field_key)
       select 'Private Hospital','PVT',true,'superadmin',now(),0,false,'infra_type'
       WHERE NOT EXISTS (select 1 from listvalue_field_value_detail  where value='Private Hospital' and field_key='infra_type' );

Insert into health_infrastructure_type_location  (health_infra_type_id,location_level)
    select  (select id from listvalue_field_value_detail  where code = 'PVT' and value='Private Hospital' and field_key='infra_type'  and is_active=true) ,3
    where not exists( select 1 from health_infrastructure_type_location  where health_infra_type_id =(select id from listvalue_field_value_detail  where code = 'PVT' and value='Private Hospital' and field_key='infra_type'  and is_active=true) );

delete from query_master where code='health_infrastructure_retrieval';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state,description)
values(1,now(),'health_infrastructure_retrieval','locationId,type,name,limit,offset','
with hospital_data as(SELECT type as hospitalType, name as name, location_id as locationid,
 is_nrc as isNrc, is_cmtc as isCmtc, is_fru as isFru, is_sncu as isScnu,  is_chiranjeevi_scheme as isChiranjeeviScheme, is_balsaka as isBalsaka, is_pmjy as isPmjy, id as id, address as address
 FROM public.health_infrastructure_details
  where (location_id= #locationId# or ''#locationId#'' = ''null'' or ''#locationId#'' = '''') and (''#name#'' = ''null'' or name ilike ''%#name#%'')
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