create table if not exists user_absent_response
(
	id bigserial primary key,
	user_id bigint not null,
	absent_response character varying(255),
	absent_response_other character varying(255),
	created_by bigint not null,
	created_on timestamp without time zone not null
);