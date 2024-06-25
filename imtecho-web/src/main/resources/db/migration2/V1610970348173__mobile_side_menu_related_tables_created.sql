drop table if exists mobile_feature_master;
drop table if exists mobile_menu_role_relation;
drop table if exists mobile_menu_master;

create table mobile_feature_master (
	mobile_constant text primary key,
	feature_name text,
	mobile_display_name text,
	state text,
	created_on timestamp without time zone,
	created_by integer,
	modified_on timestamp without time zone,
	modified_by integer
);

create table mobile_menu_master (
	id serial primary key,
	config_json text,
	menu_name text,
	created_on timestamp without time zone,
	created_by integer,
	modified_on timestamp without time zone,
	modified_by integer
);

create table mobile_menu_role_relation (
	menu_id integer,
	role_id integer primary key
);


insert into mobile_feature_master (mobile_constant, feature_name, mobile_display_name, state, created_on, created_by, modified_on, modified_by)
values
('FHW_CFHC', 'FHW CFHC', 'CFHC', 'ACTIVE', now(), -1, now(), -1),
('FHW_SURVEILLANCE', 'FHW Surveillance', 'Surveillance', 'ACTIVE', now(), -1, now(), -1),
('FHW_MY_PEOPLE', 'FHW My People', 'My People', 'ACTIVE', now(), -1, now(), -1),
('FHW_NOTIFICATION', 'FHW Your Schedule', 'Your Schedule', 'ACTIVE', now(), -1, now(), -1),
('FHW_ASSIGN_FAMILY', 'Assign Family', 'Assign Family', 'ACTIVE', now(), -1, now(), -1),
('FHW_MOBILE_VERIFICATION', 'Mobile Verification', 'Mobile Verification', 'ACTIVE', now(), -1, now(), -1),
('FHW_NCD_SCREENING', 'FHW NCD Screening', 'NCD Screening', 'ACTIVE', now(), -1, now(), -1),
('FHW_NCD_REGISTER', 'FHW NCD Register', 'NCD Register', 'ACTIVE', now(), -1, now(), -1),
('FHW_WORK_REGISTER', 'FHW Work Register', 'Work Register', 'ACTIVE', now(), -1, now(), -1),
('FHW_WORK_STATUS', 'Work Status', 'Work Status', 'ACTIVE', now(), -1, now(), -1),
('FHW_DATA_QUALITY', 'Data Quality', 'Data Quality', 'ACTIVE', now(), -1, now(), -1),
('FHW_HIGH_RISK_WOMEN_AND_CHILD', 'FHW High Risk Mother and Child', 'High Risk Mother and Child', 'ACTIVE', now(), -1, now(), -1),
('LIBRARY', 'Library', 'Library', 'ACTIVE', now(), -1, now(), -1),
('ANNOUNCEMENTS', 'Announcements', 'Announcements', 'ACTIVE', now(), -1, now(), -1),
('WORK_LOG', 'Work Log', 'Work Log', 'ACTIVE', now(), -1, now(), -1);


with datas as (
	insert into mobile_menu_master (menu_name, config_json, created_on, created_by, modified_on, modified_by)
	values ('FHW Menu', '[{"mobile_constant":"FHW_CFHC","order":1},{"mobile_constant":"FHW_DATA_QUALITY","order":2},{"mobile_constant":"FHW_SURVEILLANCE","order":3},{"mobile_constant":"FHW_ASSIGN_FAMILY","order":4},{"mobile_constant":"FHW_MY_PEOPLE","order":5},{"mobile_constant":"FHW_MOBILE_VERIFICATION","order":6},{"mobile_constant":"FHW_NOTIFICATION","order":7},{"mobile_constant":"FHW_HIGH_RISK_WOMEN_AND_CHILD","order":8},{"mobile_constant":"FHW_NCD_SCREENING","order":9},{"mobile_constant":"FHW_NCD_REGISTER","order":10},{"mobile_constant":"LIBRARY","order":11},{"mobile_constant":"ANNOUNCEMENTS","order":12},{"mobile_constant":"FHW_WORK_REGISTER","order":13},{"mobile_constant":"FHW_WORK_STATUS","order":14}]',
	now(), -1, now(), -1)
	returning id
)
insert into mobile_menu_role_relation (menu_id, role_id)
select id, (select id from um_role_master urm where name = 'FHW') from datas;