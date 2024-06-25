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
				when #uniqueHealthId# is not null then imm.unique_health_id = #uniqueHealthId#
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
		inner join imt_family imf on imf.family_id = imm.family_id
		left join location_master lm on lm.id = imf.location_id
		left join ncd_specialist_master nsm on nsm.member_id = members.member_id
		left join ncd_cardiologist_data ncd on ncd.id = nsm.last_cardiologist_id
		and nsm.last_cardiologist_id is not null
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

DELETE FROM QUERY_MASTER WHERE CODE='fetch_cardiologist_patients_list';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'71598c1a-e9da-4008-88be-391bdf6f985c', 97070,  current_date , 97070,  current_date , 'fetch_cardiologist_patients_list',
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
				when #uniqueHealthId# is not null then imm.unique_health_id = #uniqueHealthId#
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
	select distinct member_id,
		nsm.last_ecg_specialist_id,
		nsm.last_cardiologist_id,
		nsm.last_ecg_screening_id
	from ncd_specialist_master nsm
	inner join base_data on base_data.id = nsm.member_id
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
		imm.unique_health_id as "uniqueHealthId",
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
				when #uniqueHealthId# is not null then imm.unique_health_id = #uniqueHealthId#
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
    select distinct nsm.member_id,
        nsm.last_ecg_specialist_id,
        nsm.last_cardiologist_id,
        nsm.last_ecg_screening_id
    from ncd_specialist_master nsm
        inner join ncd_ecg_member_detail nemd on nsm.last_ecg_specialist_id = nemd.id
        inner join base_data on base_data.id = nsm.member_id
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
        imm.unique_health_id as "uniqueHealthId",
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

DELETE FROM QUERY_MASTER WHERE CODE='fetch_ophthalmologist_patients_list';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'9e85bf90-642e-4fbc-b88d-aeca158c55b1', 97070,  current_date , 97070,  current_date , 'fetch_ophthalmologist_patients_list',
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
				when #uniqueHealthId# is not null then imm.unique_health_id = #uniqueHealthId#
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
	select member_id,
		last_retinopathy_test_id,
		last_opthamologist_id
	from ncd_specialist_master
	inner join base_data on base_data.id = ncd_specialist_master.member_id
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
		imm.unique_health_id as "uniqueHealthId",
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