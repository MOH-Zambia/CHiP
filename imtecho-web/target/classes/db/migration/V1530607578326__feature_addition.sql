update menu_config  
    set feature_json  = '{"canMarkAttendance":false}'
        where navigation_state = 'techo.training.scheduled';