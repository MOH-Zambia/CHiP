create table if not exists user_data_access_detail_request
(
	id bigserial not null,
	user_id bigint,
	created_on timestamp without time zone,
	apk_version integer,
	CONSTRAINT user_data_access_detail_request_pk PRIMARY KEY (id)
);

insert into query_master(created_by, created_on, modified_by, modified_on, code, params, query,returns_result_set,state)
values (1027,localtimestamp,null,null,'user_access_detail_access_mob_entry','userId,apkVersion',
'insert into user_data_access_detail_request 
(user_id,created_on,apk_version)
select #userId#,localtimestamp,#apkVersion#',
false,'ACTIVE');