ALTER TABLE public.notification_type_master
   ALTER COLUMN code SET NOT NULL;

ALTER TABLE public.notification_type_master
  ADD CONSTRAINT unique_code_notification_type_master UNIQUE (code);

ALTER TABLE public.techo_notification_master
  DROP COLUMN IF EXISTS other_details,
  ADD COLUMN other_details text;

insert into notification_type_master (created_by,created_on,modified_by,modified_on,code,name,type,role_id,state) 
values (-1,now(),-1,now(),'MI','Migration-In','MO',30,'ACTIVE');

insert into notification_type_master (created_by,created_on,modified_by,modified_on,code,name,type,role_id,state) 
values (-1,now(),-1,now(),'MO','Migration-Out','MO',30,'ACTIVE');