INSERT INTO public.menu_config
( feature_json, group_id, active, is_dynamic_report, menu_name, navigation_state, sub_group_id, menu_type, only_admin, menu_display_order, "uuid", group_name_uuid, sub_group_uuid, description)
VALUES( '{}', NULL, true, NULL, 'Service Visit Details', 'techo.manage.servicevisitedit', NULL, 'manage', NULL, NULL, NULL, NULL, NULL, NULL);

INSERT INTO public.menu_config
( feature_json, group_id, active, is_dynamic_report, menu_name, navigation_state, sub_group_id, menu_type, only_admin, menu_display_order, "uuid", group_name_uuid, sub_group_uuid, description)
VALUES('{}', NULL, true, NULL, 'Userwise Visit Details ', 'techo.manage.userdetails', NULL, 'manage', NULL, NULL, NULL, NULL, NULL, NULL);

DELETE FROM QUERY_MASTER WHERE CODE='covid_19_screening';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'34428022-9471-47b6-a7a5-166aa25e76de', 97105,  current_date , 97105,  current_date , 'covid_19_screening', 
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
im.id as hidden_member_id,
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
'9ccd4891-b9b1-42c5-a389-f0a61d14e955', 97105,  current_date , 97105,  current_date , 'fetch_list_of_services', 
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
    SELECT COALESCE(COUNT(DISTINCT rhsm.member_id), 0) as hiv_fu_screening_count , 
           rhsm.location_id
    FROM rch_hiv_screening_master rhsm 
    INNER JOIN dates d ON rhsm.created_on BETWEEN d.from_date AND d.to_date
    WHERE rhsm.location_id IN (SELECT id FROM loc_det) and rhsm.referral_place is not null
    GROUP BY rhsm.location_id
),
active_malaria_cte AS (
    SELECT COALESCE(COUNT(DISTINCT md.member_id), 0) as active_malaria_count,
           md.location_id 
    FROM malaria_details md
    INNER JOIN dates d ON md.created_on BETWEEN d.from_date AND d.to_date
    WHERE md.location_id IN (SELECT id FROM loc_det)
    AND md.malaria_type = ''ACTIVE''
    GROUP BY md.location_id
),
passive_malaria_cte AS (
    SELECT COALESCE(COUNT(DISTINCT md.member_id), 0) as passive_malaria_count,
           md.location_id 
    FROM malaria_details md
    INNER JOIN dates d ON md.created_on BETWEEN d.from_date AND d.to_date
    WHERE md.location_id IN (SELECT id FROM loc_det)
    AND md.malaria_type = ''PASSIVE''
    GROUP BY md.location_id
),
known_positive_cte AS (
    SELECT COALESCE(COUNT(DISTINCT md.member_id), 0) as known_positive_count,
           md.location_id 
    FROM rch_hiv_known_master md
    INNER JOIN dates d ON md.created_on BETWEEN d.from_date AND d.to_date
    WHERE md.location_id IN (SELECT id FROM loc_det)
    GROUP BY md.location_id
),
hiv_screening_cte AS (
    SELECT COALESCE(COUNT(DISTINCT md.member_id), 0) as hiv_screening_count,
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
    SELECT COALESCE(COUNT(DISTINCT md.member_id), 0) as chip_tb_count,
           md.location_id 
    FROM tuberculosis_screening_details md
    INNER JOIN dates d ON md.created_on BETWEEN d.from_date AND d.to_date
    WHERE md.location_id IN (SELECT id FROM loc_det)
    AND md.form_type = ''TB_SCREENING''
    GROUP BY md.location_id
),
chip_tb_follow_up_cte AS (
    SELECT COALESCE(COUNT(DISTINCT md.member_id), 0) as chip_tb_follow_up_count,
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
    SELECT COALESCE(COUNT(DISTINCT md.member_id), 0) as hiv_positive_count,
           md.location_id 
    FROM rch_preg_hiv_positive_master md
    INNER JOIN dates d ON md.created_on BETWEEN d.from_date AND d.to_date
    WHERE md.location_id IN (SELECT id FROM loc_det)
    GROUP BY md.location_id
),
emtct_cte AS (
    SELECT COALESCE(COUNT(DISTINCT md.member_id), 0) as emtct_count,
           md.location_id 
    FROM emtct_details md
    INNER JOIN dates d ON md.created_on BETWEEN d.from_date AND d.to_date
    WHERE md.location_id IN (SELECT id FROM loc_det)
    GROUP BY md.location_id
),
malaria_index_cte AS (
    SELECT COALESCE(COUNT(DISTINCT md.member_id), 0) as malaria_index_count,
           md.location_id 
    FROM malaria_index_case_details md
    INNER JOIN dates d ON md.created_on BETWEEN d.from_date AND d.to_date
    WHERE md.location_id IN (SELECT id FROM loc_det)
    GROUP BY md.location_id
),
malaria_non_index_cte AS (
    SELECT COALESCE(COUNT(DISTINCT md.member_id), 0) as malaria_non_index_count,
           md.location_id 
    FROM malaria_non_index_case_details md
    INNER JOIN dates d ON md.created_on BETWEEN d.from_date AND d.to_date
    WHERE md.location_id IN (SELECT id FROM loc_det)
    GROUP BY md.location_id
),
chip_gbv_screening_cte AS (
    SELECT COALESCE(COUNT(DISTINCT md.member_id), 0) as chip_gbv_screening_count,
           md.location_id 
    FROM gbv_visit_master md
    INNER JOIN dates d ON md.created_on BETWEEN d.from_date AND d.to_date
    WHERE md.location_id IN (SELECT id FROM loc_det)
    GROUP BY md.location_id
)

