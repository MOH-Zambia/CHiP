drop table if exists ncd_cardiologist_data;
create table if not exists ncd_cardiologist_data(
	id serial primary key,
	member_id integer,
	created_on timestamp without time zone default now(),
	created_by integer,
	modified_on timestamp without time zone default now(),
	modified_by integer,
	screening_date timestamp without time zone,
	case_confirmed boolean,
	note text,
	satisfactory_image boolean,
	old_mi integer,
	lvh integer,
	type text
);

DELETE FROM QUERY_MASTER WHERE CODE='fetch_ecg_graph_data_by_id';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'f251278a-9238-46dc-8e93-174459dc9417', 97070,  current_date , 97070,  current_date , 'fetch_ecg_graph_data_by_id',
'id',
'select * from ncd_ecg_graph_detail where id = #id#',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='fetch_ecg_dates_by_member';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'63a1e390-689f-43f7-a4f3-769f7bcead49', 97070,  current_date , 97070,  current_date , 'fetch_ecg_dates_by_member',
'memberId',
'select id,service_date,graph_detail_id,member_id from ncd_member_ecg_detail where member_id = #memberId#',
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
                when (
                    nsm.last_ecg_specialist_id is not null
                    or nsm.last_stroke_specialist_id is not null
                    or nsm.last_amputation_specialist_id is not null
                    or nsm.last_renal_specialist_id is not null
                ) then (
                    case
                        when nsm.last_cardiologist_id is null or ncd.case_confirmed is true or ncd.satisfactory_image is true then ''green''
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

alter table if exists ncd_specialist_master
add column if not exists last_generic_screening_id integer,
add column if not exists last_urine_screening_id integer,
add column if not exists last_ecg_screening_id integer;

ALTER TABLE IF EXISTS ncd_specialist_master
DROP CONSTRAINT IF EXISTS ncd_specialist_master_unique_member;
alter table if exists ncd_specialist_master
add constraint ncd_specialist_master_unique_member unique (member_id);

DELETE FROM QUERY_MASTER WHERE CODE='fetch_stroke_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'61385a3c-7418-4c54-9f1b-ac33bf657529', 97070,  current_date , 97070,  current_date , 'fetch_stroke_data',
'member_id',
'select
	case when
		nmiad.history_disease ilike ''%stroke%''
	then
		''Yes''
		when nmiad.id is null then null
	else
		''No''
	end as "isStrokePresent",
	case when
		ngs.stroke_history is true
	then
		''Yes''
		when
		ngs.stroke_history is false
		then
		''No''
	else
		null
	end as "researcherRoleInput"
from ncd_specialist_master nsm
left join ncd_member_initial_assessment_detail nmiad on nmiad.member_id = nsm.member_id
left join ncd_general_screening ngs on ngs.id = nsm.last_generic_screening_id
where nsm.member_id = cast(#member_id# as integer)',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='fetch_renal_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'eb6b996c-a815-4226-87fe-15c4aa639522', 97070,  current_date , 97070,  current_date , 'fetch_renal_data',
'member_id',
'select
	case when
		nut.albumin = ''0''
	then
		''0''
	else
		length(nut.albumin)
	end as "albuminLevelInUrine"
from ncd_specialist_master nsm
left join ncd_urine_test nut on nut.id = nsm.last_urine_screening_id
where nsm.member_id = cast(#member_id# as integer)',
null,
true, 'ACTIVE');


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
		when
		ngs.foot_problem_history is false
		then ''No''
	else
		null
	end as "isAmputation"
from ncd_specialist_master nsm
left join ncd_general_screening ngs on ngs.id = nsm.last_generic_screening_id
where nsm.member_id = cast(#member_id# as integer)',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='fetch_unsure_cardiologist_patients_list';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'1c640f4b-124b-4ce5-af56-2270eff80a25', 97070,  current_date , 97070,  current_date , 'fetch_unsure_cardiologist_patients_list',
'offset,limit,userId',
'with members as(
    select distinct nsm.member_id,
        nsm.last_ecg_specialist_id,
        nsm.last_cardiologist_id,
        nsm.last_ecg_screening_id
    from ncd_specialist_master nsm
        inner join ncd_ecg_member_detail nemd on nsm.last_ecg_specialist_id = nemd.id
    where nemd.old_mi = 2
        or nemd.lvh = 2
),
member_with_location as(
    select distinct members.member_id,
        concat(
            imm.first_name,
            '''',
            imm.middle_name,
            '''',
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
                        when ncd.case_confirmed is true or ncd.satisfactory_image is true then ''green''
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
    where imm.basic_state in (
            ''NEW'',
            ''VERIFIED'',
            ''REVERIFICATION'',
            ''TEMPORARY''
        )
        and imf.location_id in (
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

DELETE FROM QUERY_MASTER WHERE CODE='fetch_cardiologist_patients_list';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'71598c1a-e9da-4008-88be-391bdf6f985c', 97070,  current_date , 97070,  current_date , 'fetch_cardiologist_patients_list',
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
        )
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


DELETE FROM QUERY_MASTER WHERE CODE='fetch_cardiologist_rejection_by_member_id';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'f57689b3-7dec-4dff-8d87-1dd92649d840', 97070,  current_date , 97070,  current_date , 'fetch_cardiologist_rejection_by_member_id',
'memberId',
'select
nsm.member_id,note
from ncd_specialist_master nsm
left join ncd_cardiologist_data ncd on ncd.id = nsm.last_cardiologist_id
left join ncd_ecg_member_detail nemd on nemd.id = nsm.last_ecg_specialist_id
where nsm.member_id = #memberId# and ncd.created_on > nemd.created_on and ncd.case_confirmed is false',
null,
true, 'ACTIVE');