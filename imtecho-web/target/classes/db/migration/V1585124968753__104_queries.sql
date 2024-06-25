delete from query_master where code='retrieve_all_gvk_covid_104_calls_response';
delete from query_master where code='retrieve_locations_by_type';
delete from query_master where code='retrieve_gvk_covid_104_calls_response_by_id';
delete from query_master where code='retrieve_gvk_covid_104_calls_contact_response_by_id';
delete from query_master where code='update_gvk_covid_104_calls_response';
delete from query_master where code='insert_gvk_covid_104_calls_contact_response';
delete from query_master where code='insert_gvk_covid_104_calls_response';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'retrieve_all_gvk_covid_104_calls_response','limit,offSet','
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
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'retrieve_locations_by_type','type','
select * from location_master where type in (#type#) order by name
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'retrieve_gvk_covid_104_calls_response_by_id','id','
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
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'retrieve_gvk_covid_104_calls_contact_response_by_id','id','
select person_name as "name",
contact_no as "contactNo",
district as "districtLocationId",
other_detail as "otherDetail"
from gvk_covid_104_calls_contact_response
where gvk_response_id = #id#
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'update_gvk_covid_104_calls_response','dateOfCalling,personName,age,gender,contactNo,address,pinCode,
district,block,village,isInformationCall,hasFever,feverDays,havingCough,coughDays,hasShortnessOfBreath,travelAbroad,
country,arrivalDate,inTouchWithAnyone,modifiedBy,id','
update gvk_covid_104_calls_response
set date_of_calling = ''#dateOfCalling#'',
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
arrival_date = ''#arrivalDate#'',
in_touch_with_anyone_travelled_recently = #inTouchWithAnyone#,
modified_by = #modifiedBy#,
modified_on = now()
where id = #id#;
delete from gvk_covid_104_calls_contact_response where gvk_response_id = #id#;
',false,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'insert_gvk_covid_104_calls_contact_response','gvkId,personName,contactNo,district,otherDetails','
insert into gvk_covid_104_calls_contact_response
(gvk_response_id,person_name,contact_no,district,other_detail)
values(#gvkId#,
case when ''#personName#'' = ''null'' then null else ''#personName#'' end,
case when ''#contactNo#'' = ''null'' then null else ''#contactNo#'' end,
#district#,
case when ''#otherDetails#'' = ''null'' then null else ''#otherDetails#'' end);
',false,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'insert_gvk_covid_104_calls_response','dateOfCalling,personName,age,gender,contactNo,address,pinCode,
district,block,village,isInformationCall,hasFever,feverDays,havingCough,coughDays,hasShortnessOfBreath,travelAbroad,
country,arrivalDate,inTouchWithAnyone,modifiedBy,createdBy','
insert into gvk_covid_104_calls_response
(date_of_calling,person_name,age,gender,contact_no,address,pin_code,district,block,village,
is_information_call,has_fever,fever_days,having_cough,cough_days,has_shortness_of_breath,has_travel_abroad_in_15_days,
country,arrival_date,in_touch_with_anyone_travelled_recently,created_by,created_on,modified_by,modified_on)
values(''#dateOfCalling#'',''#personName#'',#age#,''#gender#'',''#contactNo#'',''#address#'',#pinCode#,#district#,#block#,#village#,
#isInformationCall#,#hasFever#,#feverDays#,#havingCough#,#coughDays#,#hasShortnessOfBreath#,#travelAbroad#,
#country#,''#arrivalDate#'',#inTouchWithAnyone#,#createdBy#,now(),#modifiedBy#,now())
returning id;
',true,'ACTIVE');