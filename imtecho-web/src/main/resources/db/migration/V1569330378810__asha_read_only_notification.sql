INSERT INTO public.notification_type_master(
    created_by, created_on, modified_by, modified_on, code, name, type, role_id, state)
VALUES (
    -1,now(),-1,now(),'ASHA_READ_ONLY','Asha Read Only Notification','MO',24,'ACTIVE'
);