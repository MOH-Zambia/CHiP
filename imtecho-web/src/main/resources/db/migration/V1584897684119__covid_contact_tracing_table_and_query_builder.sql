/*ALTER TABLE covid_travellers_info 
drop column if exists is_cough,
drop column if exists is_fever,
drop column if exists is_respiratory_issue,
drop column if exists other_symptoms,
drop column if exists travel_date,
drop column if exists is_travel_from_other_country;

ALTER TABLE covid_travellers_info 
ADD column is_cough boolean,
ADD column is_fever boolean,
ADD column is_respiratory_issue boolean,
ADD column other_symptoms text,
ADD column travel_date text,
ADD column is_travel_from_other_country text;

alter table idsp_member_screening_details
drop column if exists gender,
drop column if exists age;

alter table idsp_member_screening_details
add column gender text,
add column age smallint;
*/


DROP TABLE if exists public.covid_case_travel_history;

CREATE TABLE public.covid_case_travel_history
(
  id serial,
  cases_id integer,
  contact_person_id integer,
  place_of_origin text,
  destination text,
  mode_of_transport text,
  flight_no text,
  flight_seat_no text,
  train_no text,
  train_seat_no text,
  bus_detail text,
  travel_agency_detail text,
  purpose_of_travel text,
  treavel_date date,
  other_detail text,
  created_by integer,
  created_on timestamp without time zone,
  modified_by integer,
  modified_on timestamp without time zone,
  CONSTRAINT covid_case_travel_history_pkey PRIMARY KEY (id)
);


DROP TABLE if exists public.covid_case_contact_history;

CREATE TABLE public.covid_case_contact_history
(
  id serial primary key ,
  cases_id integer,
  member_id integer,
  travel_history_id integer,
  contact_date date,
  person_name text,
  gender text,
  contact_no text,
  address text,
  other_detail text,
  age integer,
  location_id integer,
  level0_contact_id integer,
  level1_contact_id integer,
  level integer,
  state character varying(250),
  health_state character varying(250),
  parent_id integer,
  test_result text,
  created_by integer,
  created_on timestamp without time zone,
  modified_by integer,
  modified_on timestamp without time zone
);


