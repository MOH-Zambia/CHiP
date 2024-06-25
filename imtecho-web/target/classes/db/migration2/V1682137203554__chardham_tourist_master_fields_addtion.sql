alter table chardham_tourist_master
add column if not exists age integer,
add column if not exists weight numeric(5,2),
add column if not exists has_breathlessness bool,
add column if not exists has_high_blood_pressure bool,
add column if not exists has_asthma bool,
add column if not exists has_diabetes bool,
add column if not exists has_heart_condition bool,
add column if not exists is_pregnant bool,
add column if not exists oxygen_value numeric(3,1),
add column if not exists blood_sugar_test_value integer,
add column if not exists temperature numeric(4,1),
add column if not exists systolic_bp integer,
add column if not exists diastolic_bp integer;

alter table chardham_tourist_screening_master
add column if not exists start_time timestamp without time zone,
add column if not exists end_time timestamp without time zone,
add column if not exists other_diagnosis text,
add column if not exists other_medicines text,
add column if not exists course_of_treatment text,
drop column if exists symptoms,
drop column if exists treatment;

create table if not exists chardham_tourist_screening_master_symptoms_rel(
    screening_id integer not null,
    symptoms integer not null,
    primary key(screening_id,symptoms)
);

create table if not exists chardham_tourist_screening_master_diagnosis_rel(
    screening_id integer not null,
    diagnosis integer not null,
    primary key(screening_id,diagnosis)
);

create table if not exists chardham_tourist_screening_master_treatment_rel(
    screening_id integer not null,
    treatment integer not null,
    primary key(screening_id,treatment)
);