----Household
--pie
DELETE FROM QUERY_MASTER WHERE CODE='fetch_household_pie_chart_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'2b31dc96-6f34-4b03-8e79-ace65d716c60', 97104,  current_date , 97104,  current_date , 'fetch_household_pie_chart_data',
'location_id',
'with cte as (
    select
        count(*) filter (where age(im.dob) >= interval ''5 years'' and gender = ''M'') as total_men,
        count(*) filter (where age(im.dob) >= interval ''5 years'' and gender = ''F'') as total_women,
        count(*) filter (where age(im.dob) < interval ''5 years'') as total_children
    from imt_member im
    inner join imt_family if on im.family_id = if.family_id
    inner join location_hierchy_closer_det lhcd on lhcd.child_id = if.area_id
    where lhcd.parent_id = #location_id#
)
select
    cast(json_build_object(
        ''labels'', array[''Men'', ''Women'', ''Children''],
        ''values'', array[(select total_men from cte), (select total_women from cte), (select total_children from cte)]
    ) as text) as result;',
'Feature Name :- All Service Dashboard
Purpose :- To fetch household data for pie chart',
true, 'ACTIVE');

--bar
DELETE FROM QUERY_MASTER WHERE CODE='fetch_household_bar_chart_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'd553bae7-5d19-415c-85e6-081eabc9b390', 97104,  current_date , 97104,  current_date , 'fetch_household_bar_chart_data',
'location_id',
'with cte as (
    select
        count(*) filter (where if.drinking_water_source is not null or if.other_water_source is not null) as improved_water_sources,
        count(*) filter (where if.type_of_toilet is not null or if.other_toilet is not null) as improved_toilet_facilities,
        count(*) filter (where if.waste_disposal_method is not null) as disposal,
        count(*) filter (where if.handwash_available) as handwashing_facilities
    from imt_family if
    inner join location_hierchy_closer_det lhcd on lhcd.child_id = if.area_id
    where lhcd.parent_id = #location_id#
)
select
 cast(json_build_object(
        ''labels'', array[''Improved Water Sources'',''Improved Toilet Facilities'',''Disposal'',''Handwashing Facility''],
        ''values'', array[(select improved_water_sources from cte),
        (select improved_toilet_facilities from cte),
        (select disposal from cte),
        (select handwashing_facilities from cte)]
    ) as text) as result;',
'Feature Name :- All Service Dashboard
 Purpose :- To fetch household data for bar chart',
true, 'ACTIVE');

--table
DELETE FROM QUERY_MASTER WHERE CODE='fetch_household_table_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'3d62b661-706d-4bf7-a9b7-4f97c54bc602', 97104,  current_date , 97104,  current_date , 'fetch_household_table_data',
'location_id',
'with locations as (
    select
        lm.id as location_id,
        lm.english_name as location_name
    from location_master lm
    inner join location_hierchy_closer_det lhcd on lm.id = lhcd.child_id
    where lhcd.parent_id = #location_id#
    and lhcd.depth = 1
)
select
    l.location_name as "Location",
    count(distinct if.id) as "TotalHouseholds",
    count(im.id) as "TotalClients",
    count(im.id) filter (where age(im.dob) between interval ''15 years'' and interval ''75 years'') as "EligibleMembers",
    count(im.id) filter (where im.is_pregnant) as "PregnantWomen",
    count(im.id) filter (where age(im.dob) < interval ''5 years'') as "ChildrenUnder5"
from locations l
left join location_hierchy_closer_det lhcd on l.location_id = lhcd.parent_id
left join imt_family if on if.area_id = lhcd.child_id
left join imt_member im on if.family_id = im.family_id
group by 1;',
'Feature Name :- All Service Dashboard
Purpose :- To fetch household data for table',
true, 'ACTIVE');


---Pregnant Women

