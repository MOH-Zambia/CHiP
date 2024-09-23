DELETE FROM QUERY_MASTER WHERE CODE='covid_19_screening';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'34428022-9471-47b6-a7a5-166aa25e76de', 97104,  current_date , 97104,  current_date , 'covid_19_screening', 
'from_date,to_date,offset,limit,location_id', 
'with params AS (
 select
to_date(case when #from_date# = ''null'' then null else #from_date# end, ''MM-DD-YYY'') as from_date ,
to_date(case when #to_date# = ''null'' then null else #to_date# end, ''MM-DD-YYYY'') + interval ''1 day'' - interval ''1 millisecond'' as to_date,
      lm.english_name as location_name 
from location_master lm where lm.id = #location_id#
),
loc_det as (
  SELECT lm.id
    FROM location_master lm 
    INNER JOIN location_hierchy_closer_det lhcd ON lm.id = lhcd.child_id
    WHERE lhcd.parent_id = #location_id#

)
select CONCAT(im.first_name, '' '', im.middle_name, '' '', im.last_name) as full_name,
im.unique_health_id as  health_id , 
TO_CHAR(csd.created_on, ''YYYY-MM-DD HH24:MI'') as service_date,
CONCAT(uu.first_name, '' '', uu.middle_name, '' '', uu.last_name) as cbv_name,
csd.id as hidden_member_id,
d.location_name,
get_location_hierarchy(csd.location_id) as hierarchy
    FROM covid_screening_details csd 
    INNER JOIN params d ON csd.created_on BETWEEN d.from_date AND d.to_date
    inner join imt_member im on im.id = csd.member_id
 inner join  um_user uu on uu.id = csd.created_by
    WHERE csd.location_id in ( select id from loc_det) AND
csd.member_status IN (''AVAILABLE'')
 limit #limit# offset #offset#;', 
'Fetch details of member who filled COVID 19 Screening Form', 
true, 'ACTIVE');