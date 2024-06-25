drop table if exists wt_last_4_days_not_logged_in_CHO_HWC;

CREATE TABLE wt_last_4_days_not_logged_in_CHO_HWC(
    id serial,
    user_id  int,
    from_date date,
    to_date date,
    last_logged_in_time timestamp without time zone,
    next_logged_in_time timestamp without time zone,
    state text,
    created_on timestamp without time zone    
);