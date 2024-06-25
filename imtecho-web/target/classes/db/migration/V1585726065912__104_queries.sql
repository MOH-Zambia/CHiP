delete from QUERY_MASTER where CODE='retrieve_all_gvk_covid_104_calls_response';

insert into public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
1,  current_date , 1,  current_date , 'retrieve_all_gvk_covid_104_calls_response',
'limit,offSet',
'
select id as "id",
date_of_calling as "dateOfCalling",
person_name as "name",
age as "age",
gender as "gender",
contact_no as "mobileNumber",
address as "address",
get_location_hierarchy(village) as "locationHierarchy"
from gvk_covid_104_calls_response
limit #limit# offset #offSet#
',
null,
true, 'ACTIVE');

delete from QUERY_MASTER where CODE='retrieve_gvk_covid_104_calls_response_by_id';

insert into public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
1,  current_date , 1,  current_date , 'retrieve_gvk_covid_104_calls_response_by_id',
'id',
'
select id as "id",
date_of_calling as "dateOfCalling",
person_name as "name",
age as "age",
gender as "gender",
contact_no as "contact_no",
address as "address",
pin_code as "pinCode",
get_location_hierarchy(village) as "locationHierarchy",
district as "district_locationId",
block as "taluka_locationId",
village as "locationId",
is_information_call as "isInformationCall",
has_fever as "isHavingFever",
fever_days as "feverDays",
having_cough as "isHavingCough",
cough_days as "coughDays",
has_shortness_of_breath as "isHavingShortnessBreath",
has_travel_abroad_in_15_days as "isTravelAbroad",
country as "contactCountry",
arrival_date as "dateOfArrival",
in_touch_with_anyone_travelled_recently as "isInTouchWithRecentTraveller"
from gvk_covid_104_calls_response
where id = #id#
',
null,
true, 'ACTIVE');

delete from QUERY_MASTER where CODE='retrieve_gvk_covid_104_calls_contact_response_by_id';

insert into public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
1,  current_date , 1,  current_date , 'retrieve_gvk_covid_104_calls_contact_response_by_id',
'id',
'
select person_name as "name",
contact_no as "contactNo",
district as "districtLocationId",
location_master.name as "districtName",
other_detail as "otherDetail"
from gvk_covid_104_calls_contact_response
left join location_master on gvk_covid_104_calls_contact_response.district = location_master.id
where gvk_response_id = #id#
',
null,
true, 'ACTIVE');

delete from QUERY_MASTER where CODE='insert_gvk_covid_104_calls_response';

insert into public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
1,  current_date , 1,  current_date , 'insert_gvk_covid_104_calls_response',
'feverDays,country,address,dateOfCalling,gender,isInformationCall,travelAbroad,coughDays,arrivalDate,personName,inTouchWithAnyone,hasFever,createdBy,pinCode,district,block,modifiedBy,hasShortnessOfBreath,village,havingCough,age,contactNo',
'insert into gvk_covid_104_calls_response
(date_of_calling,person_name,age,gender,contact_no,address,pin_code,district,block,village,
is_information_call,has_fever,fever_days,having_cough,cough_days,has_shortness_of_breath,has_travel_abroad_in_15_days,
country,arrival_date,in_touch_with_anyone_travelled_recently,created_by,created_on,modified_by,modified_on)
values(to_timestamp(''#dateOfCalling#'',''DD/MM/YYYY HH:MI:SS''),''#personName#'',#age#,''#gender#'',''#contactNo#'',''#address#'',#pinCode#,#district#,#block#,#village#,
#isInformationCall#,#hasFever#,#feverDays#,#havingCough#,#coughDays#,#hasShortnessOfBreath#,#travelAbroad#,
#country#,case when ''#arrivalDate#'' = ''null'' then null else to_timestamp(''#arrivalDate#'',''DD/MM/YYYY HH:MI:SS'') end,#inTouchWithAnyone#,#createdBy#,now(),#modifiedBy#,now())
returning id;',
null,
true, 'ACTIVE');

delete from QUERY_MASTER where CODE='insert_gvk_covid_104_calls_contact_response';

insert into public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
1,  current_date , 1,  current_date , 'insert_gvk_covid_104_calls_contact_response',
'gvkId,personName,contactNo,district,otherDetails',
'
insert into gvk_covid_104_calls_contact_response
(gvk_response_id,person_name,contact_no,district,other_detail)
values(#gvkId#,
case when ''#personName#'' = ''null'' then null else ''#personName#'' end,
case when ''#contactNo#'' = ''null'' then null else ''#contactNo#'' end,
#district#,
case when ''#otherDetails#'' = ''null'' then null else ''#otherDetails#'' end);
',
null,
false, 'ACTIVE');

delete from QUERY_MASTER where CODE='update_gvk_covid_104_calls_response';

insert into public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
1,  current_date , 1,  current_date , 'update_gvk_covid_104_calls_response',
'feverDays,country,address,dateOfCalling,gender,isInformationCall,travelAbroad,coughDays,arrivalDate,personName,inTouchWithAnyone,hasFever,pinCode,district,block,modifiedBy,hasShortnessOfBreath,id,village,havingCough,age,contactNo',
'update gvk_covid_104_calls_response
set date_of_calling = to_timestamp(''#dateOfCalling#'',''DD/MM/YYYY HH:MI:SS''),
person_name = ''#personName#'',
age = #age#,
gender = ''#gender#'',
contact_no = ''#contactNo#'',
address = ''#address#'',
pin_code = #pinCode#,
district = #district#,
block = #block#,
village = #village#,
is_information_call = #isInformationCall#,
has_fever = #hasFever#,
fever_days = #feverDays#,
having_cough = #havingCough#,
cough_days = #coughDays#,
has_shortness_of_breath = #hasShortnessOfBreath#,
has_travel_abroad_in_15_days = #travelAbroad#,
country = #country#,
arrival_date = case when ''#arrivalDate#'' = ''null'' then null else to_timestamp(''#arrivalDate#'',''DD/MM/YYYY HH:MI:SS'') end,
in_touch_with_anyone_travelled_recently = #inTouchWithAnyone#,
modified_by = #modifiedBy#,
modified_on = now()
where id = #id#;
delete from gvk_covid_104_calls_contact_response where gvk_response_id = #id#;',
null,
false, 'ACTIVE');