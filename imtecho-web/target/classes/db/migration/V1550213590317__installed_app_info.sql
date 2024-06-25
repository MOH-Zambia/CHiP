delete from query_master where code='installed_app_info';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'installed_app_info','user_name,imei','
select usr.user_name,appinfo.imei,string_agg(appinfo.application_name,'', '' order by installed_date desc) as installedapplist from user_installed_apps appinfo
inner join um_user usr on appinfo.user_id = usr.id 
	and usr.user_name = ''#user_name#'' 
	and case when #imei# is null then true else appinfo.imei = ''#imei#'' end
group by appinfo.imei,usr.user_name
',true,'ACTIVE');


insert into menu_config(active,menu_name,navigation_state,menu_type) values('TRUE','Mobile Management','techo.manage.mobilemangementinfo','manage');