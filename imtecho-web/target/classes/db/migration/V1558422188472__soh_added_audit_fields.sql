alter table soh_user
add column created_by bigint NOT NULL default -1;

alter table soh_user
add column created_on timestamp without time zone NOT NULL default now();

alter table soh_user
add column modified_by bigint;

alter table soh_user
add column modified_on timestamp without time zone;

alter table soh_user
add otp character varying(50);

update um_role_master set code ='SOH_USER' WHERE id=192;