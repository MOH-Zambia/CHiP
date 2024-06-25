INSERT INTO menu_config (menu_name, menu_type, active, navigation_state,feature_json) values
('Ophthalmologist patient list','ncd',TRUE,'techo.ncd.ophthalmologistList','{}');

alter table if exists ncd_specialist_master
add column if not exists last_retinopathy_test_id integer,
add column if not exists last_opthamologist_id integer;

drop table if exists ncd_opthamologist_data;
create table if not exists ncd_opthamologist_data(
	id serial primary key,
	member_id integer,
	created_on timestamp without time zone default now(),
	created_by integer,
	modified_on timestamp without time zone default now(),
	modified_by integer,
	screening_date timestamp without time zone,
	lefteye_feedback text,
	lefteye_other_type text,
	righteye_feedback text,
	righteye_other_type text
);

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

DELETE FROM QUERY_MASTER WHERE CODE='fetch_stroke_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'61385a3c-7418-4c54-9f1b-ac33bf657529', 97070,  current_date , 97070,  current_date , 'fetch_stroke_data',
'member_id',
'select case
		when t.history_disease ilike ''%listvalue.id%'' then ''Yes''
		when t.id is null then null
		else ''No''
	end as "isStrokePresent",
	case
		when ngs.stroke_history is true then ''Yes''
		when ngs.stroke_history is false then ''No''
		else null
	end as "researcherRoleInput",
	case
		when ht.disease_history ilike ''listvalue.id'' then ''Yes''
		when ht.id is null then null
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
		and (
			last_ecg_specialist_id is not null
			or last_cardiologist_id is not null
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
		) as color,
		nemd.old_mi,
		nemd.lvh
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
        ) as color,
		nemd.old_mi,
		nemd.lvh
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

DELETE FROM QUERY_MASTER WHERE CODE='fetch_ecg_graph_data_by_id';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'f251278a-9238-46dc-8e93-174459dc9417', 97070,  current_date , 97070,  current_date , 'fetch_ecg_graph_data_by_id',
'id',
'select negd.*,nmed.detection,nmed.ecg_type,nmed.recommendation,nmed.risk,nmed.heart_rate,nmed.pr,nmed.qrs,nmed.qt,nmed.qtc from ncd_ecg_graph_detail negd
inner join ncd_member_ecg_detail nmed on nmed.graph_detail_id = negd.id
where negd.id = #id#',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='fetch_ophthalmologist_patients_list';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'9e85bf90-642e-4fbc-b88d-aeca158c55b1', 97070,  current_date , 97070,  current_date , 'fetch_ophthalmologist_patients_list',
'offset,limit,userId',
'with members as(
	select member_id,
		last_retinopathy_test_id,
		last_opthamologist_id
	from ncd_specialist_master
	where last_retinopathy_test_id is not null
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
				when nod.id is not null then case
					when nod.created_on > nrtd.created_on
					and nod.lefteye_feedback = ''unsatisfactory'' or nod.righteye_feedback = ''unsatisfactory'' then ''blue''
					when nod.created_on > nrtd.created_on
					and nod.lefteye_feedback != ''unsatisfactory'' or nod.righteye_feedback != ''unsatisfactory''  then ''green''
					when nod.created_on <= nrtd.created_on then ''red''
				end
			end
		) as color
	from members
		inner join imt_member imm on imm.id = members.member_id
		inner join imt_family imf on imm.family_id = imf.family_id
		left join location_master lm on lm.id = imf.location_id
		left join ncd_opthamologist_data nod on nod.id = members.last_opthamologist_id
		left join ncd_retinopathy_test_detail nrtd on nrtd.id = members.last_retinopathy_test_id
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

DELETE FROM QUERY_MASTER WHERE CODE='fetch_researcher_input_for_ophthalmologist';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'c9491ec2-8406-40a8-a972-d88b5ffcc3cd', 97070,  current_date , 97070,  current_date , 'fetch_researcher_input_for_ophthalmologist',
'memberId',
'select nrtd.* from ncd_specialist_master nsm
inner join ncd_retinopathy_test_detail nrtd on nsm.last_retinopathy_test_id = nrtd.id where nsm.member_id = #memberId#',
null,
true, 'ACTIVE');