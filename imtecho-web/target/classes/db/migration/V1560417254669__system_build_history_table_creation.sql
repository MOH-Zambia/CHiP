drop table if exists system_build_history;

create table system_build_history
(
    id bigserial primary key,
    server_start_date timestamp without time zone not null,
    build_date timestamp without time zone not null,
    build_version integer,
    maven_version character varying
);

insert into system_build_history (server_start_date,build_date,build_version,maven_version) values (now(),now(),1,'3.0.5');