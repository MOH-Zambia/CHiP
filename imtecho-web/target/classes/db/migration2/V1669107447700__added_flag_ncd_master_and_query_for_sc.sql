ALTER TABLE IF EXISTS public.ncd_master
  ADD COLUMN IF NOT EXISTS flag boolean;


DELETE FROM QUERY_MASTER WHERE CODE='retrieve_all_sub_centers';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'2eb64314-c413-44e9-83da-0a34463ea64f', 97070,  current_date , 97070,  current_date , 'retrieve_all_sub_centers',
 null,
'select get_location_hierarchy(id) as name,id from location_master where type=''SC'' and is_active is true order by name',
null,
true, 'ACTIVE');