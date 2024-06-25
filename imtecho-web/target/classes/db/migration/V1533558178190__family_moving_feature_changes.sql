alter table menu_config alter column feature_json type text;

update menu_config  
    set feature_json  = '{"canSearchByLocation":false,"canSearchByFamilyId":true,"canSearchByMemberHealthId":true,"canSearchArchived":false,
	"canMarkUnverified":false}'
        where navigation_state = 'techo.manage.familymoving';