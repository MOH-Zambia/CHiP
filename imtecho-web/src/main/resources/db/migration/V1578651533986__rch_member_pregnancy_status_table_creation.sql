drop table if exists rch_member_pregnancy_status;

create table rch_member_pregnancy_status (
    member_id integer primary key,
    reg_date date,
    anc_date text,
    bp text,
    haemoglobin text,
    urine_test text,
    weight text,
    immunisation text,
    fa_tablets text,
    ifa_tablets text,
    calcium_tablets text,
    night_blindness boolean,
    modified_on timestamp without time zone
);