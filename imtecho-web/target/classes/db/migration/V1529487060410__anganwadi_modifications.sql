alter table anganwadi_master add column icds_code varchar(11);

ALTER TABLE anganwadi_master ADD CONSTRAINT unique_icds UNIQUE (icds_code);

UPDATE public.menu_config
   SET feature_json='{"canEdit":false}'
 WHERE navigation_state='techo.manage.anganwadi';