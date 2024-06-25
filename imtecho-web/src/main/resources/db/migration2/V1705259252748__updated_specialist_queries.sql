DELETE FROM QUERY_MASTER WHERE CODE='fetch_mo_specialist_patients_list';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'6ef7dce6-4fe7-4526-9ac8-6ad0f8908be7', 97070,  current_date , 97070,  current_date , 'fetch_mo_specialist_patients_list',
'offset,locationId,limit,uniqueHealthId,userId',
'with base_data as(
    select distinct imm.id,
        imf.location_id
    from imt_member imm
        inner join imt_family imf on imf.family_id = imm.family_id
        inner join location_hierchy_closer_det lhcd on lhcd.child_id = imf.location_id
    where (
            case
                when #locationId# is not null then lhcd.parent_id = #locationId#
                when #uniqueHealthId#  is not null then imm.unique_health_id = #uniqueHealthId#
                else lhcd.parent_id in (
                    select uul.loc_id
                    from um_user_location uul
                    where uul.user_id = #userId#
                        and state = ''ACTIVE''
                )
            end
        )
),
members as(
    select distinct member_id
    from ncd_general_screening
        inner join base_data on base_data.id = ncd_general_screening.member_id
    union
    select distinct member_id
    from ncd_urine_test
        inner join base_data on base_data.id = ncd_urine_test.member_id
    union
    select distinct member_id
    from ncd_member_ecg_detail
        inner join base_data on base_data.id = ncd_member_ecg_detail.member_id
),
members_data as(
    select nsm.member_id,
        cast(max_researcher_date as date) max_researcher_date,
        cast(max_specialist_date as date) max_specialist_date
    from ncd_specialist_master nsm
        left join (
            select member_id,
                max(service_date) as max_researcher_date
            from (
                    select member_id,
                        service_date
                    from ncd_member_ecg_detail
                    union all
                    select member_id,
                        service_date
                    from ncd_general_screening
                    union all
                    select member_id,
                        service_date
                    from ncd_urine_test
                ) as t
            group by member_id
        ) as researcher on researcher.member_id = nsm.member_id
        left join (
            select member_id,
                max(screening_date) as max_specialist_date
            from (
                    select member_id,
                        screening_date
                    from ncd_ecg_member_detail
                    union all
                    select member_id,
                        screening_date
                    from ncd_stroke_member_detail
                    union all
                    select member_id,
                        screening_date
                    from ncd_amputation_member_detail
                    union all
                    select member_id,
                        screening_date
                    from ncd_renal_member_detail
                ) as t
            group by member_id
        ) as specialist on specialist.member_id = nsm.member_id
),
member_with_location as(
    select distinct members.member_id,
        concat(
            imm.first_name,
            '' '',
            imm.middle_name,
            '' '',
            imm.last_name
        ) as name,
        imm.unique_health_id as "unqieHealthId",
        date_part(''year'', age(imm.dob)) as age,
        imm.gender,
        imf.location_id as locationId,
        lm.name as village,
        (
            case
                when last_generic_screening_id is not null
                and last_urine_screening_id is not null
                and last_ecg_screening_id is not null then (
                    case
                        when last_ecg_specialist_id is not null
                        and last_stroke_specialist_id is NOT NULL
                        and last_amputation_specialist_id is NOT NULL
                        and last_renal_specialist_id is NOT NULL THEN (
                            case
                                when ncd.created_on > nemd.created_on
                                and ncd.case_confirmed is false then ''red''
                                when last_ecg_screening_id is not null
                                and last_ecg_specialist_id is not null
                                and nemd.created_on < nmed.created_on
                                and nemd.satisfactory_image is false then ''#ff4d4d''
                                when last_ecg_screening_id is not null
                                and last_ecg_specialist_id is not null
                                and nemd.created_on > nmed.created_on
                                and nemd.satisfactory_image is false then ''blue''
                                else ''green''
                            end
                        )
                        when last_ecg_specialist_id is null
                        and last_stroke_specialist_id is NULL
                        and last_amputation_specialist_id is NULL
                        and last_renal_specialist_id is NULL THEN ''black''
                        when (last_ecg_specialist_id is null
                        or last_stroke_specialist_id is NULL
                        or last_amputation_specialist_id is NULL
                        or last_renal_specialist_id is null)
                        and members_data.max_researcher_date < members_data.max_specialist_date THEN ''#ffcc00''
                        when (last_ecg_specialist_id is null
                        or last_stroke_specialist_id is NULL
                        or last_amputation_specialist_id is NULL
                        or last_renal_specialist_id is null)
                        and members_data.max_researcher_date > members_data.max_specialist_date THEN ''#ff4d4d''
                    end
                )
                when last_generic_screening_id is not null
                or last_urine_screening_id is not null
                or last_ecg_screening_id is not null then (
                    case
                        when members_data.max_specialist_date is null then ''black''
                        when members_data.max_researcher_date > members_data.max_specialist_date then ''#ff4d4d''
                        when last_ecg_screening_id is not null
                        and last_ecg_specialist_id is null
                        and members_data.max_specialist_date is not null then ''#ff4d4d''
                        when last_ecg_screening_id is not null
                        and last_ecg_specialist_id is null
                        and members_data.max_specialist_date is null then ''black''
                        when members_data.max_researcher_date < members_data.max_specialist_date
                        and last_ecg_specialist_id is null
                        and last_stroke_specialist_id is NULL
                        and last_amputation_specialist_id is NULL
                        and last_renal_specialist_id is NULL THEN ''black''
                        when members_data.max_researcher_date < members_data.max_specialist_date
                        and (
                            last_ecg_specialist_id is null
                            or last_stroke_specialist_id is NULL
                            or last_amputation_specialist_id is NULL
                            or last_renal_specialist_id is NULL
                        ) THEN ''#ffcc00''
                        when ncd.created_on > nemd.created_on
                        and ncd.case_confirmed is false then ''red''
                        when last_ecg_screening_id is not null
                        and last_ecg_specialist_id is not null
                        and nemd.created_on > nmed.created_on
                        and nemd.satisfactory_image is false then ''blue''
                        when last_ecg_screening_id is not null
                        and last_ecg_specialist_id is not null
                        and nemd.created_on < nmed.created_on
                        and nemd.satisfactory_image is false then ''#ff4d4d''
                        when last_ecg_screening_id is not null
                        and last_ecg_specialist_id is not null
                        and nemd.created_on > nmed.created_on
                        and nemd.satisfactory_image is not false then ''green''
                        else ''green''
                    end
                )
                else ''Black''
            end
        ) as color
    from members
        inner join imt_member imm on imm.id = members.member_id
        inner join imt_family imf on imf.family_id = imm.family_id
        left join location_master lm on lm.id = imf.location_id
        left join ncd_specialist_master nsm on nsm.member_id = members.member_id
        left join ncd_ecg_member_detail nemd on nemd.id = nsm.last_ecg_specialist_id
        and nsm.last_ecg_specialist_id is not null
        left join ncd_stroke_member_detail nsmd on nsmd.id = nsm.last_stroke_specialist_id
        and nsm.last_stroke_specialist_id is not null
        left join ncd_amputation_member_detail namd on namd.id = nsm.last_amputation_specialist_id
        and nsm.last_amputation_specialist_id is not null
        left join ncd_renal_member_detail nrmd on nrmd.id = nsm.last_renal_specialist_id
        and nsm.last_renal_specialist_id is not null
        left join ncd_cardiologist_data ncd on ncd.id = nsm.last_cardiologist_id
        and nsm.last_cardiologist_id is not null
        left join ncd_general_screening ngs on ngs.id = nsm.last_generic_screening_id
        and nsm.last_generic_screening_id is not null
        left join ncd_urine_test nut on nut.id = nsm.last_urine_screening_id
        and nsm.last_urine_screening_id is not null
        left join ncd_member_ecg_detail nmed on nmed.id = nsm.last_ecg_screening_id
        and nsm.last_ecg_screening_id is not null
        left join members_data on members_data.member_id = nsm.member_id
)
select member_with_location.*,
    lm.name as "subCenter"