--pie
DELETE FROM QUERY_MASTER WHERE CODE='fetch_pregnant_women_pie_chart_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'222bf967-597b-4767-8632-b7dc2bcd3011', 97104,  current_date , 97104,  current_date , 'fetch_pregnant_women_pie_chart_data',
'location_id',
'with cte as (
    select
        count(*) filter (where im.is_high_risk_case is not true and rphpm.member_id is null) as normal,
        count(*) filter (where im.is_high_risk_case and rphpm.member_id is not null) as high_risk_hiv,
        count(*) filter (where im.is_high_risk_case and rphpm.member_id is null) as high_risk,
        count(*) filter (where im.is_high_risk_case is not true and rphpm.member_id is not null) as hiv
    from imt_member im
    inner join imt_family if on im.family_id = if.family_id
    inner join location_hierchy_closer_det lhcd on lhcd.child_id = if.area_id
    left join rch_preg_hiv_positive_master rphpm on im.id = rphpm.member_id
    where im.is_pregnant and lhcd.parent_id = #location_id#
)
select cast(json_build_object(
        ''labels'', array[''Normal'',''High Risk & HIV'',''High Risk'',''HIV''],
        ''values'', array[
        (select normal from cte),
        (select high_risk_hiv from cte),
        (select high_risk from cte),
        (select hiv from cte)
    ]
    ) as text) as result',
'Feature Name :- All Service Dashboard
 Purpose :- To fetch pregnant women data for pie chart',
true, 'ACTIVE');

--bar
DELETE FROM QUERY_MASTER WHERE CODE='fetch_pregnant_women_bar_chart_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'450a25b3-5135-4591-a8f0-9c8fc5f169d4', 97104,  current_date , 97104,  current_date , 'fetch_pregnant_women_bar_chart_data',
'location_id',
'with cte as (
    select
        (select count(*)
        from rch_anc_master ram
        inner join location_hierchy_closer_det lhcd on lhcd.parent_id = #location_id# and lhcd.child_id = ram.location_id) as anc_visits,
        (select count(*)
        from rch_wpd_mother_master rwmm
        inner join location_hierchy_closer_det lhcd on lhcd.parent_id = #location_id# and lhcd.child_id = rwmm.location_id
        where rwmm.has_delivery_happened) as pregnancy_outcome_visits,
        (select count(*)
        from rch_pnc_master rpm
        inner join location_hierchy_closer_det lhcd on lhcd.parent_id = #location_id# and lhcd.child_id = rpm.location_id) as pnc_visits
)
select cast(json_build_object(
        ''labels'', array[''ANC Visits'',''Pregnancy Outcome Visits'',''PNC Visits''],
        ''values'', array[
        (select anc_visits from cte),
        (select pregnancy_outcome_visits from cte),
        (select pnc_visits from cte)
    ]
    ) as text) as result',
'Feature Name :- All Service Dashboard
 Purpose :- To fetch pregnant women data for bar chart',
true, 'ACTIVE');

