create table if not exists user_wise_feature_time_taken_detail_analytics (
user_id int,
role_id int,
page_title_id int,
avg_active_time NUMERIC,
max_active_time int,
no_of_times int,
on_date date,
primary key(user_id,role_id,page_title_id,on_date)
);


insert into system_configuration (system_key,is_active,key_value) values ('LAST_EXECUTION_DATE_USER_WISE_FEATURE_TIME_TAKEN_DETAIL_ANALYTICS',true,now() - interval '2 years')
	ON CONFLICT ON CONSTRAINT system_configuration_pkey DO nothing;





