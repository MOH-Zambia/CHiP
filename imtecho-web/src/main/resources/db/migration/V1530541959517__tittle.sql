ALTER TABLE imt_member
DROP COLUMN IF EXISTS place_of_birth,
ADD COLUMN place_of_birth character varying(15),
DROP COLUMN IF EXISTS birth_weight,
ADD COLUMN birth_weight real,
DROP COLUMN IF EXISTS complementary_feeding_started,
ADD COLUMN complementary_feeding_started boolean;