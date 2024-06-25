DROP TABLE IF EXISTS stock_management_details;
CREATE TABLE if not exists stock_management_details
(
  id serial primary key,
  latitude character varying(100),
  longitude character varying(100),
  requested_by integer,
  health_infra_id integer,
  medicines_and_quantity text,
  approval_status text,
  created_by integer NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by integer,
  modified_on timestamp without time zone
);




