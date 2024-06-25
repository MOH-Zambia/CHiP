ALTER TABLE imt_member
drop column if exists husband_id,
ADD COLUMN husband_id bigint;