DROP TABLE IF EXISTS request_response_page_wise_time_details;
create table if not exists request_response_page_wise_time_details(
	id text,
	user_id int,
	page_title text,
	active_tab_time int,
	total_time int,
	next_page_id text,
	prev_page_id text,
	created_on timestamp
);

ALTER TABLE request_response_time_spent_on_page
ADD COLUMN state_id text;


DROP TABLE IF EXISTS request_response_regex_list_to_be_ignored;

CREATE TABLE IF NOT EXISTS request_response_regex_list_to_be_ignored(
	id serial,
	regex_pattern text PRIMARY KEY
);

insert into request_response_regex_list_to_be_ignored (regex_pattern) values
	('(.*\/*imtecho-ui\/)'),
	('(.*\/*oauth\/token)'),
	('.*(api/insertStateSpendTime)'),
	('.*(api/upload/location/process).*'),
	('.*(api/upload/document)+(/upload)*(/uploadDocument)*'),
	('.*(api/npcb/upload)'),
	('.*(api/announcement/upload)'),
	('.*(www).*')
ON CONFLICT ON CONSTRAINT request_response_regex_list_to_be_ignored_pkey 
DO NOTHING;




