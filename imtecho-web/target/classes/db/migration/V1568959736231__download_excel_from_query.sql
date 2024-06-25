delete from user_menu_item where menu_config_id in (select id from menu_config where menu_name = 'Query Excel Sheet Genereator');

delete from menu_config where id in (select id from menu_config where menu_name = 'Query Excel Sheet Genereator');

INSERT INTO  menu_config(
                active, menu_name, navigation_state, menu_type) 
        VALUES('TRUE','Query Excel Sheet Genereator', 'techo.manage.queryexcelsheetgenerator', 'admin');