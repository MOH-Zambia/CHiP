
CREATE TABLE if not exists public.mytecho_user_tip_of_the_day
(
 member_id bigint NOT NULL,
 tip_id bigint NOT NULL,
 is_sent boolean,
 created_on timestamp without time zone,
 created_by bigint,
 base_date_type character varying(300),
 schedule_date timestamp without time zone,
 is_notification_sent boolean,
 CONSTRAINT mytecho_user_tip_of_the_day_pkey PRIMARY KEY (member_id, tip_id)
)