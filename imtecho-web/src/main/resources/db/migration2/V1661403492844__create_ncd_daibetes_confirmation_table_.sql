
DROP TABLE IF EXISTS public.ncd_diabetes_confirmation_detail;
CREATE TABLE public.ncd_diabetes_confirmation_detail
(
  id serial PRIMARY KEY,
  member_id integer NOT NULL,
  location_id integer,
  family_id integer,
  created_by integer,
  created_on timestamp without time zone,
  modified_by integer,
  modified_on timestamp without time zone,
  latitude character varying(100),
  longitude character varying(100),
  mobile_start_date timestamp without time zone NOT NULL,
  mobile_end_date timestamp without time zone NOT NULL,
  screening_date timestamp without time zone,
  fasting_blood_sugar integer,
  post_prandial_blood_sugar integer,
  flag boolean,
  done_by character varying(200),
  done_on timestamp without time zone
);