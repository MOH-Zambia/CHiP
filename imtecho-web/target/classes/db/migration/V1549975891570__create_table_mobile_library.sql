drop table if exists mobile_library_master;
create table mobile_library_master (
    id bigserial,
    role_id bigint,
    category text,
    file_name text,
    file_type text,
    created_by bigint,
    created_on timestamp without time zone,
    modified_by bigint,
    modified_on timestamp without time zone,
    primary key (id)
);