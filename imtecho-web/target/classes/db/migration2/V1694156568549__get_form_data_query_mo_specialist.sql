DELETE FROM QUERY_MASTER WHERE CODE='get_amputation_form_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'40c6b56b-a28d-4870-ad13-fb03a81b510d', 97070,  current_date , 97070,  current_date , 'get_amputation_form_data',
'member_id,screening_date',
'select
	amputation.amputation_present as "amputationPresent"
from
	ncd_amputation_member_detail amputation
where
	amputation.member_id = cast(#member_id# as integer)
and
	cast(amputation.screening_date as date) = cast(#screening_date# as date)
limit 1;',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='get_stroke_form_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'4f432d92-6290-4b26-863d-a3b872e25a94', 97070,  current_date , 97070,  current_date , 'get_stroke_form_data',
'member_id,screening_date',
'select
	stroke.stroke_present as "strokePresent"
from
	ncd_stroke_member_detail stroke
where
	stroke.member_id = cast(#member_id# as integer)
and
	cast(stroke.screening_date as date) = cast(#screening_date# as date)
limit 1;',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='get_ecg_form_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'7b40b903-2fdc-4071-bf77-6043ab1b3707', 97070,  current_date , 97070,  current_date , 'get_ecg_form_data',
'member_id,screening_date',
'select
	ecg.satisfactory_image as "needsRetake",
	ecg.old_mi as "oldMI",
	ecg.lvh as "lvh",
	ecg."type" as "type"
from
	ncd_ecg_member_detail ecg
where
	ecg.member_id = cast(#member_id# as integer)
and
	cast(ecg.screening_date as date) = cast(#screening_date# as date)
limit 1;',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='get_renal_form_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'7470a9f8-ff86-425b-b14a-ff270c99dba1', 97070,  current_date , 97070,  current_date , 'get_renal_form_data',
'member_id,screening_date',
'select
	renal.is_s_creatinine_done as "isSCreatinineDone",
	renal.s_creatinine_value as "sCreatinineValue",
	renal.is_renal_complication_present as "isRenalComplicationPresent"
from
	ncd_renal_member_detail renal
where
	renal.member_id = cast(#member_id# as integer)
and
	cast(renal.screening_date as date) = cast(#screening_date# as date)
limit 1;',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='fetch_mo_specialist_patients_list';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'6ef7dce6-4fe7-4526-9ac8-6ad0f8908be7', 97070,  current_date , 97070,  current_date , 'fetch_mo_specialist_patients_list',
'offset,limit,userId',
'with members as(
    select distinct member_id
    from ncd_general_screening
    union
    select distinct member_id
    from ncd_urine_test
    union
    select distinct member_id
    from ncd_member_ecg_detail
),
member_with_location as(
    select distinct member_id,
        concat(
            imm.first_name,
            '' '',
            imm.middle_name,
            '' '',
            imm.last_name
        ) as name,
        date_part(''year'', age(imm.dob)) as age,
        imm.gender,
        imf.location_id as locationId,
        lm.name as village
    from members
        inner join imt_member imm on imm.id = members.member_id
        inner join imt_family imf on imm.family_id = imf.family_id
        left join location_master lm on lm.id = imf.location_id
    where imm.basic_state in (''NEW'', ''VERIFIED'', ''REVERIFICATION'', ''TEMPORARY'')
        and location_id in (
            select child_id
            from location_hierchy_closer_det
            where parent_id in (
                    select uul.loc_id
                    from um_user_location uul
                    where uul.user_id = #userId#
                        and state = ''ACTIVE''
                )
        )
)
select member_with_location.*,
    lm.name as "subCenter"
from member_with_location
    left join location_hierchy_closer_det lhcd on member_with_location.locationId = lhcd.child_id
    left join location_master lm on lhcd.parent_id = lm.id
where parent_loc_type = ''SC''
order by member_with_location.name ASC limit #limit# offset #offset#',
null,
true, 'ACTIVE');


INSERT INTO menu_config (menu_name, menu_type, active, navigation_state,feature_json) values
('MO specialist patient list','ncd',TRUE,'techo.ncd.mospecialistList','{}');

INSERT INTO menu_config (menu_name, menu_type, active, navigation_state,feature_json) values
('Cardiologist patient list','ncd',TRUE,'techo.ncd.cardiologistList','{}');

DELETE FROM QUERY_MASTER WHERE CODE='fetch_member_detail_for_specialist_role';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'8d570f95-b2db-4ffb-b8c0-48206ce76270', 97070,  current_date , 97070,  current_date , 'fetch_member_detail_for_specialist_role',
'memberId',
'select distinct im.id,
    concat(first_name, '' '', middle_name, '' '', last_name) as member_name,
    im.gender,
    date_part(''year'', age(im.dob)) as age,
    tobacco_addiction,
    smoking_addiction,
    additional_info,
    ngs.duration_of_hypertension,
    ngs.duration_of_diabetes,
    ngs.stroke_symptoms,
    (
        case
            when nmiad.history_disease is null then null
            else case
                when nmiad.history_disease ilike ''%t.id%'' then ''Yes''
                else ''No''
            end
        end
    ) as stroke
from imt_member im
    left join ncd_member_initial_assessment_detail nmiad on nmiad.member_id = im.id
    left join ncd_general_screening ngs on ngs.member_id = im.id
    cross join (select id from listvalue_field_value_detail where value=''Stroke''and field_key=''diseaseHistoryList'') as t
where im.id = #memberId#',
null,
true, 'ACTIVE');