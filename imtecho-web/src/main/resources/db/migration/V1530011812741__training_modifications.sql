CREATE TABLE if not exists tr_course_trainer_role_rel
(
  course_id bigint NOT NULL,
  trainer_role_id bigint, 
    FOREIGN KEY (course_id)
      REFERENCES tr_course_master (course_id)
);

INSERT INTO field_constant_master(
           field_name, created_on, created_by, modified_on, modified_by)
    VALUES ('COURSE_MODULE_NAME',localtimestamp,-1,null,null);


INSERT INTO public.field_value_master(
            field_id, field_value, created_on, created_by, modified_on, 
            modified_by)
select id,'FHS',localtimestamp,-1,null,null from field_constant_master where field_name = 'COURSE_MODULE_NAME';


INSERT INTO public.field_value_master(
            field_id, field_value, created_on, created_by, modified_on, 
            modified_by)
select id,'RCH',localtimestamp,-1,null,null from field_constant_master where field_name = 'COURSE_MODULE_NAME';

INSERT INTO public.field_value_master(
            field_id, field_value, created_on, created_by, modified_on, 
            modified_by)
select id,'WEB',localtimestamp,-1,null,null from field_constant_master where field_name = 'COURSE_MODULE_NAME';

alter table tr_course_master add column module_id bigint;