alter table if exists rch_vaccine_adverse_effect
add column if not exists session_site text;

alter table if exists rch_vaccine_adverse_effect
add column if not exists cluster Boolean;

alter table if exists rch_vaccine_adverse_effect
add column if not exists vaccination_place text;

alter table if exists rch_vaccine_adverse_effect
add column if not exists notification_date Timestamp;

alter table if exists rch_vaccine_adverse_effect
add column if not exists vaccination_date Timestamp;

alter table if exists rch_vaccine_adverse_effect
add column if not exists vaccination_in text;