from member_with_location
    left join location_hierchy_closer_det lhcd on member_with_location.locationId = lhcd.child_id
    left join location_master lm on lhcd.parent_id = lm.id
where parent_loc_type = ''SC''
order by member_with_location.name ASC
limit #limit# offset #offset#',
null,
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='get_ecg_form_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'7b40b903-2fdc-4071-bf77-6043ab1b3707', 97070,  current_date , 97070,  current_date , 'get_ecg_form_data',
'member_id',
'select ecg.satisfactory_image as "needsRetake",
    ecg.old_mi as "oldMI",
    ecg.lvh as "lvh",
    ecg."type" as "type"
from ncd_specialist_master nsm
    inner join ncd_ecg_member_detail ecg on nsm.last_ecg_specialist_id = ecg.id
    inner join ncd_member_ecg_detail nmed on nmed.id = nsm.last_ecg_screening_id
where ecg.member_id = cast(
        #member_id# as integer)
        and ecg.created_on > nmed.created_on
        order by ecg.id desc
limit 1;',
null,
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='get_opthamologist_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'4284f05f-b596-424a-80b5-869c33415ce8', 97070,  current_date , 97070,  current_date , 'get_opthamologist_data',
'memberId',
'select ncd.*
from ncd_specialist_master nsm
    left join ncd_opthamologist_data ncd on ncd.id = nsm.last_opthamologist_id
    left join ncd_retinopathy_test_detail nemd on nemd.id = nsm.last_retinopathy_test_id
where nsm.member_id = #memberId# and ncd.created_on > nemd.created_on',
null,
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='get_cardiologist_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'1cd20fdd-8db2-4466-83f7-eb7cfb1fbcb2', 97070,  current_date , 97070,  current_date , 'get_cardiologist_data',
'memberId',
'select ncd.*
from ncd_specialist_master nsm
    left join ncd_cardiologist_data ncd on ncd.id = nsm.last_cardiologist_id
    left join ncd_ecg_member_detail nemd on nemd.id = nsm.last_ecg_specialist_id
where nsm.member_id = #memberId# and ncd.created_on > nemd.created_on',
null,
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='get_renal_form_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'7470a9f8-ff86-425b-b14a-ff270c99dba1', 97070,  current_date , 97070,  current_date , 'get_renal_form_data',
'member_id',
'select renal.is_s_creatinine_done as "isSCreatinineDone",
	renal.s_creatinine_value as "sCreatinineValue",
	renal.is_renal_complication_present as "isRenalComplicationPresent"
from ncd_renal_member_detail renal
where renal.member_id = cast(
		#member_id# as integer)
		order by id desc
		limit 1;',
null,
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='get_amputation_form_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'40c6b56b-a28d-4870-ad13-fb03a81b510d', 97070,  current_date , 97070,  current_date , 'get_amputation_form_data',
'member_id',
'select amputation.amputation_present as "amputationPresent"
from ncd_amputation_member_detail amputation
where amputation.member_id = cast(
		#member_id# as integer)
		order by id desc
		limit 1;',
null,
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='get_stroke_form_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'4f432d92-6290-4b26-863d-a3b872e25a94', 97070,  current_date , 97070,  current_date , 'get_stroke_form_data',
'member_id',
'select stroke.stroke_present as "strokePresent"
from ncd_stroke_member_detail stroke
where stroke.member_id = cast(
		#member_id# as integer)
		order by id desc
		limit 1;',
null,
true, 'ACTIVE');