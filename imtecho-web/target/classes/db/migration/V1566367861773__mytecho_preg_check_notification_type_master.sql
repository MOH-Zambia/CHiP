INSERT INTO public.notification_type_master(
            created_by, created_on, modified_by, modified_on, code, name, 
            type, role_id, state, notification_for)
    VALUES (-1, now(), -1, now(), 'MYTECHO_PREG_SYMP', 'Pregnancy Symptoms Checker', 
            'MYTECHO', '202', 'ACTIVE', 'USER');
