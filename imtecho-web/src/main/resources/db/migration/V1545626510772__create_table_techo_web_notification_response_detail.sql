CREATE TABLE techo_web_notification_response_det
(
  id bigserial PRIMARY KEY,
  notification_type_id bigint NOT NULL,
  notification_id bigint NOT NULL,
  location_id bigint,
  location_hierarchy_id bigint,
  schedule_date timestamp without time zone NOT NULL,
  due_on timestamp without time zone,
  expiry_date timestamp without time zone,
  from_state character varying(100),
  to_state character varying(100),
  ref_code bigint,
  other_details text,
  notification_type_escalation_id text,
  action_taken text,
  created_by bigint NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by bigint,
  modified_on timestamp without time zone
  
);