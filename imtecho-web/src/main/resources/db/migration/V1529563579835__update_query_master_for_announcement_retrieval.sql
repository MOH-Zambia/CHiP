update query_master set query = 'select id, subject, from_date, is_active, default_language, file_extension from announcement_info_master as aim
        left join announcement_info_detail as aid on aim.id = aid.announcement 
        where id in (select announcement from announcement_location_detail,location_hierchy_closer_det lh ,um_user_location uml
        where lh.parent_id = location and uml.user_id = #userId# and lh.child_id = uml.loc_id and uml.state = ''ACTIVE'' 
        and announcement_for in (''#userType#'') and is_active = true) and from_date < now()' where code = 'retrieval_announcements';