
DROP TABLE if exists user_menu_item;
DROP TABLE if exists menu_config;
DROP TABLE if exists menu_group;

DROP TABLE if exists um_user_master;

DROP TABLE if exists um_user;

DROP TABLE if exists um_role_master;

CREATE TABLE menu_group
(
  id bigserial NOT NULL ,
  group_name character varying(100),
  active boolean,
  parent_group bigint,
  group_type character varying(255),
  CONSTRAINT menu_group_pkey PRIMARY KEY (id)
);


CREATE TABLE menu_config
(
  id bigserial NOT NULL ,
  feature_json character varying(100),
  group_id bigint,
  active boolean,
  is_dynamic_report boolean,
  menu_name character varying(100),
  navigation_state character varying(255),
  sub_group_id bigint,
  menu_type character varying(100),
  CONSTRAINT menu_config_pkey PRIMARY KEY (id),
  CONSTRAINT fk_menu_group_id_menu_config_sub_group_id FOREIGN KEY (sub_group_id)
      REFERENCES menu_group (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fk_menu_group_id_menu_config_group_id FOREIGN KEY (group_id)
      REFERENCES menu_group (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);


CREATE TABLE user_menu_item
(
  user_menu_id bigserial NOT NULL ,
  designation_id bigint,
  feature_json character varying(5000),
  group_id bigint,
  menu_config_id bigint,
  user_id bigint,
  role_id bigint,
  CONSTRAINT user_menu_item_pkey PRIMARY KEY (user_menu_id),
  CONSTRAINT fk_menu_config_id_user_menu_item_menu_config_id FOREIGN KEY (menu_config_id)
      REFERENCES menu_config (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE um_role_master
(
  id bigserial NOT NULL,
  created_by bigint NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by bigint,
  modified_on timestamp without time zone,
  code character varying(255),
  description character varying(500),
  name character varying(50) NOT NULL,
  state character varying(255),
  CONSTRAINT um_role_master_pkey PRIMARY KEY (id)
);

CREATE TABLE um_user
(
  id bigserial NOT NULL,
  created_by bigint NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by bigint,
  modified_on timestamp without time zone,
  aadhar_number character varying(255),
  address character varying(100) NOT NULL,
  code character varying(255),
  contact_number character varying(15) NOT NULL,
  date_of_birth date,
  email_id character varying(150),
  first_name character varying(100) NOT NULL,
  gender character varying(15),
  last_name character varying(100) NOT NULL,
  middle_name character varying(100),
  password character varying(50),
  prefered_language character varying(30),
  role_id bigint,
  state character varying(255),
  user_name character varying(30) NOT NULL,
  CONSTRAINT um_user_pkey PRIMARY KEY (id),
  CONSTRAINT fk_um_role_master_id_um_user_role_id FOREIGN KEY (role_id)
      REFERENCES um_role_master (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT uk_um_user_user_name UNIQUE (user_name)
);



DROP INDEX if exists um_user_aadhar_number_idx;

CREATE INDEX um_user_aadhar_number_idx
  ON um_user
USING btree
  (aadhar_number);

DROP INDEX if exists um_user_role_id_idx;

CREATE INDEX um_user_role_id_idx
  ON um_user
  USING btree
  (role_id);


DROP INDEX if exists um_user_state_idx;

CREATE INDEX um_user_state_idx
  ON um_user
  USING btree
  (state);

DROP INDEX if exists um_user_user_name_idx;

CREATE INDEX um_user_user_name_idx
  ON um_user
  USING btree
  (user_name);



DO $$DECLARE r record;
BEGIN
        FOR r IN SELECT
    tc.constraint_name
FROM 
    information_schema.table_constraints AS tc 
    JOIN information_schema.key_column_usage AS kcu
      ON tc.constraint_name = kcu.constraint_name
    JOIN information_schema.constraint_column_usage AS ccu
      ON ccu.constraint_name = tc.constraint_name
WHERE constraint_type = 'FOREIGN KEY' AND tc.table_name='location_master' and ccu.table_name = 'hierarchy_type_master'
        LOOP
            EXECUTE 'ALTER TABLE IF EXISTS ' || 'location_master'|| ' DROP CONSTRAINT IF EXISTS'|| quote_ident(r.constraint_name) || ';';
        END LOOP;
END$$;


DROP TABLE if exists hierarchy_type_relation;

DROP TABLE if exists hierarchy_master;

DROP TABLE if exists hierarchy_type_master;

DROP TABLE if exists location_type_master;


CREATE TABLE hierarchy_master
(
  hierarchy_type character varying(50) NOT NULL,
  code character varying(255) NOT NULL,
  name character varying(255) NOT NULL,
  CONSTRAINT hierarchy_master_pkey PRIMARY KEY (hierarchy_type)
);


CREATE TABLE location_type_master
(
  type character varying(255) NOT NULL,
  name character varying(255) NOT NULL,
  CONSTRAINT location_type_master_pkey PRIMARY KEY (type)
);


CREATE TABLE IF NOT EXISTS location_level_hierarchy_master
(
  id bigserial NOT NULL,
  location_id integer,
  level1 integer,
  level2 integer,
  level3 integer,
  level4 integer,
  level5 integer,
  level6 integer,
  level7 integer,
  effective_date timestamp without time zone,
  expiration_date timestamp without time zone,
  is_active boolean NOT NULL,
  location_type character varying(50),
  CONSTRAINT location_level_hierarchy_master_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS location_master
(
  id bigserial NOT NULL,
  address character varying(300),
  associated_user character varying(50),
  contact1_email character varying(50),
  contact1_name character varying(50),
  contact1_phone character varying(15),
  contact2_email character varying(50),
  contact2_name character varying(50),
  contact2_phone character varying(20),
  created_by character varying(50) NOT NULL,
  created_on timestamp without time zone NOT NULL,
  is_active boolean NOT NULL,
  is_archive boolean NOT NULL,
  max_users smallint,
  modified_by character varying(50),
  modified_on timestamp without time zone,
  name character varying(50) NOT NULL,
  pin_code character varying(15),
  type character varying(5) NOT NULL,
  unique_id character varying(50),
  parent bigint,
  is_tba_avaiable boolean,
  total_population bigint,
  location_hierarchy_id bigint,
  location_code character varying(255),
  state character varying(255),
  CONSTRAINT location_master_pkey PRIMARY KEY (id),
  CONSTRAINT fk_location_level_hierarchy_master_id_location_master_location_hierarchy_id FOREIGN KEY (location_hierarchy_id)
      REFERENCES location_level_hierarchy_master (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fk_location_master_parent_id FOREIGN KEY (parent)
      REFERENCES location_master (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE IF NOT EXISTS location_hierchy_closer_det
(
  id  bigserial NOT NULL,
  child_id bigint NOT NULL,
  child_loc_type character varying(255) NOT NULL,
  depth integer NOT NULL,
  parent_id bigint NOT NULL,
  parent_loc_type character varying(255) NOT NULL,
  CONSTRAINT location_hierchy_closer_det_pkey PRIMARY KEY (id),
  CONSTRAINT fk_location_master_id_child_id FOREIGN KEY (child_id)
      REFERENCES public.location_master (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fk_location_master_id_parent_id FOREIGN KEY (parent_id)
      REFERENCES public.location_master (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);

DROP TABLE if exists um_user_location;

CREATE TABLE um_user_location
(
  id bigserial NOT NULL,
  created_by bigint NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by bigint,
  modified_on timestamp without time zone,
  loc_id bigint,
  state character varying(255),
  type character varying(255) NOT NULL,
  user_id bigint,
  hierarchy_type character varying(50),
  level integer,
  CONSTRAINT um_user_location_pkey PRIMARY KEY (id),
  CONSTRAINT fk_location_master_id_um_user_location_loc_id FOREIGN KEY (loc_id)
      REFERENCES location_master (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);

DO $$ 
   BEGIN
       BEGIN
           ALTER TABLE location_master
 ADD COLUMN state character varying(100);
       EXCEPTION
           WHEN duplicate_column THEN RAISE NOTICE 'Already exists';
       END;
   END;
$$;
-- ALTER TABLE location_master
--   ADD COLUMN state character varying(100);