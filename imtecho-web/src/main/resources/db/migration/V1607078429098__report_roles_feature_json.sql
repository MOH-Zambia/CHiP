update menu_config
set feature_json = '{"basic":true,"advanced":false}'
where menu_name = 'Reports' and navigation_state = 'techo.report.all';