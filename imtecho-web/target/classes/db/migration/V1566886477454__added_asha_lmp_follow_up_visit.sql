DROP TABLE IF EXISTS rch_asha_lmp_follow_up;

CREATE TABLE rch_asha_lmp_follow_up
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
    notification_id bigint,
    year smallint,
    service_date timestamp without time zone,
    member_status text,
    lmp timestamp without time zone,
    phone_number text,
    is_pregnant boolean,
    pregnancy_test_done boolean,
    family_planning_method text,
    fp_insert_operate_date timestamp without time zone,
    place_of_death text,
    death_date timestamp without time zone,
    death_reason text,
    other_death_reason text,
    created_by bigint NOT NULL,
    created_on timestamp without time zone NOT NULL,
    modified_by bigint,
    modified_on timestamp without time zone
);


insert into notification_type_master (created_by, created_on, modified_by, modified_on, code, name, type, role_id, state, notification_for)
values (-1, now(), -1, now(), 'ASHA_LMPFU', 'ASHA LMP Follow Up Notification', 'MO', 30, 'ACTIVE', 'MEMBER');

insert into form_master (created_by, created_on, modified_by, modified_on, code, name, state)
values(-1, now(), -1, now(), 'ASHA_LMPFU', 'ASHA LMP Follow Up Form', 'ACTIVE');