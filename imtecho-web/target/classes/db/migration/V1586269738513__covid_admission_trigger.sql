CREATE OR REPLACE FUNCTION covid19_addmission_insert_update_trigger_func()
  RETURNS trigger AS
$BODY$
BEGIN
	NEW.search_text = concat_ws(' ',NEW.first_name,NEW.middle_name,NEW.last_name,NEW.case_no,NEW.unit_no,NEW.opd_case_no,NEW.current_bed_no,NEW.contact_number,(select ward_name from health_infrastructure_ward_details where id = NEW.current_ward_id));
   RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;



DROP TRIGGER if exists covid19_admission_detail_trigger ON public.covid19_admission_detail;
CREATE TRIGGER covid19_admission_detail_trigger
  BEFORE UPDATE or INSERT
  ON public.covid19_admission_detail
  FOR EACH ROW
  EXECUTE PROCEDURE public.covid19_addmission_insert_update_trigger_func();

update covid19_admission_detail set status  = status;

