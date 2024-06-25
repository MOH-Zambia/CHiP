DELETE FROM public.query_master
 WHERE code='retrieve_all_information_of_user';
insert into query_master(created_by,created_on,code,params,query,returns_result_set,state,description)
values(1,now(),'retrieve_all_information_of_user','username','select 
um.contact_number as mobilenumber, 
um.email_id as emailid, um.first_name || '' '' || um.middle_name || '' '' || um.last_name as fullname,
um.gender, to_char(um.date_of_birth, ''dd/mm/yyyy'') as dateofbirth, um.user_name as username, um.state, um.title, um.techo_phone_number as techophonenumber,
loc.level as locationlevel, loc.state as areaofinterventionstate, 
rol.name as rolename, rol.state as rolestate,
string_agg(lm.name,'> ' order by lhcd.depth desc) as locationname, locname.state as locationstate
from um_user um
inner join um_user_location loc on loc.user_id = um.id and loc.state = ''ACTIVE''
inner join location_hierchy_closer_det lhcd on loc.loc_id = lhcd.child_id
inner join location_master lm on lm.id = lhcd.parent_id
inner join um_role_master rol on um.role_id = rol.id
left join location_master locname on loc.loc_id = locname.id and locName.state = ''ACTIVE''
where um.user_name = ''#username#''
group by um.aadhar_number, um.contact_number, um.email_id, um.first_name, um.middle_name, um.last_name,
um.gender, um.date_of_birth, um.user_name, um.state, um.title, um.techo_phone_number,
loc.level, loc.state,rol.name, rol.state, locname.state , lhcd.child_id limit 1',true,'ACTIVE','Retrieve User Information using userName');


DELETE FROM public.query_master
 WHERE code='retrieve_user_login_details';
insert into query_master(created_by,created_on,code,params,query,returns_result_set,state,description)
values(1,now(),'retrieve_user_login_details','username','select loginfo.imei_number as imeinumber, loginfo.apk_version as apkversion, loginfo.logging_from_web as loggingfromweb, loginfo.no_of_attempts as noofattempts,
to_char(loginfo.created_on, ''hh12:mi:ss dd/mm/yyyy'') as logindet  from um_user_login_det loginfo
left join um_user um on um.id = loginfo.user_id 
where um.user_name = ''#username#'' 
group by loginfo.created_on,loginfo.imei_number,loginfo.apk_version,loginfo.logging_from_web,loginfo.no_of_attempts  
order by loginfo.created_on 
desc limit 5',true,'ACTIVE','Retrieve User Information using userName');