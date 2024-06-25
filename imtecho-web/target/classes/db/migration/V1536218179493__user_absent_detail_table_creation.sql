create table if not exists user_absent_detail
(
	id bigserial primary key,
	user_id bigint not null,
	absent_from timestamp without time zone not null,
	absent_to timestamp without time zone not null,
	status character varying(100) not null,
	created_on timestamp without time zone not null,
	modified_by bigint not null,
	modified_on timestamp without time zone
);