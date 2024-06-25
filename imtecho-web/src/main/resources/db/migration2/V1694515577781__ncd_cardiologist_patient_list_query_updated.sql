DELETE FROM QUERY_MASTER WHERE CODE='fetch_cardiologist_patients_list';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'71598c1a-e9da-4008-88be-391bdf6f985c', 97072,  current_date , 97072,  current_date , 'fetch_cardiologist_patients_list',
'offset,limit,userId',
'with members as(
    select distinct member_id,
        nsm.last_ecg_specialist_id,
        nsm.last_cardiologist_id,
        nsm.last_ecg_screening_id
    from ncd_specialist_master nsm
    where member_id not in(
            select nsm.member_id
            from ncd_specialist_master nsm
                inner join ncd_ecg_member_detail nemd on nemd.id = nsm.last_ecg_specialist_id
                and (
                    nemd.old_mi = 2
                    or nemd.lvh = 2
                )
        ) and (last_ecg_specialist_id is not null or last_cardiologist_id is not null or last_ecg_screening_id is not null)
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
        date_part(''year'', age(imm.dob)) as age,
        imm.gender,
        imf.location_id as locationId,
        lm.name as village,
        (
            case
                when ncd.id is not null then (
                    case
                        when ncd.case_confirmed is false then (
                            case
                                when ncd.created_on > nemd.created_on then ''orange''
                                else ''red''
                            end
                        )
                        when ncd.case_confirmed is true
                        or ncd.satisfactory_image is true then ''green''
                        when ncd.satisfactory_image is false then (
                            case
                                when ncd.created_on > nmed.created_on then ''blue''
                                else ''red''
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
        left join ncd_member_ecg_detail nmed on nmed.id = members.last_ecg_screening_id
        left join ncd_cardiologist_data ncd on ncd.id = members.last_cardiologist_id
        left join ncd_ecg_member_detail nemd on nemd.id = members.last_ecg_specialist_id
    where imf.location_id in (
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