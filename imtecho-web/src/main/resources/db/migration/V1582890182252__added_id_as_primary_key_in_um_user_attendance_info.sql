alter table um_user_attendance_info
drop constraint if exists um_user_attendance_info_pkey,
add primary key (id);