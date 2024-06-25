update
	menu_config
set
	feature_json = '{"isShowHealthIdModal":false,"isShowHIPModal":false, "isShowConsentList": false}'
where
	(menu_name = 'ANC Service Visit'
		and navigation_state = 'techo.manage.ancSearch')
	or (menu_name = 'Institutional Delivery Reg. Form'
		and navigation_state = 'techo.manage.wpdSearch');
