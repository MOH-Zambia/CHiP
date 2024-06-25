drop table if exists imt_member_sickle_cell_anemia_rel;
create table imt_member_sickle_cell_anemia_rel (
    sickle_cell_anemia_id integer,
    cfhc_id integer
);

drop table if exists imt_member_cfhc_master;
create table imt_member_cfhc_master(
    id serial primary key,
    member_id integer,
    is_child_going_school boolean,
    current_studying_standard character varying(5),
    current_school_name character varying(256),
    ready_for_more_child boolean,
    family_planning_method character varying(50),
    another_family_planning_method character varying(50),
    is_fever_with_cs_for_da_days boolean,
    is_fever_with_h_ep_mp_sr boolean,
    is_fever_with_h_jp boolean,
    sickle_cell_anemia text,
    is_skin_patches boolean,
    blood_pressure character varying(100),
    is_cough_for_mt_one_week boolean,
    is_fever_at_evening_time boolean,
    is_filling_any_weekness boolean,
    created_by integer,
    created_on timestamp without time zone NOT NULL,
    modified_on timestamp without time zone NOT NULL,
    modified_by integer
);