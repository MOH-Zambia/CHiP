CREATE OR REPLACE FUNCTION public.covid19_addmission_delete_trigger_func()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
INSERT INTO zzz_delete_covid19_admission_detail
	select * from covid19_admission_detail where id = OLD.id;
   RETURN OLD;
END;
$function$;


CREATE OR REPLACE FUNCTION public.covid19_admission_refer_detail_delete_trigger_func()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
INSERT INTO zzz_delete_covid19_admission_refer_detail
	select * from covid19_admission_refer_detail where id = OLD.id;
   RETURN OLD;
END;
$function$;

CREATE OR REPLACE FUNCTION public.covid19_admitted_case_daily_status_delete_trigger_func()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
INSERT INTO zzz_delete_covid19_admitted_case_daily_status
	select * from covid19_admitted_case_daily_status where id = OLD.id;
   RETURN OLD;
END;
$function$;

CREATE OR REPLACE FUNCTION public.covid19_lab_test_detail_delete_trigger_func()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
INSERT INTO zzz_delete_covid19_lab_test_detail
	select * from covid19_lab_test_detail where id = OLD.id;
   RETURN OLD;
END;
$function$;


CREATE OR REPLACE FUNCTION public.create_entry_in_immunisation_archive()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
begin

case when TG_OP = 'DELETE' 
then INSERT INTO rch_immunisation_master_archive(id, member_id, member_type, visit_type, visit_id, notification_id, 
            immunisation_given, given_on, given_by, created_by, created_on, 
            modified_by, modified_on, family_id, location_id, location_hierarchy_id, 
            pregnancy_reg_det_id)
    VALUES (old.id, old.member_id, old.member_type, old.visit_type, old.visit_id, old.notification_id, 
            old.immunisation_given, old.given_on, old.given_by, old.created_by, old.created_on, 
            old.modified_by, old.modified_on, old.family_id, old.location_id, old.location_hierarchy_id, 
            old.pregnancy_reg_det_id);end case;
    return old;
end;
$function$;


CREATE OR REPLACE FUNCTION public.delete_rch_member_death_detail_trigger_func()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
begin
case when TG_OP = 'DELETE' then 
    INSERT INTO rch_member_death_deatil_archive(
            id, member_id, family_id, dod, created_on, created_by, death_reason, 
            place_of_death, location_id, location_hierarchy_id, other_death_reason)
    VALUES (OLD.id, OLD.member_id, OLD.family_id, OLD.dod, OLD.created_on, OLD.created_by, OLD.death_reason
    ,OLD.place_of_death,OLD.location_id,OLD.location_hierarchy_id,OLD.other_death_reason);
end case;
return old;
end;
$function$;

CREATE OR REPLACE FUNCTION public.imt_member_delete_trigger_function()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN

INSERT INTO imt_member_archive
    SELECT OLD.*;

RETURN NULL;
END$function$;


CREATE OR REPLACE FUNCTION public.rch_lmp_follow_up_delete_trigger_function()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN

INSERT INTO rch_lmp_follow_up_archive
    SELECT OLD.*;

RETURN NULL;
END$function$;

CREATE OR REPLACE FUNCTION public.rch_pnc_master_delete_trigger_function()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN

INSERT INTO rch_pnc_master_archive
    SELECT OLD.*;

RETURN NULL;
END$function$;

CREATE OR REPLACE FUNCTION public.rch_pregnancy_registration_det_delete_trigger_function()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN

INSERT INTO rch_pregnancy_registration_det_archive
    SELECT OLD.*;

RETURN NULL;
END$function$;


CREATE OR REPLACE FUNCTION public.rch_wpd_mother_master_delete_trigger_function()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN

INSERT INTO rch_wpd_mother_master_archive
    SELECT OLD.*;

RETURN NULL;
END$function$;