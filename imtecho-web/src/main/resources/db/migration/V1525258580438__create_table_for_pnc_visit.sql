CREATE TABLE if not exists rch_pnc_master
(
    id bigserial,
    member_id bigint NOT NULL,
    family_id bigint NOT NULL,
    latitude character varying(100),
    longitude character varying(100),
    mobile_start_date timestamp without time zone NOT NULL,
    mobile_end_date timestamp without time zone NOT NULL,
    location_id bigint NOT NULL,
    location_hierarchy_id bigint NOT NULL,
    notification_id bigint,
    created_by bigint NOT NULL,
    created_on timestamp without time zone NOT NULL,
    modified_by bigint,
    modified_on timestamp without time zone,
    PRIMARY KEY (id)
);

CREATE TABLE if not exists rch_pnc_mother_master
(
    id bigserial,
    pnc_master_id bigint,
    mother_id bigint,
    date_of_delivery timestamp without time zone,
    service_date timestamp without time zone,
    is_alive boolean,
    ifa_tablets_given integer,
    other_danger_sign character varying(100),
    mother_referral_done boolean,
    referral_place bigint,
    created_by bigint NOT NULL,
    created_on timestamp without time zone NOT NULL,
    modified_by bigint,
    modified_on timestamp without time zone,
    PRIMARY KEY (id)
);

CREATE TABLE if not exists rch_pnc_mother_danger_signs_rel
(
    mother_pnc_id bigint NOT NULL,
    mother_danger_signs bigint NOT NULL,
    PRIMARY KEY (mother_pnc_id, mother_danger_signs),
    FOREIGN KEY (mother_pnc_id)
        REFERENCES rch_pnc_mother_master (id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE if not exists rch_pnc_family_planning_methods_rel
(
    mother_pnc_id bigint NOT NULL,
    family_planning_methods bigint NOT NULL,
    PRIMARY KEY (mother_pnc_id, family_planning_methods),
    FOREIGN KEY (mother_pnc_id)
        REFERENCES rch_pnc_mother_master (id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE if not exists rch_pnc_mother_death_reason_rel
(
    mother_pnc_id bigint NOT NULL,
    mother_death_reason bigint NOT NULL,
    PRIMARY KEY (mother_pnc_id, mother_death_reason),
    FOREIGN KEY (mother_pnc_id)
        REFERENCES rch_pnc_mother_master (id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE if not exists rch_pnc_child_master
(
    id bigserial,
    pnc_master_id bigint,
    child_id bigint,
    is_alive boolean,
    other_danger_sign character varying(100),
    child_referral_done character varying(20),
    child_weight real,
    created_by bigint NOT NULL,
    created_on timestamp without time zone NOT NULL,
    modified_by bigint,
    modified_on timestamp without time zone,
    PRIMARY KEY (id)
);

CREATE TABLE if not exists rch_pnc_child_danger_signs_rel
(
    child_pnc_id bigint NOT NULL,
    child_danger_signs bigint NOT NULL,
    PRIMARY KEY (child_pnc_id, child_danger_signs),
    FOREIGN KEY (child_pnc_id)
        REFERENCES rch_pnc_child_master (id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE if not exists rch_pnc_child_death_reason_rel
(
    child_pnc_id bigint NOT NULL,
    child_death_reason bigint NOT NULL,
    PRIMARY KEY (child_pnc_id, child_death_reason),
    FOREIGN KEY (child_pnc_id)
        REFERENCES rch_pnc_child_master (id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION
);

ALTER TABLE rch_lmp_follow_up DROP COLUMN family_planning_method;

CREATE TABLE if not exists rch_lmpfu_family_planning_methods_rel
(
    lmpfu_id bigint NOT NULL,
    family_planning_methods bigint NOT NULL,
    PRIMARY KEY (lmpfu_id, family_planning_methods),
    FOREIGN KEY (lmpfu_id)
        REFERENCES rch_lmp_follow_up (id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION
);
