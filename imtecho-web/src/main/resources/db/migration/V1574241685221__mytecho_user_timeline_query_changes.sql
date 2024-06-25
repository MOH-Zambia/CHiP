DELETE FROM query_master where code='mytecho_create_user_timeline';

INSERT INTO public.query_master
(created_by, created_on, code, params, query, returns_result_set, state, description)
VALUES(1, now(), 'mytecho_create_user_timeline', 'member_id,timeline_config_id,event_code,service_date,response_json,loggedInUserId', '/*Create User Time Line*/
INSERT INTO mytecho_user_timeline_response_det
(member_id,event_code,mt_timeline_config_id, response_json, created_by, created_on,service_date, status)
VALUES(#member_id#
,case when ''#event_code#'' = ''null'' then null else ''#event_code#'' end
,cast(case when ''#timeline_config_id#'' = ''null'' then null else ''#timeline_config_id#'' end as smallint)
,case when ''#response_json#'' = ''null'' then null else ''#response_json#'' end 
,#loggedInUserId#
,now()
,''#service_date#''
,''ACTIVE'');', false, 'ACTIVE', NULL);

DELETE FROM query_master where code='mytecho_update_user_timeline';

INSERT INTO public.query_master
(created_by, created_on, code, params, query, returns_result_set, state, description)
VALUES(1, now(), 'mytecho_update_user_timeline', 'service_date,response_json,loggedInUserId,id', 'update mytecho_user_timeline_response_det
set response_json = case when ''#response_json#'' = ''null'' then null else ''#response_json#'' end 
,modified_by = #loggedInUserId#
,modified_on = now()
,service_date = ''#service_date#''
where id = #id#;', false, 'ACTIVE', NULL);

DELETE FROM query_master where code='mytecho_archive_user_timeline';

INSERT INTO public.query_master
(created_by, created_on, code, params, query, returns_result_set, state, description)
VALUES(1, now(), 'mytecho_archive_user_timeline', 'id', 'update mytecho_user_timeline_response_det
set status = ''ARCHIVED''
where id = #id#;', false, 'ACTIVE', NULL);

CREATE TABLE if not exists public.mytecho_user_timeline_response_det (
	id serial NOT NULL,
	mt_timeline_config_id integer NULL,
	response_json text NULL,
	created_by integer NOT NULL,
	created_on timestamp NOT NULL,
	event_code varchar(50) NULL,
	service_date date NOT NULL,
	member_id integer NOT NULL,
	status text NOT NULL,
	modified_by integer NULL,
	modified_on timestamp NULL,
	CONSTRAINT mytecho_user_timeline_response_det_pkey PRIMARY KEY (id)
);
