DELETE FROM public.query_master
 WHERE code='retrieve_all_information_of_user';
insert into query_master(created_by,created_on,code,params,query,returns_result_set,state,description)
values(1,now(),'retrieve_all_information_of_user','username','select 
um.contact_number as mobilenumber, 
um.email_id as emailid, um.first_name || '' '' || um.middle_name || '' '' || um.last_name as fullname,
um.gender, to_char(um.date_of_birth, ''dd/mm/yyyy'') as dateofbirth, um.user_name as username, um.state, um.title, um.techo_phone_number as techophonenumber,
log_det.imei_number as imeinumber, log_det.apk_version as apkversion, log_det.logging_from_web as loggingfromweb, log_det.no_of_attempts as noofattempts,
loc.level as locationlevel, loc.state as areaofinterventionstate, 
rol.name as rolename, rol.state as rolestate,
string_agg(locName.name , '','') as locationname, locName.state as locationstate
from um_user um
left join um_user_login_det as log_det on log_det.user_id = um.id 
inner join um_user_location loc on loc.user_id = um.id
inner join um_role_master rol on um.role_id = rol.id
left join location_master locname on loc.loc_id = locname.id and locName.state = ''ACTIVE''
where um.user_name = ''#username#'' 
group by um.aadhar_number, um.contact_number, um.email_id, um.first_name, um.middle_name, um.last_name,
um.gender, um.date_of_birth, um.user_name, um.state, um.title, um.techo_phone_number,log_det.imei_number,log_det.apk_version,
log_det.logging_from_web,log_det.no_of_attempts,loc.level, loc.state,rol.name, rol.state, locName.state',true,'ACTIVE','Retrieve User Information using userName');

DELETE FROM public.query_master
 WHERE code='retrieve_family_and_member_info';
insert into query_master(created_by,created_on,code,params,query,returns_result_set,state,description)
values(1,now(),'retrieve_family_and_member_info','familyid','select f.address1 as address1, f.address2 as address2, f.bpl_flag as bplflag, f.house_number as housenumber, f.is_verified_flag as verifiedflag,
f.migratory_flag as migratoryflag, f.toilet_available_flag as toiletavailableflag, f.vulnerable_flag as vulnerableflag, f.basic_state as familybasicstate,
f.emamta_location_id as emamtalocationid, f.location_id as locationid,
m.id as memberid, m.unique_health_id as uniquehealthid, m.first_name || '' '' || m.middle_name || '' '' || m.last_name as membername,
m.family_head as familyhead, m.is_pregnant as ispregnant, m.gender as gender, m.mobile_number as mobilenumber, m.basic_state as memberbasicstate
from imt_family  f
inner join imt_member m on f.family_id = m.family_id where f.family_id = ''#familyid#''',true,'ACTIVE','Retrieve family and members basic info using familyId');
