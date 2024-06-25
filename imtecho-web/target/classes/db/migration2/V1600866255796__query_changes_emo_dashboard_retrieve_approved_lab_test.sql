DELETE FROM QUERY_MASTER WHERE CODE='emo_dashboard_retrieve_approved_lab_test';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'ad79001b-1b7b-4418-88f4-8b1e725eebba', 84954,  current_date , 84954,  current_date , 'emo_dashboard_retrieve_approved_lab_test',
'searchText,offset,limit,loggedInUserId',
'with idsp_screening as (
	select
	clt.id as "id",
        clt.source as "source",
	(case when f.area_id is not null then f.area_id else f.location_id end)   as loc_id,
	m.family_id,
	m.id as member_id,
	m.first_name || '' '' || m.middle_name || '' '' || m.last_name || '' ('' || m.unique_health_id || '')'' || ''<br>'' || m.family_id as member_det,
	concat(to_char(m.dob, ''DD/MM/YYYY''),''('',EXTRACT(YEAR FROM age(m.dob)),'')'') as dob,
	(case when ref_by.id is null then ''N/A''
		else concat(concat_ws('' '',ref_by.first_name,ref_by.middle_name,ref_by.last_name),'' ('',ref_by.contact_number,'')'',''<BR>('',ref_by.user_name,'') ('',urm.name,'')'') end) as reffer_by,

	(case when idsp.is_cough = 1 then true else false end) as is_cough,
	(case when idsp.is_any_illness_or_discomfort = 1 then true else false end) as is_any_illness_or_discomfort,
	(case when idsp.is_breathlessness = 1 then true else false end) as breathlessness,
	(case when idsp.is_fever = 1 then true else false end) as is_fever,
	(case when idsp.has_travel = 1 then ''Local''
		when idsp.has_travel=2 then concat(''International'',(case when idsp.country is not null then concat('' ('',idsp.country,'')'') end))
		else ''No'' end) as travel,
	concat_ws('','', address1, address2) as address,
	m.mobile_number as contact_person,
	clt.lab_test_status
	from covid19_lab_test_recommendation clt
	inner join imt_member m on clt.member_id = m.id
	inner join imt_family f on f.family_id = m.family_id
	left join um_user ref_by on ref_by.id = clt.reffer_by
       left join um_role_master urm on urm.id = ref_by.role_id
	left join idsp_screening_analytics idsp on clt.member_id = idsp.member_id
	where clt.lab_test_status in (''APPROVE'',''SYSTEM_APPROVE'')
        and (''#searchText#'' = ''null'' OR clt.search_text ilike ''%#searchText#%'')
	and clt.refer_health_infra_id is null
	and clt.location_id in (select child_id from location_hierchy_closer_det lhc where parent_id in (select loc_id from um_user_location ul where ul.state = ''ACTIVE'' and ul.user_id = #loggedInUserId#))
	order by idsp.member_id
	limit #limit# offset #offset#
),contact_person as (
	select distinct on(a.member_id) a.member_id as id,
	 concat( contact_person.first_name, '' '', contact_person.middle_name, '' '', contact_person.last_name,
		'' ('', case when contact_person.mobile_number is null then ''N/A'' else contact_person.mobile_number end, '')'' ) as contactPersonMobileNo
	from imt_member contact_person
	inner join idsp_screening a on a.family_id = contact_person.family_id
	where contact_person.basic_state in (''NEW'',''IDSP'',''VERIFIED'') and contact_person.id != a.member_id and a.contact_person is null
	order by a.member_id,contact_person.dob
),
loc as (
	select distinct loc_id from idsp_screening
),
loc_det as (
	select loc.loc_id, get_location_hierarchy_from_ditrict(loc.loc_id) as aoi
	from loc
)/*, fhw_det as (
	select loc.loc_id,
	u.first_name || '' '' || u.last_name || '' ('' || u.user_name || '')'' || ''<br>''
	|| ''Contact : '' || case when u.contact_number is not null then u.contact_number else ''N/A'' end as fhw
	from um_user_location ul, um_user u, loc,location_hierchy_closer_det
	where loc.loc_id = location_hierchy_closer_det.child_id and
	location_hierchy_closer_det.parent_id = ul.loc_id and u.id = ul.user_id
	and u.state = ''ACTIVE'' and ul.state = ''ACTIVE''
	and u.role_id in (select id from um_role_master where name in (''MO UPHC'', ''MO PHC''))
	group by loc.loc_id, ul.state, u.state, u.first_name, u.last_name, u.user_name, u.contact_number
)*/
select
idsp_screening.id as "id",
idsp_screening.source as "source",
idsp_screening.member_det as "memberDetails",
loc_det.aoi as "location",
(case when idsp_screening.contact_person is not null then idsp_screening.contact_person else contact_person.contactPersonMobileNo end) as "contactPersonMobileNo",
idsp_screening.dob as "dob",
idsp_screening.address as "address",
idsp_screening.is_cough as "hasCough",
idsp_screening.is_fever as "hasFever",
idsp_screening.breathlessness as "hasBreathlessness",
idsp_screening.travel as "hasTravelHistory",
idsp_screening.reffer_by as "refferBy",
idsp_screening.lab_test_status as "labTestStatus"
/*fhw_det.fhw as "moDetails"*/
from idsp_screening
left join contact_person on contact_person.id = idsp_screening.id
inner join loc_det on idsp_screening.loc_id = loc_det.loc_id;',
null,
true, 'ACTIVE');