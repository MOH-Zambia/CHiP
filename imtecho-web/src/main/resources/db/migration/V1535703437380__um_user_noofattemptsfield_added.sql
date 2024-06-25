alter table um_user
drop column if exists no_of_attempts, 
add column no_of_attempts integer;