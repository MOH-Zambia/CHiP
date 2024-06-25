DELETE FROM QUERY_MASTER WHERE CODE='fetch_stock_requests_by_infra_id';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'fc0e7c25-c8cc-44a5-aeb7-d68fe3eb23ec', 60512,  current_date , 60512,  current_date , 'fetch_stock_requests_by_infra_id',
'infraId',
'SELECT
    CONCAT(um_user.first_name, '' '', um_user.middle_name, '' '', um_user.last_name) AS username,
 	 CONCAT(
        ''['',
        STRING_AGG(
            CONCAT(
                ''{"medicine_name": "'', lffd.value, ''", "medicineQuantity": '', CAST(smr.quantity AS VARCHAR), '', "medicineId": '' ,lffd.id ,  ''}''
            ),
            '',''
        ),
        '']''
    ) AS medicine_data,
    smd.id
FROM
    stock_management_details smd
JOIN
    um_user ON smd.requested_by  = um_user.id
join
    stock_medicines_rel smr on smr.id = smd.id
LEFT JOIN
    listvalue_field_value_detail lffd ON lffd.id = smr.medicine_id
WHERE
    smd.health_infra_id = #infraId# and smr.status = ''REQUESTED''
GROUP BY
    um_user.first_name,
    um_user.middle_name,
    um_user.last_name,
    um_user.id ,
    smd.id',
null,
true, 'ACTIVE');