ALTER TABLE imt_member 
    DROP COLUMN IF EXISTS last_delivery_date, 
    ADD COLUMN last_delivery_date timestamp without time zone;