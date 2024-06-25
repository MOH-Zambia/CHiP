insert into system_configuration values ('IS_FILter_APPLIED_ON_EACH_REQUEST',true,false) 
ON CONFLICT ON CONSTRAINT system_configuration_pkey 
DO NOTHING;

create table if not exists request_response_url_mapping(
	id serial,
	url text UNIQUE NOT NULL,
	PRIMARY KEY (id)
);

create table if not exists request_response_page_title_mapping(
	id serial,
	page_title text UNIQUE NOT NULL,
	PRIMARY KEY (id)
);

drop table if exists request_response_details_master;

create table if not exists request_response_details_master 
(
id serial not null primary key,
url integer,
page_title integer,
param text,
body text,
start_time timestamp,
end_time timestamp,
remote_ip text,
uuid text,
username text 
);