--table
DELETE FROM QUERY_MASTER WHERE CODE='fetch_pregnant_women_table_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'623a8862-d694-4789-893c-c9bcf97ea6a7', 97104,  current_date , 97104,  current_date , 'fetch_pregnant_women_table_data',
'location_id',
'with locations as (
    select
        lm.id as location_id,
        lm.english_name as location_name
    from location_master lm
    inner join location_hierchy_closer_det lhcd on lm.id = lhcd.child_id
    where lhcd.parent_id = #location_id#
    and lhcd.depth = 1
), preg_women_info as (
    select
        l.location_id,
        count(*) as pw,
        count(*) filter (where im.is_high_risk_case) as high_risk
    from locations l
    inner join location_hierchy_closer_det lhcd on l.location_id = lhcd.parent_id
    inner join imt_family if on if.area_id = lhcd.child_id
    inner join imt_member im on im.family_id = if.family_id
    where im.is_pregnant and lhcd.parent_id = #location_id#
    group by 1
), hiv_info as (
    select
        l.location_id,
        count(*) as hiv_positive_women
    from locations l
    inner join location_hierchy_closer_det lhcd on l.location_id = lhcd.parent_id
    inner join rch_preg_hiv_positive_master rphpm on rphpm.location_id = lhcd.child_id
    group by 1
), anc_visits as (
    select
        l.location_id,
        count(*) as anc_visits_done
    from locations l
    inner join location_hierchy_closer_det lhcd on l.location_id = lhcd.parent_id
    inner join rch_anc_master ram on ram.location_id = lhcd.child_id
    group by 1
), pnc_visits as (
    select
        l.location_id,
        count(*) as pnc_visits_done
    from locations l
    inner join location_hierchy_closer_det lhcd on l.location_id = lhcd.parent_id
    inner join rch_pnc_master rpm on rpm.location_id = lhcd.child_id
    group by 1
), wpd_visits as (
    select
        l.location_id,
        count(*) as wpd_visits_done,
        count(*) filter (where rwmm.pregnancy_outcome = ''LBIRTH'') as lbirth,
        count(*) filter (where rwmm.pregnancy_outcome = ''SBIRTH'') as sbirth
    from locations l
    inner join location_hierchy_closer_det lhcd on l.location_id = lhcd.parent_id
    inner join rch_wpd_mother_master rwmm on rwmm.location_id = lhcd.child_id
    where rwmm.has_delivery_happened
    group by 1
)
select
    l.location_name as "Location",
    coalesce(sum(pwi.pw), 0) as "PregnantWomen",
    coalesce(sum(pwi.high_risk), 0) as "HighRiskWomen",
    coalesce(sum(hi.hiv_positive_women), 0) as "womenWithHIV",
    coalesce(sum(av.anc_visits_done), 0) as "ANCvisits",
    coalesce(sum(wv.wpd_visits_done), 0) as "deliveries",
    coalesce(sum(pv.pnc_visits_done), 0) as "PNCvisits",
    coalesce(sum(wv.lbirth), 0) as "liveBirth",
    coalesce(sum(wv.sbirth), 0) as "stillBirth"
from locations l
left join preg_women_info pwi on l.location_id = pwi.location_id
left join hiv_info hi on l.location_id = hi.location_id
left join anc_visits av on l.location_id = av.location_id
left join pnc_visits pv on l.location_id = pv.location_id
left join wpd_visits wv on l.location_id = wv.location_id
group by 1;',
'Feature Name :- All Service Dashboard
Purpose :- To fetch pregnant women data for table',
true, 'ACTIVE');


---Under 5

--pie
DELETE FROM QUERY_MASTER WHERE CODE='fetch_under_five_pie_chart_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'0f43c585-3825-496d-aa35-eb3d7e8a5dab', 97104,  current_date , 97104,  current_date , 'fetch_under_five_pie_chart_data',
'location_id',
'with cte as (
    select
        count(*) filter (where age(im.dob) < interval ''1 year'') as age_0_1,
        count(*) filter (where age(im.dob) >= interval ''1 year'' and age(im.dob) < interval ''2 years'') as age_1_2,
        count(*) filter (where age(im.dob) >= interval ''2 year'' and age(im.dob) < interval ''3 years'') as age_2_3,
        count(*) filter (where age(im.dob) >= interval ''3 year'' and age(im.dob) < interval ''4 years'') as age_3_4,
        count(*) filter (where age(im.dob) >= interval ''4 year'' and age(im.dob) < interval ''5 years'') as age_4_5
    from imt_member im
    inner join imt_family if on im.family_id = if.family_id
    inner join location_hierchy_closer_det lhcd on lhcd.child_id = if.area_id and lhcd.parent_id = #location_id#
    where age(im.dob) < interval ''5 years''
)
select cast(json_build_object(
        ''labels'', array[''Age 0-1'',''Age 1-2'',''Age 2-3'',''Age 3-4'',''Age 4-5''],
        ''values'', array[
        (select age_0_1 from cte),
        (select age_1_2 from cte),
        (select age_2_3 from cte),
        (select age_3_4 from cte),
        (select age_4_5 from cte)
    ]
    ) as text) as result',
'Feature Name :- All Service Dashboard
Purpose :- To fetch under five years data for pie chart',
true, 'ACTIVE');

