ALTER TABLE imt_member
drop column if exists current_gravida,
ADD COLUMN current_gravida smallint,
drop column if exists current_para,
ADD COLUMN current_para smallint;