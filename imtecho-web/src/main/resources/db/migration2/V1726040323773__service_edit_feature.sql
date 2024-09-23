DELETE FROM QUERY_MASTER WHERE CODE='fhw_vae';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'343ce495-48e9-4416-b064-7a55057ca404', 97104,  current_date , 97104,  current_date , 'fhw_vae', 
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
TO_CHAR(rvae.created_on, ''YYYY-MM-DD HH24:MI'') as service_date,
CONCAT(uu.first_name, '' '', uu.middle_name, '' '', uu.last_name) as cbv_name,
rvae.id as hidden_member_id,
d.location_name,
get_location_hierarchy(rvae.location_id) as hierarchy
    FROM rch_vaccine_adverse_effect rvae
    INNER JOIN params d ON rvae.created_on BETWEEN d.from_date AND d.to_date
    inner join imt_member im on im.id = rvae.member_id
 inner join  um_user uu on uu.id = rvae.created_by
    WHERE rvae.location_id in ( select id from loc_det)
limit #limit# offset #offset#;', 
'fetches members for adverse vaccine effects', 
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='chip_tb_follow_up';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'41d5a2b3-d129-4a57-8e0d-221684dae699', 97104,  current_date , 97104,  current_date , 'chip_tb_follow_up', 
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
TO_CHAR(tsd.created_on, ''YYYY-MM-DD HH24:MI'') as service_date,
CONCAT(uu.first_name, '' '', uu.middle_name, '' '', uu.last_name) as cbv_name,
tsd.id as hidden_member_id,
d.location_name,
get_location_hierarchy(tsd.location_id) as hierarchy
    FROM tuberculosis_screening_details tsd 
    INNER JOIN params d ON tsd.created_on BETWEEN d.from_date AND d.to_date
    inner join imt_member im on im.id = tsd.member_id
 inner join  um_user uu on uu.id = tsd.created_by
    WHERE tsd.location_id in ( select id from loc_det) and form_type=''TB_FOLLOW_UP''
 limit #limit# offset #offset#;', 
'fetches tuberculosis follow up details', 
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='emtct';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'e3ebe5b4-38c2-48ec-8bed-27ab5a38f766', 97104,  current_date , 97104,  current_date , 'emtct', 
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
TO_CHAR(ed.created_on, ''YYYY-MM-DD HH24:MI'') as service_date,
CONCAT(uu.first_name, '' '', uu.middle_name, '' '', uu.last_name) as cbv_name,
ed.id as hidden_member_id,
d.location_name,
get_location_hierarchy(ed.location_id) as hierarchy
    FROM emtct_details ed 
    INNER JOIN params d ON ed.created_on BETWEEN d.from_date AND d.to_date
    inner join imt_member im on im.id = ed.member_id
 inner join  um_user uu on uu.id = ed.created_by
    WHERE ed.location_id in ( select id from loc_det)
 limit #limit# offset #offset#;', 
'fetches emtct details', 
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='chip_tb';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'e3fe72a5-b18c-4ac3-b37e-0ad187c1ffc3', 97104,  current_date , 97104,  current_date , 'chip_tb', 
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
TO_CHAR(tsd.created_on, ''YYYY-MM-DD HH24:MI'') as service_date,
CONCAT(uu.first_name, '' '', uu.middle_name, '' '', uu.last_name) as cbv_name,
tsd.id as hidden_member_id,
d.location_name,
get_location_hierarchy(tsd.location_id) as hierarchy
    FROM tuberculosis_screening_details tsd 
    INNER JOIN params d ON tsd.created_on BETWEEN d.from_date AND d.to_date
    inner join imt_member im on im.id = tsd.member_id
 inner join  um_user uu on uu.id = tsd.created_by
    WHERE tsd.location_id in ( select id from loc_det) and form_type=''TB_SCREENING''
 limit #limit# offset #offset#;', 
'fetches tuberculosis details', 
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='hiv_screening';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'7ed5710b-1eac-4ad4-a440-10560bdba074', 97104,  current_date , 97104,  current_date , 'hiv_screening', 
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
TO_CHAR(rhsm.created_on, ''YYYY-MM-DD HH24:MI'') as service_date,
CONCAT(uu.first_name, '' '', uu.middle_name, '' '', uu.last_name) as cbv_name,
rhsm.id as hidden_member_id,
d.location_name,
get_location_hierarchy(rhsm.location_id) as hierarchy
    FROM rch_hiv_screening_master rhsm 
    INNER JOIN params d ON rhsm.created_on BETWEEN d.from_date AND d.to_date
    inner join imt_member im on im.id = rhsm.member_id
 inner join  um_user uu on uu.id = rhsm.created_by
    WHERE rhsm.location_id in ( select id from loc_det)
 limit #limit# offset #offset#;', 
