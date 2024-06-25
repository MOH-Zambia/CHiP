create table request_response_details_master 
(
id serial not null primary key,
url text,
param text,
body text,
start_time timestamp,
end_time timestamp,
remote_ip text
)
