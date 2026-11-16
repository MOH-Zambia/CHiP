-- Fix the "State Of Health Data Population 2" timer event (event_configuration 247).
--
-- Every run since 2025-01-06 has failed with
--   relation "soh_timeline_analytics_t" already exists
-- The template commits in blocks. Its final block renamed soh_timeline_analytics_t to
-- soh_timeline_analytics_temp and then ran DROP TABLE soh_timeline_analytics_t, which no
-- longer existed, so that block always rolled back, leaving soh_timeline_analytics_t
-- behind, and the next run's CREATE TABLE failed on it.
--
-- Changes: drop any leftover soh_timeline_analytics_t before creating it, and remove the
-- impossible DROP after the rename. Both stored copies of the template are updated.
-- Idempotent. Flyway is disabled; apply by hand.

update event_configuration_type
   set template = $tpl$--======================================================================================================================
--UPDATE timer_event
BEGIN;
UPDATE timer_event 
SET 
    completed_on = clock_timestamp(),
    status = 'PROCESSED1'
WHERE 
    event_config_id = 247
    AND status = 'PROCESSED';
COMMIT;
--========================================================================================================================
-- CREATE ANALYTICS TABLE
BEGIN;

-- A failed run leaves this table behind; without the drop every later run fails on CREATE.
DROP TABLE IF EXISTS public.soh_timeline_analytics_t;

CREATE TABLE public.soh_timeline_analytics_t (
    location_id INTEGER NOT NULL,
    element_name TEXT NOT NULL,
    target DOUBLE PRECISION,
    male INTEGER,
    female INTEGER,
    chart1 DOUBLE PRECISION,
    chart2 DOUBLE PRECISION,
    chart3 DOUBLE PRECISION,
    chart4 DOUBLE PRECISION,
    chart5 DOUBLE PRECISION,
    chart6 DOUBLE PRECISION,
    chart7 DOUBLE PRECISION,
    chart8 DOUBLE PRECISION,
    chart9 DOUBLE PRECISION,
    chart10 DOUBLE PRECISION,
    chart11 DOUBLE PRECISION,
    chart12 DOUBLE PRECISION,
    chart13 DOUBLE PRECISION,
    chart14 DOUBLE PRECISION,
    chart15 DOUBLE PRECISION,
    value DOUBLE PRECISION,
    timeline_type CHARACTER VARYING(50) NOT NULL,
    created_on TIMESTAMP WITHOUT TIME ZONE,
    reporting VARCHAR(255),
    calculatedTarget NUMERIC(12, 2),
    color VARCHAR(255),
    percentage NUMERIC(12, 2),
    displayValue TEXT,
    days INTEGER,
    sortPriority INTEGER,
    rank_of_location INTEGER,
    PRIMARY KEY (location_id, element_name, timeline_type)
);

-- Update timer_event to mark status as 'PROCESSED3'
UPDATE timer_event 
SET 
    completed_on = clock_timestamp(),
    status = 'PROCESSED2'
WHERE 
    event_config_id = 247 
    AND status = 'PROCESSED1';
