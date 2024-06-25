ALTER TABLE mytecho_user
DROP COLUMN IF EXISTS gender,
ADD COLUMN gender varchar(1),
DROP COLUMN IF EXISTS dob,
ADD COLUMN dob date,
DROP COLUMN IF EXISTS address,
ADD COLUMN address text;