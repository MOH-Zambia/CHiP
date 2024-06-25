DELETE FROM QUERY_MASTER WHERE CODE='dr_techo_rbsk_child_search_by_family_id_1';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'd3ed8454-3e10-4837-be3f-498389248d25', 74909,  current_date , 74909,  current_date , 'dr_techo_rbsk_child_search_by_family_id_1',
'familyId',
'select
	child.id as "memberId",
	child.unique_health_id as "uniqueHealthId",
	child.first_name as "firstName",
	child.middle_name as "middleName",
	child.last_name as "lastName",
	child.family_id as "familyId",
	child.gender,
	child.dob,
	child.birth_weight as "weight",
	mother.unique_health_id as "motherId",
	mother.mobile_number as "motherPhoneNumber",
	concat( mother.first_name, '' '', mother.middle_name, '' '', mother.last_name ) as "motherName"
from
	imt_member child
inner join imt_member mother on
	child.mother_id = mother.id
where
	child.family_id in ( #familyId# )',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='dr_techo_rbsk_child_search_by_member_id_1';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'5d628790-7e89-43db-9a28-07a26f37c84e', 74909,  current_date , 74909,  current_date , 'dr_techo_rbsk_child_search_by_member_id_1',
'uniqueHealthId',
'select
	child.id as "memberId",
	child.unique_health_id as "uniqueHealthId",
	child.first_name as "firstName",
	child.middle_name as "middleName",
	child.last_name as "lastName",
	child.family_id as "familyId",
	child.gender,
	child.dob,
	child.birth_weight as "weight",
	mother.unique_health_id as "motherId",
	mother.mobile_number as "motherPhoneNumber",
	concat( mother.first_name, '' '', mother.middle_name, '' '', mother.last_name ) as "motherName"
from
	imt_member child
inner join imt_member mother on
	child.mother_id = mother.id
where
	child.unique_health_id in ( #uniqueHealthId# )',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='update_user_pin_1';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'902feb83-aa1c-48fe-be56-9eda813aaaf4', 74909,  current_date , 74909,  current_date , 'update_user_pin_1',
'pin,id',
'UPDATE um_user SET pin = #pin# ,modified_on = now() WHERE id = #id#;',
null,
false, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='dr_techo_retrieve_by_mobile_number_1';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'56706199-6d4b-4ae5-a95f-0a9ffd823f98', 74909,  current_date , 74909,  current_date , 'dr_techo_retrieve_by_mobile_number_1',
'mobileNumber',
'select id as "memberId",
unique_health_id as "uniqueHealthId",
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

DELETE FROM QUERY_MASTER WHERE CODE='dr_techo_retrieve_by_family_id_1';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'd0469b82-8f98-4402-9c84-9c10ed5fb5f2', 74909,  current_date , 74909,  current_date , 'dr_techo_retrieve_by_family_id_1',
'familyId',
'select id as "memberId",
unique_health_id as "uniqueHealthId",
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

DELETE FROM QUERY_MASTER WHERE CODE='dr_techo_retrieve_by_unique_health_id_1';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'710df376-5f55-4745-8121-aa46cafc3cab', 74909,  current_date , 74909,  current_date , 'dr_techo_retrieve_by_unique_health_id_1',
'uniqueHealthId',
'select id as "memberId",
unique_health_id as "uniqueHealthId",
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


DELETE FROM QUERY_MASTER WHERE CODE='dr_techo_rbsk_child_search_by_mobile_number_1';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'48ccc861-381b-42f6-b654-992c3eac7317', 74909,  current_date , 74909,  current_date , 'dr_techo_rbsk_child_search_by_mobile_number_1',
'mobileNumber',
'with mother_details as ( select
	id, unique_health_id, mobile_number, concat( first_name, '' '', middle_name, '' '', last_name ) as mother_name
from
	imt_member
where
	mobile_number in ( #mobileNumber# ) ) select
	child.id as "memberId",
	child.unique_health_id as "uniqueHealthId",
	child.first_name as "firstName",
	child.middle_name as "middleName",
	child.last_name as "lastName",
	child.family_id as "familyId",
	child.gender,
	child.dob,
	child.birth_weight as "weight",
	mother.unique_health_id as "motherId",
	mother.mobile_number as "motherPhoneNumber",
	mother.mother_name as "motherName"
from
	imt_member child
inner join mother_details mother on
	child.mother_id = mother.id
where
	child.mother_id in ( select
		id
	from
		mother_details )',
null,
true, 'ACTIVE');