DELETE FROM QUERY_MASTER WHERE CODE='get_geo_service_location_details';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'2615ca21-441b-45a9-91a7-333a95b7dc6c', 75398,  current_date , 75398,  current_date , 'get_geo_service_location_details', 
'serviceType,from_date,to_date,locationId', 
'with location_services as (
select 
sum(case when geo_location_state = ''INCORRECT'' then 1 else 0 end) as incorrect_locations,
sum(case when geo_location_state = ''CORRECT'' then 1 else 0 end) as correct_locations,
sum(case when geo_location_state = ''NOT_FOUND'' or geo_location_state is null then 1 else 0 end) as geo_not_available,
count(1) as total_services,
user_id
from rch_member_services  rlfu 
left join location_master latLongLocation on latLongLocation.id = rlfu.lat_long_location_id
where 
rlfu.location_id in (select child_id from location_hierchy_closer_det where parent_id =#locationId#)
and
case when ''all'' = #serviceType# then rlfu.service_type in (''FHW_LMP'',''FHW_ANC'',''FHW_MOTHER_WPD'',''FHW_PNC'',''FHW_CS'') else rlfu.service_type=#serviceType# end 
and service_date between #from_date# and #to_date#
group by user_id 
)
select ls.*, concat(um.first_name,'' '',um.last_name) as name
from location_services ls
inner join um_user um  on ls.user_id = um.id', 
null, 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='get_geo_service_by_user_id';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'122c1d59-3d4a-41f7-9b0d-aca91c8aa66f', 75398,  current_date , 75398,  current_date , 'get_geo_service_by_user_id', 
'serviceType,from_date,to_date,locationId,userId', 
'select 
user_id,
ROW_NUMBER () OVER (ORDER BY rlfu.id) as "srNo",
concat(um.first_Name, '' '' , um.last_name) as name,
concat(im.first_Name, '' '' , im.last_name) as "memberName",
get_location_hierarchy(rlfu.location_id) as Location, 
rlfu.location_id as "locationId",
get_location_hierarchy(lat_long_location_id) as "latLongLocation",
geo_location_state as "geoLocationState",
rlfu.latitude,
rlfu.longitude,
rlfu.lat_long_location_distance as "latLongLocationDistrance",
case when rlfu.service_type = ''FHW_LMP'' then ''LMP Service''
     when rlfu.service_type = ''FHW_ANC'' then ''ANC Service''
     when rlfu.service_type = ''FHW_MOTHER_WPD'' then ''Delivery Service''
     when rlfu.service_type = ''FHW_PNC'' then ''PNC Service''
     when rlfu.service_type = ''FHW_CS'' then ''Child Service'' end 
 as "serviceType",
to_char(rlfu.service_date,''dd-MM-yyyy'') as "serviceDate"
from rch_member_services  rlfu 
inner join um_user um on um.id = rlfu.user_id
inner join imt_member im on im.id = rlfu.member_id
--and geo_location_state in (''CORRECT'',''INCORRECT'')
where user_id = #userId#
and case when ''all'' = #serviceType# then rlfu.service_type in (''FHW_LMP'',''FHW_ANC'',''FHW_MOTHER_WPD'',''FHW_PNC'',''FHW_CS'') else rlfu.service_type=#serviceType# end
and service_date between #from_date# and #to_date#
and rlfu.location_id in (select child_id from location_hierchy_closer_det where parent_id =#locationId#)', 
null, 
true, 'ACTIVE');