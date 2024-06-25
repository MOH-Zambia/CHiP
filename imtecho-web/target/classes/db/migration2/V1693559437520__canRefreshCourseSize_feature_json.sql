update
	menu_config
set
	feature_json = cast(feature_json as jsonb) || jsonb '{"canRefreshCourseSize": false}'
where
	navigation_state  = 'techo.manage.courselist';