'fetches HIV screening data', 
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='hiv_known';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'c96dfc0d-4164-4295-b76f-7737f48e028d', 97104,  current_date , 97104,  current_date , 'hiv_known', 
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
TO_CHAR(rhkm.created_on, ''YYYY-MM-DD HH24:MI'') as service_date,
CONCAT(uu.first_name, '' '', uu.middle_name, '' '', uu.last_name) as cbv_name,
rhkm.id as hidden_member_id,
d.location_name,
get_location_hierarchy(rhkm.location_id) as hierarchy
    FROM rch_hiv_known_master rhkm 
    INNER JOIN params d ON rhkm.created_on BETWEEN d.from_date AND d.to_date
    inner join imt_member im on im.id = rhkm.member_id
 inner join  um_user uu on uu.id = rhkm.created_by
    WHERE rhkm.location_id in ( select id from loc_det)
 limit #limit# offset #offset#;', 
'fetches members with known HIV', 
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='active_malaria';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'17b1eb37-4956-48a8-8b5a-3bf17ceed986', 97104,  current_date , 97104,  current_date , 'active_malaria', 
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
TO_CHAR(md.created_on, ''YYYY-MM-DD HH24:MI'') as service_date,
CONCAT(uu.first_name, '' '', uu.middle_name, '' '', uu.last_name) as cbv_name,
md.id as hidden_member_id,
d.location_name,
get_location_hierarchy(md.location_id) as hierarchy
    FROM malaria_details md 
    INNER JOIN params d ON md.created_on BETWEEN d.from_date AND d.to_date
    inner join imt_member im on im.id = md.member_id
 inner join  um_user uu on uu.id = md.created_by
    WHERE md.location_id in ( select id from loc_det) and md.malaria_type=''ACTIVE''
 limit #limit# offset #offset#;', 
'fetches members with active malaria', 
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='passive_malaria';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'2c4833d8-f1ef-477f-b70e-15727421a77d', 97104,  current_date , 97104,  current_date , 'passive_malaria', 
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
TO_CHAR(md.created_on, ''YYYY-MM-DD HH24:MI'') as service_date,
CONCAT(uu.first_name, '' '', uu.middle_name, '' '', uu.last_name) as cbv_name,
md.id as hidden_member_id,
d.location_name,
get_location_hierarchy(md.location_id) as hierarchy
    FROM malaria_details md 
    INNER JOIN params d ON md.created_on BETWEEN d.from_date AND d.to_date
    inner join imt_member im on im.id = md.member_id
 inner join  um_user uu on uu.id = md.created_by
    WHERE md.location_id in ( select id from loc_det) and md.malaria_type=''PASSIVE''
 limit #limit# offset #offset#;', 
'fetches members with passive malaria', 
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='chip_gbv_screening';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'5e929436-5ffc-46f9-baa7-fe82767433d1', 97104,  current_date , 97104,  current_date , 'chip_gbv_screening', 
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
TO_CHAR(gvm.service_date, ''YYYY-MM-DD HH24:MI'') as service_date,
CONCAT(uu.first_name, '' '', uu.middle_name, '' '', uu.last_name) as cbv_name,
gvm.id as hidden_member_id,
d.location_name,
get_location_hierarchy(gvm.location_id) as hierarchy
    FROM gbv_visit_master gvm 
    INNER JOIN params d ON gvm.service_date BETWEEN d.from_date AND d.to_date
    inner join imt_member im on im.id = CAST(gvm.member_id AS integer)
 inner join  um_user uu on uu.id = gvm.created_by
  WHERE gvm.location_id in ( select id from loc_det)
 limit #limit# offset #offset#;', 
'fetches gbv_screening_details', 
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='malaria_non_index';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'1b7b0f36-222b-4ca7-ad39-c24301ad291a', 97104,  current_date , 97104,  current_date , 'malaria_non_index', 
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
TO_CHAR(mnicd.created_on, ''YYYY-MM-DD HH24:MI'') as service_date,
CONCAT(uu.first_name, '' '', uu.middle_name, '' '', uu.last_name) as cbv_name,
mnicd.id as hidden_member_id,
d.location_name,
get_location_hierarchy(mnicd.location_id) as hierarchy
    FROM malaria_non_index_case_details mnicd 
    INNER JOIN params d ON mnicd.created_on BETWEEN d.from_date AND d.to_date
    inner join imt_member im on im.id = mnicd.member_id
 inner join  um_user uu on uu.id = mnicd.created_by
    WHERE mnicd.location_id in ( select id from loc_det)
 limit #limit# offset #offset#;', 
