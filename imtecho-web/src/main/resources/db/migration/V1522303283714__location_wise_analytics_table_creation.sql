CREATE TABLE if not exists location_wise_analytics
(
   loc_id bigint, 
   fhs_imported_from_emamta_family integer, 
   fhs_imported_from_emamta_member integer, 
   fhs_to_be_processed_family integer, 
   fhs_verified_family integer, 
   fhs_archived_family integer, 
   fhs_new_family integer, 
   fhs_total_member integer, 
   fhs_inreverification_family integer, 
   PRIMARY KEY (loc_id)
);

insert into location_wise_analytics (loc_id)
select id from location_master;
