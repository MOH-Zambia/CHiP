ALTER TABLE mytecho_pregnant_woman_symptoms_master
DROP COLUMN IF EXISTS mt_member_id,
ADD COLUMN mt_member_id bigint,
DROP COLUMN IF EXISTS mt_family_id,
ADD COLUMN mt_family_id bigint,
DROP COLUMN IF EXISTS json_data,
ADD COLUMN json_data text;