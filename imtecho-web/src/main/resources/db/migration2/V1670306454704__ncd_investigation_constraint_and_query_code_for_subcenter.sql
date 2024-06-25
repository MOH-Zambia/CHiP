ALTER TABLE IF EXISTS ncd_member_investigation_detail DROP CONSTRAINT IF EXISTS ncd_member_investigation_unique;

ALTER TABLE IF EXISTS ncd_member_investigation_detail
ADD CONSTRAINT ncd_member_investigation_unique UNIQUE (member_id, screening_date, report);


DELETE FROM QUERY_MASTER WHERE CODE='retrieve_all_sub_centers';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'2eb64314-c413-44e9-83da-0a34463ea64f', 97070,  current_date , 97070,  current_date , 'retrieve_all_sub_centers',
'userId',
'select get_location_hierarchy(id) as name,id from location_master where type=''SC'' and is_active is true and id in (select child_id
    from location_hierchy_closer_det
    where parent_id in (select uul.loc_id
	from um_user_location uul where uul.user_id = #userId# and state=''ACTIVE'')) order by name',
null,
true, 'ACTIVE');