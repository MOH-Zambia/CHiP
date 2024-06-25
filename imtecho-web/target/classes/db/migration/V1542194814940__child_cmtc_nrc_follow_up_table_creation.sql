drop table if exists child_cmtc_nrc_follow_up;

create table child_cmtc_nrc_follow_up
(
    id bigserial primary key,
    child_id bigint,
    referred_by bigint,
    follow_up_visit integer,
    follow_up_date timestamp without time zone,
    bilateral_pitting_oedema text,
    weight real,
    height integer,
    mid_upper_arm_circumference integer,
    illness text,
    other_illness text,
    sd_score text,
    program_output text,
    discharge_from_program timestamp without time zone,
    created_by bigint,
    created_on timestamp without time zone,
    modified_by bigint,
    modified_on timestamp without time zone
);

alter table child_cmtc_nrc_admission_detail
drop column if exists other_illness,
drop column if exists other_death_place,
add column other_illness text,
add column other_death_place text;

alter table child_cmtc_nrc_screening_detail
drop column if exists is_dead;

alter table child_cmtc_nrc_discharge_detail
drop column if exists other_illness,
add column other_illness text