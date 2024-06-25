delete from user_menu_item where menu_config_id in (select id from menu_config where menu_name = 'Timeline Configuration');

delete from menu_config where id in (select id from menu_config where menu_name = 'Timeline Configuration');

INSERT INTO  menu_config(
                active, menu_name, navigation_state, menu_type, feature_json) 
        VALUES('TRUE','Timeline Configuration', 'techo.manage.timelineconfigs', 'manage',
                '{"canModifyMasterTimeline":false, "canModifyEnglishTimeline":false, "canModifyHindiTimeline":false,
                "canModifyGujaratiTimeline":false}');      