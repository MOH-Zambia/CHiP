DROP TABLE IF EXISTS imt_family_migration_master;

CREATE TABLE imt_family_migration_master
(
    id bigserial PRIMARY KEY,
    family_id bigint,
    is_split_family boolean,
    split_family_id bigint,
    is_current_location boolean,
    member_ids text,
    state text,
    type text,
    out_of_state boolean,
    migrated_location_not_known boolean,
    location_migrated_to bigint,
    location_migrated_from bigint,
    area_migrated_to bigint,
    area_migrated_from bigint,
    nearest_loc_id bigint,
    village_name text,
    fhw_asha_name text,
    fhw_asha_phone text,
    other_information text,
    reported_on timestamp without time zone,
    reported_by bigint,
    reported_location_id bigint,
    confirmed_on timestamp without time zone,
    confirmed_by bigint,
    mobile_data text,
    created_on timestamp without time zone,
    created_by bigint,
    modified_on timestamp without time zone,
    modified_by bigint
);

ALTER TABLE imt_family DROP COLUMN if exists split_from, ADD COLUMN split_from bigint;

insert into notification_type_master (created_by, created_on, modified_by, modified_on, code, name, type, role_id, state, notification_for)
values (-1, now(), -1, now(), 'FMO', 'Family Migration Out Notification', 'MO', 30, 'ACTIVE', 'MEMBER');

insert into notification_type_master (created_by, created_on, modified_by, modified_on, code, name, type, role_id, state, notification_for)
values (-1, now(), -1, now(), 'FMI', 'Family Migration In Notification', 'MO', 30, 'ACTIVE', 'MEMBER');

insert into form_master (created_by, created_on, modified_by, modified_on, code, name, state)
values(-1, now(), -1, now(), 'FAM_MIG_OUT', 'Family Migration Out Form', 'ACTIVE');

insert into form_master (created_by, created_on, modified_by, modified_on, code, name, state)
values(-1, now(), -1, now(), 'FAM_MIG_IN', 'Family Migration In Form', 'ACTIVE');

insert into form_master (created_by, created_on, modified_by, modified_on, code, name, state)
values(-1, now(), -1, now(), 'FAM_MIG_OUT_CONF', 'Family Migration Out Confirmation Form', 'ACTIVE');

insert into form_master (created_by, created_on, modified_by, modified_on, code, name, state)
values(-1, now(), -1, now(), 'FAM_MIG_IN_CONF', 'Family Migration In Confirmation Form', 'ACTIVE');