'fetches malaria non index cases', 
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='malaria_index';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'043fe116-12a0-4b31-873d-1912d6cbd998', 97104,  current_date , 97104,  current_date , 'malaria_index', 
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
TO_CHAR(micd.created_on, ''YYYY-MM-DD HH24:MI'') as service_date,
CONCAT(uu.first_name, '' '', uu.middle_name, '' '', uu.last_name) as cbv_name,
micd.id as hidden_member_id,
d.location_name,
get_location_hierarchy(micd.location_id) as hierarchy
    FROM malaria_index_case_details micd 
    INNER JOIN params d ON micd.created_on BETWEEN d.from_date AND d.to_date
    inner join imt_member im on im.id = micd.member_id
 inner join  um_user uu on uu.id = micd.created_by
    WHERE micd.location_id in ( select id from loc_det)
 limit #limit# offset #offset#;', 
'fetches malaria index cases', 
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='hiv_positive';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'794dcfb7-8744-416a-89ce-74b3ec26ce97', 97104,  current_date , 97104,  current_date , 'hiv_positive', 
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
TO_CHAR(rph.created_on, ''YYYY-MM-DD HH24:MI'') as service_date,
CONCAT(uu.first_name, '' '', uu.middle_name, '' '', uu.last_name) as cbv_name,
rph.id as hidden_member_id,
d.location_name,
get_location_hierarchy(rph.location_id) as hierarchy
    FROM rch_preg_hiv_positive_master rph 
    INNER JOIN params d ON rph.created_on BETWEEN d.from_date AND d.to_date
    inner join imt_member im on im.id = rph.member_id
 inner join  um_user uu on uu.id = rph.created_by
    WHERE rph.location_id in ( select id from loc_det)
 limit #limit# offset #offset#;', 
'HIV_POSITIVE', 
true, 'ACTIVE');

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
    WHERE csd.location_id in ( select id from loc_det)
 limit #limit# offset #offset#;', 
