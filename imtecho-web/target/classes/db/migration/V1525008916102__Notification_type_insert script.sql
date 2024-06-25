iNSERT INTO public.notification_type_master(
            created_by, created_on, modified_by, modified_on, code, name, 
            type, role_id, state)
    VALUES ( 1,now(), 1, now(), 'LMPFU', 'LMP Follow Up','MO',(select id from um_role_master where code = 'FHW'),'ACTIVE' 
);

INSERT INTO public.notification_type_master(
            created_by, created_on, modified_by, modified_on, code, name, 
            type, role_id, state)
    VALUES ( 1,now(), 1, now(), 'FHW_ANC', 'FHW ANC','MO',(select id from um_role_master where code = 'FHW'),'ACTIVE' 
);


INSERT INTO public.notification_type_master(
            created_by, created_on, modified_by, modified_on, code, name, 
            type, role_id, state)
    VALUES ( 1,now(), 1, now(), 'FHW_PNC', 'FHW PNC','MO',(select id from um_role_master where code = 'FHW'),'ACTIVE' 
);


INSERT INTO public.notification_type_master(
            created_by, created_on, modified_by, modified_on, code, name, 
            type, role_id, state)
    VALUES ( 1,now(), 1, now(), 'FHW_CS', 'FHW CHild Service','MO',(select id from um_role_master where code = 'FHW'),'ACTIVE' 
);

INSERT INTO public.notification_type_master(
            created_by, created_on, modified_by, modified_on, code, name, 
            type, role_id, state)
    VALUES ( 1,now(), 1, now(), 'FHW_WPD', 'FHW WPD','MO',(select id from um_role_master where code = 'FHW'),'ACTIVE' 
);