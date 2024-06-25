delete from query_master where code='version_based_app_install_counts';

insert into query_master(created_by,created_on,code,query,returns_result_set,state)
values(1,current_date,'version_based_app_install_counts','
select mp.text_version,count(distinct user_id) from  
(select user_id,max(apk_version) as version from um_user_login_det where apk_version is not null group by user_id)
as t1,um_user u,mobile_version_mapping mp where mp.apk_version = t1.version and u.id = t1.user_id and u.state = ''ACTIVE'' group by text_version order by text_version desc limit 5
',true,'ACTIVE');