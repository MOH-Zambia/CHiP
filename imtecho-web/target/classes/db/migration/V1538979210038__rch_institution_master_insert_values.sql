INSERT INTO rch_institution_master(name,location_id,type)
SELECT name,id,type FROM location_master where type='SC' or type='P';
update rch_institution_master 
set is_location=true,state='active',created_on=NOW()::timestamp,created_by=1,modified_by=1,modified_on=NOW()::timestamp;