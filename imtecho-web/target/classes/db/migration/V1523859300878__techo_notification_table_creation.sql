CREATE TABLE if not exists techo_notification_master
(
  id bigserial,
  notification_type_id bigint NOT NULL,
  notification_code character varying(100),
  location_id bigint,
  location_hierchy_id bigint,
  user_id bigint,
  family_id bigint,
  member_id bigint,
  schedule_date timestamp without time zone NOT NULL,
  due_on timestamp without time zone,
  expiry_date timestamp without time zone,
  action_by bigint,
  state character varying(100),
    created_by bigint NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by bigint,
  modified_on timestamp without time zone,
  CONSTRAINT techo_notification_master_pkey PRIMARY KEY (id)
);


CREATE TABLE if not exists techo_notification_state_detail
(
  id bigserial,
  notification_id bigint NOT NULL,
  from_state character varying(100),
  to_state character varying(100),
  from_schedule_date timestamp without time zone,
  to_schedule_date timestamp without time zone,
  created_by bigint NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by bigint,
  modified_on timestamp without time zone,
  CONSTRAINT techo_notification_state_detail_pkey PRIMARY KEY (id)
);

ALTER TABLE public.event_configuration
  ADD COLUMN event_type_detail_code character varying(200);

CREATE TABLE if not exists event_mobile_notification_pending
(
  id bigserial,
  notification_configuration_type_id character varying(100),
  base_date timestamp without time zone,
  user_id bigint,
  family_id bigint,
  member_id bigint,
  created_by bigint NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by bigint,
  modified_on timestamp without time zone,
  CONSTRAINT event_mobile_notification_pending_pkey PRIMARY KEY (id)
);

ALTER TABLE public.timer_event
  ADD COLUMN json_data text;
