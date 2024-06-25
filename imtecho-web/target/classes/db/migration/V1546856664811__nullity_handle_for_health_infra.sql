delete from query_master where code='health_infrastructure_retrieve_by_id';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state,description)
values(1,now(),'health_infrastructure_retrieve_by_id','id','
with hd as (select id as id,type as type, name as name,
location_id as locationid,address as address, is_nrc as isnrc ,
 is_fru as isfru, is_cmtc as iscmtc,is_sncu as issncu,is_blood_bank as isbloodbank,
is_gynaec as isgynaec,is_pediatrician as ispediatrician,
(case when postal_code=''null'' then '''' else postal_code end)  as postalcode,
(case when landline_number=''null'' then '''' else landline_number end) as landlinenumber, 
(case when mobile_number=''null'' then '''' else mobile_number end) as mobilenumber,
(case when email=''null'' then '''' else email end) as email,
(case when name_in_english=''null'' then '''' else name_in_english end) as nameinenglish,
(case when latitude=''null'' then '''' else latitude end) as latitude,
(case when longitude=''null'' then '''' else longitude end) as longitude, 
emamta_id as emamtaid,
(case when nin=''null'' then '''' else nin end) as nin
 from  health_infrastructure_details where id=11)
select * from hd h, (select child_id,string_agg(location_master.name,'' > '' order by depth desc) as locationname
from location_hierchy_closer_det,location_master, hd where child_id = hd.locationid
and location_master.id = location_hierchy_closer_det.parent_id
group by child_id) as t1',true,'ACTIVE','Retrieve Health Infrastructure by id');