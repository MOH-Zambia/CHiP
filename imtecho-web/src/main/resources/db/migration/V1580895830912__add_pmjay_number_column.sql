alter table imt_member_cfhc_master
drop column if exists pmjay_number,
add column pmjay_number character varying(9);
