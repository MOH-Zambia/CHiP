 DROP TABLE if exists notification_configuration;
CREATE TABLE notification_configuration
(
  id bigserial,
  created_by bigint NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by bigint,
  modified_on timestamp without time zone,
  day smallint,
  description character varying(1000),
  event_type character varying(100),
  event_type_detail_id bigint,
  form_type_id bigint,
  hour smallint,
  minute smallint,
  name character varying(500) NOT NULL,
  config_json text,
  state character varying(255),
  trigger_when character varying(50),
  CONSTRAINT notification_configuration_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