--bar
DELETE FROM QUERY_MASTER WHERE CODE='fetch_under_five_bar_chart_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'1641b26f-da10-4f1b-b399-cbd7bbd46595', 97104,  current_date , 97104,  current_date , 'fetch_under_five_bar_chart_data',
'location_id',
'with cte as (
    select
        count(*) filter (where rcsm.is_high_risk_case is not true) as normal,
        count(*) filter (where rcsm.is_high_risk_case) as high_risk
    from rch_child_service_master rcsm
    inner join location_hierchy_closer_det lhcd on lhcd.child_id = rcsm.location_id
    where lhcd.parent_id = #location_id#
)
select cast(json_build_object(
        ''labels'', array[''Normal'',''High Risk''],
        ''values'', array[
        (select normal from cte),
        (select high_risk from cte)
    ]
    ) as text) as result',
'Feature Name :- All Service Dashboard
Purpose :- To fetch under five years data for bar chart',
true, 'ACTIVE');

--table
DELETE FROM QUERY_MASTER WHERE CODE='fetch_under_five_table_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'3880e812-3360-4118-ab29-16f6c5751d10', 97104,  current_date , 97104,  current_date , 'fetch_under_five_table_data',
'location_id',
'with locations as (
    select
        lm.id as location_id,
        lm.english_name as location_name
    from location_master lm
    inner join location_hierchy_closer_det lhcd on lm.id = lhcd.child_id
    where lhcd.parent_id = #location_id#
    and lhcd.depth = 1
)
select
    l.location_name as "Location",
    count(distinct im.id) as "TotalChildren",
    count(rcsm.id) filter (where rcsm.id is not null) as "TotalChildServicevisit",
    count(distinct im.id) filter (where rcsm.is_high_risk_case) as "HighRiskChildrenIdentified",
    count(distinct im.id) filter (where rcsm.referral_place is not null) as "ReferredChildren"
from locations l
left join location_hierchy_closer_det lhcd on l.location_id = lhcd.parent_id
left join imt_family if on if.area_id = lhcd.child_id
left join imt_member im on im.family_id = if.family_id
left join rch_child_service_master rcsm on rcsm.member_id = im.id
group by 1;',
'Feature Name :- All Service Dashboard
Purpose :- To fetch under five years data for table',
true, 'ACTIVE');


---Malaria

--pie
DELETE FROM QUERY_MASTER WHERE CODE='fetch_malaria_pie_chart_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'abceb610-2f13-4786-8a27-34107afe364c', 97104,  current_date , 97104,  current_date , 'fetch_malaria_pie_chart_data',
'location_id',
'with cte as (
    select
        count(*) filter (where md.malaria_type = ''ACTIVE'') as active,
        count(*) filter (where md.malaria_type = ''PASSIVE'') as passive
    from malaria_details md
    inner join location_hierchy_closer_det lhcd on lhcd.child_id = md.location_id and lhcd.parent_id = #location_id#
)
select cast(json_build_object(
        ''labels'', array[''Active'',''Passive''],
        ''values'', array[
        (select active from cte),
        (select passive from cte)
    ]
    ) as text) as result;',
'Feature Name :- All Service Dashboard
Purpose :- To fetch malaria data for pie chart',
true, 'ACTIVE');

--bar
DELETE FROM QUERY_MASTER WHERE CODE='fetch_malaria_bar_chart_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'6eb36797-9b17-4e94-816d-a6dad1d0c296', 97104,  current_date , 97104,  current_date , 'fetch_malaria_bar_chart_data',
'location_id',
'with cte as (
    select
        count(*) filter (where md.malaria_type = ''ACTIVE'') as active,
        count(*) filter (where md.malaria_type = ''PASSIVE'') as passive,
        count(*) filter (where md.referral_place is not null) as referred
    from malaria_details md
    inner join location_hierchy_closer_det lhcd on lhcd.child_id = md.location_id and lhcd.parent_id = #location_id#
)
select cast(json_build_object(
        ''labels'', array[''Active Cases'',''Passive Cases'',''Referred to health facility''],
        ''values'', array[
        (select active from cte),
        (select passive from cte),
        (select referred from cte)
    ]
    ) as text) as result;',
'Feature Name :- All Service Dashboard
Purpose :- To fetch malaria data for bar chart',
true, 'ACTIVE');

