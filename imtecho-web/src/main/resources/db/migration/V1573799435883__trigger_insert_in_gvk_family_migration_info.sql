--Create Function Which Will Be Executed On Trigger

CREATE OR REPLACE FUNCTION insert_in_gvk_family_migration_info()
RETURNS trigger AS
$BODY$
begin

if NEW.state = 'REPORTED'
and NEW.type = 'OUT' and (NEW.out_of_state = false or NEW.out_of_state is null)
and NEW.migrated_location_not_known = true 
 then
	insert into gvk_family_migration_info (family_migration_id , created_by ,  created_on , modified_by , modified_on , gvk_call_status  , call_attempt , schedule_date )
	Values ( NEW.id,  -1  , now() , -1  ,now() , 'com.argusoft.imtecho.gvk.call.to-be-processed' , 0 , now() );
end if;
return new;
end;
$BODY$
  LANGUAGE plpgsql VOLATILE;




--Create Trigger

CREATE TRIGGER insert_in_gvk_family_migration_info
    AFTER INSERT ON imt_family_migration_master
    FOR EACH ROW 
    EXECUTE PROCEDURE insert_in_gvk_family_migration_info();
