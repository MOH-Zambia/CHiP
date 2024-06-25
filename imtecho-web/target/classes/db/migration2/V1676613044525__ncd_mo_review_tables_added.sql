drop table if exists ncd_mo_review_detail;
create table if not exists ncd_mo_review_detail(
	id serial PRIMARY KEY,
    member_id integer,
    created_by integer,
    created_on timestamp without time zone,
    modified_by integer,
    modified_on timestamp without time zone,
	screening_date timestamp without time zone,
	location_id integer,
	health_infra_id integer,
	does_required_ref boolean,
	refferral_reason character varying(100),
	followup_date timestamp without time zone,
	refferral_place character varying(50),
	followup_place character varying(50),
	comment text,
	is_followup boolean,
	diseases character varying(50)
);

alter table if exists ncd_member_followup_detail
add column if not exists created_from character varying(50);

drop table if exists ncd_mo_review_followup_detail;
create table if not exists ncd_mo_review_followup_detail(
	id serial PRIMARY KEY,
    member_id integer,
    created_by integer,
    created_on timestamp without time zone,
    modified_by integer,
    modified_on timestamp without time zone,
	screening_date timestamp without time zone,
	location_id integer,
	health_infra_id integer,
	does_required_ref boolean,
	refferral_reason character varying(100),
	followup_date timestamp without time zone,
	refferral_place character varying(50),
	followup_place character varying(50),
	comment text,
	is_remove boolean,
	diseases character varying(50)
);

INSERT INTO menu_config (menu_name, menu_type, active, navigation_state,feature_json) values
('MO Review Screen','ncd',TRUE,'techo.ncd.moreview','{}');

INSERT INTO menu_config (menu_name, menu_type, active, navigation_state,feature_json) values
('MO Review followup Screen','ncd',TRUE,'techo.ncd.moreviewfollowup','{}');