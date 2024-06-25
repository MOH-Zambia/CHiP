drop table if exists deleted_locations;
CREATE TABLE deleted_locations
(
  id bigserial primary key,
  location_id bigint,
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
  name character varying(4000) NOT NULL,
  pin_code character varying(15),
  type character varying(10) NOT NULL,
  unique_id character varying(50),
  parent bigint,
  is_tba_avaiable boolean,
  total_population bigint,
  location_hierarchy_id bigint,
  location_code character varying(255),
  state character varying(100),
  location_flag character varying(255),
  census_population bigint,
  is_cmtc_present boolean,
  english_name text,
  is_nrc_present boolean,
  has_active_user boolean,
  has_family boolean,
  deleted_on timestamp without time zone
);


drop table if exists deleted_users;
CREATE TABLE deleted_users
(
  id bigserial primary key,
  user_id bigint,
  created_by bigint NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by bigint,
  modified_on timestamp without time zone,
  aadhar_number character varying(255),
  address character varying(100),
  code character varying(255),
  contact_number character varying(15),
  date_of_birth date,
  email_id character varying(150),
  first_name character varying(100) NOT NULL,
  gender character varying(15),
  last_name character varying(100) NOT NULL,
  middle_name character varying(100),
  password character varying(250),
  prefered_language character varying(30),
  role_id bigint,
  state character varying(255),
  user_name character varying(60) NOT NULL,
  server_type character varying(10),
  search_text character varying(1500),
  title character varying(10),
  imei_number character varying(100),
  techo_phone_number character varying(100),
  aadhar_number_encrypted character varying(24),
  no_of_attempts integer,
  rch_institution_master_id bigint,
  infrastructure_id bigint,
  deleted_on timestamp without time zone
);


drop table if exists deleted_location_level_hierarchys;
CREATE TABLE deleted_location_level_hierarchys
(
  id bigserial primary key,
  location_level_hierarchy_id bigint,
  location_id bigint,
  level1 bigint,
  level2 bigint,
  level3 bigint,
  level4 bigint,
  level5 bigint,
  level6 bigint,
  level7 bigint,
  effective_date timestamp without time zone,
  expiration_date timestamp without time zone,
  is_active boolean NOT NULL,
  location_type character varying(50),
  deleted_on timestamp without time zone
);