alter table rch_asha_anc_master 
drop column if exists member_status,
add column member_status text,
drop column if exists is_alive,
add column is_alive boolean,
drop column if exists death_date,
add column death_date date,
drop column if exists death_place,
add column death_place text,
drop column if exists death_reason,
add column death_reason text,
drop column if exists other_death_reason,
add column other_death_reason text,
drop column if exists other_death_reason;