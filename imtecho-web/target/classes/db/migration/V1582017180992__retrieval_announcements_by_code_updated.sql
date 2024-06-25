-- for issue https://argusgit.argusoft.com/mhealth-projects/imtecho/issues/3172

update query_master
    set modified_by = 1,
        modified_on = now(),
        params = 'lastUpdatedOn,userType,userId',
        query = 'select id, subject, from_date, is_active, default_language, file_extension, contains_multimedia, media_path, modified_on from announcement_info_master as aim
            left join announcement_info_detail as aid on aim.id = aid.announcement 
            where id in (select announcement from announcement_location_detail,location_hierchy_closer_det lh ,um_user_location uml
            where lh.parent_id = location and uml.user_id = #userId# and lh.child_id = uml.loc_id and uml.state = ''ACTIVE'' 
            and announcement_for in (''#userType#'') and is_active = true) 
            and from_date < now() and modified_on >= cast((case when ''#lastUpdatedOn#'' = ''null'' 
            then ''1970-01-01 05:30:00.0'' else ''#lastUpdatedOn#'' end) as timestamp)'
        where code = 'retrieval_announcements'