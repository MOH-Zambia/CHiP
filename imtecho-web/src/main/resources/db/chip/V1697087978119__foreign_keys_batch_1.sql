alter table health_infrastructure_details
add constraint fk_health_infrastructure_details_location_master
foreign key (location_id) references location_master (id);

alter table imt_family
add constraint fk_imt_family_location_master_1
foreign key (location_id) references location_master (id);

alter table imt_family
add constraint fk_imt_family_location_master_2
foreign key (area_id) references location_master (id);

alter table rch_child_service_master
add constraint fk_rch_child_service_master_location_master
foreign key (location_id) references location_master (id);

alter table rch_immunisation_master
add constraint fk_rch_immunisation_master_location_master
foreign key (location_id) references location_master (id);

alter table um_user
add constraint fk_um_user_um_role_master
foreign key (role_id) references um_role_master (id);

alter table um_user_location
add constraint fk_um_user_location_location_master
foreign key (loc_id) references location_master (id);