COMMIT;
--=======================================================================================================================
-- INTERVALS
BEGIN;
DROP TABLE IF EXISTS intervals;
WITH parameters AS (
    SELECT 
        TO_DATE(
            CONCAT('04-01-', 
            CASE 
                WHEN DATE_PART('month', CURRENT_DATE) >= 4 THEN DATE_PART('year', CURRENT_DATE)
                ELSE DATE_PART('year', CURRENT_DATE) - 1
            END),
            'MM-DD-YYYY'
        ) AS financial_year_start_date
)
SELECT * 
INTO intervals
FROM (
    SELECT 
        INTERVAL '1 days' AS interval, 
        'YESTERDAY' AS timeline_type, 
        'Yesterday' AS label, 
        FALSE AS is_active, 
        FALSE AS is_default, 
        (CURRENT_DATE - INTERVAL '1 days') AS from_date, 
        (CURRENT_DATE + INTERVAL '1 day' - INTERVAL '1 millisecond') AS to_date
    UNION ALL
    SELECT 
        INTERVAL '7 days', 
        'LAST_7_DAYS', 
        'Last 7 days', 
        TRUE, 
        FALSE, 
        (CURRENT_DATE - INTERVAL '7 days'), 
        (CURRENT_DATE + INTERVAL '1 day' - INTERVAL '1 millisecond')
    UNION ALL
    SELECT 
        INTERVAL '30 days', 
        'LAST_30_DAYS', 
        'Last 30 days', 
        TRUE, 
        TRUE, 
        (CURRENT_DATE - INTERVAL '30 days'), 
        (CURRENT_DATE + INTERVAL '1 day' - INTERVAL '1 millisecond')
    UNION ALL
    SELECT 
        INTERVAL '365 days', 
        'LAST_365_DAYS', 
        'Last 365 days', 
        TRUE, 
        FALSE, 
        (CURRENT_DATE - INTERVAL '365 days'), 
        (CURRENT_DATE + INTERVAL '1 day' - INTERVAL '1 millisecond')
    UNION ALL
    SELECT 
        (EXTRACT(day FROM NOW() - (SELECT financial_year_start_date FROM parameters))) * INTERVAL '1 day', 
        'YEAR_04_2019', 
        'Current FY', 
        TRUE, 
        FALSE, 
        (CURRENT_DATE - (EXTRACT(day FROM NOW() - (SELECT financial_year_start_date FROM parameters))) * INTERVAL '1 day'), 
        (CURRENT_DATE + INTERVAL '1 day' - INTERVAL '1 millisecond')
) AS t;
UPDATE timer_event 
SET 
    completed_on = clock_timestamp(),
    status = 'PROCESSED3'
WHERE 
    event_config_id = 247 
    AND status = 'PROCESSED2';

COMMIT;
--=======================================================================================================================
-- MALARIA
BEGIN;
WITH location_det AS (
    SELECT DISTINCT child_id AS loc_id
    FROM location_hierchy_closer_det
    WHERE parent_id IN (
        SELECT id FROM location_master
        WHERE parent IS NULL
        LIMIT 1
    )
),
malaria_data AS (
    SELECT 
        lh.parent_id AS loc_id,
        intervals.timeline_type,
        COUNT(DISTINCT CASE WHEN md.created_on >= CURRENT_DATE - intervals.interval THEN md.id END) AS total_tested,
        COUNT(DISTINCT CASE 
            WHEN md.created_on >= CURRENT_DATE - intervals.interval AND md.rdt_test_status = 'POSITIVE' THEN md.id
        END) AS tested_positive,
		COUNT(DISTINCT CASE 
            WHEN mic.created_on >= CURRENT_DATE - intervals.interval AND md.rdt_test_status = 'POSITIVE' THEN mic.id
        END) AS total_index_cases,
		COUNT(DISTINCT CASE 
            WHEN mnic.created_on >= CURRENT_DATE - intervals.interval AND md.rdt_test_status = 'POSITIVE' THEN mnic.id
        END) AS total_non_index_cases
    FROM location_hierchy_closer_det lh
    LEFT JOIN malaria_details md ON lh.child_id = md.location_id
    LEFT JOIN malaria_index_case_details mic ON md.member_id = mic.member_id
    LEFT JOIN malaria_non_index_case_details mnic ON md.member_id = mnic.member_id
	INNER JOIN intervals ON true
    WHERE lh.parent_id IN (SELECT loc_id FROM location_det)
	GROUP BY lh.parent_id, intervals.timeline_type
)
INSERT INTO soh_timeline_analytics_t(
    location_id, element_name, value, chart1, timeline_type, created_on
)
SELECT 
    md.loc_id, 
    cast('MALARIA' as text)  AS element_name, 
    md.total_tested, 
    md.tested_positive,
    md.timeline_type, 
    NOW()
FROM malaria_data md;

UPDATE timer_event 
SET 
    completed_on = clock_timestamp(),
    status = 'PROCESSED4'
WHERE 
    event_config_id = 247 AND status = 'PROCESSED3';
