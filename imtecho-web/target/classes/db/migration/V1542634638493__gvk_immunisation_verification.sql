update menu_config  
    set feature_json  = '{"canAbsentVerication":true,"canFamilyVerification":true, "canGvkImmunisationVerification":"true"}'
        where navigation_state = 'techo.dashboard.gvkverification';

CREATE TABLE  if not exists gvk_immunisation_verification
(
  id bigserial NOT NULL ,
  member_id bigint,
  gvk_state  varchar(255),
  schedule_date timestamp without time zone,
  call_attempt int default 0,
  created_by bigint NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by bigint,
  modified_on timestamp without time zone
);

create table if not exists gvk_immunisation_verification_response
(
  id bigserial NOT NULL ,
  gvk_immunisation_verification_child_id bigint,
  member_id bigint,   
  gvk_call_status varchar(255),
  healthworker_visited varchar(255),
  asked_child_vaccination varchar(255),
  date_asked_to_come timestamp without time zone, 
  created_by bigint NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by bigint,
  modified_on timestamp without time zone
);



