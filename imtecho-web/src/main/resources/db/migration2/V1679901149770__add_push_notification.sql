insert into menu_config
(active,menu_name,navigation_state,menu_type)
values (true,'Push Notification Type','techo.manage.pushnotificationtype','admin');

insert into menu_config
(active,menu_name,navigation_state,menu_type)
values (true,'Push Notification Configuration','techo.manage.pushnotification','manage');


drop table if exists techo_push_notification_master;
Drop table if exists techo_push_notification_location_detail;
Drop table if exists techo_push_notification_role_user_detail;
Drop table if exists techo_push_notification_config_master;
drop table if exists techo_push_notification_type;


CREATE table if not exists techo_push_notification_type (
	id serial NOT NULL,
    type text  NOT null UNIQUE,
    message text NULL,
    heading text null,
    description text NULL,
    is_active boolean default true,
    media_id integer NULL,
    created_on timestamp NULL,
    modified_on timestamp NULL,
    created_by int4 NULL,
    modified_by int4 NULL,
    CONSTRAINT techo_push_notification_type_pkey PRIMARY KEY (id)
);

CREATE table if not exists techo_push_notification_master (
    id bigserial NOT NULL,
    user_id int4 NULL,
    "type" text NULL,
    response text NULL,
    "exception" text NULL,
    is_sent bool NULL DEFAULT false,
    is_processed bool NULL DEFAULT false,
    completed_on timestamp null,
    processed_on timestamp null,
    created_by int4 NULL,
    created_on timestamp NULL,
    modified_by int4 NULL,
    modified_on timestamp NULL,
    CONSTRAINT techo_push_notification_master_pkey PRIMARY KEY (id),
    CONSTRAINT techo_push_notification_master_type_foreign_key FOREIGN KEY ("type")
      REFERENCES  techo_push_notification_type ("type")
);


CREATE TABLE if not exists techo_push_notification_config_master
(
  id serial NOT NULL,
  name character varying(200) NOT NULL,
  notification_type_id integer,
  description character varying(1000) ,
  config_type text NOT NULL,
  trigger_type text NOT NULL,
  status text NOT NULL,
  state text NOT null,
  schedule_date_time timestamp without time zone null,
  query_uuid uuid NULL,
  created_on timestamp NULL,
  modified_on timestamp NULL,
  created_by int4 NULL,
  modified_by int4 NULL,
  CONSTRAINT techo_push_notification_config_master_pkey PRIMARY KEY (id),
  CONSTRAINT techo_push_notification_config_master_type_foreign_key FOREIGN KEY (notification_type_id)
      REFERENCES  techo_push_notification_type (id)
);

CREATE TABLE if not exists techo_push_notification_location_detail
(
  id serial NOT NULL ,
  push_config_id int NOT NULL,
  location_id  int NOT NULL ,
  CONSTRAINT techo_push_notification_location_detail_pkey PRIMARY KEY (id),
  CONSTRAINT techo_push_notification_location_detail_config_foreign_key FOREIGN KEY (push_config_id)
      REFERENCES  techo_push_notification_config_master (id)
);

CREATE TABLE if not exists techo_push_notification_role_user_detail
(
  id serial NOT NULL ,
  push_config_id int NOT NULL,
  role_id  int NOT NULL ,
  CONSTRAINT techo_push_notification_role_user_detail_pkey PRIMARY KEY (id),
   CONSTRAINT techo_push_notification_role_user_detail_config_foreign_key FOREIGN KEY (push_config_id)
      REFERENCES  techo_push_notification_config_master (id)
);


update menu_config set feature_json  ='{"canAccessQueryBased":false	}'
	where navigation_state ='techo.manage.pushnotification';


ALTER TABLE public.event_configuration_type
  ADD column if not exists push_notification_config_json text;


ALTER TABLE IF EXISTS techo_push_notification_master
ADD COLUMN IF NOT EXISTS event_id character varying (255);

ALTER TABLE IF EXISTS techo_push_notification_master
ADD COLUMN IF NOT EXISTS message text;


delete from system_configuration where system_key = 'SERVER_URL';
INSERT INTO public.system_configuration(
            system_key, is_active, key_value)
    VALUES ('SERVER_URL', true,'https://demo.medplat.org');


drop table if exists firebase_token;

CREATE TABLE if not exists firebase_token
(
  id bigserial,
  user_id integer,
  token text,
  created_by integer NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by integer,
  modified_on timestamp without time zone,
  CONSTRAINT firebase_token_data_pkey PRIMARY KEY (id)
);

