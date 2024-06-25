DELETE FROM QUERY_MASTER WHERE CODE='get_wpd_id_by_member_id_and_delivery_date';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'b1115134-609e-400b-aa37-3debefb67c24', 80316,  current_date , 80316,  current_date , 'get_wpd_id_by_member_id_and_delivery_date',
'memberId',
'select id from rch_wpd_mother_master where member_id = #memberId#  order by id desc limit 1',
null,
true, 'ACTIVE');