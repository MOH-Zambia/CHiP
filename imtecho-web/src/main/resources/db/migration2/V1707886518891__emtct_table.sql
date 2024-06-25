DROP TABLE IF EXISTS emtct_details;
CREATE TABLE if not exists emtct_details
(
  id serial primary key,
  member_id integer NOT NULL,
  family_id integer,
  location_id integer,
  member_status character varying(50),
  dbs_test_done boolean,
  dbs_result character varying(100),
  created_by integer NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by integer,
  modified_on timestamp without time zone
);


drop table if exists rch_child_service_symptoms_rel;
CREATE TABLE if not exists rch_child_service_symptoms_rel
(
    child_service_id integer NOT NULL,
    symptoms integer NOT NULL,
    PRIMARY KEY (child_service_id, symptoms),
    FOREIGN KEY (child_service_id)
        REFERENCES rch_child_service_master (id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION
);


drop table if exists stock_medicines_rel;
CREATE TABLE if not exists stock_medicines_rel
(
    id integer NOT NULL,
    medicine_id integer NOT NULL,
    quantity integer,
    status text,
    FOREIGN KEY (id)
        REFERENCES stock_management_details (id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION
);

ALTER TABLE rch_child_service_master
DROP column if exists child_symptoms;

alter table rch_child_service_master
add column if not exists other_symptoms text;


alter table stock_management_details
drop column if exists medicines_and_quantity;

alter table stock_management_details
drop column if exists approval_status;





