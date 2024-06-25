drop table if exists mytecho_sync_status;
create table mytecho_sync_status(
id text,
user_id bigint,
notification_id bigint,
status character varying(2),
action_date timestamp without time zone,
form_code text,
submitted_data text,
exception text,
CONSTRAINT mytecho_sync_status_pkey PRIMARY KEY (id)
)