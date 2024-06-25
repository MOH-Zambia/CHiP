
--insert into notification_type_role_rel(role_id, notification_type_id)
--select 30, id from notification_type_master where code in
--('NCD_CVC_CLINIC_VISIT','NCD_CVC_HOME_VISIT');
--
--insert into notification_type_role_rel(role_id, notification_type_id)
--select (select id from um_role_master urm where code = 'CC'), id from notification_type_master where code in
--('NCD_CVC_CLINIC_VISIT','NCD_CVC_HOME_VISIT');