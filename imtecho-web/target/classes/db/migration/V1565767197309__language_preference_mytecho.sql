ALTER TABLE mytecho_user
DROP COLUMN IF EXISTS language_preference,
ADD COLUMN language_preference varchar(5);

update mytecho_user set language_preference = 'EN';