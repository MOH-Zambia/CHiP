create table if not exists chardham_emergency_requests
(
	id serial primary key,
	health_infra_id integer not null,
	request_description text not null,
	request_to_type text not null,
	request_state text not null, --PENDING,REJECTED,ONGOING,COMPLETED,CANCELLED
	response_id integer,
	created_by integer not null,
	created_on timestamp without time zone not null,
	modified_by integer not null,
	modified_on timestamp without time zone not null
);

create table if not exists chardham_emergency_response(
	id serial primary key,
	request_id integer not null,
	user_id integer not null,
	response_state text not null, --PENDING,APPROVED,REJECTED,NO_RESPONSE
	rejection_reason text,
	created_by integer not null,
	created_on timestamp without time zone not null,
	modified_by integer not null,
	modified_on timestamp without time zone not null
)