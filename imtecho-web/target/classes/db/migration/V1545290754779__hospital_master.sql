drop table if exists health_infrastructure_details;
CREATE TABLE public.health_infrastructure_details
(
   id bigserial primary key,
   hospital_type character varying(250), 
   name character varying(500), 
   location_id bigint, 
   is_nrc boolean, 
   is_cmtc boolean, 
   is_fru boolean, 
   is_sncu boolean, 
   is_chiranjeevi_scheme boolean, 
   is_balsaka boolean, 
   is_pmjy boolean,    
   address character varying(1000),
state character varying(255),
 created_by bigint,
created_on timestamp without time zone,
modified_by bigint,
modified_on timestamp without time zone
);
drop table if exists role_health_infrastructure;

CREATE TABLE public.role_health_infrastructure
(
   role_id bigint, 
   health_infrastructure_id bigint, 
   id bigserial,
    state character varying(255),
    created_by bigint,
    created_on timestamp without time zone,
    modified_by bigint, 
    modified_on timestamp without time zone
);

ALTER TABLE public.um_user
  ADD COLUMN infrastructure_id bigint;

INSERT INTO menu_config (menu_name, menu_type, active, navigation_state,feature_json) values 
('Health Infrastructure','manage',TRUE,'techo.manage.healthinfrastructures','{"canAdd":true,"canEdit":true}');
