DELETE FROM QUERY_MASTER WHERE CODE='covid19_admin_update_suggested_hospital';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
75398,  current_date , 75398,  current_date , 'covid19_admin_update_suggested_hospital', 
'admissionId,healthInfaId', 
'update covid19_admission_detail
set suggested_health_infra = #healthInfaId#
where id=#admissionId#', 
null, 
false, 'ACTIVE');