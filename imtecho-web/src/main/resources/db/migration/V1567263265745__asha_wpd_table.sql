DROP TABLE IF EXISTS rch_asha_wpd_master;

CREATE TABLE rch_asha_wpd_master
(
  id bigserial NOT NULL PRIMARY KEY,
  member_id bigint NOT NULL,
  family_id bigint NOT NULL,
  latitude text,
  longitude text,
  mobile_start_date timestamp without time zone NOT NULL,
  mobile_end_date timestamp without time zone NOT NULL,
  location_id bigint NOT NULL,
  location_hierarchy_id bigint NOT NULL,
  pregnancy_reg_det_id bigint,
  notification_id bigint,
  service_date date,
  member_status text,
  mother_alive boolean,
  death_date date,
  death_reason text,
  place_of_death text,
  other_death_reason text,
  has_delivery_happened boolean,
  created_by bigint NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by bigint,
  modified_on timestamp without time zone
);


insert into notification_type_master (created_by, created_on, modified_by, modified_on, code, name, type, role_id, state, notification_for)
values (-1, now(), -1, now(), 'ASHA_WPD', 'ASHA WPD Notification', 'MO', 24, 'ACTIVE', 'MEMBER');

insert into form_master (created_by, created_on, modified_by, modified_on, code, name, state)
values(-1, now(), -1, now(), 'ASHA_WPD', 'ASHA WPD Form', 'ACTIVE');