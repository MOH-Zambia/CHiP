CREATE OR REPLACE FUNCTION public.update_form_master_info_on_notification_type_add_or_update()
  RETURNS trigger AS
$BODY$
begin
	if  (TG_OP = 'INSERT') then
		insert into form_master (created_by,created_on,modified_by,modified_on,code,name,state)
		values (new.created_by,now(),new.modified_by,now(),new.code,new.name,new.state);
	else 
           update form_master set modified_by=new.modified_by, modified_on= now(), code=new.code, name=new.name, state=new.state
           where code = old.code;
	end if;
	
	return new;
end
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

DROP TRIGGER IF EXISTS update_form_master_info_on_notification_type_add_or_update ON public.notification_type_master;

CREATE TRIGGER update_form_master_info_on_notification_type_add_or_update
  AFTER INSERT OR UPDATE
  ON public.notification_type_master
  FOR EACH ROW
  EXECUTE PROCEDURE public.update_form_master_info_on_notification_type_add_or_update();