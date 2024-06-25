insert
	into
		soh_element_permissions( element_id, permission_type )
		select id, 'ALL' from soh_element_configuration where element_name != 'COVID_STATUS_REPORT'