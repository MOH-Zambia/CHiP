alter table gvk_high_risk_follow_up_usr_info 
add column is_high_risk_condition_confirmed boolean, 
add column fhw_call_attempt integer;

ALTER TABLE public.gvk_high_risk_follow_up_usr_info
  ALTER COLUMN call_response_message TYPE text;


