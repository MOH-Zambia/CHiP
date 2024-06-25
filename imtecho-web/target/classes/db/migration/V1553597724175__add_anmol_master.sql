-- Table: public.anmol_master

-- DROP TABLE public.anmol_master;

CREATE TABLE public.anmol_master
(
  id bigserial,
  member_id bigint,
  enmol_eligible_couple_created_date timestamp without time zone,
  enmol_eligible_registration_id character varying(255),
  enmol_eligible_mobile_id character varying(255),
  enmol_eligible_wsdl_code text,
  mother_registration_status character varying(50),
  mother_registration_wsdl_code text,
  mother_registration_date timestamp without time zone,
  mother_medial_registration_status character varying(50),
  mother_medial_registration_date timestamp without time zone,
  mother_medial_registration_wsdl_code text,
  eligible_couple_xml text,
  mother_registration_xml text,
  mother_medial_registration_xml text,
  mother_delivery_date timestamp without time zone,
  mother_delivery_xml text,
  mother_delivery_wsdl_code text,
  mother_delivery_status character varying(50),
  pregnancy_reg_det_id bigint,
  child_registration_id character varying(255),
  child_registration_status character varying(50),
  child_registration_wsdl_code text,
  child_registration_xml text,
  child_id bigint,
  child_infant_registration_id character varying(255),
  child_infant_registration_status character varying(50),
  child_infant_registration_wsdl_code text,
  child_infant_registration_xml text,
  CONSTRAINT anmol_master_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
