alter table if exists rch_hiv_known_master
add column if not exists other_medication_along BOOLEAN,
add column if not exists enough_medication BOOLEAN,
add column if not exists viral_load_test BOOLEAN,
add column if not exists viral_load_suppressed BOOLEAN,
add column if not exists unprotected_sex BOOLEAN,
add column if not exists hiv_status_of_member_known BOOLEAN,
add column if not exists willing_to_share_status BOOLEAN,
add column if not exists name TEXT,
add column if not exists phone_number TEXT,
add column if not exists address TEXT,
add column if not exists lmp_date TIMESTAMP;