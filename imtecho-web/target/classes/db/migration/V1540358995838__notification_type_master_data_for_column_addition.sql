alter TABLE  notification_type_master
drop column if exists data_for,
add column data_for text;