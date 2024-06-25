delete from form_master where code = 'MIGRATION_REVERTED';
INSERT INTO public.form_master(
    created_by, created_on, modified_by, modified_on, code, name, state)
VALUES (1, now(), 1, now(), 'MIGRATION_REVERTED', 'MIGRATION REVERTED', 'ACTIVE');

   
delete from notification_type_master where code = 'MR';
INSERT INTO public.notification_type_master(
    created_by, created_on, modified_by, modified_on, code, name, type, role_id, state)
VALUES ( 1, now(), 1, now(), 'MR', 'MIGRATION REVERTED', 'MO', (select id from um_role_master where code = 'FHW'), 'ACTIVE');