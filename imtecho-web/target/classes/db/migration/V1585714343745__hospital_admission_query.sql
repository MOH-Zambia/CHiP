DROP TABLE if exists public.covid19_lab_test_recommendation;

CREATE TABLE public.covid19_lab_test_recommendation
(
  id serial,
  member_id integer,
  location_id integer,
  opd_lab_test_id integer,
  lab_test_status text,
  lab_test_status_entry_by integer,
  lab_test_status_entry_on timestamp without time zone,
  refer_health_infra_id integer,
  refer_health_infra_entry_by integer,
  refer_health_infra_entry_on timestamp without time zone,
  reffer_by integer,
  admission_id integer,
  CONSTRAINT covid19_lab_test_recommendation_pkey PRIMARY KEY (id)
);

DROP TABLE if exists public.covid19_admission_detail;

CREATE TABLE public.covid19_admission_detail
(
  id serial,
  member_id integer,
  location_id integer,
  covid19_lab_test_recommendation_id integer,
  health_infra_id integer,
  current_ward_id integer,
  current_bed_no text,
  admission_status_id integer,
  last_check_up_detail_id integer,
  admission_date timestamp without time zone,
  admission_entry_by integer,
  admission_entry_on timestamp without time zone,
  discharge_date timestamp without time zone,
  discharge_remark text,
  discharge_status text,
  discharge_entry_by integer,
  discharge_entry_on timestamp without time zone,
  admission_from text,
  status text,
  first_name text,
  middle_name text,
  last_name text,
  dob date,
  contact_number text,
  address text,
  is_cough boolean,
  is_fever boolean,
  is_breathlessness boolean,
  is_hiv boolean,
  is_heart_patient boolean,
  is_diabetes boolean,
  case_no text,
  last_lab_test_id integer,
  gender text,
  age smallint,
  pincode character varying(6),
  emergency_contact_name text,
  emergency_contact_no character varying(10),
  is_immunocompromized boolean,
  is_hypertension boolean,
  is_malignancy boolean,
  is_renal_condition boolean,
  is_copd boolean,
  pregnancy_status text,
  date_of_onset_symptom date,
  occupation text,
  travelled_place text,
  abroad_contact_details text,
  travel_history text,
  is_abroad_in_contact text,
  death_date date,
  death_cause text,
  CONSTRAINT covid19_admission_detail_pkey PRIMARY KEY (id)
);


DROP TABLE if exists covid19_admitted_case_daily_status;

CREATE TABLE covid19_admitted_case_daily_status
(
  id serial,
  member_id integer,
  location_id integer,
  admission_id integer,
  service_date date,
  ward_id integer,
  bed_no text,
  health_status text,
  on_ventilator boolean,
  ventilator_type1 boolean,
  ventilator_type2 boolean,
  on_o2 boolean,
  remarks text,
  created_by integer,
  created_on timestamp without time zone,
  last_lab_test_id integer,
  gender text,
  on_air boolean,
  clinically_clear boolean,
  CONSTRAINT covid19_admitted_case_daily_status_pkey PRIMARY KEY (id)
);

DROP TABLE if exists public.covid19_lab_test_detail;

CREATE TABLE public.covid19_lab_test_detail
(
  id serial,
  member_id integer,
  location_id integer,
  covid_admission_detail_id integer,
  lab_collection_status text,
  lab_collection_on timestamp without time zone,
  lab_collection_entry_by integer,
  lab_sample_rejected_by integer,
  lab_sample_rejected_on timestamp without time zone,
  lab_sample_reject_reason text,
  lab_sample_received_by integer,
  lab_sample_received_on timestamp without time zone,
  lab_result_entry_on timestamp without time zone,
  lab_result_entry_by integer,
  lab_result text,
  sample_health_infra integer,
  sample_health_infra_send_to integer,
  created_by integer,
  created_on timestamp without time zone,
  lab_test_number text,
  CONSTRAINT covid19_lab_test_detail_pkey PRIMARY KEY (id)
);


delete from query_master where code = 'retrieve_locations_by_type';
INSERT INTO query_master
(created_by, created_on, modified_by, modified_on, code, params, query, returns_result_set, state, description, is_public)
VALUES(1, '2020-03-25 00:00:00.000', 409, '2020-03-26 03:06:54.950', 'retrieve_locations_by_type', NULL, 'select * from location_master where type in (''D'',''C'') order by name', true, 'ACTIVE', NULL, true);


