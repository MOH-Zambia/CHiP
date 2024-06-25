CREATE TABLE public.system_sync_status_dump
(
  id text NOT NULL,
  action_date timestamp without time zone NOT NULL,
  relative_id bigint,
  status text,
  record_string text,
  mobile_date timestamp without time zone,
  user_id bigint,
  device text,
  client_id bigint,
  lastmodified_by bigint,
  lastmodified_date timestamp without time zone,
  duration_of_processing bigint,
  error_message text,
  exception text,
  mail_sent boolean,
  CONSTRAINT system_sync_status_dump_pkey PRIMARY KEY (id)
)
