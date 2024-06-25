alter table imt_member 
drop column if exists fhsr_phone_verified,
add column fhsr_phone_verified boolean;


DROP TABLE IF EXISTS rch_other_form_master;
CREATE TABLE rch_other_form_master(
    id bigserial primary key,
    member_id bigint,
    family_id bigint,
    location_id bigint,
    longitude text,
    latitude text,
    mobile_start_date timestamp without time zone,
    mobile_end_date timestamp without time zone,
    form_code text,
    form_data text,
    created_by bigint,
    created_on timestamp without time zone,
    modified_by bigint,
    modified_on timestamp without time zone
);