--table
DELETE FROM QUERY_MASTER WHERE CODE='fetch_malaria_table_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'029179d9-cad5-4660-b016-4e6b0dfc6add', 97104,  current_date , 97104,  current_date , 'fetch_malaria_table_data',
'location_id',
'with locations as (
    select
        lm.id as location_id,
        lm.english_name as location_name
    from location_master lm
    inner join location_hierchy_closer_det lhcd on lm.id = lhcd.child_id
    where lhcd.parent_id = #location_id#
    and lhcd.depth = 1
)
select
    l.location_name as "Location",
    count(md.id) filter (where md.malaria_type = ''ACTIVE'') as "ActiveMalariaCases",
    count(md.id) filter (where md.malaria_type = ''PASSIVE'') as "PassiveMalariaCases",
    count(md.id) filter (where micd.id is not null) as "IndexCases",
    count(md.id) filter (where md.referral_place is not null) as "ReferredToHealthFacility"
from locations l
left join location_hierchy_closer_det lhcd on l.location_id = lhcd.parent_id
left join malaria_details md on md.location_id = lhcd.child_id
left join malaria_index_case_details micd on micd.member_id = md.member_id
group by 1;',
'Feature Name :- All Service Dashboard
Purpose :- To fetch malaria data for table',
true, 'ACTIVE');


--- Tuberculosis

--pie
DELETE FROM QUERY_MASTER WHERE CODE='fetch_tuberculosis_pie_chart_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'26468e59-3354-4b9c-9cec-d10dad6c71f6', 97104,  current_date , 97104,  current_date , 'fetch_tuberculosis_pie_chart_data',
'location_id',
'with cte as (
    select
        count(*) filter (where tsd.is_tb_suspected is not true) as normal
    from tuberculosis_screening_details tsd
    inner join location_hierchy_closer_det lhcd on lhcd.child_id = tsd.location_id and lhcd.parent_id = #location_id#
)
select cast(json_build_object(
        ''labels'', array[''Normal''],
        ''values'', array[
        (select normal from cte)
    ]
    ) as text) as result;',
'Feature Name :- All Service Dashboard
 Purpose :- To fetch tuberculosis data for pie chart',
true, 'ACTIVE');

--bar
DELETE FROM QUERY_MASTER WHERE CODE='fetch_tuberculosis_bar_chart_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'12406bef-1ad8-4a4f-b6ab-4938f81695c8', 97104,  current_date , 97104,  current_date , 'fetch_tuberculosis_bar_chart_data',
'location_id',
'with cte as (
    select
        count(*) filter (where tsd.is_tb_suspected is not true) as normal,
        count(*) filter (where tsd.is_patient_taking_medicines) as on_treatment,
        count(*) filter (where age(im.dob) < interval ''14 years'') as member_under_14
    from tuberculosis_screening_details tsd
    inner join imt_member im on tsd.member_id = im.id
    inner join location_hierchy_closer_det lhcd on lhcd.child_id = tsd.location_id and lhcd.parent_id = #location_id#
)
select cast(json_build_object(
        ''labels'', array[''Normal'',''On treatment'',''Member under 14 years of age''],
        ''values'', array[
        (select normal from cte),
        (select on_treatment from cte),
        (select member_under_14 from cte)
    ]
    ) as text) as result;',
'Feature Name :- All Service Dashboard
Purpose :- To fetch tuberculosis data for bar chart',
true, 'ACTIVE');

--table
DELETE FROM QUERY_MASTER WHERE CODE='fetch_tuberculosis_table_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'b383d8c9-d849-4a78-aa63-78e3e825baa2', 97104,  current_date , 97104,  current_date , 'fetch_tuberculosis_table_data',
'location_id',
'with locations as (
    select
        lm.id as location_id,
        lm.english_name as location_name
    from location_master lm
    inner join location_hierchy_closer_det lhcd on lm.id = lhcd.child_id
    where lhcd.parent_id = #location_id#
    and lhcd.depth = 1
)
select
    l.location_name as "Location",
    count(tsd.id) as "TotalScreened",
    count(tsd.id) filter (where tsd.is_patient_taking_medicines) as "TotalOnTreatment"
