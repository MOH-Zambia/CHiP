ALTER TABLE um_user
drop column if exists pin,
ADD COLUMN pin varchar(10);