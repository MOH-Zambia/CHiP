ALTER TABLE imt_member 
DROP COLUMN if exists last_method_of_contraception, 
ADD COLUMN last_method_of_contraception character varying(15);