delete from query_master where code = 'emo_dashboard_get_reffer_paitent_list';
INSERT INTO query_master
(created_by, created_on, modified_by, modified_on, code, params, query, returns_result_set, state, description, is_public)
VALUES(409, '2020-03-30 15:08:33.781', 409, '2020-03-30 15:08:33.781', 'emo_dashboard_get_reffer_paitent_list', 'limit_offset,loggedInUserId', 'with idsp_screening as (
	select
	clt.id as "id",
	idsp.location_id as loc_id,
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
	clt.lab_test_status,
	case when clt.admission_id is not null then ''Admitted'' else ''PENDING'' end  as addmision_status,
	hid.name as refer_health_infra
	from covid19_lab_test_recommendation clt
	inner join imt_member m on clt.member_id = m.id
	inner join imt_family f on f.family_id = m.family_id
	inner join health_infrastructure_details hid on hid.id = clt.refer_health_infra_id
	left join um_user ref_by on ref_by.id = clt.reffer_by
    left join um_role_master urm on urm.id = ref_by.role_id
	left join idsp_screening_analytics idsp on clt.member_id = idsp.member_id
	
	where clt.lab_test_status in (''APPROVE'',''SYSTEM_APPROVE'')
	and clt.refer_health_infra_id is not null
	and clt.location_id in (select child_id from location_hierchy_closer_det lhc where parent_id in (select loc_id from um_user_location ul where ul.state = ''ACTIVE'' and ul.user_id = ''#loggedInUserId#''))
	order by idsp.member_id
	#limit_offset#
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
ROW_NUMBER() over () + cast(SUBSTRING(''#limit_offset#'', POSITION(''offset'' in ''#limit_offset#'') + 7) as int) as "srNo",
idsp_screening.id as "id",
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
idsp_screening.lab_test_status as "labTestStatus",
idsp_screening.refer_health_infra as "referHealthInfra",
idsp_screening.addmision_status as "addmissionStatus"
/*fhw_det.fhw as "moDetails"*/
from idsp_screening
left join contact_person on contact_person.id = idsp_screening.id
inner join loc_det on idsp_screening.loc_id = loc_det.loc_id;', true, 'ACTIVE', NULL, NULL);

delete from query_master where code = 'covid19_wards_bed_detail';
INSERT INTO query_master
(created_by, created_on, modified_by, modified_on, code, params, query, returns_result_set, state, description, is_public)
VALUES(75398, '2020-03-31 15:58:52.716', 409, '2020-04-01 05:23:06.375', 'covid19_wards_bed_detail', 'wardId', 'with health_infra_details as (
select generate_series(1,number_of_beds) as available from health_infrastructure_ward_details where id = #wardId#
), filled_bed as (
select cast(current_bed_no as text) from covid19_admission_detail where status not in (''DISCHARGE'',''DEAD'',''REFER'')
and current_ward_id = #wardId#
)
select available as id,available as bed_name from health_infra_details
where cast(available as text) not in (select distinct current_bed_no from filled_bed)', true, 'ACTIVE', NULL, NULL);

delete from query_master where code = 'emo_dashboard_retrieve_approved_lab_test';
INSERT INTO query_master
(created_by, created_on, modified_by, modified_on, code, params, query, returns_result_set, state, description, is_public)
VALUES(409, '2020-03-29 16:43:14.065', 409, '2020-03-30 14:38:02.905', 'emo_dashboard_retrieve_approved_lab_test', 'limit_offset,loggedInUserId', 'with idsp_screening as (
	select
	clt.id as "id",
	idsp.location_id as loc_id,
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
	and clt.refer_health_infra_id is null
	and clt.location_id in (select child_id from location_hierchy_closer_det lhc where parent_id in (select loc_id from um_user_location ul where ul.state = ''ACTIVE'' and ul.user_id = ''#loggedInUserId#''))
	order by idsp.member_id
	#limit_offset#
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
ROW_NUMBER() over () + cast(SUBSTRING(''#limit_offset#'', POSITION(''offset'' in ''#limit_offset#'') + 7) as int) as "srNo",
idsp_screening.id as "id",
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
inner join loc_det on idsp_screening.loc_id = loc_det.loc_id;', true, 'ACTIVE', NULL, NULL);


delete from query_master where code = 'covid19_get_ward_detail';
INSERT INTO query_master
(created_by, created_on, modified_by, modified_on, code, params, query, returns_result_set, state, description, is_public)
VALUES(409, '2020-03-29 17:45:03.024', 409, '2020-04-01 00:31:38.723', 'covid19_get_ward_detail', 'loggedInUserId', 'select ward.id,ward_name
from health_infrastructure_ward_details ward 
where ward.health_infra_id = (select uhi.health_infrastrucutre_id from user_health_infrastructure uhi 
	where uhi.user_id = ''#loggedInUserId#'' and uhi.state = ''ACTIVE'')', true, 'ACTIVE', NULL, NULL);
	

delete from query_master where code = 'insert_covid19_admitted_case_daily_status';	
INSERT INTO query_master
(created_by, created_on, modified_by, modified_on, code, params, query, returns_result_set, state, description, is_public)
VALUES(74841, '2020-03-29 22:02:56.371', 74841, '2020-03-29 22:33:08.310', 'insert_covid19_admitted_case_daily_status', 'member_id,loggedIn_user,ward_no,bed_no,health_status,admission_id,location_id', 'insert into covid19_admitted_case_daily_status(
member_id, 
location_id, 
admission_id,
service_date,
ward_id,
bed_no,
health_status,
on_ventilator,
ventilator_type1,
ventilator_type2,
on_o2,
remarks,
created_by,
created_on
)
values (
	#member_id#,
	#location_id#,
	#admission_id#,
	null,
	#ward_no#,
	#bed_no#,
	''#health_status#'',
        null,
	null,
	null,
	null,
	null,
	#loggedIn_user#,now()	
)
returning id;', true, 'ACTIVE', NULL, NULL);


delete from query_master where code = 'covid19_addmitted_case_daily_status_insert_data';
INSERT INTO query_master
(created_by, created_on, modified_by, modified_on, code, params, query, returns_result_set, state, description, is_public)
VALUES(75398, '2020-03-29 21:00:43.098', 409, '2020-04-01 03:48:05.084', 'covid19_addmitted_case_daily_status_insert_data', 'serviceDate,onAir,ventilatorType2,ventilatorType1,wardId,loggedInUserId,healthStatus,onVentilator,locationId,onO2,admissionId,bedNumber,clinicallyCured,remarks,memberId', 'with insert_daily_check_up as (
insert into covid19_admitted_case_daily_status(member_id,location_id,admission_id,service_date,ward_id,bed_no,health_status, on_ventilator,ventilator_type1,ventilator_type2,on_o2
,on_air,clinically_clear
,remarks,created_by, created_on)
values(
#memberId#, ''#locationId#'',
''#admissionId#'', ''#serviceDate#'', ''#wardId#'',  ''#bedNumber#'',''#healthStatus#'', #onVentilator#,#ventilatorType1#,#ventilatorType2#,#onO2#
,#onAir#,#clinicallyCured#
,''#remarks#'',''#loggedInUserId#'',now())
returning id
)
update covid19_admission_detail cad set current_ward_id = ''#wardId#'', current_bed_no = ''#bedNumber#'' , last_check_up_detail_id = (select id from insert_daily_check_up)
where id = #admissionId#;', false, 'ACTIVE', NULL, NULL);


delete from query_master where code = 'covid19_admission_discharge';
INSERT INTO query_master
(created_by, created_on, modified_by, modified_on, code, params, query, returns_result_set, state, description, is_public)
VALUES(75398, '2020-03-30 19:07:00.759', 409, '2020-04-01 05:16:14.787', 'covid19_admission_discharge', 'isDeath,dischargeDate,deathDate,admissionId,loggedInUserId,deathCause,isDischarge', 'with  death_state as (
update covid19_admission_detail set status = ''DEATH'',
death_cause = ''#deathCause#'',
discharge_date =to_date(''#deathDate#'',''YYYY-MM-DD''),
discharge_status =''DEATH'',
discharge_entry_by =''#loggedInUserId#'',
discharge_entry_on =now()
where id = #admissionId# and #isDeath# = true
)
update covid19_admission_detail set status = ''DISCHARGE'',
discharge_date =to_date(''#dischargeDate#'',''YYYY-MM-DD''),
discharge_status =''DISCHARGE'',
discharge_entry_by =''#loggedInUserId#'',
discharge_entry_on =now()
where id = #admissionId# and #isDischarge# = true;', false, 'ACTIVE', NULL, NULL);


delete from query_master where code = 'insert_covid19_lab_test_detail';
INSERT INTO query_master
(created_by, created_on, modified_by, modified_on, code, params, query, returns_result_set, state, description, is_public)
VALUES(75398, '2020-03-30 18:39:53.393', 409, '2020-03-31 04:37:46.168', 'insert_covid19_lab_test_detail', 'locationId,admissionId,loggedInUserId,memberId', 'with insert_lab_test_detail as (
INSERT INTO covid19_lab_test_detail(
member_id, location_id, covid_admission_detail_id, lab_collection_status,created_by,created_on,sample_health_infra)
VALUES (#memberId#,
#locationId#, ''#admissionId#'',''COLLECTION_PENDING'',''#loggedInUserId#'',now(),(select health_infra_id from covid19_admission_detail where id  = ''#admissionId#''))
returning id
)
update covid19_admission_detail set last_lab_test_id = (select id from insert_lab_test_detail)
where id = #admissionId#;', false, 'ACTIVE', NULL, NULL);

delete from query_master where code = 'covid19_lab_test_pending_sample_collection';
INSERT INTO query_master
(created_by, created_on, modified_by, modified_on, code, params, query, returns_result_set, state, description, is_public)
VALUES(409, '2020-03-29 21:53:03.291', 60512, '2020-03-31 11:53:32.322', 'covid19_lab_test_pending_sample_collection', 'limit_offset,loggedInUserId', 'with idsp_screening as (
select
	clt.id as "id",
	ltd.id as lab_id,
	clt.location_id as loc_id,
	imt_member.id as member_id,
	case when clt.member_id is null 
		then concat_ws('' '',clt.first_name,clt.middle_name,clt.last_name)
		else concat(concat_ws('' '',imt_member.first_name,imt_member.middle_name,imt_member.last_name)
			, '' ('' , imt_member.unique_health_id , '')'' , ''<br>'' , imt_member.family_id) end as member_det,
	concat(case when clt.member_id is null 
		then cast(clt.age as text)
		else cast(EXTRACT(YEAR FROM age(imt_member.dob)) as text) end,'' Year'') as age,
	to_char(clt.admission_date,''DD/MM/YYYY'') as admission_date,
	hiwd.ward_name,
	sample_from."name" as sample_from_health_infra,
	sample_from.is_covid_lab,
	clt.current_ward_id as ward_id,
	cacd.on_ventilator as on_ventilator,
	cacd.ventilator_type1 as ventilator_type1,
	cacd.ventilator_type2 as ventilator_type2,
	cacd.on_o2 as on_o2,
	cacd.on_air as on_air,
	cacd.remarks as remarks,
	clt.is_hiv as hiv,
	clt.current_bed_no,
	cacd.health_status as health_status,
	cacd.service_date as last_check_up_time
	from covid19_lab_test_detail ltd 
	inner join covid19_admission_detail clt on ltd.covid_admission_detail_id = clt.id
	inner join health_infrastructure_ward_details hiwd on hiwd.id = clt.current_ward_id
	inner join covid19_admitted_case_daily_status cacd on cacd.id = clt.last_check_up_detail_id
	left join health_infrastructure_details sample_from on sample_from.id = ltd.sample_health_infra
	left join imt_member on clt.member_id = imt_member.id
	left join imt_family on imt_member.family_id = imt_family.family_id
	where
	ltd.sample_health_infra = (select uhi.health_infrastrucutre_id from user_health_infrastructure uhi where uhi.user_id = ''#loggedInUserId#'' and uhi.state = ''ACTIVE'')
	and clt.status not in (''DISCHARGED'',''DEAD'',''REFER'') and ltd.lab_collection_status = ''COLLECTION_PENDING''
	order by cacd.service_date
	#limit_offset#
)
select 
id as "admissionId" 
,lab_id as "labCollectionId"
,member_id as "memberId"
,loc_id as "locationId"
,member_det as "memberDetail"
,age as "age"
,admission_date as "admissionDate"
,ward_name as "wardName"
,ward_id as "wardId"
,current_bed_no as "bedNumber"
,health_status as "healthStatus"
,to_char(last_check_up_time,''DD/MM/YYYY'') as "lastCheckUpTime"
,on_ventilator
,ventilator_type1
,ventilator_type2
,on_o2
,on_air
,remarks
,hiv
,sample_from_health_infra as "sampleFrom"
,is_covid_lab as "isSameHealthInfrastructure"
from idsp_screening;', true, 'ACTIVE', NULL, NULL);


delete from query_master where code = 'covid19_lab_test_pending_sample_receive';
INSERT INTO query_master
(created_by, created_on, modified_by, modified_on, code, params, query, returns_result_set, state, description, is_public)
VALUES(60512, '2020-03-30 12:36:12.137', 409, '2020-04-01 03:22:38.895', 'covid19_lab_test_pending_sample_receive', 'limit_offset,loggedInUserId', 'with idsp_screening as (
select
	clt.id as "id",
	ltd.id as lab_id,
	clt.location_id as loc_id,
	imt_member.id as member_id,
	case when clt.member_id is null 
		then concat_ws('' '',clt.first_name,clt.middle_name,clt.last_name)
		else concat(concat_ws('' '',imt_member.first_name,imt_member.middle_name,imt_member.last_name)
			, '' ('' , imt_member.unique_health_id , '')'' , ''<br>'' , imt_member.family_id) end as member_det,
	concat(case when clt.member_id is null 
		then cast(clt.age as text)
		else cast(EXTRACT(YEAR FROM age(imt_member.dob)) as text) end,'' Year'') as age,
	to_char(clt.admission_date,''DD/MM/YYYY'') as admission_date,
	hiwd.ward_name,
	sample_from."name" as sample_from_health_infra,
	sample_from.is_covid_lab,
	clt.current_ward_id as ward_id,
	cacd.on_ventilator as on_ventilator,
	cacd.ventilator_type1 as ventilator_type1,
	cacd.ventilator_type2 as ventilator_type2,
	cacd.on_o2 as on_o2,
	cacd.on_air as on_air,
	cacd.remarks as remarks,
	clt.is_hiv as hiv,
	clt.current_bed_no,
	cacd.health_status as health_status,
	cacd.service_date as last_check_up_time
	from covid19_lab_test_detail ltd 
	inner join covid19_admission_detail clt on ltd.covid_admission_detail_id = clt.id
	inner join health_infrastructure_ward_details hiwd on hiwd.id = clt.current_ward_id
	inner join covid19_admitted_case_daily_status cacd on cacd.id = clt.last_check_up_detail_id
	left join health_infrastructure_details sample_from on sample_from.id = ltd.sample_health_infra
	left join imt_member on clt.member_id = imt_member.id
	left join imt_family on imt_member.family_id = imt_family.family_id
	where
	ltd.sample_health_infra_send_to = (select uhi.health_infrastrucutre_id from user_health_infrastructure uhi where uhi.user_id = ''#loggedInUserId#'' and uhi.state = ''ACTIVE'')
	and clt.status not in (''DISCHARGED'',''DEAD'',''REFER'') and ltd.lab_collection_status = ''SAMPLE_COLLECTED''
	order by cacd.service_date
	#limit_offset#
)
select 
id as "admissionId" 
,lab_id as "labCollectionId"
,member_id as "memberId"
,loc_id as "locationId"
,member_det as "memberDetail"
,age as "age"
,admission_date as "admissionDate"
,ward_name as "wardName"
,ward_id as "wardId"
,current_bed_no as "bedNumber"
,health_status as "healthStatus"
,to_char(last_check_up_time,''DD/MM/YYYY'') as "lastCheckUpTime"
,on_ventilator
,ventilator_type1
,ventilator_type2
,on_o2
,on_air
,remarks
,hiv
,sample_from_health_infra as "sampleFrom"
,is_covid_lab as "isSameHealthInfrastructure"
from idsp_screening;', true, 'ACTIVE', NULL, NULL);


delete from query_master where code = 'emo_dashboard_retrieve_referred_for_covid_lab_test';
INSERT INTO query_master
(created_by, created_on, modified_by, modified_on, code, params, query, returns_result_set, state, description, is_public)
VALUES(1, '2020-03-28 00:00:00.000', 409, '2020-03-30 14:30:06.435', 'emo_dashboard_retrieve_referred_for_covid_lab_test', 'limit_offset,loggedInUserId', 'with idsp_screening as (
	select
	clt.id as "id",
	idsp.location_id as loc_id,
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
	m.mobile_number as contact_person
	from covid19_lab_test_recommendation clt
	inner join imt_member m on clt.member_id = m.id
	inner join imt_family f on f.family_id = m.family_id
	left join um_user ref_by on ref_by.id = clt.reffer_by
	left join um_role_master urm on urm.id = ref_by.role_id
	left join idsp_screening_analytics idsp on clt.member_id = idsp.member_id
	where clt.lab_test_status = ''PENDING''
	and clt.location_id in (select child_id from location_hierchy_closer_det lhc where parent_id in (select loc_id from um_user_location ul where ul.state = ''ACTIVE'' and ul.user_id = ''#loggedInUserId#''))
	order by idsp.member_id
	#limit_offset#
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
ROW_NUMBER() over () + cast(SUBSTRING(''#limit_offset#'', POSITION(''offset'' in ''#limit_offset#'') + 7) as int) as "srNo",
idsp_screening.id as "id",
idsp_screening.member_det as "memberDetails",
loc_det.aoi as "location",
(case when idsp_screening.contact_person is not null then idsp_screening.contact_person else contact_person.contactPersonMobileNo end) as "contactPersonMobileNo",
idsp_screening.dob as "dob",
idsp_screening.address as "address",
idsp_screening.is_cough as "hasCough",
idsp_screening.is_fever as "hasFever",
idsp_screening.breathlessness as "hasBreathlessness",
idsp_screening.travel as "hasTravelHistory",
idsp_screening.reffer_by as "refferBy"
/*fhw_det.fhw as "moDetails"*/
from idsp_screening
left join contact_person on contact_person.id = idsp_screening.id
inner join loc_det on idsp_screening.loc_id = loc_det.loc_id;', true, 'ACTIVE', NULL, false);


delete from query_master where code = 'covid19_get_confirmed_admitted_patient_list';
INSERT INTO query_master
(created_by, created_on, modified_by, modified_on, code, params, query, returns_result_set, state, description, is_public)
VALUES(409, '2020-03-29 20:34:30.651', 409, '2020-04-01 03:26:53.896', 'covid19_get_confirmed_admitted_patient_list', 'limit_offset,loggedInUserId', 'with idsp_screening as (
select
	clt.id as "id",
	clt.location_id as loc_id,
	imt_member.id as member_id,
	case when clt.member_id is null 
		then concat_ws('' '',clt.first_name,clt.middle_name,clt.last_name)
		else concat(concat_ws('' '',imt_member.first_name,imt_member.middle_name,imt_member.last_name)
			, '' ('' , imt_member.unique_health_id , '')'' , ''<br>'' , imt_member.family_id) end as member_det,
	concat(case when clt.member_id is null 
		then clt.age
		else EXTRACT(YEAR FROM age(imt_member.dob)) end,'' Year'') as dob,
	to_char(clt.admission_date,''DD/MM/YYYY'') as admission_date,
	hiwd.ward_name,
	clt.current_ward_id as ward_id,
	cacd.on_ventilator as on_ventilator,
	cacd.ventilator_type1 as ventilator_type1,
	cacd.ventilator_type2 as ventilator_type2,
	cacd.on_o2 as on_o2,
	cacd.on_air as on_air,
	cacd.remarks as remarks,
	clt.current_bed_no,
	cltd.lab_collection_status as test_result,
	(case when cltd.lab_collection_status in (''COLLECTION_PENDING'',''SAMPLE_COLLECTED'',''SAMPLE_ACCEPTED'') then true else false end) as "isLabTestInProgress",
	cacd.health_status as health_status,
	cacd.service_date as last_check_up_time
	from covid19_admission_detail clt
	inner join health_infrastructure_ward_details hiwd on hiwd.id = clt.current_ward_id
	inner join covid19_admitted_case_daily_status cacd on cacd.id = clt.last_check_up_detail_id
	inner join covid19_lab_test_detail cltd on cltd.id = clt.last_lab_test_id
	left join imt_member on clt.member_id = imt_member.id
	left join imt_family on imt_member.family_id = imt_family.family_id
	where
	clt.health_infra_id = (select uhi.health_infrastrucutre_id from user_health_infrastructure uhi where uhi.user_id = ''#loggedInUserId#'' and uhi.state = ''ACTIVE'')
	and clt.status in (''CONFORMED'')
	order by cacd.service_date
	#limit_offset#
)
select 
id as "admissionId" 
,member_id as "memberId"
,loc_id as "locationId"
,member_det as "memberDetail"
,dob as "DOB"
,admission_date as "admissionDate"
,ward_name as "wardName"
,ward_id as "wardId"
,current_bed_no as "bedNumber"
,test_result as "testResult"
,health_status as "healthStatus"
,to_char(last_check_up_time,''DD/MM/YYYY'') as "lastCheckUpTime"
,on_ventilator
,ventilator_type1
,ventilator_type2
,on_o2
,on_air
,remarks
,"isLabTestInProgress"
from idsp_screening;', true, 'ACTIVE', NULL, NULL);


delete from query_master where code = 'retrieve_covid_hospitals_by_location';
INSERT INTO query_master
(created_by, created_on, modified_by, modified_on, code, params, query, returns_result_set, state, description, is_public)
VALUES(60512, '2020-03-29 17:22:39.739', 60512, '2020-03-29 17:22:39.739', 'retrieve_covid_hospitals_by_location', 'locationId', 'select *
from health_infrastructure_details
where (case when #locationId# is not null then location_id in (select child_id from location_hierchy_closer_det where parent_id = #locationId#) else true end)
and (is_covid_hospital or is_covid_lab)', true, 'ACTIVE', NULL, NULL);


delete from query_master where code = 'covid19_get_pending_admission_for_lab_test';
INSERT INTO query_master
(created_by, created_on, modified_by, modified_on, code, params, query, returns_result_set, state, description, is_public)
VALUES(409, '2020-03-29 16:57:24.190', 409, '2020-03-30 14:43:16.545', 'covid19_get_pending_admission_for_lab_test', 'limit_offset,loggedInUserId', 'with idsp_screening as (
	select
	clt.id as "id",
        idsp.location_id as loc_id,
	m.family_id,
	m.id as member_id,
	m.gender,
	m.first_name || '' '' || m.middle_name || '' '' || m.last_name || '' ('' || m.unique_health_id || '')'' || ''<br>'' || m.family_id as member_det,
	concat(to_char(m.dob, ''DD/MM/YYYY''),''('',EXTRACT(YEAR FROM age(m.dob)),'')'') as dob,
	(case when ref_by.id is null then ''N/A'' 
		else concat(concat_ws('' '',ref_by.first_name,ref_by.middle_name,ref_by.last_name),'' ('',ref_by.contact_number,'')'',''<BR>('',ref_by.user_name,'')'') end) as reffer_by,
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
	left join um_user ref_by on ref_by.id = clt.refer_health_infra_entry_by
	left join idsp_screening_analytics idsp on clt.member_id = idsp.member_id
	where clt.refer_health_infra_id is not null
	and clt.admission_id is null
	--and cld.refer_health_infra_id in (select id from user_health_infrastructure uhi where uhi.user_id = ''#loggedInUserId#'' and uhi.state = ''ACTIVE'')
	order by idsp.member_id
	#limit_offset#
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
ROW_NUMBER() over () + cast(SUBSTRING(''#limit_offset#'', POSITION(''offset'' in ''#limit_offset#'') + 7) as int) as "srNo",
idsp_screening.id as "id",
idsp_screening.loc_id as "locationId",
idsp_screening.member_id as "memberId",
idsp_screening.member_det as "memberDetails",
idsp_screening.gender,
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
inner join loc_det on idsp_screening.loc_id = loc_det.loc_id;', true, 'ACTIVE', NULL, NULL);


delete from query_master where code = 'insert_covid19_admission_detail';
INSERT INTO query_master
(created_by, created_on, modified_by, modified_on, code, params, query, returns_result_set, state, description, is_public)
VALUES(74841, '2020-03-29 21:09:01.746', 409, '2020-03-31 02:51:18.970', 'insert_covid19_admission_detail', 'member_id,loggedIn_user,ward_no,bed_no,loggedInUserId,location_id,isHeartPatient,covid19_lab_test_recommendation_id,admission_date,isHIV,health_status,isDiabetes,isPregnant', 'with generated_id as (
select  nextval(''covid19_admission_detail_id_seq'') as id 
),insert_daily_admission_det as (
insert into covid19_admitted_case_daily_status(member_id,location_id,admission_id,service_date,ward_id,bed_no,health_status,created_by,created_on)
values(#member_id#,#location_id#,(select id from generated_id),''#admission_date#'',#ward_no#,''#bed_no#'',''#health_status#'',''#loggedInUserId#'',now())
returning id
),insert_lab_test as (
INSERT INTO public.covid19_lab_test_detail(
member_id, location_id, covid_admission_detail_id, lab_collection_status)
VALUES (#member_id#,
#location_id#, (select id from generated_id),''COLLECTION_PENDING'')
returning id
),update_lab_test_recommdation as (
update covid19_lab_test_recommendation set admission_id = (select id from generated_id)
where id = #covid19_lab_test_recommendation_id#
)
insert into covid19_admission_detail 
(id,
member_id,
location_id,
covid19_lab_test_recommendation_id,
last_lab_test_id,
last_check_up_detail_id,
health_infra_id,
current_ward_id,
current_bed_no,
admission_status_id,
admission_date,
admission_entry_by,
admission_entry_on,
is_hiv,
is_pregnant,
is_heart_patient,
is_diabetes,
admission_from,
status
)
values(
(select id from generated_id)
,#member_id#
,#location_id#
,#covid19_lab_test_recommendation_id#
,(select id from insert_lab_test)
,(select id from insert_daily_admission_det)
, (select uhi.health_infrastrucutre_id from user_health_infrastructure uhi where uhi.user_id = ''#loggedInUserId#'' and uhi.state = ''ACTIVE'')
,#ward_no#
,''#bed_no#''
,(select id from insert_daily_admission_det)
,''#admission_date#''
,#loggedIn_user#
,now()
,#isHIV#
,#isPregnant#
,#isHeartPatient#
,#isDiabetes#
,''LAB_RECOMMENDATION''
,''ADMITTED''
)
RETURNING id;', true, 'ACTIVE', NULL, NULL);


delete from query_master where code = 'insert_covid19_new_admission_detail';
INSERT INTO query_master
(created_by, created_on, modified_by, modified_on, code, params, query, returns_result_set, state, description, is_public)
VALUES(80248, '2020-03-30 23:52:21.584', 409, '2020-04-01 02:30:32.823', 'insert_covid19_new_admission_detail', 'firstname,occupation,gender,bed_no,date_of_onset_symptom,isHypertension,isRenalCondition,emergencyContactNo,isHeartPatient,abroad_contact_details,talukaLocationId,admission_date,locationId,contact_no,case_number,health_status,memberId,isImmunocompromized,member_id,address,loggedIn_user,ward_no,emergencyContactName,hasCough,pregnancy_status,middlename,travelHistory,loggedInUserId,isCOPD,travelledPlace,lastname,isMalignancy,hasShortnessBreath,covid19_lab_test_recommendation_id,hasFever,isHIV,pinCode,is_abroad_in_contact,isDiabetes,age', 'with generated_id as (
select  nextval(''covid19_admission_detail_id_seq'') as id 
),health_infra_det as (
select * from health_infrastructure_details where id = (select uhi.health_infrastrucutre_id from user_health_infrastructure uhi where uhi.user_id = ''#loggedInUserId#'' and uhi.state = ''ACTIVE'')
),insert_daily_admission_det as (
insert into covid19_admitted_case_daily_status(member_id,location_id,admission_id,service_date,ward_id,bed_no,health_status,created_by,created_on)
values(#member_id#,#talukaLocationId#,(select id from generated_id),''#admission_date#'',#ward_no#,''#bed_no#'',''#health_status#'',''#loggedInUserId#'',now())
returning id
),insert_lab_test as (
INSERT INTO public.covid19_lab_test_detail(
member_id, location_id, covid_admission_detail_id, lab_collection_status,created_by,created_on,sample_health_infra)
VALUES (#memberId#,
#locationId#, (select id from generated_id),''COLLECTION_PENDING'',''#loggedInUserId#'',now(), (select id from health_infra_det))
returning id
),update_lab_test_recommdation as (
update covid19_lab_test_recommendation set admission_id = (select id from generated_id)
where id = #covid19_lab_test_recommendation_id#
)
insert into covid19_admission_detail 
(id,
member_id,
first_name,
middle_name,
last_name,
age,
contact_number,
address,
gender,

case_no,

is_cough,
is_fever,
is_breathlessness,
location_id,
covid19_lab_test_recommendation_id,
last_lab_test_id,
last_check_up_detail_id,
health_infra_id,
current_ward_id,
current_bed_no,
admission_status_id,
admission_date,
admission_entry_by,
admission_entry_on,
is_hiv,
is_heart_patient,
is_diabetes,
admission_from,
status,
pincode,
emergency_contact_name,
emergency_contact_no,
is_immunocompromized,
is_hypertension,
is_malignancy,
is_renal_condition,
is_copd,
pregnancy_status,
date_of_onset_symptom,
occupation,
travel_history,
travelled_place,
is_abroad_in_contact,
abroad_contact_details
)
values(
(select id from generated_id)
,#member_id#
,''#firstname#''
,(case when ''#middlename#'' = ''null'' then null else ''#middlename#'' end)
,(case when ''#lastname#'' = ''null'' then null else ''#lastname#'' end)
,#age#
,(case when ''#contact_no#'' = ''null'' then null else ''#contact_no#'' end)
,(case when ''#address#'' = ''null'' then null else ''#address#'' end)
,(case when ''#gender#'' = ''null'' then null else ''#gender#'' end)
,(case when ''#case_number#'' = ''null'' then null else ''#case_number#'' end)
,#hasCough#
,#hasFever#
,#hasShortnessBreath#
,''#talukaLocationId#''
,#covid19_lab_test_recommendation_id#
,(select id from insert_lab_test)
,(select id from insert_daily_admission_det)
,(select id from health_infra_det)
,#ward_no#
,''#bed_no#''
,(select id from insert_daily_admission_det)
,''#admission_date#''
,#loggedIn_user#
,now()
,#isHIV#
,#isHeartPatient#
,#isDiabetes#
,''NEW''
,''SUSPECT''
,''#pinCode#''
,''#emergencyContactName#''
,''#emergencyContactNo#''
,#isImmunocompromized#
,#isHypertension#
,#isMalignancy#
,#isRenalCondition#
,#isCOPD#
,(case when ''#pregnancy_status#'' = ''null'' then null else ''#pregnancy_status#'' end)
,''#date_of_onset_symptom#''
,(case when ''#occupation#'' = ''null'' then null else ''#occupation#'' end)
,(case when ''#travelHistory#'' = ''null'' then null else ''#travelHistory#'' end)
,(case when ''#travelledPlace#'' = ''null'' then null else ''#travelledPlace#'' end)
,(case when ''#is_abroad_in_contact#'' = ''null'' then null else ''#is_abroad_in_contact#'' end)
,(case when ''#abroad_contact_details#'' = ''null'' then null else ''#abroad_contact_details#'' end)
)
RETURNING id;', true, 'ACTIVE', 'This query will insert new record into data base for new covid 19 patient Query must be corrected to map with UI 
JSON as input paramter', NULL);


delete from query_master where code = 'covid19_lab_test_pending_sample_result';

INSERT INTO query_master
(created_by, created_on, modified_by, modified_on, code, params, query, returns_result_set, state, description, is_public)
VALUES(60512, '2020-03-30 12:38:01.350', 409, '2020-04-01 03:10:34.356', 'covid19_lab_test_pending_sample_result', 'limit_offset,loggedInUserId', 'with idsp_screening as (
select
	clt.id as "id",
	ltd.id as lab_id,
	clt.location_id as loc_id,
	imt_member.id as member_id,
	case when clt.member_id is null 
		then concat_ws('' '',clt.first_name,clt.middle_name,clt.last_name)
		else concat(concat_ws('' '',imt_member.first_name,imt_member.middle_name,imt_member.last_name)
			, '' ('' , imt_member.unique_health_id , '')'' , ''<br>'' , imt_member.family_id) end as member_det,
	concat(case when clt.member_id is null 
		then cast(clt.age as text)
		else cast(EXTRACT(YEAR FROM age(imt_member.dob)) as text) end,'' Year'') as age,
	to_char(clt.admission_date,''DD/MM/YYYY'') as admission_date,
	hiwd.ward_name,
	sample_from."name" as sample_from_health_infra,
	sample_from.is_covid_lab,
	clt.current_ward_id as ward_id,
	cacd.on_ventilator as on_ventilator,
	cacd.ventilator_type1 as ventilator_type1,
	cacd.ventilator_type2 as ventilator_type2,
	cacd.on_o2 as on_o2,
	cacd.on_air as on_air,
	cacd.remarks as remarks,
	clt.is_hiv as hiv,
	clt.current_bed_no,
	cacd.health_status as health_status,
	cacd.service_date as last_check_up_time
	from covid19_lab_test_detail ltd 
	inner join covid19_admission_detail clt on ltd.covid_admission_detail_id = clt.id
	inner join health_infrastructure_ward_details hiwd on hiwd.id = clt.current_ward_id
	inner join covid19_admitted_case_daily_status cacd on cacd.id = clt.last_check_up_detail_id
	left join health_infrastructure_details sample_from on sample_from.id = ltd.sample_health_infra
	left join imt_member on clt.member_id = imt_member.id
	left join imt_family on imt_member.family_id = imt_family.family_id
	where
	ltd.sample_health_infra_send_to = (select uhi.health_infrastrucutre_id from user_health_infrastructure uhi where uhi.user_id = ''#loggedInUserId#'' and uhi.state = ''ACTIVE'')
	and clt.status not in (''DISCHARGED'',''DEAD'',''REFER'') and ltd.lab_collection_status = ''SAMPLE_ACCEPTED''
	order by cacd.service_date
	#limit_offset#
)
select 
id as "admissionId" 
,lab_id as "labCollectionId"
,member_id as "memberId"
,loc_id as "locationId"
,member_det as "memberDetail"
,age as "age"
,admission_date as "admissionDate"
,ward_name as "wardName"
,ward_id as "wardId"
,current_bed_no as "bedNumber"
,health_status as "healthStatus"
,to_char(last_check_up_time,''DD/MM/YYYY'') as "lastCheckUpTime"
,on_ventilator
,ventilator_type1
,ventilator_type2
,on_o2
,on_air
,remarks
,hiv
,sample_from_health_infra as "sampleFrom"
,is_covid_lab as "isSameHealthInfrastructure"
,cast(''CONFIRMATION'' as text) as "resultStage"
from idsp_screening', true, 'ACTIVE', NULL, NULL);

delete from query_master where code = 'covid19_get_suspected_admitted_patient_list';

INSERT INTO query_master
(created_by, created_on, modified_by, modified_on, code, params, query, returns_result_set, state, description, is_public)
VALUES(75398, '2020-03-31 15:56:47.411', 409, '2020-04-01 03:26:04.027', 'covid19_get_suspected_admitted_patient_list', 'limit_offset,loggedInUserId', 'with idsp_screening as (
select
	clt.id as "id",
	clt.location_id as loc_id,
	imt_member.id as member_id,
	case when clt.member_id is null 
		then concat_ws('' '',clt.first_name,clt.middle_name,clt.last_name)
		else concat(concat_ws('' '',imt_member.first_name,imt_member.middle_name,imt_member.last_name)
			, '' ('' , imt_member.unique_health_id , '')'' , ''<br>'' , imt_member.family_id) end as member_det,
	concat(case when clt.member_id is null 
		then clt.age
		else EXTRACT(YEAR FROM age(imt_member.dob)) end,'' Year'') as dob,
	to_char(clt.admission_date,''DD/MM/YYYY'') as admission_date,
	hiwd.ward_name,
	clt.current_ward_id as ward_id,
	cacd.on_ventilator as on_ventilator,
	cacd.ventilator_type1 as ventilator_type1,
	cacd.ventilator_type2 as ventilator_type2,
	cacd.on_o2 as on_o2,
	cacd.on_air as on_air,
	cacd.remarks as remarks,
	clt.current_bed_no,
	cltd.lab_collection_status as test_result,
	(case when cltd.lab_collection_status in (''COLLECTION_PENDING'',''SAMPLE_COLLECTED'',''SAMPLE_ACCEPTED'') then true else false end) as "isLabTestInProgress",
	cacd.health_status as health_status,
	cacd.service_date as last_check_up_time
	from covid19_admission_detail clt
	inner join health_infrastructure_ward_details hiwd on hiwd.id = clt.current_ward_id
	inner join covid19_admitted_case_daily_status cacd on cacd.id = clt.last_check_up_detail_id
	inner join covid19_lab_test_detail cltd on cltd.id = clt.last_lab_test_id
	left join imt_member on clt.member_id = imt_member.id
	left join imt_family on imt_member.family_id = imt_family.family_id
	where
	clt.health_infra_id = (select uhi.health_infrastrucutre_id from user_health_infrastructure uhi where uhi.user_id = ''#loggedInUserId#'' and uhi.state = ''ACTIVE'')
	and clt.status in (''SUSPECT'')
	order by cacd.service_date
	#limit_offset#
)
select 
id as "admissionId" 
,member_id as "memberId"
,loc_id as "locationId"
,member_det as "memberDetail"
,dob as "DOB"
,admission_date as "admissionDate"
,ward_name as "wardName"
,ward_id as "wardId"
,current_bed_no as "bedNumber"
,test_result as "testResult"
,health_status as "healthStatus"
,to_char(last_check_up_time,''DD/MM/YYYY'') as "lastCheckUpTime"
,on_ventilator
,ventilator_type1
,ventilator_type2
,on_o2
,on_air
,remarks
,"isLabTestInProgress"
from idsp_screening;', true, 'ACTIVE', NULL, NULL);

CREATE OR REPLACE FUNCTION public.get_location_hierarchy_from_district(location_id bigint)
  RETURNS text AS
$BODY$
	DECLARE 
	hierarchy text;
	
        BEGIN	
		return (select string_agg(l2.name,' > ' order by lhcd.depth desc) as location_id
				from location_master l1 
				inner join location_hierchy_closer_det lhcd on lhcd.child_id = l1.id
				inner join location_master l2 on l2.id = lhcd.parent_id
				where l1.id = location_id and lhcd.parent_loc_type not in ('S','R'));
		
        END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
  
  
delete from user_menu_item ufa where ufa.menu_config_id = (select id from menu_config where menu_name = 'COVID-19 Hospital Admission');

delete from menu_config where menu_name = 'COVID-19 Hospital Admission';

INSERT INTO menu_config
( feature_json, group_id, active, is_dynamic_report, menu_name, navigation_state, sub_group_id, menu_type, only_admin, menu_display_order)
VALUES('{"isShowReferredAdmissionTab":false,
"isShowSuspectAdmittedCasesTab":false,
"isShowConfirmedAdmittedCasesTab":false,
"isShowAdmitButton":false,
"isShowCheckUpButton":false,
"isShowDischargeButton":false,
"isShowNewAdmissionButton":false}', (select id from menu_group where group_name = 'COVID-19' and group_type = 'manage'), true, NULL, 'COVID-19 Hospital Admission', 'techo.manage.covidAdmission', NULL, 'manage', NULL, NULL);



delete from user_menu_item ufa where ufa.menu_config_id = (select id from menu_config where navigation_state = 'techo.manage.labtest');

delete from menu_config where navigation_state = 'techo.manage.labtest';

INSERT INTO menu_config
(feature_json, group_id, active, is_dynamic_report, menu_name, navigation_state, sub_group_id, menu_type, only_admin, menu_display_order)
VALUES('{"canSampleCollect" : false,
"canSampleReceive" : false,
"canSampleResult" : false}', (select id from menu_group where group_name = 'COVID-19' and group_type = 'manage'), true
, NULL, 'Lab', 'techo.manage.labtest', NULL, 'manage', false, NULL);
 

