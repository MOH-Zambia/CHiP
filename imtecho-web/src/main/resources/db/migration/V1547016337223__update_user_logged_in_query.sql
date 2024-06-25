DELETE FROM public.query_master
 WHERE code='retrieve_user_login_details';
insert into query_master(created_by,created_on,code,params,query,returns_result_set,state,description)
values(1,now(),'retrieve_user_login_details','username','select loginfo.imei_number as imeinumber, loginfo.apk_version as apkversion, loginfo.logging_from_web as loggingfromweb, loginfo.no_of_attempts as noofattempts,
to_char(loginfo.created_on, ''dd/mm/yyyy hh12:mi:ss'') as logindet  from um_user_login_det loginfo
left join um_user um on um.id = loginfo.user_id 
where um.user_name = ''#username#'' 
group by loginfo.created_on,loginfo.imei_number,loginfo.apk_version,loginfo.logging_from_web,loginfo.no_of_attempts  
order by loginfo.created_on 
desc limit 5',true,'ACTIVE','Retrieve User Information using userName');