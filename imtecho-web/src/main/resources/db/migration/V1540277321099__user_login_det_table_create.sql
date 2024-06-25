CREATE TABLE public.um_user_login_det
(
   id bigserial, 
   user_id bigint NOT NULL, 
   no_of_attempts integer, 
   logging_from_web boolean NOT NULL, 
   imei_number text, 
   apk_version integer, 
   created_on timestamp without time zone NOT NULL, 
   PRIMARY KEY (id)
);