DELETE FROM QUERY_MASTER WHERE CODE='insert_remaining_medicine_req';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'67fe580b-1250-4cd1-a36a-68b6cd217031', 97105,  current_date , 97105,  current_date , 'insert_remaining_medicine_req', 
'quantity,medicineId,id,loggedInUserId,userId,infraId', 
'INSERT INTO stock_medicines_rel (id, medicine_id, quantity, status, approved_qty)
    VALUES (#id#, #medicineId#, #quantity#, ''REQUESTED'', 0);

INSERT INTO stock_management_details (id, requested_by, health_infra_id, created_by, created_on, modified_by, modified_on)
SELECT 
    #id#,
    #userId#,
    #infraId#,
    #loggedInUserId#,
    NOW(),
    #loggedInUserId#,
    now()
WHERE not EXISTS (SELECT 1 FROM stock_management_details WHERE id = #id#);', 
'create request for remaining qty of stock', 
false, 'ACTIVE');