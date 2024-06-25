begin;
delete from public.query_master where code = 'idsp_from_s_data_retrival';
INSERT INTO public.query_master(
            created_by,
            created_on,
            code,
            params,
            query,
            returns_result_set,
            state
            )
    VALUES (
        1,
        localtimestamp,
        'idsp_from_s_data_retrival',
        'location_id,report_from_date,report_to_date',
        'with ldsp_detail as(
select lhc.parent_id as location_id,
coalesce(sum(fever_less_than_7_days_male_less_than_5_year),0) as fever_less_than_7_days_male_less_than_5_year,
coalesce(sum(fever_less_than_7_days_male_more_than_5_year),0) as fever_less_than_7_days_male_more_than_5_year,
coalesce(sum(fever_less_than_7_days_female_less_than_5_year),0) as fever_less_than_7_days_female_less_than_5_year,
coalesce(sum(fever_less_than_7_days_female_more_than_5_year),0) as fever_less_than_7_days_female_more_than_5_year,
coalesce(sum(only_fever_male_less_than_5_year),0) as only_fever_male_less_than_5_year,
coalesce(sum(only_fever_male_more_than_5_year),0) as  only_fever_male_more_than_5_year,
coalesce(sum(only_fever_female_less_than_5_year),0) as only_fever_female_less_than_5_year ,
coalesce(sum(only_fever_female_more_than_5_year),0) as  only_fever_female_more_than_5_year,
coalesce(sum(fever_with_rash_male_less_than_5_year),0) as  fever_with_rash_male_less_than_5_year,
coalesce(sum(fever_with_rash_male_more_than_5_year),0) as  fever_with_rash_male_more_than_5_year,
coalesce(sum(fever_with_rash_female_less_than_5_year),0) as  fever_with_rash_female_less_than_5_year,
coalesce(sum(fever_with_rash_female_more_than_5_year),0) as  fever_with_rash_female_more_than_5_year,
coalesce(sum(fever_with_server_joint_pain_male_less_than_5_year),0) as  fever_with_server_joint_pain_male_less_than_5_year,
coalesce(sum(fever_with_server_joint_pain_male_more_than_5_year),0) as  fever_with_server_joint_pain_male_more_than_5_year,
coalesce(sum(fever_with_server_joint_pain_female_less_than_5_year),0) as  fever_with_server_joint_pain_female_less_than_5_year,
coalesce(sum(fever_with_server_joint_pain_female_more_than_5_year),0) as fever_with_server_joint_pain_female_more_than_5_year ,
coalesce(sum(fever_with_daze_male_less_than_5_year),0) as  fever_with_daze_male_less_than_5_year,
coalesce(sum(fever_with_daze_male_more_than_5_year),0) as  fever_with_daze_male_more_than_5_year,
coalesce(sum(fever_with_daze_female_less_than_5_year),0) as  fever_with_daze_female_less_than_5_year,
coalesce(sum(fever_with_daze_female_more_than_5_year),0) as  fever_with_daze_female_more_than_5_year,
coalesce(sum(fever_with_bleeding_male_less_than_5_year),0) as fever_with_bleeding_male_less_than_5_year ,
coalesce(sum(fever_with_bleeding_male_more_than_5_year),0) as fever_with_bleeding_male_more_than_5_year ,
coalesce(sum(fever_with_bleeding_female_less_than_5_year),0) as  fever_with_bleeding_female_less_than_5_year,
coalesce(sum(fever_with_bleeding_female_more_than_5_year),0) as fever_with_bleeding_female_more_than_5_year ,
coalesce(sum(fever_more_than_7_days_male_less_than_5_year),0) as  fever_more_than_7_days_male_less_than_5_year,
coalesce(sum(fever_more_than_7_days_male_more_than_5_year),0) as fever_more_than_7_days_male_more_than_5_year ,
coalesce(sum(fever_more_than_7_days_female_less_than_5_year),0) as fever_more_than_7_days_female_less_than_5_year ,
coalesce(sum(fever_more_than_7_days_female_more_than_5_year),0) as  fever_more_than_7_days_female_more_than_5_year,
coalesce(sum(cough_less_than_2_week_male_less_than_5_year),0) as cough_less_than_2_week_male_less_than_5_year,
coalesce(sum(cough_less_than_2_week_male_more_than_5_year),0) as  cough_less_than_2_week_male_more_than_5_year,
coalesce(sum(cough_less_than_2_week_female_less_than_5_year),0) as  cough_less_than_2_week_female_less_than_5_year,
coalesce(sum(cough_less_than_2_week_female_more_than_5_year),0) as  cough_less_than_2_week_female_more_than_5_year,
coalesce(sum(cough_more_than_2_week_male_less_than_5_year),0) as cough_more_than_2_week_male_less_than_5_year,
coalesce(sum(cough_more_than_2_week_male_more_than_5_year),0) as cough_more_than_2_week_male_more_than_5_year,
coalesce(sum(cough_more_than_2_week_female_less_than_5_year),0) as  cough_more_than_2_week_female_less_than_5_year,
coalesce(sum(cough_more_than_2_week_female_more_than_5_year),0) as cough_more_than_2_week_female_more_than_5_year,
coalesce(sum(lws_with_small_dehydration_male_less_than_5_year),0) as lws_with_small_dehydration_male_less_than_5_year,
coalesce(sum(lws_with_small_dehydration_male_more_than_5_year),0) as lws_with_small_dehydration_male_more_than_5_year,
coalesce(sum(lws_with_small_dehydration_female_less_than_5_year),0) as lws_with_small_dehydration_female_less_than_5_year,
coalesce(sum(lws_with_small_dehydration_female_more_than_5_year),0) as lws_with_small_dehydration_female_more_than_5_year,
coalesce(sum(lws_with_no_dehydration_male_less_than_5_year),0) as lws_with_no_dehydration_male_less_than_5_year,
coalesce(sum(lws_with_no_dehydration_male_more_than_5_year),0) as lws_with_no_dehydration_male_more_than_5_year,
coalesce(sum(lws_with_no_dehydration_female_less_than_5_year),0) as lws_with_no_dehydration_female_less_than_5_year,
coalesce(sum(lws_with_no_dehydration_female_more_than_5_year),0) as lws_with_no_dehydration_female_more_than_5_year,
coalesce(sum(lws_with_blood_male_less_than_5_year),0) as lws_with_blood_male_less_than_5_year,
coalesce(sum(lws_with_blood_male_more_than_5_year),0) as lws_with_blood_male_more_than_5_year,
coalesce(sum(lws_with_blood_female_less_than_5_year),0) as lws_with_blood_female_less_than_5_year,
coalesce(sum(lws_with_blood_female_more_than_5_year),0) as lws_with_blood_female_more_than_5_year,
coalesce(sum(case_of_acute_jaundice_male_less_than_5_year),0) as case_of_acute_jaundice_male_less_than_5_year,
coalesce(sum(case_of_acute_jaundice_male_more_than_5_year),0) as case_of_acute_jaundice_male_more_than_5_year,
coalesce(sum(case_of_acute_jaundice_female_less_than_5_year),0) as case_of_acute_jaundice_female_less_than_5_year,
coalesce(sum(case_of_acute_jaundice_female_more_than_5_year),0) as case_of_acute_jaundice_female_more_than_5_year,
coalesce(sum(case_of_flacid_paralysis_male_less_than_5_year),0) as case_of_flacid_paralysis_male_less_than_5_year,
coalesce(sum(case_of_flacid_paralysis_male_more_than_5_year),0) as case_of_flacid_paralysis_male_more_than_5_year,
coalesce(sum(case_of_flacid_paralysis_female_less_than_5_year),0) as case_of_flacid_paralysis_female_less_than_5_year,
coalesce(sum(case_of_flacid_paralysis_female_more_than_5_year),0) as case_of_flacid_paralysis_female_more_than_5_year,
coalesce(sum(other_unusual_symptoms_male_less_than_5_year),0) as other_unusual_symptoms_male_less_than_5_year,
coalesce(sum(other_unusual_symptoms_male_more_than_5_year),0) as other_unusual_symptoms_male_more_than_5_year,
coalesce(sum(other_unusual_symptoms_female_less_than_5_year),0) as other_unusual_symptoms_female_less_than_5_year,
coalesce(sum(other_unusual_symptoms_female_more_than_5_year),0) as other_unusual_symptoms_female_more_than_5_year
from location_hierchy_closer_det lhc
left join idsp_member_screening_summary_detail imsd on imsd.location_id = lhc.child_id and imsd.report_date between to_date(''#report_from_date#'',''MM-DD-YYYY'')
and to_date(''#report_to_date#'',''MM-DD-YYYY'')
where lhc.parent_id = #location_id#
group by lhc.parent_id
)
select ''Fever <7 Days'' as reason,
fever_less_than_7_days_male_less_than_5_year as "male_less_than_5_year",
fever_less_than_7_days_male_more_than_5_year as "male_more_than_5_year",
fever_less_than_7_days_male_less_than_5_year + fever_less_than_7_days_male_more_than_5_year   as "male_total",
fever_less_than_7_days_female_less_than_5_year as "female_less_than_5_year",
fever_less_than_7_days_female_more_than_5_year as "female_more_than_5_year",
fever_less_than_7_days_female_less_than_5_year + fever_less_than_7_days_female_more_than_5_year   as "female_total",
fever_less_than_7_days_male_less_than_5_year + fever_less_than_7_days_male_more_than_5_year
	+ fever_less_than_7_days_female_less_than_5_year + fever_less_than_7_days_female_more_than_5_year   as "total"
from ldsp_detail
union all
select ''Only Fever'' as reason,
only_fever_male_less_than_5_year as "male_less_than_5_year",
only_fever_male_more_than_5_year as "male_more_than_5_year",
only_fever_male_less_than_5_year+only_fever_male_more_than_5_year as "male_total",
only_fever_female_less_than_5_year as "female_less_than_5_year",
only_fever_female_more_than_5_year as "female_more_than_5_year",
only_fever_female_less_than_5_year+only_fever_female_less_than_5_year as "female_total",
only_fever_male_less_than_5_year+only_fever_male_more_than_5_year
	+only_fever_female_less_than_5_year+only_fever_female_less_than_5_year as "total"
from ldsp_detail
union all
select ''With Rash'' as reason,
fever_with_rash_male_less_than_5_year as "male_less_than_5_year",
fever_with_rash_male_more_than_5_year as "male_more_than_5_year",
fever_with_rash_male_less_than_5_year + fever_with_rash_male_more_than_5_year as "male_total",
fever_with_rash_female_less_than_5_year as "female_less_than_5_year",
fever_with_rash_female_more_than_5_year as "female_more_than_5_year",
fever_with_rash_female_less_than_5_year+fever_with_rash_female_more_than_5_year as "female_total",
fever_with_rash_male_less_than_5_year + fever_with_rash_male_more_than_5_year
	+ fever_with_rash_female_less_than_5_year+fever_with_rash_female_more_than_5_year as "total"
from ldsp_detail
union all
select ''With Severe Joint Pains & Swelling'' as reason,
fever_with_server_joint_pain_male_less_than_5_year as "male_less_than_5_year",
fever_with_server_joint_pain_male_more_than_5_year as "male_more_than_5_year",
fever_with_server_joint_pain_male_less_than_5_year + fever_with_server_joint_pain_male_more_than_5_year as "male_total",
fever_with_server_joint_pain_female_less_than_5_year as "female_less_than_5_year",
fever_with_server_joint_pain_female_more_than_5_year as "female_more_than_5_year",
fever_with_server_joint_pain_female_less_than_5_year+ fever_with_server_joint_pain_female_more_than_5_year as "female_total",
fever_with_server_joint_pain_male_less_than_5_year + fever_with_server_joint_pain_male_more_than_5_year
	+fever_with_server_joint_pain_female_less_than_5_year+ fever_with_server_joint_pain_female_more_than_5_year as "total"
from ldsp_detail
union all
select ''With bleeding'' as reason,
fever_with_bleeding_male_less_than_5_year as "male_less_than_5_year",
fever_with_bleeding_male_more_than_5_year as "male_more_than_5_year",
fever_with_bleeding_male_less_than_5_year + fever_with_bleeding_male_more_than_5_year as "male_total",
fever_with_bleeding_female_less_than_5_year as "female_less_than_5_year",
fever_with_bleeding_female_more_than_5_year as "female_more_than_5_year",
fever_with_bleeding_female_less_than_5_year+ fever_with_bleeding_female_more_than_5_year as "female_total",
fever_with_bleeding_male_less_than_5_year + fever_with_bleeding_male_more_than_5_year
	+ fever_with_bleeding_female_less_than_5_year+ fever_with_bleeding_female_more_than_5_year as "total"
from ldsp_detail
union all
select ''With Daze/Semi or unconciousness'' as reason,
fever_with_daze_male_less_than_5_year as "male_less_than_5_year",
fever_with_daze_male_more_than_5_year as "male_more_than_5_year",
fever_with_daze_male_less_than_5_year+fever_with_daze_male_more_than_5_year as "male_total",
fever_with_daze_female_less_than_5_year as "female_less_than_5_year",
fever_with_daze_female_more_than_5_year as "female_more_than_5_year",
fever_with_daze_female_less_than_5_year + fever_with_daze_female_more_than_5_year as "female_total",
fever_with_daze_male_less_than_5_year+fever_with_daze_male_more_than_5_year
	+ fever_with_daze_female_less_than_5_year + fever_with_daze_female_more_than_5_year as "total"
from ldsp_detail
union all
select ''Fever >7 Days'' as reason,
fever_more_than_7_days_male_less_than_5_year as "male_less_than_5_year",
fever_more_than_7_days_male_more_than_5_year as "male_more_than_5_year",
fever_more_than_7_days_male_less_than_5_year + fever_more_than_7_days_male_more_than_5_year as "male_total",
fever_more_than_7_days_female_less_than_5_year as "female_less_than_5_year",
fever_more_than_7_days_female_more_than_5_year as "female_more_than_5_year",
fever_more_than_7_days_female_less_than_5_year+ fever_more_than_7_days_female_more_than_5_year as "female_total",
fever_more_than_7_days_male_less_than_5_year + fever_more_than_7_days_male_more_than_5_year
+fever_more_than_7_days_female_less_than_5_year+ fever_more_than_7_days_female_more_than_5_year as "total"
from ldsp_detail
union all
select ''<2 Weeks'' as reason,
cough_less_than_2_week_male_less_than_5_year as "male_less_than_5_year",
cough_less_than_2_week_male_more_than_5_year as "male_more_than_5_year",
cough_less_than_2_week_male_less_than_5_year+cough_less_than_2_week_male_more_than_5_year as "male_total",
cough_less_than_2_week_female_less_than_5_year as "female_less_than_5_year",
cough_less_than_2_week_female_more_than_5_year as "female_more_than_5_year",
cough_less_than_2_week_female_less_than_5_year+ cough_less_than_2_week_female_more_than_5_year as "female_total",
cough_less_than_2_week_male_less_than_5_year+cough_less_than_2_week_male_more_than_5_year
	+cough_less_than_2_week_female_less_than_5_year+ cough_less_than_2_week_female_more_than_5_year as "total"
from ldsp_detail
union all
select ''>2 Weeks'' as reason,
cough_more_than_2_week_male_less_than_5_year as "male_less_than_5_year",
cough_more_than_2_week_male_more_than_5_year as "male_more_than_5_year",
cough_more_than_2_week_male_less_than_5_year + cough_more_than_2_week_male_more_than_5_year as "male_total",
cough_more_than_2_week_female_less_than_5_year as "female_less_than_5_year",
cough_more_than_2_week_female_more_than_5_year as "female_more_than_5_year",
cough_more_than_2_week_female_less_than_5_year + cough_more_than_2_week_female_more_than_5_year as "female_total",
cough_more_than_2_week_male_less_than_5_year + cough_more_than_2_week_male_more_than_5_year
	+cough_more_than_2_week_female_less_than_5_year + cough_more_than_2_week_female_more_than_5_year as "total"
from ldsp_detail
union all
select ''With small/much dehydration'' as reason,
lws_with_small_dehydration_male_less_than_5_year as "male_less_than_5_year",
lws_with_small_dehydration_male_more_than_5_year as "male_more_than_5_year",
lws_with_small_dehydration_male_less_than_5_year + lws_with_small_dehydration_male_more_than_5_year as "male_total",
lws_with_small_dehydration_female_less_than_5_year as "female_less_than_5_year",
lws_with_small_dehydration_female_more_than_5_year as "female_more_than_5_year",
lws_with_small_dehydration_female_less_than_5_year + lws_with_small_dehydration_female_more_than_5_year as "female_total",
lws_with_small_dehydration_male_less_than_5_year + lws_with_small_dehydration_male_more_than_5_year
	+ lws_with_small_dehydration_female_less_than_5_year + lws_with_small_dehydration_female_more_than_5_year as "total"
from ldsp_detail
union all
select ''With no dehydration'' as reason,
lws_with_no_dehydration_male_less_than_5_year as "male_less_than_5_year",
lws_with_no_dehydration_male_more_than_5_year as "male_more_than_5_year",
lws_with_no_dehydration_male_less_than_5_year + lws_with_no_dehydration_male_more_than_5_year as "male_total",
lws_with_no_dehydration_female_less_than_5_year as "female_less_than_5_year",
lws_with_no_dehydration_female_more_than_5_year as "female_more_than_5_year",
lws_with_no_dehydration_female_less_than_5_year + lws_with_no_dehydration_female_more_than_5_year as "female_total",
lws_with_no_dehydration_male_less_than_5_year + lws_with_no_dehydration_male_more_than_5_year
	+lws_with_no_dehydration_female_less_than_5_year + lws_with_no_dehydration_female_more_than_5_year as "total"
from ldsp_detail
union all
select ''With blood in stool'' as reason,
lws_with_blood_male_less_than_5_year as "male_less_than_5_year",
lws_with_blood_male_more_than_5_year as "male_more_than_5_year",
lws_with_blood_male_less_than_5_year+lws_with_blood_male_more_than_5_year as "male_total",
lws_with_blood_female_less_than_5_year as "female_less_than_5_year",
lws_with_blood_female_more_than_5_year as "female_more_than_5_year",
lws_with_blood_female_less_than_5_year + lws_with_blood_female_more_than_5_year as "female_total",
lws_with_blood_male_less_than_5_year+lws_with_blood_male_more_than_5_year +
+lws_with_blood_female_less_than_5_year + lws_with_blood_female_more_than_5_year as "total"
from ldsp_detail
union all
select ''Case of acute Jaundice'' as reason,
case_of_acute_jaundice_male_less_than_5_year as "male_less_than_5_year",
case_of_acute_jaundice_male_more_than_5_year as "male_more_than_5_year",
case_of_acute_jaundice_male_less_than_5_year +  case_of_acute_jaundice_male_more_than_5_year as "male_total",
case_of_acute_jaundice_female_less_than_5_year as "female_less_than_5_year",
case_of_acute_jaundice_female_more_than_5_year as "female_more_than_5_year",
case_of_acute_jaundice_female_less_than_5_year + case_of_acute_jaundice_female_more_than_5_year as "female_total",
case_of_acute_jaundice_male_less_than_5_year +  case_of_acute_jaundice_male_more_than_5_year
+case_of_acute_jaundice_female_less_than_5_year + case_of_acute_jaundice_female_more_than_5_year as "total"
from ldsp_detail
union all
select ''Case of Acute Flacid Paralysis'' as reason,
case_of_flacid_paralysis_male_less_than_5_year as "male_less_than_5_year",
case_of_flacid_paralysis_male_more_than_5_year as "male_more_than_5_year",
case_of_flacid_paralysis_male_less_than_5_year + case_of_flacid_paralysis_male_more_than_5_year as "male_total",
case_of_flacid_paralysis_female_less_than_5_year as "female_less_than_5_year",
case_of_flacid_paralysis_female_more_than_5_year as "female_more_than_5_year",
case_of_flacid_paralysis_female_less_than_5_year + case_of_flacid_paralysis_female_more_than_5_year as "female_total",
case_of_flacid_paralysis_male_less_than_5_year + case_of_flacid_paralysis_male_more_than_5_year
	+ case_of_flacid_paralysis_female_less_than_5_year + case_of_flacid_paralysis_female_more_than_5_year as "total"
from ldsp_detail
union all
select ''Unusual Symptoms leading to death of hospitalization'' as reason,
other_unusual_symptoms_male_less_than_5_year as "male_less_than_5_year",
other_unusual_symptoms_male_more_than_5_year as "male_more_than_5_year",
other_unusual_symptoms_male_less_than_5_year + other_unusual_symptoms_male_more_than_5_year as "male_total",
other_unusual_symptoms_female_less_than_5_year as "female_less_than_5_year",
other_unusual_symptoms_female_more_than_5_year as "female_more_than_5_year",
other_unusual_symptoms_female_less_than_5_year + other_unusual_symptoms_female_more_than_5_year as "female_total",
other_unusual_symptoms_male_less_than_5_year + other_unusual_symptoms_male_more_than_5_year
	+ other_unusual_symptoms_female_less_than_5_year + other_unusual_symptoms_female_more_than_5_year as "total"
from ldsp_detail',
        true,
        'ACTIVE'
        );
commit;


begin;
delete from public.query_master where code = 'idsp_from_s_other_detail';
INSERT INTO public.query_master(
            created_by,
            created_on,
            code,
            params,
            query,
            returns_result_set,
            state
            )
    VALUES (
        1,
        localtimestamp,
        'idsp_from_s_other_detail',
        'location_id',
        'select max((case when lm."type" = ''S'' then lm.name end)) as state
,max((case when lm."type" in (''D'',''C'') then lm.name end)) as district
,max((case when lm."type" in (''B'',''Z'') then lm.name end)) as block
,max(ru.name) as reporting_unit
from location_hierchy_closer_det lhc,location_master lm,location_master as ru
where lhc.child_id = #location_id# and lhc.parent_id = lm.id
and ru.id = #location_id#
group by lhc.child_id',
        true,
        'ACTIVE'
        );
commit;