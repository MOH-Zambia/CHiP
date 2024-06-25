INSERT INTO public.query_master(
    created_by, created_on, code, params, query, returns_result_set, state, description)
    VALUES (1, localtimestamp, 'retrieval_deleted_families', 'user_id,modified_on', 
        'select family_id from imt_family_location_change_detail where from_location_id in 
        (select child_id from location_hierchy_closer_det where parent_id in 
        (select loc_id from um_user_location where user_id = #user_id# and state = ''ACTIVE''))
        and (''#modified_on#'' = ''null'' or created_on >= ''#modified_on#'')', 
        true, 'ACTIVE', 'retrieve all deleted families for user');