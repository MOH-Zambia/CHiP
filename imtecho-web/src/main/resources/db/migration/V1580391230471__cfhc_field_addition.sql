alter table imt_member_cfhc_master
drop column if exists currently_using_fp_method,
drop column if exists change_fp_method,
drop column if exists fp_method_used,
drop column if exists fp_insert_operate_date,
add column currently_using_fp_method boolean,
add column change_fp_method boolean,
add column fp_method character varying(50),
add column fp_insert_operate_date date;