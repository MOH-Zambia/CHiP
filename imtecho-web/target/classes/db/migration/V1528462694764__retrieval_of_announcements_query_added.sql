INSERT INTO public.query_master(
    created_by, created_on, code, params, query, returns_result_set, state, description)
    VALUES (1, localtimestamp, 'retrieval_announcements', 'userId,userType', 
        'select id, subject, from_date, is_active, language, file_extension from announcement_info_master as aim
        inner join announcement_info_detail as aid on aim.id = aid.announcement 
        where id in (select announcement from announcement_location_detail 
        where location in (select loc_id from um_user_location where user_id = #userId#) 
        and announcement_for in (''#userType#'', ''A'') and is_active = true)', 
        true, 'ACTIVE', 'retrieve all announcement for user');