'Fetch details of member who filled COVID 19 Screening Form', 
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='fetch_list_of_services';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'9ccd4891-b9b1-42c5-a389-f0a61d14e955', 97104,  current_date , 97104,  current_date , 'fetch_list_of_services', 
'from_date,to_date,location_id', 
'WITH 
loc_det AS (
    SELECT lm.id
    FROM location_master lm 
    INNER JOIN location_hierchy_closer_det lhcd ON lm.id = lhcd.child_id
    WHERE lhcd.parent_id = #location_id#
),
dates AS (
    SELECT 
        CASE WHEN ''#from_date#'' = ''null'' THEN NULL ELSE TO_DATE(''#from_date#'', ''MM/DD/YYYY'') END AS from_date,
        CASE WHEN ''#to_date#'' = ''null'' THEN NULL ELSE TO_DATE(''#to_date#'', ''MM/DD/YYYY'') + INTERVAL ''1 day'' - INTERVAL ''1 second'' END AS to_date
),
covid_screening_cte AS (
    SELECT COALESCE(COUNT(DISTINCT csd.member_id), 0) as covid_screening_count, 
           csd.location_id 
    FROM covid_screening_details csd 
    INNER JOIN dates d ON csd.created_on BETWEEN d.from_date AND d.to_date
    WHERE csd.location_id IN (SELECT id FROM loc_det)
    GROUP BY csd.location_id
),
hiv_fu_screening_cte AS (
    SELECT COALESCE(COUNT(rhsm.id), 0) as hiv_fu_screening_count , 
           rhsm.location_id
    FROM rch_hiv_screening_master rhsm 
    INNER JOIN dates d ON rhsm.created_on BETWEEN d.from_date AND d.to_date
    WHERE rhsm.location_id IN (SELECT id FROM loc_det) and rhsm.referral_place is not null
    GROUP BY rhsm.location_id
),
active_malaria_cte AS (
    SELECT COALESCE(COUNT( md.id), 0) as active_malaria_count,
           md.location_id 
    FROM malaria_details md
    INNER JOIN dates d ON md.created_on BETWEEN d.from_date AND d.to_date
    WHERE md.location_id IN (SELECT id FROM loc_det)
    AND md.malaria_type = ''ACTIVE''
    GROUP BY md.location_id
),
passive_malaria_cte AS (
    SELECT COALESCE(COUNT( md.id), 0) as passive_malaria_count,
           md.location_id 
    FROM malaria_details md
    INNER JOIN dates d ON md.created_on BETWEEN d.from_date AND d.to_date
    WHERE md.location_id IN (SELECT id FROM loc_det)
    AND md.malaria_type = ''PASSIVE''
    GROUP BY md.location_id
),
known_positive_cte AS (
    SELECT COALESCE(COUNT(md.id), 0) as known_positive_count,
           md.location_id 
    FROM rch_hiv_known_master md
    INNER JOIN dates d ON md.created_on BETWEEN d.from_date AND d.to_date
    WHERE md.location_id IN (SELECT id FROM loc_det)
    GROUP BY md.location_id
),
hiv_screening_cte AS (
    SELECT COALESCE(COUNT(md.id), 0) as hiv_screening_count,
           md.location_id 
    FROM rch_hiv_screening_master md
    INNER JOIN dates d ON md.created_on BETWEEN d.from_date AND d.to_date
    WHERE md.location_id IN (SELECT id FROM loc_det)
    AND md.referral_place IS NULL
    GROUP BY md.location_id
),
fhw_anc_visit_cte AS (
    SELECT COALESCE(COUNT(DISTINCT md.member_id), 0) as fhw_anc_visit_count,
           md.location_id 
    FROM rch_asha_anc_master md
    INNER JOIN dates d ON md.created_on BETWEEN d.from_date AND d.to_date
    WHERE md.location_id IN (SELECT id FROM loc_det)
    GROUP BY md.location_id
),
rch_pnc_cte AS (
    SELECT COALESCE(COUNT(DISTINCT md.member_id), 0) as rch_pnc_count,
           md.location_id 
    FROM rch_pnc_master md
    INNER JOIN dates d ON md.created_on BETWEEN d.from_date AND d.to_date
    WHERE md.location_id IN (SELECT id FROM loc_det)
    GROUP BY md.location_id
),
chip_tb_cte AS (
    SELECT COALESCE(COUNT(md.id), 0) as chip_tb_count,
           md.location_id 
    FROM tuberculosis_screening_details md
    INNER JOIN dates d ON md.created_on BETWEEN d.from_date AND d.to_date
    WHERE md.location_id IN (SELECT id FROM loc_det)
    AND md.form_type = ''TB_SCREENING''
    GROUP BY md.location_id
),
chip_tb_follow_up_cte AS (
    SELECT COALESCE(COUNT( md.id), 0) as chip_tb_follow_up_count,
           md.location_id 
    FROM tuberculosis_screening_details md
    INNER JOIN dates d ON md.created_on BETWEEN d.from_date AND d.to_date
    WHERE md.location_id IN (SELECT id FROM loc_det)
    AND md.form_type = ''TB_FOLLOW_UP''
    GROUP BY md.location_id
),
fhw_cs_cte AS (
    SELECT COALESCE(COUNT(DISTINCT md.member_id), 0) as fhw_cs_count,
           md.location_id 
    FROM rch_asha_child_service_master md
    INNER JOIN dates d ON md.created_on BETWEEN d.from_date AND d.to_date
    WHERE md.location_id IN (SELECT id FROM loc_det)
    GROUP BY md.location_id
),
hiv_positive_cte AS (
    SELECT COALESCE(COUNT( md.id), 0) as hiv_positive_count,
           md.location_id 
    FROM rch_preg_hiv_positive_master md
    INNER JOIN dates d ON md.created_on BETWEEN d.from_date AND d.to_date
    WHERE md.location_id IN (SELECT id FROM loc_det)
    GROUP BY md.location_id
),
emtct_cte AS (
    SELECT COALESCE(COUNT(md.id), 0) as emtct_count,
           md.location_id 
    FROM emtct_details md
    INNER JOIN dates d ON md.created_on BETWEEN d.from_date AND d.to_date
    WHERE md.location_id IN (SELECT id FROM loc_det)
    GROUP BY md.location_id
),
malaria_index_cte AS (
    SELECT COALESCE(COUNT( md.id), 0) as malaria_index_count,
           md.location_id 
    FROM malaria_index_case_details md
    INNER JOIN dates d ON md.created_on BETWEEN d.from_date AND d.to_date
    WHERE md.location_id IN (SELECT id FROM loc_det)
    GROUP BY md.location_id
),
malaria_non_index_cte AS (
    SELECT COALESCE(COUNT( md.id), 0) as malaria_non_index_count,
           md.location_id 
    FROM malaria_non_index_case_details md
    INNER JOIN dates d ON md.created_on BETWEEN d.from_date AND d.to_date
    WHERE md.location_id IN (SELECT id FROM loc_det)
    GROUP BY md.location_id
),
chip_gbv_screening_cte AS (
    SELECT COALESCE(COUNT( md.id), 0) as chip_gbv_screening_count,
           md.location_id 
    FROM gbv_visit_master md
    INNER JOIN dates d ON md.service_date BETWEEN d.from_date AND d.to_date
    WHERE md.location_id IN (SELECT id FROM loc_det)
    GROUP BY md.location_id
),
fhw_vae_cte AS (
    SELECT COALESCE(COUNT(md.id), 0) as fhw_vae_count,
           md.location_id 
    FROM rch_vaccine_adverse_effect md
    INNER JOIN dates d ON md.created_on BETWEEN d.from_date AND d.to_date
    WHERE md.location_id IN (SELECT id FROM loc_det)
    GROUP BY md.location_id
)
SELECT 
    lm.id as hidden_location_id,
    lm.english_name as "Location Name",
    COALESCE(sum(cte02.covid_screening_count), 0) as "COVID_19_SCREENING",
    COALESCE(sum(cte2.hiv_fu_screening_count), 0) as "HIV_SCREENING_FU",
    COALESCE(sum(cte3.active_malaria_count), 0) as "ACTIVE_MALARIA",
    COALESCE(sum(cte4.passive_malaria_count), 0) as "PASSIVE_MALARIA",
    COALESCE(sum(cte5.known_positive_count), 0) as "KNOWN_POSITIVE",
    COALESCE(sum(cte6.hiv_screening_count), 0) as "HIV_SCREENING",
    COALESCE(sum(cte7.fhw_anc_visit_count), 0) as "FHW_ANC",
    COALESCE(sum(cte8.rch_pnc_count), 0) as "RCH_FACILITY_PNC (FHW_PNC)",
    COALESCE(sum(cte9.chip_tb_count), 0) as "CHIP_TB",
    COALESCE(sum(cte10.chip_tb_follow_up_count), 0) as "CHIP_TB_FOLLOW_UP",
    COALESCE(sum(cte11.fhw_cs_count), 0) as "FHW_CS",
    COALESCE(sum(cte12.hiv_positive_count), 0) as "HIV_POSITIVE",
    COALESCE(sum(cte13.emtct_count), 0) as "EMTCT",
    COALESCE(sum(cte14.malaria_index_count), 0) as "MALARIA_INDEX",
    COALESCE(sum(cte15.malaria_non_index_count), 0) as "MALARIA_NON_INDEX",
    COALESCE(sum(cte16.chip_gbv_screening_count), 0) as "CHIP_GBV_SCREENING",
	COALESCE(sum(cte17.fhw_vae_count), 0) as "FHW_VAE"
