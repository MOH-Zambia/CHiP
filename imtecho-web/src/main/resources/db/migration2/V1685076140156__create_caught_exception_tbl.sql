drop table if exists caught_exception;

create table caught_exception (
    id SERIAL,
    exception_msg text not null,
    exception_type character varying(20) not null,
    exception_stack_trace text not null,
    data_string text,
    created_by integer not null,
    created_on timestamp without time zone not null,
    modified_by integer,
    modified_on timestamp without time zone,
    username character varying(255),
    request_url text,
    primary key (id)
);
