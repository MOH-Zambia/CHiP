INSERT INTO public.query_master(     
                created_by, created_on, code, params, 
                query, returns_result_set, state, description)
    VALUES (1,localtimestamp,'retrival_listvalues_multimedia', '', 
            'select id,value from listvalue_field_value_detail where multimedia_type <> ''''', true, 'ACTIVE', 'retrieves all multimedia values');

INSERT INTO public.query_master(
            created_by, created_on, code, params, 
            query, returns_result_set, state, description)
    VALUES (1,localtimestamp,'update_values_inactive', 'idsToBeInActive', 
            'update listvalue_field_value_detail 
	set is_active=false
	where id in (#idsToBeInActive#)', false, 'ACTIVE', 'retrieves all multimedia values');