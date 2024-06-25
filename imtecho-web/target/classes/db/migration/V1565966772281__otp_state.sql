ALTER TABLE otp_master  
DROP COLUMN IF EXISTS state,
ADD COLUMN state text;

UPDATE otp_master set state = 'INACTIVE';