DROP TABLE IF EXISTS public.user_notification_sync_detail;
CREATE TABLE public.user_notification_sync_detail
(
  id bigserial,
  user_id bigint NOT NULL,
  sync_date timestamp without time zone NOT NULL,
  CONSTRAINT user_notification_sync_detail_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);