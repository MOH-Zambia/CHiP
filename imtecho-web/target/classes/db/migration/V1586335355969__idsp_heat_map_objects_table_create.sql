drop table if exists idsp_heat_map_objects_master;
create table idsp_heat_map_objects_master (
    id serial primary key,
    user_id integer,
    shape_json text,
    state character varying(10),
    created_on timestamp without time zone,
    created_by integer,
    modified_on timestamp without time zone,
    modified_by integer
);