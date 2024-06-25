ALTER TABLE public.notification_type_master
   ALTER COLUMN code TYPE character varying(200);

ALTER TABLE public.form_master
   ALTER COLUMN code TYPE character varying(200);

update um_role_master set code = 'mo_phc' where name = 'MO PHC';
update um_role_master set code = 'mo_ayush' where name = 'MO AYUSH';
update um_role_master set code = 'mo_corporation' where name = 'MOH Corporation';
update um_role_master set code = 'mo_uphc' where name = 'MO UPHC';