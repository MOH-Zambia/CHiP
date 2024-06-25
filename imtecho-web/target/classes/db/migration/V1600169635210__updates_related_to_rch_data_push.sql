
drop table if exists anmol_lmp_follow_up_details;

create table anmol_lmp_follow_up_details (
	id serial,
	member_id integer,
	location_id integer,
	lmp_date date,
	family_planning_method text,
	pregnancy_reg_det_id integer,
	anmol_registration_id text,
	anmol_follow_up_status text,
	anmol_follow_up_wsdl_code character varying (50),
	anmol_follow_up_date timestamp without time zone,
	anmol_upload_status_code timestamp without time zone,
	anmol_case_no integer,
	eligible_registration_id character varying (255),
	service_date date,
	is_pregnant boolean not null,
	pregnancy_test_done boolean not null
);

drop table if exists anmol_eligible_couple_tracking_new;

CREATE TABLE anmol_eligible_couple_tracking_new
(
  serial_id serial primary key,
  member_id integer,
  registration_no character varying(255),
  mobile_id character varying(255),
  id integer,
  rural_urban text,
  pregnant text,
  method text,
  other character varying,
  pregnant_test text,
  visitdate text,
  created_on text,
  created_date timestamp without time zone,
  state_code integer,
  district_code character varying(255),
  taluka_code character varying(255),
  village_code character varying(255),
  healthfacility_code integer,
  healthsubfacility_code integer,
  healthblock_code integer,
  healthfacility_type integer,
  asha_id integer,
  anm_id integer,
  created_by integer,
  whose_mobile text,
  case_no integer,
  rchlmpfollowupid integer unique,
  visit_no integer,
  is_upload boolean DEFAULT false
);

/*

drop table if exists zzz_anmol_lmp_follow_up_details_16_09_2020;

 create table zzz_anmol_lmp_follow_up_details_16_09_2020(
	id serial,
	eligible_registration_id text,
	case_no integer,
	reg_date timestamp without time zone,
	lmp_date timestamp without time zone,
	pregnancy_reg_det_id integer
 );

with reg_details as (
select distinct registration_no,case_no from zzz_anmol_lmp_vs_visit_date_reg_date_gj_states_report_query_1 query_1
union all
select distinct registration_no,case_no  from zzz_anmol_lmp_vs_visit_date_reg_date_gj_states_report_query_2 query_2
)
insert into zzz_anmol_lmp_follow_up_details_16_09_2020 (eligible_registration_id,case_no,reg_date,lmp_date,pregnancy_reg_det_id)
select am.eligible_registration_id,
am.case_no
,rprd.reg_date ,
rprd.lmp_date,
rprd.id
from anmol_master am
inner join reg_details reg on am.eligible_registration_id  = reg.registration_no
inner join rch_pregnancy_registration_det rprd on rprd.id  = am.pregnancy_reg_det_id
where cast(am.case_no as text)  = reg.case_no and
 cast(rprd.reg_date as date) - cast(rprd.lmp_date as date)  between 35 and 322;

*/