 drop table if exists field_value_master;

 drop table if exists field_constant_master;

CREATE TABLE field_constant_master
(
  id bigserial NOT NULL,
  field_name character varying(255),
  created_on timestamp without time zone,
  created_by bigint,
  modified_on timestamp without time zone,
  modified_by bigint,
  CONSTRAINT field_constant_master_pkey PRIMARY KEY (id)
);

CREATE TABLE field_value_master
(
  id bigserial NOT NULL,
  field_id bigint,
  field_value character varying(255),
  created_on timestamp without time zone,
  created_by bigint,
  modified_on timestamp without time zone,
  modified_by bigint,
  CONSTRAINT field_value_master_pkey PRIMARY KEY (id),
  FOREIGN KEY (field_id) REFERENCES  field_constant_master (id)  
);

INSERT INTO public.field_constant_master(field_name, created_on, created_by, modified_on, modified_by)
VALUES ('GVK_ABSENT_REASON_DROPDOWN',localtimestamp,-1,null,null);

INSERT INTO public.field_constant_master(field_name, created_on, created_by, modified_on, modified_by)
VALUES ('GVK_WORK_QUESTION_DROPDOWN',localtimestamp,-1,null,null);

INSERT INTO public.field_value_master(field_value, created_on, created_by, modified_on, modified_by, field_id)
VALUES ('No. I was logged in but no network', localtimestamp,-1,null,null,1);

INSERT INTO public.field_value_master(field_value, created_on, created_by, modified_on, modified_by, field_id)
VALUES ('I am on Leave', localtimestamp,-1,null,null,1);

INSERT INTO public.field_value_master(field_value, created_on, created_by, modified_on, modified_by, field_id)
VALUES ('Health reasons - Self', localtimestamp,-1,null,null,1);

INSERT INTO public.field_value_master(field_value, created_on, created_by, modified_on, modified_by, field_id)
VALUES ('Health reasons - Family', localtimestamp,-1,null,null,1);

INSERT INTO public.field_value_master(field_value, created_on, created_by, modified_on, modified_by, field_id)
VALUES ('Others - Please specify', localtimestamp,-1,null,null,1);

INSERT INTO public.field_value_master(field_value, created_on, created_by, modified_on, modified_by, field_id)
VALUES ('Not Applicable - I am already working', localtimestamp,-1,null,null,2);

INSERT INTO public.field_value_master(field_value, created_on, created_by, modified_on, modified_by, field_id)
VALUES ('From Tomorrow', localtimestamp,-1,null,null,2);

INSERT INTO public.field_value_master(field_value, created_on, created_by, modified_on, modified_by, field_id)
VALUES ('From day after tomorrow', localtimestamp,-1,null,null,2);

INSERT INTO public.field_value_master(field_value, created_on, created_by, modified_on, modified_by, field_id)
VALUES ('I dont know', localtimestamp,-1,null,null,2);
