ALTER table if exists rch_anc_master
ADD column if not exists tetanus_vaccine_date date,
ADD column if not exists blood_sample_code varchar(255),
ADD column if not exists information_before_tested text,
ADD column if not exists blood_test_result_appointment_date date,
ADD column if not exists blood_test_result_receiving_date date,
ADD column if not exists syphilis_test_result varchar(255),
ADD column if not exists payment_type varchar(255),
ADD column if not exists remarks text;


ALTER table if exists rch_pnc_mother_master
ADD column if not exists tetanus4_date date,
ADD column if not exists tetanus5_date date,
add column if not exists check_for_breastfeeding bool,
ADD column if not exists payment_type varchar(255),
ADD column if not exists remarks text;


alter table if exists rch_wpd_mother_master
add column if not exists payment_type varchar(255),
add column if not exists remarks text;


alter table if exists rch_wpd_child_master
add column if not exists vitamin_k1_date date,
add column if not exists exclusive_breastfeeding_in_health_center bool;