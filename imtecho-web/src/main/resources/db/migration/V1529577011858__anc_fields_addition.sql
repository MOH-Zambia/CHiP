ALTER TABLE rch_anc_master
ADD COLUMN death_date timestamp without time zone,
ADD COLUMN blood_group character(2),
ADD COLUMN vdrl_test character varying(20),
ADD COLUMN hiv_test character varying(20);