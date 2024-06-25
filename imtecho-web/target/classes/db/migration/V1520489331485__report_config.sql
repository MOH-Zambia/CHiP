CREATE TABLE public.report_master
(
  id bigserial,
  report_name character varying(100),
  file_name character varying(500),
  active boolean,
  report_type character varying(15),
  menu_id bigint,
  modified_on timestamp without time zone,
  created_by bigint NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by bigint,
  config_json text,
  CONSTRAINT report_master_pkey PRIMARY KEY (id),
  CONSTRAINT "FK_MENU_CONFIG" FOREIGN KEY (menu_id)
      REFERENCES public.menu_config (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
);

CREATE TABLE public.report_parameter_master
(
  id bigserial,
  label character varying(200),
  name character varying(200),
  type character varying(200),
  report_master_id bigint,
  rpt_data_type character varying(200),
  report_name character varying(200),
  is_query boolean,
  is_required boolean,
  options character varying,
  query character varying,
  default_value character varying,
  implicit_parameter character varying,
  created_on timestamp without time zone NOT NULL,
  modified_on timestamp without time zone,
  created_by bigint NOT NULL,
  modified_by bigint,
  CONSTRAINT report_parameter_master_pkey PRIMARY KEY (id),
  
  CONSTRAINT report_parameter_master_report_master_id_fkey FOREIGN KEY (report_master_id)
      REFERENCES public.report_master (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION

)