drop table if exists imt_family_cfhc_done_by_details;


create table imt_family_cfhc_done_by_details (
	family_id varchar(255),
	user_id int not null,
	role_id int not null,
	created_by int not null,
	created_on timestamp not null,
	modified_by int not null,
	modified_on timestamp not null,
	primary key(family_id)
);


alter table location_wise_analytics
drop column if exists chfc_member_verified_by_fhw,
add column chfc_member_verified_by_fhw int,
drop column if exists chfc_member_verified_by_mphw,
add column chfc_member_verified_by_mphw int,
drop column if exists chfc_family_verified_by_fhw,
add column chfc_family_verified_by_fhw int,
drop column if exists chfc_family_verified_by_mphw,
add column chfc_family_verified_by_mphw int,
drop column if exists chfc_new_member_by_fhw,
add column chfc_new_member_by_fhw int,
drop column if exists chfc_new_member_by_mphw,
add column chfc_new_member_by_mphw int,
drop column if exists chfc_new_family_by_fhw,
add column chfc_new_family_by_fhw int,
drop column if exists chfc_new_family_by_mphw,
add column chfc_new_family_by_mphw int,
drop column if exists chfc_member_in_reverification_by_fhw,
add column chfc_member_in_reverification_by_fhw int,
drop column if exists chfc_member_in_reverification_by_mphw,
add column chfc_member_in_reverification_by_mphw int,
drop column if exists chfc_family_in_reverification_by_fhw,
add column chfc_family_in_reverification_by_fhw int,
drop column if exists chfc_family_in_reverification_by_mphw,
add column chfc_family_in_reverification_by_mphw int;