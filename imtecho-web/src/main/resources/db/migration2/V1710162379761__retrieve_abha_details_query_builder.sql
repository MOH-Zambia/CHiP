DELETE FROM QUERY_MASTER WHERE CODE='retrieve_abha_details_by_member_id';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'3011b7b4-250c-453f-8e52-993f728cec84', -1,  current_date , -1,  current_date , 'retrieve_abha_details_by_member_id',
'memberId',
'select * from ndhm_health_id_user_details where member_id = #memberId#',
'Retrieve ABHA Details by memberid',
true, 'ACTIVE');