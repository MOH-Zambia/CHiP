alter table covid19_lab_infrastructure_kit_history
drop column received_from,
add column received_from integer;

DELETE FROM listvalue_field_value_detail WHERE field_key = 'testing_kit_supplier';
DELETE FROM listvalue_field_master WHERE field_key = 'testing_kit_supplier';

INSERT INTO listvalue_field_master (field_key, field, is_active, field_type, form, role_type) 
VALUES('testing_kit_supplier', 'Testing Kit Supplier', true, 'T', 'WEB', NULL);

INSERT INTO listvalue_field_value_detail (is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code) 
VALUES(true, false, 'nvora', now(), 'Local Hospital Purchase', 'testing_kit_supplier', 0, NULL, NULL),
(true, false, 'nvora', now(), 'ICMR', 'testing_kit_supplier', 0, NULL, NULL),
(true, false, 'nvora', now(), 'GMSCL', 'testing_kit_supplier', 0, NULL, NULL),
(true, false, 'nvora', now(), 'Other Labs', 'testing_kit_supplier', 0, NULL, NULL);

DELETE FROM QUERY_MASTER WHERE CODE='covid19_retrieve_lab_infrastructure_testing_details';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'45aae210-9890-4721-b008-4f514cbccb25', 79677,  current_date , 79677,  current_date , 'covid19_retrieve_lab_infrastructure_testing_details', 
'healthInfraId', 
'select clikh.receipt_date as "receiptDate",
lfvd.value as "receivedFrom",
clikh.list_of_kits as "kitsList"
from covid19_lab_infrastructure_kit_history clikh
left join listvalue_field_value_detail lfvd on lfvd.id = clikh.received_from
where clikh.health_infra_id = #healthInfraId#;', 
null, 
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='covid19_retrieve_kit_sender_list';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'415a3a4d-e93b-43b2-9cec-26cf977508d3', 79677,  current_date , 79677,  current_date , 'covid19_retrieve_kit_sender_list', 
 null, 
'select id, value from listvalue_field_value_detail where field_key = ''testing_kit_supplier'';', 
null, 
true, 'ACTIVE');