COMMIT;
--===========================================================================================================================
-- HIV
BEGIN;
WITH location_det AS (
    SELECT DISTINCT child_id AS loc_id
    FROM location_hierchy_closer_det
    WHERE parent_id IN (
        SELECT id FROM location_master
        WHERE parent IS NULL
        LIMIT 1
    )
),
hiv_data AS (
    SELECT 
        lh.parent_id AS loc_id,
        intervals.timeline_type,
        COUNT(DISTINCT CASE WHEN rsm.created_on >= CURRENT_DATE - intervals.interval THEN rsm.created_on END) AS total_tested,
        COUNT(DISTINCT CASE 
            WHEN rpk.created_on >= CURRENT_DATE - intervals.interval THEN rpk.created_on
            WHEN rkm.created_on >= CURRENT_DATE - intervals.interval THEN rkm.created_on
        END) AS tested_positive
    FROM location_hierchy_closer_det lh
    LEFT JOIN rch_hiv_screening_master rsm ON lh.child_id = rsm.location_id
    LEFT JOIN rch_preg_hiv_positive_master rpk ON rsm.member_id = rpk.member_id
    LEFT JOIN rch_hiv_known_master rkm ON rsm.member_id = rkm.member_id
	INNER JOIN intervals ON true
    WHERE lh.parent_id IN (SELECT loc_id FROM location_det)
    GROUP BY lh.parent_id, intervals.timeline_type
)
INSERT INTO soh_timeline_analytics_t(
    location_id, element_name, value, chart1, timeline_type, created_on
)
SELECT 
    hd.loc_id, 
    cast('HIV_TEST' as TEXT) AS element_name, 
    hd.total_tested, 
    hd.tested_positive,
    hd.timeline_type, 
    NOW()
FROM hiv_data hd;

UPDATE timer_event 
SET 
    completed_on = clock_timestamp(),
    status = 'PROCESSED5'
WHERE 
    event_config_id = 247 AND status = 'PROCESSED4';
COMMIT;
--==============================================================================================================================
-- MMR
BEGIN; 
WITH location_det AS (
    SELECT DISTINCT child_id AS loc_id
    FROM location_hierchy_closer_det
    WHERE parent_id IN (
        SELECT id FROM location_master
        WHERE parent IS NULL
        LIMIT 1
    )
),
mmr_data AS ( 
	SELECT CAST(lh.parent_id AS integer) AS loc_id, 
	intervals.timeline_type, 
	SUM(CASE WHEN death_date >= current_date - intervals.interval AND maternal_detah THEN 1 ELSE 0 END) AS yesterday, 
	SUM(CASE WHEN date_of_delivery >= current_date - intervals.interval AND delivery_outcome = 'LBIRTH' THEN total_out_come ELSE 0 END) AS yesterday_live_birth 
	FROM location_hierchy_closer_det lh 
	LEFT JOIN rch_pregnancy_analytics_details ON lh.child_id = death_location_id
	INNER JOIN intervals ON true 
	WHERE lh.parent_id IN (SELECT loc_id FROM location_det)
	GROUP BY loc_id,intervals.timeline_type
	ORDER BY loc_id
)
INSERT INTO soh_timeline_analytics_t(location_id,element_name,value,chart1,timeline_type, created_on) 
	SELECT 
	md.loc_id,
	CAST('MMR' as text) as "elementName",
	md.yesterday,
	md.yesterday_live_birth,
	md.timeline_type,
	now() 
	FROM mmr_data md; 
UPDATE timer_event 
SET completed_on = clock_timestamp(),status = 'PROCESSED6' 
WHERE event_config_id = 247 AND status = 'PROCESSED5'; 
COMMIT;
--======================================================================================================================
-- TB
BEGIN;
WITH location_det AS (
    SELECT DISTINCT child_id AS loc_id
    FROM location_hierchy_closer_det
    WHERE parent_id IN (
        SELECT id FROM location_master
        WHERE parent IS NULL
        LIMIT 1
    )
),
tb_data AS (
    SELECT 
        lh.parent_id AS loc_id,
        intervals.timeline_type,
        COUNT(DISTINCT CASE 
            WHEN tbsd.created_on >= CURRENT_DATE - intervals.interval AND tbsd.is_tb_testing_done THEN tbsd.id
        END) AS tb_tested,
        COUNT(DISTINCT CASE 
            WHEN tbsd.created_on >= CURRENT_DATE - intervals.interval AND tbsd.is_tb_cured THEN tbsd.id
        END) AS tb_cured
    FROM location_hierchy_closer_det lh
    LEFT JOIN tuberculosis_screening_details tbsd ON lh.child_id = tbsd.location_id
    INNER JOIN intervals ON true
    WHERE lh.parent_id IN (SELECT loc_id FROM location_det)
    GROUP BY lh.parent_id, intervals.timeline_type
)
INSERT INTO soh_timeline_analytics_t(
    location_id, element_name, value, chart1, timeline_type, created_on
)
SELECT 
    tb.loc_id, 
    cast('TB_NOTIFICATION' as TEXT) AS element_name, 
    tb.tb_tested, 
    tb.tb_cured,
    tb.timeline_type, 
    NOW()
