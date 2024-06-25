
CREATE TABLE public.event_configuration
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
  CONSTRAINT event_configuration_pkey PRIMARY KEY (id)
);

CREATE TABLE public.event_configuration_type
(
  id character varying(255) NOT NULL,
  base_date_field_name character varying(100),
  config_id bigint,
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
  CONSTRAINT event_configuration_type_pkey PRIMARY KEY (id)
);

CREATE TABLE public.event_mobile_configuration
(
  id character varying(255) NOT NULL,
  notification_code character varying(255),
  notification_type_config_id character varying(255),
  number_of_days_added_for_due_date integer,
  number_of_days_added_for_expiry_date integer,
  number_of_days_added_for_on_date integer,
  CONSTRAINT event_mobile_configuration_pkey PRIMARY KEY (id)
);

INSERT INTO public.event_configuration(
            id, created_by, created_on, modified_by, modified_on, day, description, 
            event_type, event_type_detail_id, form_type_id, hour, minute, 
            name, config_json, state, trigger_when)
 

select id,created_by,created_on,modified_by,modified_on,day,description,event_type,event_type_detail_id,form_type_id,hour,minute,name,config_json,state,trigger_when
from notification_configuration ;

