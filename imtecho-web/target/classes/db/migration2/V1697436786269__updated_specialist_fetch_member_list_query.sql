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
members_data as(
    select nsm.member_id,
        cast(max_researcher_date as date)max_researcher_date,cast(max_specialist_date as date)max_specialist_date
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
                when (
                    members_data.max_specialist_date < members_data.max_researcher_date
                ) then ''#ff4d4d''
                when (
                    nsm.last_ecg_specialist_id is not null
                    or nsm.last_stroke_specialist_id is not null
                    or nsm.last_amputation_specialist_id is not null
                    or nsm.last_renal_specialist_id is not null
                ) then (
                    case
                        when nsm.last_cardiologist_id is null
                        or ncd.case_confirmed is true
                        or ncd.satisfactory_image is true then ''green''
                        else (
                            case
                                when ncd.case_confirmed is false then ''red''
                                when ncd.satisfactory_image is false then ''blue''
                            end
                        )
                    end
                )
            end
        ) as color
    from members
        inner join imt_member imm on imm.id = members.member_id
        inner join imt_family imf on imm.family_id = imf.family_id
        left join location_master lm on lm.id = imf.location_id
        left join ncd_specialist_master nsm on nsm.member_id = members.member_id
        left join ncd_cardiologist_data ncd on ncd.id = nsm.last_cardiologist_id
        and nsm.last_cardiologist_id is not null
        left join members_data on members_data.member_id = nsm.member_id
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
order by member_with_location.name ASC
limit #limit# offset #offset#',
null,
true, 'ACTIVE');