alter table drtecho_health_facility_reg
add column action_by bigint;

alter table drtecho_health_facility_reg
add column  action_on timestamp without time zone;

alter table drtecho_health_facility_reg
add column dr_techo_User_Id bigint;