Drop table if exists sms_staff_sms_master;

CREATE TABLE if not exists sms_staff_sms_master
(
  id serial NOT NULL ,
  name character varying(200) NOT NULL,
  description character varying(1000) ,
  sms_template text NOT NULL,
  config_type text NOT NULL,
  trigger_type text NOT NULL,
  status text NOT NULL,
  schedule_date_time timestamp without time zone,
  day SMALLINT,
  hour SMALLINT,
  minute SMALLINT,
  timer_type text,
  excel_url character varying(200),
  CONSTRAINT sms_staff_sms_master_pkey PRIMARY KEY (id)
);


Drop table if exists sms_staff_sms_location_detail;

CREATE TABLE if not exists sms_staff_sms_location_detail
(
  id serial NOT NULL ,
  sms_staff_id int NOT NULL,
  location_id  int NOT NULL ,
  CONSTRAINT sms_staff_sms_location_detail_pkey PRIMARY KEY (id)
);


Drop table if exists sms_staff_sms_role_user_detail;

CREATE TABLE if not exists sms_staff_sms_role_user_detail
(
  id serial NOT NULL ,
  sms_staff_id int NOT NULL,
  role_id  int NOT NULL ,
  user_id int,
  CONSTRAINT sms_staff_sms_role_user_detail_pkey PRIMARY KEY (id)
);

Drop table if exists sms_staff_sms_excel_config_detail;

CREATE TABLE if not exists sms_staff_sms_excel_config_detail
(
  id serial NOT NULL ,
  sms_staff_id int NOT NULL,
  mobile_number  text NOT NULL ,
  sms_template text NOT NULL,
  CONSTRAINT sms_staff_sms_excel_config_detail_pkey PRIMARY KEY (id)
);