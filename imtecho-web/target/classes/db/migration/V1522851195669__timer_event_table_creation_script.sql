CREATE TABLE public.timer_event
(
  id bigserial,
  ref_id bigint,
  event_config_id bigint,
  processed boolean,
  status character varying(20),
  type character varying(20),
  system_trigger_on timestamp without time zone,
  processed_on timestamp without time zone,
  notification_config_id character varying(100),
  notification_base_date timestamp without time zone,
  CONSTRAINT timer_event_pkey PRIMARY KEY (id)
 );