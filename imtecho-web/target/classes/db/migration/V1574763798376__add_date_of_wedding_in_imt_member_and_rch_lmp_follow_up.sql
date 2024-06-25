ALTER TABLE imt_member
drop column if exists date_of_wedding,
ADD COLUMN date_of_wedding date;

ALTER TABLE rch_lmp_follow_up
drop column if exists date_of_wedding,
ADD COLUMN date_of_wedding date;