FROM tb_data tb;

UPDATE timer_event 
SET 
    completed_on = clock_timestamp(),
    status = 'PROCESSED7'
WHERE 
    event_config_id = 247 AND status = 'PROCESSED6';
COMMIT;

begin;
with configurations as
(
	select * from soh_element_configuration
),
percentages as (
	select location_id,analytics.timeline_type ,config.*,

	-- for calculate the value
	case when (analytics.element_name ='IMR' and  analytics.chart1!=0) THEN ROUND(analytics.value * 1000 / analytics.chart1)
	when (analytics.element_name ='MMR' and  analytics.chart1!=0) THEN ROUND(analytics.value * 100000 / analytics.chart1)
	when (analytics.element_name ='ID' and  analytics.chart1!=0) THEN (analytics.value * 100 / analytics.chart1)
	when (analytics.element_name ='SR' and  analytics.male!=0) THEN (analytics.female * 1000 / analytics.male)
	when (analytics.element_name ='SAM' and  analytics.chart1!=0) THEN (analytics.value * 100 / analytics.chart1)
	when (analytics.element_name ='LBW' and  analytics.value!=0) THEN ((analytics.chart1 + chart2) * 100 / analytics.value )
	when (analytics.element_name ='PREG_REG' and  analytics.value!=0) THEN ((analytics.chart1) * 100 / analytics.value )
	when (analytics.element_name ='FI' and  analytics.chart1!=0) THEN ((analytics.value) * 100 / analytics.chart1 )
	when (analytics.element_name ='Anemia' and  (analytics.chart1 + analytics.chart2 + analytics.chart3 + analytics.chart4)!=0) THEN ((analytics.chart1) * 100 / (analytics.chart1 + analytics.chart2 + analytics.chart3 + analytics.chart4) )

	when (analytics.element_name ='VERIFICATION_SERVICE' and  analytics.value!=0) THEN ((analytics.chart1 * 100) / analytics.value )
    when (analytics.element_name ='BENEFICIARY_WRONG_MOBILE_NUMBER' and  analytics.value!=0) THEN ((analytics.chart1) * 100 / analytics.value )
    when (analytics.element_name ='DATA_QUALITY' and  analytics.value!=0) THEN ((analytics.chart1) * 100 / analytics.value )

	when (analytics.element_name ='AVG_SERVICE_DURATION' and  analytics.value!=0) THEN ((analytics.chart1) / analytics.value )

	when (analytics.element_name ='NCD_HYPERTENSION' and  analytics.chart1!=0) THEN (((((30 * value)/days)*100)/chart1))
	when (analytics.element_name ='NCD_DIABETES' and  analytics.chart1!=0) THEN (((((30 * value)/days)*100)/chart1))
	when (analytics.element_name ='NCD_CERVICAL' and  analytics.chart1!=0) THEN (((((30 * value)/days)*100)/chart1))
	when (analytics.element_name ='NCD_BREAST' and  analytics.chart1!=0) THEN (((((30 * value)/days)*100)/chart1))
	when (analytics.element_name ='NCD_ORAL' and  analytics.chart1!=0) THEN (((((30 * value)/days)*100)/chart1))

	when (analytics.element_name ='NCD_HYPERTENSION_CONFIRM' and  analytics.chart4!=0) THEN ((analytics.chart3 * 100 / analytics.chart4))
	when (analytics.element_name ='NCD_DIABETES_CONFIRM' and  analytics.chart4!=0) THEN ((analytics.chart3 * 100 / analytics.chart4))

	when (analytics.element_name ='TECHO_PENDING_WORK_NOTIFICATION' and  analytics.chart4!=0) THEN ((analytics.value * 100 / analytics.chart4))

	else 0 end as calculatedTarget,

	-- for percentage calculation
	case when (analytics.element_name ='IMR' and  analytics.chart1!=0) THEN ((analytics.value * 1000 / analytics.chart1)*100)/ config.target
	when (analytics.element_name ='MMR' and  analytics.chart1!=0) THEN ((analytics.value * 100000 / analytics.chart1)*100)/ config.target
	when (analytics.element_name ='ID' and  analytics.chart1!=0) THEN (analytics.value * 100 / analytics.chart1)
	when (analytics.element_name ='SR' and  analytics.male!=0) THEN (analytics.female * 1000 / analytics.male)
	when (analytics.element_name ='SAM' and  analytics.chart1!=0) THEN (analytics.value * 100 / analytics.chart1)
	when (analytics.element_name ='LBW' and  analytics.value!=0) THEN ((analytics.chart1 + chart2) * 100 / analytics.value )
	when (analytics.element_name ='PREG_REG' and  analytics.value!=0) THEN ((analytics.chart1) * 100 / analytics.value )
	when (analytics.element_name ='FI' and  analytics.chart1!=0) THEN ((analytics.value) * 100 / analytics.chart1 )
	when (analytics.element_name ='Anemia' and  (analytics.chart1 + analytics.chart2 + analytics.chart3 + analytics.chart4)!=0) THEN ((analytics.chart1) * 100 / (analytics.chart1 + analytics.chart2 + analytics.chart3 + analytics.chart4) )

	when (analytics.element_name ='VERIFICATION_SERVICE' and  analytics.value!=0) THEN ((analytics.chart1 * 100) / analytics.value )
	when (analytics.element_name ='BENEFICIARY_WRONG_MOBILE_NUMBER' and  analytics.value!=0) THEN ((analytics.chart1) * 100 / analytics.value )
	when (analytics.element_name ='DATA_QUALITY' and  analytics.value!=0) THEN ((analytics.chart1) * 100 / analytics.value )

	when (analytics.element_name ='AVG_SERVICE_DURATION' and  analytics.value!=0) THEN ((analytics.chart1) / analytics.value )

	when (analytics.element_name ='NCD_HYPERTENSION' and  analytics.chart1!=0) THEN (((((30 * value)/days)*100)/chart1)*100)/config.target
	when (analytics.element_name ='NCD_DIABETES' and  analytics.chart1!=0) THEN (((((30 * value)/days)*100)/chart1)*100)/config.target
	when (analytics.element_name ='NCD_CERVICAL' and  analytics.chart1!=0) THEN (((((30 * value)/days)*100)/chart1)*100)/config.target
	when (analytics.element_name ='NCD_BREAST' and  analytics.chart1!=0) THEN (((((30 * value)/days)*100)/chart1)*100)/config.target
	when (analytics.element_name ='NCD_ORAL' and  analytics.chart1!=0) THEN (((((30 * value)/days)*100)/chart1)*100)/config.target

	when (analytics.element_name ='NCD_HYPERTENSION_CONFIRM' and  analytics.chart4!=0) THEN ((analytics.chart3 * 100 / analytics.chart4)*100)/ config.target

	when (analytics.element_name ='NCD_DIABETES_CONFIRM' and  analytics.chart4!=0) THEN ((analytics.chart3 * 100 / analytics.chart4)*100)/ config.target

	when (analytics.element_name ='ABHA_NUMBER_PROGRESS' and  analytics.chart6!=0) THEN ((analytics.chart7 * 100 / analytics.chart6))

	end as percentage,

	case when location.type in ('C','Z','U','ANM','ANG','AA')
			then case when (target_for_rural is null or target_for_rural = 0) then config.target  else target_for_rural end
	     when location.type in ('D','B','P','SC','V','A')
			then case when (target_for_urban is null or target_for_urban = 0) then config.target  else target_for_urban  end
	     when location.type in ('S')
			then config.target
	     else config.target
	end
	as target_1,

	case when location.type in ('C','Z','U','ANM','ANG','AA')
			then case when (lower_bound is null or lower_bound = 0) then config.lower_bound  else lower_bound end
	     when location.type in ('D','B','P','SC','V','A')
			then case when (lower_bound_for_rural is null or lower_bound_for_rural = 0) then lower_bound   else config.lower_bound_for_rural  end
	     when location.type in ('S')
			then config.lower_bound
	     else config.lower_bound
	end
	as lower_bound_1,

	case when location.type in ('C','Z','U','ANM','ANG','AA')
			then case when (upper_bound is null or upper_bound = 0) then config.upper_bound  else upper_bound end
	     when location.type in ('D','B','P','SC','V','A')
			then case when (upper_bound_for_rural is null or upper_bound_for_rural = 0) then upper_bound   else config.upper_bound_for_rural  end
	     when location.type in ('S')
			then config.upper_bound
	     else config.upper_bound
	end
	as upper_bound_1
	from
	soh_timeline_analytics_t analytics inner join location_master location on location.id = analytics.location_id
	inner join configurations config on analytics.element_name = config.element_name
	--where location_id=26184

),
calculations as(
select
calculatedTarget,
case when calculatedTarget < lower_bound_1 then 'UNDER_REPORTING'
     when calculatedTarget > upper_bound_1  then 'OVER_REPORTING'
     when calculatedTarget >= lower_bound_1 AND calculatedTarget<=upper_bound_1   then 'AS_EXPECTED_REPORTING' end as reporting,

case when
	is_small_value_positive  then
		case when percentages.target_1 >= calculatedTarget and target_mid <=calculatedTarget and target_mid_enable then 'YELLOW'
		when percentages.target_1 > calculatedTarget  then 'GREEN'
		else 'RED' end
	else
		case when percentages.target_1 >= calculatedTarget and target_mid <=calculatedTarget and target_mid_enable then 'YELLOW'
		when percentages.target_1 <= calculatedTarget  then 'GREEN'
		else 'RED' end
	end as color,

case when
	is_small_value_positive  then
		case when percentages.target_1 >= calculatedTarget and target_mid <=calculatedTarget and target_mid_enable then 2
		when percentages.target_1 > calculatedTarget  then 1
		else 3 end
	else
		case when percentages.target_1 >= calculatedTarget and target_mid <=calculatedTarget and target_mid_enable then 2
		when percentages.target_1 <= calculatedTarget  then 1
		else 3 end
	end as sortPriority,

element_name,
percentage,
location_id,
percentages.timeline_type
from percentages
)
update soh_timeline_analytics_t
set
reporting = calculations.reporting,
calculatedTarget= calculations.calculatedTarget,
color = calculations.color,
percentage = calculations.percentage,
sortPriority = calculations.sortPriority
from calculations
where  soh_timeline_analytics_t.location_id = calculations.location_id
and soh_timeline_analytics_t.timeline_type = calculations.timeline_type
and soh_timeline_analytics_t.element_name = calculations.element_name;
update timer_event SET completed_on = clock_timestamp(),status = 'PROCESSED6'
where event_config_id = 264 and status = 'PROCESSED5';
commit;

