DELETE FROM QUERY_MASTER WHERE CODE='dr_techo_retrieve_by_family_id_1';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'd0469b82-8f98-4402-9c84-9c10ed5fb5f2', 74909,  current_date , 74909,  current_date , 'dr_techo_retrieve_by_family_id_1',
'familyId',
'select id as "memberId",
unique_health_id as "uniqueHealthId",
family_id as "familyId",
first_name as "firstName",
middle_name as "middleName",
last_name as "lastName",
gender,
dob,
mobile_number as "mobileNumber",
marital_status as "maritalStatus"
from imt_member where family_id = #familyId#',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='dr_techo_retrieve_by_mobile_number_1';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'56706199-6d4b-4ae5-a95f-0a9ffd823f98', 74909,  current_date , 74909,  current_date , 'dr_techo_retrieve_by_mobile_number_1',
'mobileNumber',
'select id as "memberId",
unique_health_id as "uniqueHealthId",
family_id as "familyId",
first_name as "firstName",
middle_name as "middleName",
last_name as "lastName",
gender,
dob,
mobile_number as "mobileNumber",
marital_status as "maritalStatus"
from imt_member where family_id in (select family_id from imt_member where mobile_number = #mobileNumber#)',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='dr_techo_retrieve_by_unique_health_id_1';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'710df376-5f55-4745-8121-aa46cafc3cab', 74909,  current_date , 74909,  current_date , 'dr_techo_retrieve_by_unique_health_id_1',
'uniqueHealthId',
'select id as "memberId",
unique_health_id as "uniqueHealthId",
family_id as "familyId",
first_name as "firstName",
middle_name as "middleName",
last_name as "lastName",
gender,
dob,
mobile_number as "mobileNumber",
marital_status as "maritalStatus"
from imt_member
where unique_health_id in (#uniqueHealthId#)',
null,
true, 'ACTIVE');