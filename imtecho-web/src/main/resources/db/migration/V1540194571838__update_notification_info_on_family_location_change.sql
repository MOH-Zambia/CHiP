CREATE OR REPLACE FUNCTION public.update_notification_info_on_family_location_change()
  RETURNS trigger AS
$BODY$
begin
    case
        when 
	    new.area_id is null and old.area_id is not null
	then 
	    --UPDATING MOBILE NOTIFICATIONS
	    update techo_notification_master set location_id = new.location_id, modified_on = now()
	    where location_id  = CAST(old.area_id as bigint) and member_id in (select id from imt_member where family_id = old.family_id);
	    --UPDATING WEB NOTIFICATIONS
            update techo_web_notification_master set location_id = new.location_id, modified_on = now()
	    where location_id  = CAST(old.area_id as bigint) and member_id in (select id from imt_member where family_id = old.family_id) and
	    notification_type_id in (select id from notification_type_master where notification_for = 'MEMBER');
	when 
	    new.area_id != old.area_id
	then 
            --UPDATING MOBILE NOTIFICATIONS
	    update techo_notification_master set location_id = CAST(new.area_id as bigint), modified_on = now()
	    where location_id  = CAST(old.area_id as bigint) and member_id in (select id from imt_member where family_id = old.family_id);
	    --UPDATING WEB NOTIFICATIONS
            update techo_web_notification_master set location_id = CAST(new.area_id as bigint), modified_on = now()
	    where location_id  = CAST(old.area_id as bigint) and member_id in (select id from imt_member where family_id = old.family_id) and
	    notification_type_id in (select id from notification_type_master where notification_for = 'MEMBER');
	else
		return new;
    end case;
    return new;
end
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

DROP TRIGGER IF EXISTS update_notification_info_on_family_location_change ON public.imt_family;

CREATE TRIGGER update_notification_info_on_family_location_change
  AFTER UPDATE
  ON public.imt_family
  FOR EACH ROW
  EXECUTE PROCEDURE public.update_notification_info_on_family_location_change();