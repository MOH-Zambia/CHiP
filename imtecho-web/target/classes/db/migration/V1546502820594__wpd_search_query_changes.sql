alter table rch_pregnancy_registration_det 
drop column if exists current_location_id,
add column current_location_id bigint;

drop index if exists current_location_state_index;
create index current_location_state_index
on rch_pregnancy_registration_det(current_location_id,state);

CREATE OR REPLACE FUNCTION public.update_notification_info_on_member_family_change()
  RETURNS trigger AS
$BODY$
DECLARE
  area_id_new bigint;
  
begin
    area_id_new := CAST((select area_id from imt_family where family_id = new.family_id) as bigint);
    case    
	when 
	    new.family_id != old.family_id
	then 
      	    --UPDATING MOBILE NOTIFICATIONS
            case 
                when 
                    area_id_new is null or area_id_new = '-1' 
                then
                    update techo_notification_master set location_id = (select f.location_id 
                    from imt_family f where family_id = new.family_id), modified_on = now() where 
                    (location_id  = (select CAST(area_id as bigint) from imt_family where family_id = old.family_id) or
                    location_id  = (select location_id from imt_family where family_id = old.family_id))
                    and member_id = new.id;

                    update techo_web_notification_master set location_id = (select f.location_id 
                    from imt_family f where family_id = new.family_id), modified_on = now() where 
                    (location_id  = (select CAST(area_id as bigint) from imt_family where family_id = old.family_id) or
                    location_id  = (select location_id from imt_family where family_id = old.family_id)) 
                    and member_id = new.id and notification_type_id in (select id from notification_type_master where notification_for = 'MEMBER');
	    --UPDATING WEB NOTIFICATIONS
                else
                    update techo_notification_master set location_id = area_id_new, modified_on = now() 
                    where (location_id  = (select CAST(area_id as bigint) from imt_family where family_id = old.family_id) or
                    location_id  = (select location_id from imt_family where family_id = old.family_id))  
                    and member_id = new.id;

                    update techo_web_notification_master set location_id = area_id_new, modified_on = now() 
                    where (location_id  = (select CAST(area_id as bigint) from imt_family where family_id = old.family_id) or
                    location_id  = (select location_id from imt_family where family_id = old.family_id))  
                    and member_id = new.id and notification_type_id in (select id from notification_type_master where notification_for = 'MEMBER');

                    update rch_pregnancy_registration_det set current_location_id = area_id_new where member_id = new.id
                    and rch_pregnancy_registration_det.state IN ('PREGNANT','PENDING') ;

                end case;
	else
            return new;
    end case;
    return new;
end
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
