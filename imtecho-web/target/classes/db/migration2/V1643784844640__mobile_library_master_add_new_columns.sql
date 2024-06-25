ALTER table mobile_library_master
drop column if exists tag,
ADD COLUMN tag varchar(250);