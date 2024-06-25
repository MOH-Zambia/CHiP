insert into notification_type_master (created_by, created_on, modified_by, modified_on, code, name, type, role_id, state, notification_for)
values (-1, now(), -1, now(), 'SAM_SCREENING', 'SAM Screening', 'MO', 30, 'ACTIVE', 'MEMBER');

insert into form_master (created_by, created_on, modified_by, modified_on, code, name, state)
values(-1, now(), -1, now(), 'SAM_SCREENING', 'SAM Screening', 'ACTIVE');

DROP TABLE IF EXISTS rch_sam_screening_master;
CREATE TABLE rch_sam_screening_master
(
    id bigserial primary key,
    member_id bigint,
    family_id bigint,
    location_id bigint,
    notification_id bigint,
    created_by bigint NOT NULL,
    created_on timestamp without time zone NOT NULL,
    modified_by bigint,
    modified_on timestamp without time zone,
    child_visit_id bigint,
    screened_on timestamp without time zone,
    height integer,
    weight real,
    mid_arm_circumference real,
    have_pedal_edema boolean,
    sd_score text,
    other_diseases text
);

DROP TABLE IF EXISTS rch_sam_screening_diseases_rel;
CREATE TABLE rch_sam_screening_diseases_rel(
    sam_screening_id bigint NOT NULL,
    diseases bigint NOT NULL,
    PRIMARY KEY (sam_screening_id, diseases),
    FOREIGN KEY (sam_screening_id)
        REFERENCES rch_sam_screening_master (id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION
);