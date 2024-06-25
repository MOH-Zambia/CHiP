--add reason column to stock_medicines_rel table 
alter table if exists stock_medicines_rel 
add column if not exists reason text;

--update query to return results in order and based on status of the requests

DELETE FROM QUERY_MASTER WHERE CODE='fetch_stock_requests_by_infra_id';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'fc0e7c25-c8cc-44a5-aeb7-d68fe3eb23ec', 97105,  current_date , 97105,  current_date , 'fetch_stock_requests_by_infra_id', 
'offset,limit,infraId,status', 
'SELECT
    CONCAT(um_user.first_name, '' '', um_user.middle_name, '' '', um_user.last_name) AS username,
 	 CONCAT(
        ''['',
        STRING_AGG(
            CONCAT(
                ''{"medicine_name": "'', lffd.value, ''", "medicineQuantity": '', CAST(smr.quantity AS VARCHAR), 
                '', "medicineId": '' ,lffd.id ,'', "in_stock": '',sie.medicine_stock_amount - sie.used ,'', "inventoryId" :'',sie.id ,'', "reason": "'',smr.reason,''", "approved_qty" : '',smr.approved_qty , ''}''
            ),
            '',''
        ),
        '']''
    ) AS medicine_data,
    smd.id,
    smr.status
FROM
    stock_management_details smd
JOIN
    um_user ON smd.requested_by  = um_user.id
join
    stock_medicines_rel smr on smr.id = smd.id
inner join
	stock_inventory_entity sie on sie.requested_by = um_user.id and sie.medicine_id = smr.medicine_id
LEFT JOIN
    listvalue_field_value_detail lffd ON lffd.id = smr.medicine_id
WHERE
    smd.health_infra_id = #infraId# and
    case when #status# = ''APPROVED'' then smr.status in (''APPROVED'', ''ACKNOWLEDGED'')
    else #status# = smr.status end
GROUP BY
    um_user.first_name,
    um_user.middle_name,
    um_user.last_name,
    um_user.id ,
    smd.id,
    smr.status

 order by smd.created_on desc
limit #limit# offset #offset#',
'N/A',
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='fetch_users_for_inventory_list';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'932171e5-e46d-467c-94db-be1b9602f97f', 97105,  current_date , 97105,  current_date , 'fetch_users_for_inventory_list',
'user_id',
'select CONCAT(uu.first_name, '' '', uu.middle_name, '' '', uu.last_name) AS username , uu.id as user_id from um_user uu
inner join health_infrastructure_details hid
on ( select infrastructure_id from um_user where id = #user_id#) = hid.id
and uu.id != #user_id#',
'used to fetch list of users for updating inventory of medicines',
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='fetch_medicine_for_user';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'9bd1b6ba-0d33-4058-acf0-433370787238', 97105,  current_date , 97105,  current_date , 'fetch_medicine_for_user',
'user_id',
'select value as medicine_name, lfvd.id as medicine_id , (sie.medicine_stock_amount - sie.used ) as in_stock ,
sie.id as inventory_id
 from listvalue_field_value_detail lfvd
inner join stock_inventory_entity sie on sie.medicine_id = lfvd.id and sie.requested_by = #user_id#
where field_key = ''listOfMedicines'';',
'User for fetching list of medicines for a user',
true, 'ACTIVE');