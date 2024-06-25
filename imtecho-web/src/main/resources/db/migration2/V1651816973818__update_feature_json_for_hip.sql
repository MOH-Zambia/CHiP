update
	menu_config
set
	feature_json = '{"isShowHealthIdModal":true,"isShowHIPModal":false, "canExamine":true}'
where
	menu_name = 'Referred Patients'
		and navigation_state = 'techo.ncd.members';


update
	menu_config
set
	feature_json = '{"isShowHealthIdModal":true,"isShowHIPModal":false}'
where
    menu_name = 'CMTC/NRC Child Screening'
		and navigation_state = 'techo.manage.childscreeninglist';


update
	menu_config
set
	feature_json = '{"isShowHealthIdModal":true,"isShowHIPModal":false, "canManageRegistration": true, "canManageTreatment": true, "canManageMedicines": true}'
where
    menu_name = 'Out-Patient Treatment (OPD)'
		and navigation_state = 'techo.manage.outPatientTreatmentSearch';
