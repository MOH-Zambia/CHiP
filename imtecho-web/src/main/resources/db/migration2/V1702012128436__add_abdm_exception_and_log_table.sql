drop table if exists abdm_exception;

create table abdm_exception (
	id SERIAL,
	exception_msg text,
	exception_type varchar(30) not null,
	exception_stack_trace text not null,
	data_string text,
	created_by integer not null,
	created_on timestamp without time zone not null,
    modified_by integer,
    modified_on timestamp without time zone,
    PRIMARY KEY (id)
);


drop table if exists abdm_api_call_log;

create table abdm_api_call_log (
	id bigserial NOT NULL,
	call_type varchar(100),
	member_id integer,
	time_taken_in_ms bigint,
	error text,
	created_on timestamp without time zone NOT NULL,
  	created_by int NOT NULL,
  	modified_on timestamp without time zone NOT NULL,
  	modified_by int,
  	CONSTRAINT abdm_api_call_log_pkey PRIMARY KEY (id)
)