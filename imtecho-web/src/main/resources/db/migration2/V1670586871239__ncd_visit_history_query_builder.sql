DELETE FROM QUERY_MASTER WHERE CODE='ncd_patient_visit_history_by_member_id';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'c6b8bc7e-ba12-49bf-aa4c-e121e59f75d0', 97070,  current_date , 97070,  current_date , 'ncd_patient_visit_history_by_member_id',
'memberId',
'select member_id,visit_date,disease_code "diseaseCode",status,reading,concat(visit_by,'': '',um_user.first_name,'' '',um_user.last_name) "DiagnosedBy" from ncd_visit_history
inner join um_user on ncd_visit_history.created_by = um_user.id
where member_id= #memberId#',
null,
true, 'ACTIVE');