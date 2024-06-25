delete from query_master where code='family_move_location_by_familyids';
INSERT INTO public.query_master(
            created_by, created_on, modified_by, modified_on, code, params, 
            query, returns_result_set, state, description)
VALUES(-1,now(),-1,now(),'family_move_location_by_familyids','location_id,family_ids,user_id',
'update public.imt_family set location_id=#location_id# ,modified_by =#user_id#,modified_on=now()
where family_id in(#family_ids#);'
,true,'ACTIVE','It will call User move family list to another location.');

INSERT INTO menu_config (menu_name, menu_type, active, navigation_state,feature_json) values 
('Family Moving','manage',TRUE,'techo.manage.familymoving','{"canSearchByLocation":false,"canSearchByFamilyId":true,"canSearchByMemberHealthId":true}');
