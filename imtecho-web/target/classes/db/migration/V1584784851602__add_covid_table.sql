drop table if exists covid_travellers_info;

CREATE TABLE public.covid_travellers_info
(
  id serial primary key,
  name text,
  address text,
  pincode integer,
  location_id integer,
  member_id integer,
  is_active boolean,
  flight_no text,
  age integer,
  gender character varying(50),
  country character varying(100),
  district_id integer,
  date_of_departure timestamp without time zone,
  date_of_receipt timestamp without time zone,
  observation text,
  symptoms text,
  created_by integer,
  created_on timestamp without time zone,
  modified_by integer,
  modified_on timestamp without time zone,
  district_name text,
  tracking_start_date timestamp without time zone,
  mobile_number text,
  health_status text,
  remarks text,
  status text,
  input_type text
);