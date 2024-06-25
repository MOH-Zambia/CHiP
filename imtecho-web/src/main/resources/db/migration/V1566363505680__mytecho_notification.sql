drop table if exists mytecho_notification_master;
create table mytecho_notification_master(
id bigserial,
notification_type_id bigint,
user_id bigint,
notification_for bigint,
scheduled_date date NOT NULL,
due_date date,
expiry_date date,
state text,
related_id bigint,
action_on timestamp without time zone,
action_by bigint,
created_by bigint NOT NULL,
created_on timestamp without time zone NOT NULL,
modified_by bigint,
modified_on timestamp without time zone,
CONSTRAINT mytecho_notification_master_pkey PRIMARY KEY (id)
);