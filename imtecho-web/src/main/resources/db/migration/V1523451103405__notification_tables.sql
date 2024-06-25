CREATE TABLE public.mobile_notification_configuration
(
  id character varying(255) NOT NULL,
  notification_code character varying(255),
  number_of_days_added_for_due_date integer,
  number_of_days_added_for_expiry_date integer,
  number_of_days_added_for_on_date integer,
  CONSTRAINT mobile_notification_configuration_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);


CREATE TABLE public.notification_configuration_type
(
  id character varying(255) NOT NULL,
  base_date_field_name character varying(100),
  day smallint,
  email_subject character varying(500),
  email_subject_parameter character varying(500),
  hour smallint,
  minute smallint,
  mobile_notification_type bigint,
  template character varying(500),
  template_parameter character varying(500),
  triger_when character varying(255),
  type character varying(100) NOT NULL,
  CONSTRAINT notification_configuration_type_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);