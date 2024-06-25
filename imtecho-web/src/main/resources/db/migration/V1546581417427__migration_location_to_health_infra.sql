 /*insert into health_infrastructure_details   (location_id,  name,type)
  select l.id,name,h.id from listvalue_field_value_detail  h, location_master l where h.field_key='infra_type' and h.code=l.type  and (type='P' or type='SC' or type='U') ;*/

 ALTER TABLE public.health_infrastructure_details RENAME name_in_gujarati  TO name_in_english;

delete from query_master where code= 'health_infrastructure_retrieve_by_id';
insert into query_master(created_by,created_on,code,params,query,returns_result_set,state,description)
values(1,now(),'health_infrastructure_retrieve_by_id','id','
with hd as (select id as id,type as type, name as name,location_id as locationid,address as address, is_nrc as isnrc , is_fru as isfru, is_cmtc as iscmtc,is_sncu as issncu,is_blood_bank as isbloodbank,is_gynaec as isgynaec,is_pediatrician as ispediatrician, postal_code as postalcode,landline_number as landlinenumber, mobile_number as mobilenumber,email as email,name_in_english as nameinenglish,latitude as latitude,longitude as longitude, emamta_id as emamtaid, nin as nin from  health_infrastructure_details where id=#id#)
select * from hd h, (select child_id,string_agg(location_master.name,'' > '' order by depth desc) as locationname
from location_hierchy_closer_det,location_master, hd where child_id = hd.locationid
and location_master.id = location_hierchy_closer_det.parent_id
group by child_id) as t1',true,'ACTIVE','Retrieve Health Infrastructure by id');

delete from query_master where code='health_infrastructure_update';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state,description)
values(1,now(),'health_infrastructure_update','issncu,isfru,iscmtc,ispmjy,address,locationid,name,isnrc,id,type,isgynaec,longitude,latitude,nin,isbloodbank,landlinenumber,mobilenumber,email,ispediatrician,emamtaid,postalcode,nameinenglish','
UPDATE public.health_infrastructure_details
   SET type=''#type#'', name=''#name#'', location_id=#locationid#, is_nrc=#isnrc#, is_cmtc=#iscmtc#, 
       is_fru=#isfru#, is_sncu=#issncu#, 
        address=''#address#'',
latitude=''#latitude#'', longitude=''#longitude#'', nin=''#nin#'', emamta_id=#emamtaid#, 
       is_blood_bank=#isbloodbank#, is_gynaec=#isgynaec#, is_pediatrician=#ispediatrician#, postal_code=''#postalcode#'', 
       landline_number=''#landlinenumber#'', mobile_number=''#mobilenumber#'', email=''#email#'', name_in_english=''#nameinenglish#''


 WHERE id=#id#;',false,'ACTIVE','Update Health Infrastructure');

delete from query_master where code='health_infrastructure_create';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state,description)
values(1,now(),'health_infrastructure_create','issncu,isfru,iscmtc,address,locationid,name,isnrc,type,latitude,longitude,nin,emamtaid,isbloodbank,isgynaec,ispediatrician,postalcode,landlinenumber,mobilenumber,email,nameinenglish','
INSERT INTO public.health_infrastructure_details(
            type, name, location_id, is_nrc, is_cmtc, is_fru, is_sncu, 
              address,latitude, 
            longitude, nin, emamta_id, is_blood_bank, is_gynaec, is_pediatrician, 
            postal_code, landline_number, mobile_number, email, name_in_english)
    VALUES (''#type#'',''#name#'',#locationid#,#isnrc#,#iscmtc#,#isfru#,#issncu#,
''#address#'',''#latitude#'',''#longitude#'',''#nin#'',#emamtaid#,#isbloodbank#,
#isgynaec#,#ispediatrician#,''#postalcode#'',''#landlinenumber#'',''#mobilenumber#'',''#email#'',''#nameinenglish#''
);',false,'ACTIVE','Add health infrastructure details');


