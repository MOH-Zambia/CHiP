create table mytecho_push_notification_log(
id bigserial,
token text,
user_id bigint,
heading text,
message text,
response text,
exception text,
created_on timestamp without time zone,
CONSTRAINT mytecho_push_notification_log_pkey PRIMARY KEY (id)
);