delete from query_master where code = 'covid19_contact_tracing_insert_beneficary_data';
INSERT INTO query_master
(id, created_by, created_on, modified_by, modified_on, code, params, query, returns_result_set, state, description, is_public)
VALUES(1539, 409, '2020-03-22 11:53:43.102', 409, '2020-03-22 18:28:45.335', 'covid19_contact_tracing_insert_beneficary_data', 'modified_on,address,gender,created_on,contact_no,name,modified_by,location,state,created_by,age', 'insert into covid_case_contact_history(person_name,age,gender,contact_no,address,health_state,state, location_id,created_by, created_on, modified_on, modified_by,level)
values(
''#name#'', ''#age#'',
''#gender#'', ''#contact_no#'', ''#address#'',  ''#state#'',''PENDING'', #location#,
''#created_by#'',''#created_on#'', ''#modified_on#'', ''#modified_by#'',0
)
returning id;', true, 'ACTIVE', NULL, NULL);


delete from query_master where code = 'covid19_contatct_tracing_update_beneficary_detail';
INSERT INTO query_master
(id, created_by, created_on, modified_by, modified_on, code, params, query, returns_result_set, state, description, is_public)
VALUES(1540, 409, '2020-03-22 11:57:44.249', 409, '2020-03-22 18:32:44.796', 'covid19_contatct_tracing_update_beneficary_detail', 'address,gender,contact_no,name,modified_by,location,state,id,age', 'update covid_case_contact_history
set person_name =''#name#'' ,
age =''#age#'' ,
gender =''#gender#'' ,
contact_no =''#contact_no#'' ,
address =''#address#'' ,
health_state = ''#state#'',
location_id=''#location#'',
modified_on = now() ,
modified_by =  ''#modified_by#''
where id = ''#id#'';', false, 'ACTIVE', NULL, NULL);



delete from query_master where code = 'covid19_get_pending_contact_tracing_detail';
INSERT INTO query_master
(id, created_by, created_on, modified_by, modified_on, code, params, query, returns_result_set, state, description, is_public)
VALUES(1541, 409, '2020-03-22 12:09:29.659', 409, '2020-03-22 21:53:56.843', 'covid19_get_pending_contact_tracing_detail', 'loggedInUserId', 'select cch.id,cch.person_name as name,cch.age,cch.gender,cch.contact_no,cch.address,cch.health_state as state,cch.level
,cch.location_id as "locationId",get_location_hierarchy(cch.location_id) as "location"
from covid_case_contact_history cch,location_hierchy_closer_det llh
where state = ''PENDING'' 
and cch.location_id = llh.child_id 
and llh.parent_id in (select loc_id from um_user_location where user_id = #loggedInUserId# and state = ''ACTIVE'')
order by state desc,level', true, 'ACTIVE', NULL, NULL);


delete from query_master where code = 'covid19_get_beneficary_detail_by_id';
INSERT INTO query_master
(id, created_by, created_on, modified_by, modified_on, code, params, query, returns_result_set, state, description, is_public)
VALUES(1542, 409, '2020-03-22 12:11:59.970', 74909, '2020-03-22 21:30:24.221', 'covid19_get_beneficary_detail_by_id', 'id', 'with travel_history as(
select 
json_agg(json_build_object(''id'',cct.id
,''travelDate'',to_char(cct.treavel_date,''DD/MM/YYYY'')
,''placeOfOrigin'',cct.place_of_origin
,''destination'',cct.destination
,''modeOfTransport'',cct.mode_of_transport
,''flightNo'',cct.flight_no
,''flightSeatNo'',cct.flight_seat_no
,''otherTransportDetails'',cct.other_detail
,''purposeOfTravel'',cct.purpose_of_travel
,''trainNo'',cct.train_no
,''trainSeatNo'',cct.train_seat_no
,''busDetail'',cct.bus_detail
,''travelAgencyDetail'',cct.travel_agency_detail
)) as travel_history 
from covid_case_travel_history cct
where cct.contact_person_id = ''#id#''
),contact_person as (
select
json_agg(json_build_object(''id'',ccch.id
,''contactDate'',to_char(ccch.contact_date,''DD/MM/YYYY'')
,''name'',ccch.person_name
,''otherDetails'',ccch.other_detail
,''address'',ccch.address
,''contactNo'',ccch.contact_no
,''location'',(select name from location_master where id = ccch.location_id)
)) as contact_person 
from covid_case_contact_history ccch
where ccch.parent_id = ''#id#''
)
select cch.id,cch.person_name as name,cch.age,cch.gender,cch.contact_no,cch.address,cch.health_state as state,cch.parent_id,cch.level
,cch.location_id as "locationId",get_location_hierarchy(cch.location_id) as "location"
,(select cast(travel_history as text) from travel_history) as travel_history
,(select cast(contact_person as text) from contact_person) as contact_person
from covid_case_contact_history cch
where cch.id=''#id#'';', true, 'ACTIVE', NULL, NULL);


delete from query_master where code = 'delete_contact_history_by_id';
INSERT INTO query_master
(id, created_by, created_on, modified_by, modified_on, code, params, query, returns_result_set, state, description, is_public)
VALUES(1574, 74909, '2020-03-22 21:47:49.883', 74909, '2020-03-22 21:50:53.876', 'delete_contact_history_by_id', 'contactId', 'delete from covid_case_contact_history where id = #contactId#', false, 'ACTIVE', NULL, NULL);


delete from query_master where code = 'delete_travel_history_by_id';
INSERT INTO query_master
(id, created_by, created_on, modified_by, modified_on, code, params, query, returns_result_set, state, description, is_public)
VALUES(1573, 74909, '2020-03-22 21:47:14.684', 74909, '2020-03-22 21:50:34.893', 'delete_travel_history_by_id', 'travelId', 'delete from covid_case_travel_history where id = #travelId#', false, 'ACTIVE', NULL, NULL);



delete from query_master where code = 'covid19_insert_contact_tracing_detail';
INSERT INTO query_master
(id, created_by, created_on, modified_by, modified_on, code, params, query, returns_result_set, state, description, is_public)
VALUES(1544, 409, '2020-03-22 13:03:21.345', 409, '2020-03-22 21:25:19.115', 'covid19_insert_contact_tracing_detail', 'address,level,contact_no,name,modified_by,contact_date,location,contact_id,other_detail,created_by', 'insert into covid_case_contact_history(person_name,contact_no,address,other_detail,health_state,state,location_id,created_by, created_on, modified_on, modified_by,parent_id,
level,contact_date)
values(
(case when ''#name#'' = ''null'' then null else ''#name#'' end)
,(case when ''#contact_no#'' = ''null'' then null else ''#contact_no#'' end)
,(case when ''#address#'' = ''null'' then null else ''#address#'' end)
,(case when ''#other_detail#'' = ''null'' then null else ''#other_detail#'' end)
,''Suspected''
,''PENDING''
,(case when ''#location#'' = ''null'' then null else #location# end)
,''#created_by#''
, now()
, now()
, ''#modified_by#''
,(case when ''#contact_id#'' = ''null'' then null else #contact_id# end)
,#level# + 1
,''#contact_date#''
)
returning id;', true, 'ACTIVE', NULL, NULL);

delete from query_master where code = 'covid19_save_travel_history';
INSERT INTO query_master
(id, created_by, created_on, modified_by, modified_on, code, params, query, returns_result_set, state, description, is_public)
VALUES(1543, 409, '2020-03-22 12:42:18.290', 74909, '2020-03-22 18:53:36.987', 'covid19_save_travel_history', 'address,destination,train_seat_no,contact_person_id,flight_seat_no,purpose_of_travel,created_by,place_of_origin,mode_of_transport,flight_no,bus_detail,train_no,modified_by,treavel_date,travel_agency_detail,other_detail', 'INSERT INTO covid_case_travel_history
(contact_person_id, place_of_origin, destination, mode_of_transport, flight_no, flight_seat_no, train_no, train_seat_no, bus_detail, travel_agency_detail, purpose_of_travel, treavel_date, other_detail, created_by, created_on, modified_by, modified_on)
VALUES(#contact_person_id#
,(case when ''#place_of_origin#'' = ''null'' then null else ''#address#'' end)
,(case when ''#destination#'' = ''null'' then null else ''#destination#'' end)
,(case when ''#mode_of_transport#'' = ''null'' then null else ''#mode_of_transport#'' end)
,(case when ''#flight_no#'' = ''null'' then null else ''#flight_no#'' end)
,(case when ''#flight_seat_no#'' = ''null'' then null else ''#flight_seat_no#'' end)
,(case when ''#train_no#'' = ''null'' then null else ''#train_no#'' end)
,(case when ''#train_seat_no#'' = ''null'' then null else ''#train_seat_no#'' end)
,(case when ''#bus_detail#'' = ''null'' then null else ''#bus_detail#'' end)
,(case when ''#travel_agency_detail#'' = ''null'' then null else ''#travel_agency_detail#'' end)
,(case when ''#purpose_of_travel#'' = ''null'' then null else ''#purpose_of_travel#'' end)
,''#treavel_date#''
,(case when ''#other_detail#'' = ''null'' then null else ''#other_detail#'' end)
,(case when ''#created_by#'' = ''null'' then null else #created_by# end)
, now()
,(case when ''#modified_by#'' = ''null'' then null else #modified_by# end)
,now()
)
returning id;', true, 'ACTIVE', NULL, NULL);


delete from query_master where code = 'retrieve_locations_by_type';
INSERT INTO query_master
(id, created_by, created_on, modified_by, modified_on, code, params, query, returns_result_set, state, description, is_public)
VALUES(1546, 74909, '2020-03-22 18:01:59.575', 409, '2020-03-22 23:43:54.099', 'retrieve_locations_by_type', NULL, 'select * from location_master where type in (''D'',''C'') order by name', true, 'ACTIVE', NULL, NULL);
/*
delete from user_menu_item where menu_config_id = (select id from menu_config where menu_name = 'COVID-19 Contact Tracing');

delete from menu_config where menu_name = 'COVID-19 Contact Tracing';


INSERT INTO menu_config
(feature_json, group_id, active, is_dynamic_report, menu_name, navigation_state, sub_group_id, menu_type, only_admin, menu_display_order)
VALUES(NULL, (select id from menu_group where group_name = 'COVID-19'), true, NULL, 'COVID-19 Contact Tracing', 'techo.manage.covidcases', NULL, 'manage', NULL, NULL);
*/