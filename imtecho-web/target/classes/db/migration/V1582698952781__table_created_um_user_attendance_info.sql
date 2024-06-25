drop table if exists um_user_attendance_info;

create table um_user_attendance_info
(
    id serial,
    user_id integer,
    attendance_date date,
    locations text,
    start_time timestamp without time zone,
    end_time timestamp without time zone,

    created_on timestamp without time zone,
    created_by integer,
    modified_by integer,
    modified_on timestamp without time zone
);