from locations l
left join location_hierchy_closer_det lhcd on l.location_id = lhcd.parent_id
left join tuberculosis_screening_details tsd on lhcd.child_id = tsd.location_id
group by 1;',
'Feature Name :- All Service Dashboard
Purpose :- To fetch tuberculosis data for table',
true, 'ACTIVE');

---Covid

--pie

DELETE FROM QUERY_MASTER WHERE CODE='fetch_covid_pie_chart_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'bfa974a8-9d17-420a-b80f-d86cbeb552e8', 97104,  current_date , 97104,  current_date , 'fetch_covid_pie_chart_data',
'location_id',
'with cte as (
    select
        count(*) filter (where csd.is_dose_one_taken and csd.is_dose_two_taken) as fully_vaccinated,
        count(*) filter (where csd.is_dose_one_taken and csd.is_dose_two_taken is not true) as partially_vaccinated,
        count(*) filter (where csd.is_dose_one_taken is not true) as pending
    from covid_screening_details csd
    inner join location_hierchy_closer_det lhcd on lhcd.child_id = csd.location_id and lhcd.parent_id = #location_id#
)
select cast(json_build_object(
        ''labels'', array[''Fully'',''Partial'',''Pending''],
        ''values'', array[
        (select fully_vaccinated from cte),
        (select partially_vaccinated from cte),
        (select pending from cte)
    ]
    ) as text) as result;',
'Feature Name :- All Service Dashboard
Purpose :- To fetch covid data for pie chart',
true, 'ACTIVE');

--table

DELETE FROM QUERY_MASTER WHERE CODE='fetch_covid_table_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'77f3dbeb-bade-4f96-88c9-e3400d488473', 97104,  current_date , 97104,  current_date , 'fetch_covid_table_data',
'location_id',
'with locations as (
    select
        lm.id as location_id,
        lm.english_name as location_name
    from location_master lm
    inner join location_hierchy_closer_det lhcd on lm.id = lhcd.child_id
    where lhcd.parent_id = #location_id#
    and lhcd.depth = 1
)
select
    l.location_name as "Location",
    count(csd.id) as "TotalScreened",
    count(csd.id) filter (where csd.is_dose_one_taken and csd.is_dose_two_taken) as "FullyVaccinated",
    count(csd.id) filter (where csd.is_dose_one_taken and csd.is_dose_two_taken is not true) as "PartiallyVaccinated",
    count(csd.id) filter (where csd.is_dose_one_taken is not true) as "NotVaccinated",
    count(csd.id) filter (where csd.any_reactions) as "AdverseEffect"
from locations l
left join location_hierchy_closer_det lhcd on l.location_id = lhcd.parent_id
left join covid_screening_details csd on lhcd.child_id = csd.location_id
group by 1;',
'Feature Name :- All Service Dashboard
 Purpose :- To fetch covid data for table',
true, 'ACTIVE');


---HIV

--pie

DELETE FROM QUERY_MASTER WHERE CODE='fetch_hiv_pie_chart_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'0a00cb8a-a8b0-488c-a682-89d6234b589d', 97104,  current_date , 97104,  current_date , 'fetch_hiv_pie_chart_data',
'location_id',
'with cte as (
    select
        (select count(*)
        from rch_preg_hiv_positive_master rphpm
        inner join location_hierchy_closer_det lhcd on lhcd.parent_id = #location_id# and lhcd.child_id = rphpm.location_id) as positive_pregnant,
        (select count(*)
        from rch_hiv_screening_master rhsm
        inner join location_hierchy_closer_det lhcd on lhcd.parent_id = #location_id# and lhcd.child_id = rhsm.location_id
        where rhsm.eligible_for_hiv) as positive,
        (select count(*)
        from rch_hiv_screening_master rhsm
        inner join location_hierchy_closer_det lhcd on lhcd.parent_id = #location_id# and lhcd.child_id = rhsm.location_id
        where rhsm.eligible_for_hiv is not true) as negative
)
select cast(json_build_object(
        ''labels'', array[''Positive & Pregnant'',''Positive'',''Negative''],
        ''values'', array[
        (select positive_pregnant from cte),
        (select positive from cte),
        (select negative from cte)
    ]
    ) as text) as result;',
