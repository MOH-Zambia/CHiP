DELETE FROM QUERY_MASTER WHERE CODE='fetch_amputation_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'7c543191-a7bc-4d9f-8c28-4c915e251f70', 97070,  current_date , 97070,  current_date , 'fetch_amputation_data',
'member_id',
'select
	case when
		ngs.foot_problem_history is true
	then
		''Yes''
	else
		''No''
	end as "isAmputation"
from ncd_specialist_master nsm
left join ncd_general_screening ngs on ngs.id = nsm.last_generic_screening_id
where nsm.member_id = cast(#member_id# as integer)',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='fetch_stroke_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'61385a3c-7418-4c54-9f1b-ac33bf657529', 97070,  current_date , 97070,  current_date , 'fetch_stroke_data',
'member_id',
'select case
        when t.history_disease ilike ''%listvalue.id%'' then ''Yes''
        else ''No''
    end as "isStrokePresent",
    case
        when ngs.stroke_history is true then ''Yes''
        else ''No''
    end as "researcherRoleInput",
    case
        when ht.disease_history ilike ''listvalue.id'' then ''Yes''
        else ''No''
    end as "careCoordinatorInput"
from ncd_specialist_master nsm
    left join (
        select *
        from ncd_member_initial_assessment_detail
        where member_id = cast(
                #member_id# as integer)
                order by id desc
                limit 1
            ) as t on t.member_id = nsm.member_id
            left join (
                select *
                from ncd_member_hypertension_detail
                where member_id = cast(
                        #member_id# as integer)
                        and done_by = ''CC''
                        order by id desc
                        limit 1
                    ) as ht on ht.member_id = nsm.member_id
                    left join ncd_general_screening ngs on ngs.id = nsm.last_generic_screening_id
                    cross join (
                        select id
                        from listvalue_field_value_detail
                        where value = ''Stroke''
                            and field_key = ''diseaseHistoryList''
                    ) as listvalue
                where nsm.member_id = cast(
                        #member_id# as integer)',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='fetch_member_detail_for_specialist_role';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'8d570f95-b2db-4ffb-b8c0-48206ce76270', 97070,  current_date , 97070,  current_date , 'fetch_member_detail_for_specialist_role',
'memberId',
'select distinct im.id,
    im.unique_health_id,
    concat(im.first_name, '' '', im.middle_name, '' '', im.last_name) as member_name,
    im.gender,
    date_part(''year'', age(im.dob)) as age,
    tobacco_addiction,
    smoking_addiction,
    imnd.suffering_diabetes,
    imnd.suffering_hypertension,
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
    ) as stroke,
    lm.name as village,
    lm.type,
    im.additional_info,
    imnd.diabetes_treatment_status,
    imnd.hypertension_treatment_status,
    imnd.mentalHealth_treatment_status,
    imnd.cvc_treatement_status,
    concat(uu.first_name,'' '',uu.last_name) as village_health_worker
from imt_member im
    inner join imt_family imf on imf.family_id = im.family_id
    left join ncd_member_initial_assessment_detail nmiad on nmiad.member_id = im.id
    left join ncd_general_screening ngs on ngs.member_id = im.id
    left join location_master lm on lm.id = imf.area_id
    left join um_user_location uul on uul.loc_id = lm.id and uul.state = ''ACTIVE''
    left join um_user uu on uu.id = uul.user_id and uu.state=''ACTIVE''
    left join imt_member_ncd_detail imnd on imnd.member_id = im.id
    cross join (
        select id
        from listvalue_field_value_detail
        where value = ''Stroke''
            and field_key = ''diseaseHistoryList''
    ) as t
where im.id = #memberId#',
null,
true, 'ACTIVE');