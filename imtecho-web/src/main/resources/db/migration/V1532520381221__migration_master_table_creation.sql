create table if not exists migration_master (
 id bigserial primary key,
 member_id bigint not null,
 reported_by bigint not null,
 reported_on timestamp without time zone not null,
 location_migrated_to bigint,
 location_migrated_from bigint not null,
 migrated_location_not_known boolean not null,
 confirmed_by bigint,
 confirmed_on timestamp without time zone,
 type character varying(10) not null,
 created_by bigint not null,
 created_on timestamp without time zone not null,
 modified_by bigint,
 modified_on timestamp without time zone,
 state character varying(10) not null
);