create table if not exists request_response_time_spent_on_page (
	id serial,
	user_id int,
	state_name text,
	time_spent int,
	created_on TIMESTAMP
);


create table if not exists request_response_regex_list_to_be_ignored (
	id serial,
	regex_pattern text
);

insert into request_response_regex_list_to_be_ignored (regex_pattern) values ('.*(api/upload/location/process).*'),('.*(api/upload/document)+(/upload)*(/uploadDocument)*')
,('.*(api/npcb/upload)'),('.*(api/announcement/upload)');