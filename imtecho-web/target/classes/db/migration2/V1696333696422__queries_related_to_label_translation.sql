INSERT INTO public.menu_config (feature_json,group_id,active,is_dynamic_report,menu_name,navigation_state,sub_group_id,menu_type,only_admin,menu_display_order,uuid,group_name_uuid,sub_group_uuid,description) VALUES
	 ('{"canManage":false, "canViewKey":false}',NULL,true,NULL,'Manage Translation','techo.manage.manageTranslation',NULL,'admin',NULL,NULL,NULL,NULL,NULL,NULL);

create table if not exists temp_translation (
	id serial NOT NULL,
	app smallint NULL,
	key varchar NULL,
	value varchar NULL,
	CONSTRAINT temp_translation_pkey PRIMARY KEY (id)
);