SELECT 
    lm.id as hidden_location_id,
    lm.english_name as "Location Name",
    cte1.covid_screening_count as "COVID_19_SCREENING",
    cte2.hiv_fu_screening_count as "HIV_SCREENING_FU",
    cte3.active_malaria_count as "ACTIVE_MALARIA",
    cte4.passive_malaria_count as "PASSIVE_MALARIA",
    cte5.known_positive_count as "KNOWN_POSITIVE",
    cte6.hiv_screening_count as "HIV_SCREENING",
    cte7.fhw_anc_visit_count as "FHW_ANC",
    cte8.rch_pnc_count as "RCH_FACILITY_PNC (FHW_PNC)",
    cte9.chip_tb_count as "CHIP_TB",
    cte10.chip_tb_follow_up_count as "CHIP_TB_FOLLOW_UP",
    cte11.fhw_cs_count as "FHW_CS",
    cte12.hiv_positive_count as "HIV_POSITIVE",
    cte13.emtct_count as "EMTCT",
    cte14.malaria_index_count as "MALARIA_INDEX",
    cte15.malaria_non_index_count as "MALARIA_NON_INDEX",
    cte16.chip_gbv_screening_count as "CHIP_GBV_SCREENING"
FROM 
    covid_screening_cte cte1
LEFT JOIN hiv_fu_screening_cte cte2 ON cte2.location_id = cte1.location_id
LEFT JOIN active_malaria_cte cte3 ON cte3.location_id = cte1.location_id
LEFT JOIN passive_malaria_cte cte4 ON cte4.location_id = cte1.location_id
LEFT JOIN known_positive_cte cte5 ON cte5.location_id = cte1.location_id
LEFT JOIN hiv_screening_cte cte6 ON cte6.location_id = cte1.location_id
LEFT JOIN fhw_anc_visit_cte cte7 ON cte7.location_id = cte1.location_id
LEFT JOIN rch_pnc_cte cte8 ON cte8.location_id = cte1.location_id
LEFT JOIN chip_tb_cte cte9 ON cte9.location_id = cte1.location_id
LEFT JOIN chip_tb_follow_up_cte cte10 ON cte10.location_id = cte1.location_id
LEFT JOIN fhw_cs_cte cte11 ON cte11.location_id = cte1.location_id
LEFT JOIN hiv_positive_cte cte12 ON cte12.location_id = cte1.location_id
LEFT JOIN emtct_cte cte13 ON cte13.location_id = cte1.location_id
LEFT JOIN malaria_index_cte cte14 ON cte14.location_id = cte1.location_id
LEFT JOIN malaria_non_index_cte cte15 ON cte15.location_id = cte1.location_id
LEFT JOIN chip_gbv_screening_cte cte16 ON cte16.location_id = cte1.location_id
left join location_master lm on lm.id = cte1.location_id', 
'Retrieves counts of services', 
true, 'ACTIVE');