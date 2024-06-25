DROP TABLE if exists covid_travellers_info;
DROP TABLE if exists covid_travellers_screening_info;

CREATE TABLE if not exists covid_travellers_info (
  id integer DEFAULT nextval('imt_member_id_seq1'::regclass),
  name text,
  address text,
  pincode integer,
  location_id integer,
  member_id integer,
  mobile_number character varying(10),
  is_active boolean,
  created_by int,
  created_on timestamp without time zone,
  modified_by int,
  modified_on timestamp without time zone,
  CONSTRAINT covid_travellers_info_pkey PRIMARY KEY (id)
);

CREATE TABLE if not exists covid_travellers_screening_info (
  id serial primary key,
  any_symptoms boolean,
  referral_required boolean,
  covid_info_id integer,
  notification_id integer,
  longitude text,
  latitude text,
  mobile_start_date timestamp without time zone,
  mobile_end_date timestamp without time zone,
  created_by int,
  created_on timestamp without time zone,
  modified_by int,
  modified_on timestamp without time zone
);

insert into notification_type_master (created_by, created_on, modified_by, modified_on, code, name, type, role_id, state, notification_for)
values(-1, now(), -1, now(), 'TSA', 'Travellers Screening Alert', 'MO', 30, 'ACTIVE', 'MEMBER');