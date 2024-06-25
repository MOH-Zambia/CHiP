begin;
alter table child_cmtc_nrc_admission_detail
alter column mid_upper_arm_circumference type numeric(6,2);
commit;

begin;
alter table child_cmtc_nrc_discharge_detail
alter column mid_upper_arm_circumference type numeric(6,2);
commit;

begin;
alter table child_cmtc_nrc_follow_up
alter column mid_upper_arm_circumference type numeric(6,2);
commit;

begin;
alter table child_cmtc_nrc_weight_detail
alter column mid_upper_arm_circumference type numeric(6,2);
commit;