BEGIN;
DROP TABLE IF EXISTS soh_timeline_analytics_temp;
CREATE INDEX soh_timeline_analytics_temp_timeline_idx 
ON soh_timeline_analytics_t (timeline_type, location_id, element_name);
CREATE INDEX soh_timeline_analytics_temp_element_name_idx 
ON soh_timeline_analytics_t (element_name);
ALTER TABLE soh_timeline_analytics_t 
RENAME TO soh_timeline_analytics_temp;
DROP TABLE IF EXISTS soh_element_timeline_intervals;
ALTER TABLE IF EXISTS intervals 
RENAME TO soh_element_timeline_intervals;
UPDATE timer_event 
SET completed_on = clock_timestamp(), 
    status = 'COMPLETED' 
WHERE event_config_id = 247 AND status = 'PROCESSED7';
COMMIT;$tpl$
 where id = '10929520-5867-4ef6-b138-48fe2b6a2069';

update event_configuration
   set config_json = jsonb_set(config_json::jsonb,
                               '{0,conditions,0,notificaitonConfigsType,0,template}',
                               to_jsonb((select template from event_configuration_type
                                          where id = '10929520-5867-4ef6-b138-48fe2b6a2069')))::text
 where id = 247
   and config_json::jsonb #>> '{0,conditions,0,notificaitonConfigsType,0,id}' = '10929520-5867-4ef6-b138-48fe2b6a2069';