'Feature Name :- All Service Dashboard
Purpose :- To fetch hiv data for pie chart',
true, 'ACTIVE');

--bar

DELETE FROM QUERY_MASTER WHERE CODE='fetch_hiv_bar_chart_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'366ff92c-abe9-4a00-801d-7875f0896654', 97104,  current_date , 97104,  current_date , 'fetch_hiv_bar_chart_data',
'location_id',
'with cte as (
    select
        (select count(*)
        from rch_hiv_screening_master rhsm
        inner join location_hierchy_closer_det lhcd on lhcd.parent_id = #location_id# and lhcd.child_id = rhsm.location_id
        where rhsm.eligible_for_hiv) as positive,
        (select count(*)
        from rch_preg_hiv_positive_master rphpm
        inner join location_hierchy_closer_det lhcd on lhcd.parent_id = #location_id# and lhcd.child_id = rphpm.location_id) as positive_pregnant,
        (select count(*)
        from rch_hiv_screening_master rhsm
        inner join location_hierchy_closer_det lhcd on lhcd.parent_id = #location_id# and lhcd.child_id = rhsm.location_id
        where rhsm.receiving_art) as on_hiv_treatment,
        (select count(*)
        from rch_hiv_screening_master rhsm
        inner join location_hierchy_closer_det lhcd on lhcd.parent_id = #location_id# and lhcd.child_id = rhsm.location_id
        where rhsm.eligible_for_hiv is not true) as negative
)
select cast(json_build_object(
        ''labels'', array[''Positive cases'',''Positive pregnant women'',''On HIV treatment'',''Negative''],
        ''values'', array[
        (select positive from cte),
        (select positive_pregnant from cte),
        (select on_hiv_treatment from cte),
        (select negative from cte)
    ]
    ) as text) as result;',
'Feature Name :- All Service Dashboard
Purpose :- To fetch hiv data for bar chart',
true, 'ACTIVE');

--table

DELETE FROM QUERY_MASTER WHERE CODE='fetch_hiv_table_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'4b8494f1-8bf5-4875-9320-84604b5a87de', 97104,  current_date , 97104,  current_date , 'fetch_hiv_table_data',
'location_id',
'with locations as (
    select
        lm.id as location_id,
        lm.english_name as location_name
    from location_master lm
    inner join location_hierchy_closer_det lhcd on lm.id = lhcd.child_id
    where lhcd.parent_id = #location_id#
    and lhcd.depth = 1
),
positive_pregnant_women as (
    select
        l.location_id,
        count(rphpm.id) as positive_pregnant
    from locations l
    inner join location_hierchy_closer_det lhcd on l.location_id = lhcd.parent_id
    inner join rch_preg_hiv_positive_master rphpm on rphpm.location_id = lhcd.child_id
    group by 1
),
screening_details as (
    select
        l.location_id,
        count(rhsm.id) as total_screened,
        count(rhsm.id) filter (where rhsm.eligible_for_hiv) as positive,
        count(rhsm.id) filter (where rhsm.receiving_art) as on_hiv_treatment,
        count(rhsm.id) filter (where rhsm.eligible_for_hiv is not true) as negative
    from locations l
    inner join location_hierchy_closer_det lhcd on l.location_id = lhcd.parent_id
    inner join rch_hiv_screening_master rhsm on rhsm.location_id = lhcd.child_id
    group by 1
)
select
    l.location_name as "Location",
    coalesce(sd.total_screened,0) as "TotalScreened",
    coalesce(sd.positive,0) as "PositiveCases",
    coalesce(ppw.positive_pregnant,0) as "PositiveAndPregnantCases",
    coalesce(sd.on_hiv_treatment,0) as "OnTreatment",
    coalesce(sd.negative,0) as "NegativeCases"
from locations l
left join screening_details sd on l.location_id = sd.location_id
left join positive_pregnant_women ppw on l.location_id = ppw.location_id;',
'Feature Name :- All Service Dashboard
 Purpose :- To fetch hiv data for table',
true, 'ACTIVE');