FROM 
    loc_det cte1
	LEFT JOIN covid_screening_cte cte02 ON cte02.location_id = cte1.id
LEFT JOIN hiv_fu_screening_cte cte2 ON cte2.location_id = cte1.id
LEFT JOIN active_malaria_cte cte3 ON cte3.location_id = cte1.id
LEFT JOIN passive_malaria_cte cte4 ON cte4.location_id = cte1.id
LEFT JOIN known_positive_cte cte5 ON cte5.location_id = cte1.id
LEFT JOIN hiv_screening_cte cte6 ON cte6.location_id = cte1.id
LEFT JOIN fhw_anc_visit_cte cte7 ON cte7.location_id = cte1.id
LEFT JOIN rch_pnc_cte cte8 ON cte8.location_id = cte1.id
LEFT JOIN chip_tb_cte cte9 ON cte9.location_id = cte1.id
LEFT JOIN chip_tb_follow_up_cte cte10 ON cte10.location_id = cte1.id
LEFT JOIN fhw_cs_cte cte11 ON cte11.location_id = cte1.id
LEFT JOIN hiv_positive_cte cte12 ON cte12.location_id = cte1.id
LEFT JOIN emtct_cte cte13 ON cte13.location_id = cte1.id
LEFT JOIN malaria_index_cte cte14 ON cte14.location_id = cte1.id
LEFT JOIN malaria_non_index_cte cte15 ON cte15.location_id = cte1.id
LEFT JOIN chip_gbv_screening_cte cte16 ON cte16.location_id = cte1.id
LEFT JOIN fhw_vae_cte cte17 ON cte17.location_id = cte1.id

left join location_master lm on lm.id = cte1.id
group by 1,2', 
'Retrieves counts of services', 
true, 'ACTIVE');