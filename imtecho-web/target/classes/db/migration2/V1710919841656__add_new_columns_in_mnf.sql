alter table imt_family
add column if not exists other_waste_disposal text;

alter table imt_member
add column if not exists why_no_treatment text;