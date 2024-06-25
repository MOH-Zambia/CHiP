delete from listvalue_field_value_detail where field_key = 'SERVER_LIST';

delete from listvalue_field_master where field_key = 'SERVER_LIST';


drop table if exists server_list_master;
create table server_list_master (
	server_name text not null,
	server_type text not null,
	db_name text,
	username text,
	password text,
	host_url text not null,
	is_active boolean,
	primary key (server_name)
);

-- insert into server_list_master (server_name,server_type,db_name,username,password,host_url,is_active) values
-- ('DEV','DEV','techo_prod','techo','argusadmin','192.1.200.153',true),
-- ('TESTDEPLOY_P','TESTDROP','techo','postgres','q1w2e3R$','172.17.31.222',true),
-- ('TESTDEPLOY_T','TESTDROP','techo','postgres','q1w2e3R$','172.17.31.222',true),
-- ('STAGING','STAGING','techo_prod','postgres','argusadmin','192.1.200.153',true),
-- ('DEMO','DEMO','techo','postgres','argusadmin','127.0.0.1',true),
-- ('RCH','RCH','techo','postgres','q1w2e3R$','172.17.31.222',true);


DELETE FROM QUERY_MASTER WHERE CODE='get_active_server_list';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'bd6d99e3-0b7b-46e9-b938-1812a3e54d0a', 74840,  current_date , 74840,  current_date , 'get_active_server_list', 
 null, 
'select server_name,server_type from server_list_master where is_active = true', 
'Get all the actively available server', 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='add_server';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'dc681067-1f35-4276-8825-32052cff80af', 74840,  current_date , 74840,  current_date , 'add_server', 
'server_name,password,is_active,db_name,host,server_type,username', 
'insert into server_list_master (server_name,server_type,db_name,username,password,host_url,is_active) values
(''#server_name#'',''#server_type#'',''#db_name#'',''#username#'',''#password#'',''#host#'',#is_active#) returning server_name', 
null, 
true, 'ACTIVE');