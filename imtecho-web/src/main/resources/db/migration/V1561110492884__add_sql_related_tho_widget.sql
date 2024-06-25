drop table if exists wt_last_4_days_not_logged_in_tho;

CREATE TABLE public.wt_last_4_days_not_logged_in_tho
(
  id bigserial primary key,
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

insert into system_configuration VALUES  ('wt_last_4_days_not_logged_in_tho_last_scheduler_date',true,now());
