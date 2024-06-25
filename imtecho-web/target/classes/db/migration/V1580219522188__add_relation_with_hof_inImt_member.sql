ALTER TABLE imt_member
DROP COLUMN IF EXISTS relation_with_hof,
ADD COLUMN relation_with_hof character varying(25);