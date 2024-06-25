ALTER TABLE imt_family
DROP COLUMN IF EXISTS bpl_card_number,
ADD COLUMN bpl_card_number character varying(25);