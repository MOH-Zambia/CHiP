ALTER TABLE imt_family
DROP COLUMN IF EXISTS pmjay_card_number,
ADD COLUMN pmjay_card_number character varying(9);