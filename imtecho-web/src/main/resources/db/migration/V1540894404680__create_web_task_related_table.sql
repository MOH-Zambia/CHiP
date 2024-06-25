-- Not logged in for last_4_days
drop table if exists wt_last_4_days_not_logged_in;

create table wt_last_4_days_not_logged_in
(
id bigserial,
user_id bigint,
from_date date,
to_date date,
last_logged_in_time timestamp without time zone,
next_logged_in_time timestamp without time zone,
state text,
created_on timestamp without time zone,
modified_by bigint,
modified_on timestamp without time zone
);


-- Not logged in for last_7_days
drop table if exists wt_last_7_days_not_subbmitted_any_data;

create table wt_last_7_days_not_subbmitted_any_data
(
id bigserial,
user_id bigint,
from_date date,
to_date date,
last_submitted_data_time timestamp without time zone,
next_submitted_data_time timestamp without time zone,
state text,
created_on timestamp without time zone,
modified_by bigint,
modified_on timestamp without time zone
);


-- No preganacy registration in last_30_days
drop table if exists wt_last_30_days_not_registerd_any_pregnancy;

create table wt_last_30_days_not_registerd_any_pregnancy
(
id bigserial,
user_id bigint,
from_date date,
to_date date,
last_submitted_data_time timestamp without time zone,
next_submitted_data_time timestamp without time zone,
state text,
created_on timestamp without time zone,
modified_by bigint,
modified_on timestamp without time zone
);


delete from system_configuration where system_key in ('wt_last_4_days_not_logged_in_last_scheduler_date','wt_last_7_days_not_subbmitted_any_data_last_scheduler_date'
,'wt_last_30_days_not_registerd_any_pregnancy_last_scheduler_date');

INSERT INTO public.system_configuration(
            system_key, is_active, key_value)
    VALUES ('wt_last_4_days_not_logged_in_last_scheduler_date', true, '10-30-2018');

INSERT INTO public.system_configuration(
            system_key, is_active, key_value)
    VALUES ('wt_last_7_days_not_subbmitted_any_data_last_scheduler_date', true, '10-30-2018');

INSERT INTO public.system_configuration(
            system_key, is_active, key_value)
    VALUES ('wt_last_30_days_not_registerd_any_pregnancy_last_scheduler_date', true, '10-30-2018');



