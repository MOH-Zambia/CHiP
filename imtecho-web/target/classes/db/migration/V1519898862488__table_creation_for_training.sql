-- course_master;
CREATE TABLE if not exists course_master
(
  course_id bigserial NOT NULL ,
  created_by bigint NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by bigint,
  modified_on timestamp without time zone,
  course_description character varying(255),
  course_name character varying(255) NOT NULL,
  course_state character varying(255) NOT NULL,
  CONSTRAINT course_master_pkey PRIMARY KEY (course_id)
);


-- topic_master
CREATE TABLE if not exists topic_master
(
  topic_id bigserial NOT NULL ,
  created_by bigint NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by bigint,
  modified_on timestamp without time zone,
  topic_description character varying(255),
  topic_name character varying(255) NOT NULL,
  topic_order character varying(255),
  topic_state character varying(255),
  day integer,
  CONSTRAINT topic_master_pkey PRIMARY KEY (topic_id)
);

-- course_topic_rel

CREATE TABLE if not exists course_topic_rel
(
  course_id bigint NOT NULL,
  topic_id bigint, 
    FOREIGN KEY (course_id)
      REFERENCES course_master (course_id)
);


-- training_master
CREATE TABLE if not exists training_master
(
  training_id bigserial NOT NULL ,
  created_by bigint NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by bigint,
  modified_on timestamp without time zone,
  training_descr character varying(255),
  effective_date timestamp without time zone NOT NULL,
  expiration_date timestamp without time zone,
  location_name character varying(255),
  training_name character varying(255) NOT NULL,
  training_state character varying(255) NOT NULL,
  CONSTRAINT training_master_pkey PRIMARY KEY (training_id)
);

-- training_primary_trainer_rel;

CREATE TABLE if not exists training_primary_trainer_rel
(
  training_id bigint NOT NULL,
  primary_trainer_id bigint NOT NULL,
  CONSTRAINT training_primary_trainer_rel_pkey PRIMARY KEY (training_id, primary_trainer_id),
  FOREIGN KEY (training_id)
      REFERENCES training_master (training_id) 
);

-- training_optional_trainer_rel;

CREATE TABLE if not exists training_optional_trainer_rel
(
  training_id bigint NOT NULL,
  optional_trainer_id bigint,
   FOREIGN KEY (training_id)
      REFERENCES training_master (training_id)   
);

-- training_org_unit_rel;

CREATE TABLE if not exists training_org_unit_rel
(
  training_id bigint NOT NULL,
  org_unit_id bigint NOT NULL,
  CONSTRAINT training_org_unit_rel_pkey PRIMARY KEY (training_id, org_unit_id),
  FOREIGN KEY (training_id)
      REFERENCES training_master (training_id) 
);

-- training_course_rel;

CREATE TABLE if not exists training_course_rel
(
  training_id bigint NOT NULL,
  course_id bigint NOT NULL,
  CONSTRAINT training_course_rel_pkey PRIMARY KEY (training_id, course_id),
  FOREIGN KEY (training_id)
      REFERENCES training_master (training_id)       
);

-- training_attendee_rel;

CREATE TABLE if not exists training_attendee_rel
(
  training_id bigint NOT NULL,
  attendee_id bigint,
  FOREIGN KEY (training_id)
      REFERENCES training_master (training_id) 
);

-- training_additional_attendee_rel;

CREATE TABLE if not exists training_additional_attendee_rel
(
  training_id bigint NOT NULL,
  additional_attendee_id bigint,
  FOREIGN KEY (training_id)
      REFERENCES training_master (training_id) 
);

-- training_role_rel;

CREATE TABLE if not exists training_trainer_role_rel
(
  training_id bigint NOT NULL,
  role_id bigint NOT NULL,
  CONSTRAINT training_trainer_role_rel_pkey PRIMARY KEY (training_id, role_id),
  FOREIGN KEY (training_id)
      REFERENCES training_master (training_id)
);

CREATE TABLE if not exists training_target_role_rel
(
  training_id bigint NOT NULL,
  target_role_id bigint NOT NULL,
  CONSTRAINT training_target_role_rel_pkey PRIMARY KEY (training_id, target_role_id),
   FOREIGN KEY (training_id)
      REFERENCES training_master (training_id) 
);


-- topic_coverage_master;

CREATE TABLE if not exists topic_coverage_master
(
  id bigserial NOT NULL,
  created_by bigint NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by bigint,
  modified_on timestamp without time zone,
  course_id bigint,
  completed_on timestamp without time zone,
  descr character varying(255),
  effective_date timestamp without time zone,
  expiration_date timestamp without time zone,
  name character varying(255),
  reason character varying(255),
  remarks character varying(255),
  state character varying(255),
  submitted_on timestamp without time zone,
  topic_id bigint,
  training_id bigint,
  CONSTRAINT topic_coverage_master_pkey PRIMARY KEY (id)
);

-- certificate_master;

CREATE TABLE if not exists certificate_master
(
  certificate_id bigserial NOT NULL,
  created_by bigint NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by bigint,
  modified_on timestamp without time zone,
  certificate_descr character varying(255),
  certificate_name character varying(255),
  remarks character varying(255),
  certificate_state character varying(255),
  certificate_type character varying(255),
  certification_on timestamp without time zone,
  course_id bigint,
  grade_type character varying(255),
  training_id bigint,
  user_id bigint,
  CONSTRAINT certificate_master_pkey PRIMARY KEY (certificate_id)
);

-- attendance_master;

CREATE TABLE if not exists attendance_master
(
  attendance_id bigserial NOT NULL,
  created_by bigint NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by bigint,
  modified_on timestamp without time zone,
  completed_on timestamp without time zone,
  descr character varying(255),
  effective_date timestamp without time zone,
  expiration_date timestamp without time zone,
  is_present boolean,
  name character varying(255),
  reason character varying(255),
  remarks character varying(255),
  state character varying(255),
  type character varying(255),
  training_id bigint,
  user_id bigint,
  CONSTRAINT attendance_master_pkey PRIMARY KEY (attendance_id)
);

-- attendance_topic_rel;

CREATE TABLE if not exists attendance_topic_rel
(
  attendance_id bigint NOT NULL,
  topic_id bigint,
  FOREIGN KEY (attendance_id)
      REFERENCES attendance_master (attendance_id)      
);
