DELETE FROM QUERY_MASTER WHERE CODE='check_constant_validity_mobile_feature_master';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'095ca9c1-b995-47eb-80ce-00a1e3bae446', 74841,  current_date , 74841,  current_date , 'check_constant_validity_mobile_feature_master', 
'feature_name,is_edit,mobile_constant', 
'select case 
when #is_edit# and count(1) = 1 then true
when count(1) >= 1 then false else true end
as "isValid" from mobile_feature_master
where mobile_constant = ''#mobile_constant#''
or feature_name ilike ''#feature_name#'';', 
null, 
true, 'ACTIVE');