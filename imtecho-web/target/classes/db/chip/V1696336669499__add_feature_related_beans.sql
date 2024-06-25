INSERT INTO public.mobile_beans_feature_rel
(bean, feature)
VALUES('FamilyBean', 'CBV_NOTIFICATION');
INSERT INTO public.mobile_beans_feature_rel
(bean, feature)
VALUES('ListValueBean', 'CBV_NOTIFICATION');
INSERT INTO public.mobile_beans_feature_rel
(bean, feature)
VALUES('NotificationBean', 'CBV_NOTIFICATION');
INSERT INTO public.mobile_beans_feature_rel
(bean, feature)
VALUES('FamilyBean', 'CBV_MY_PEOPLE');
INSERT INTO public.mobile_beans_feature_rel
(bean, feature)
VALUES('ListValueBean', 'CBV_MY_PEOPLE');



insert into notification_type_role_rel(role_id, notification_type_id)
select 245, id from notification_type_master where code in
('MO','MI','FHW_WPD','FHW_CS','FHW_PNC','FHW_ANC','LMPFU','DISCHARGE','APPETITE','TT2_ALERT','IRON_SUCROSE_ALERT','SAM_SCREENING','READ_ONLY',
'FHW_PREG_CONF','FHW_DEATH_CONF','FHW_DELIVERY_CONF','FHW_MEMBER_MIGRATION','FHW_FAMILY_MIGRATION','FHW_FAMILY_SPLIT','FMI','FHW_SAM_SCREENING_REF','CMAM_FOLLOWUP');


INSERT INTO public.mobile_form_feature_rel
(form_id, mobile_constant)
VALUES(3, 'CBV_MY_PEOPLE');
INSERT INTO public.mobile_form_feature_rel
(form_id, mobile_constant)
VALUES(6, 'CBV_MY_PEOPLE');
INSERT INTO public.mobile_form_feature_rel
(form_id, mobile_constant)
VALUES(7, 'CBV_MY_PEOPLE');
INSERT INTO public.mobile_form_feature_rel
(form_id, mobile_constant)
VALUES(8, 'CBV_MY_PEOPLE');
INSERT INTO public.mobile_form_feature_rel
(form_id, mobile_constant)
VALUES(9, 'CBV_MY_PEOPLE');
INSERT INTO public.mobile_form_feature_rel
(form_id, mobile_constant)
VALUES(11, 'CBV_MY_PEOPLE');
INSERT INTO public.mobile_form_feature_rel
(form_id, mobile_constant)
VALUES(12, 'CBV_MY_PEOPLE');
INSERT INTO public.mobile_form_feature_rel
(form_id, mobile_constant)
VALUES(13, 'CBV_MY_PEOPLE');
INSERT INTO public.mobile_form_feature_rel
(form_id, mobile_constant)
VALUES(18, 'CBV_MY_PEOPLE');
INSERT INTO public.mobile_form_feature_rel
(form_id, mobile_constant)
VALUES(19, 'CBV_MY_PEOPLE');
INSERT INTO public.mobile_form_feature_rel
(form_id, mobile_constant)
VALUES(55, 'CBV_MY_PEOPLE');


INSERT INTO public.mobile_form_feature_rel
(form_id, mobile_constant)
VALUES(11, 'CBV_NOTIFICATION');
INSERT INTO public.mobile_form_feature_rel
(form_id, mobile_constant)
VALUES(16, 'CBV_NOTIFICATION');
INSERT INTO public.mobile_form_feature_rel
(form_id, mobile_constant)
VALUES(17, 'CBV_NOTIFICATION');
INSERT INTO public.mobile_form_feature_rel
(form_id, mobile_constant)
VALUES(18, 'CBV_NOTIFICATION');
INSERT INTO public.mobile_form_feature_rel
(form_id, mobile_constant)
VALUES(36, 'CBV_NOTIFICATION');
INSERT INTO public.mobile_form_feature_rel
(form_id, mobile_constant)
VALUES(4, 'CBV_NOTIFICATION');
INSERT INTO public.mobile_form_feature_rel
(form_id, mobile_constant)
VALUES(5, 'CBV_NOTIFICATION');
INSERT INTO public.mobile_form_feature_rel
(form_id, mobile_constant)
VALUES(6, 'CBV_NOTIFICATION');
INSERT INTO public.mobile_form_feature_rel
(form_id, mobile_constant)
VALUES(7, 'CBV_NOTIFICATION');
INSERT INTO public.mobile_form_feature_rel
(form_id, mobile_constant)
VALUES(8, 'CBV_NOTIFICATION');
INSERT INTO public.mobile_form_feature_rel
(form_id, mobile_constant)
VALUES(9, 'CBV_NOTIFICATION');
INSERT INTO public.mobile_form_feature_rel
(form_id, mobile_constant)
VALUES(12, 'CBV_NOTIFICATION');
INSERT INTO public.mobile_form_feature_rel
(form_id, mobile_constant)
VALUES(14, 'CBV_NOTIFICATION');
INSERT INTO public.mobile_form_feature_rel
(form_id, mobile_constant)
VALUES(15, 'CBV_NOTIFICATION');
INSERT INTO public.mobile_form_feature_rel
(form_id, mobile_constant)
VALUES(19, 'CBV_NOTIFICATION');
INSERT INTO public.mobile_form_feature_rel
(form_id, mobile_constant)
VALUES(28, 'CBV_NOTIFICATION');
INSERT INTO public.mobile_form_feature_rel
(form_id, mobile_constant)
VALUES(29, 'CBV_NOTIFICATION');

delete from mobile_feature_master where mobile_constant = 'FAMILY_FOLDER';
insert into mobile_feature_master (mobile_constant, feature_name, mobile_display_name, state, created_on, created_by, modified_on, modified_by)
values('FAMILY_FOLDER', 'Family Folder', 'Family Folder', 'ACTIVE',  now(), -1, now(), -1);

delete from mobile_form_details where form_name = 'FAMILY_FOLDER';
insert into mobile_form_details(form_name, file_name, created_on, created_by, modified_on, modified_by)
values('FAMILY_FOLDER', 'FAMILY_FOLDER', now(), -1, now(), -1);

delete from mobile_form_feature_rel where mobile_constant = 'FAMILY_FOLDER';
insert into mobile_form_feature_rel (form_id, mobile_constant)
select id, 'FAMILY_FOLDER' from mobile_form_details where form_name = 'FAMILY_FOLDER';

delete from mobile_form_details where form_name = 'FAMILY_FOLDER_MEMBER_UPDATE';
insert into mobile_form_details(form_name, file_name, created_on, created_by, modified_on, modified_by)
values('FAMILY_FOLDER_MEMBER_UPDATE', 'FAMILY_FOLDER_MEMBER_UPDATE', now(), -1, now(), -1);

delete from mobile_form_feature_rel where mobile_constant = 'FAMILY_FOLDER_MEMBER_UPDATE';
insert into mobile_form_feature_rel (form_id, mobile_constant)
select id, 'FAMILY_FOLDER' from mobile_form_details where form_name = 'FAMILY_FOLDER_MEMBER_UPDATE';

delete from listvalue_field_form_relation where form_id = (select id from mobile_form_details where form_name = 'FAMILY_FOLDER');
insert into listvalue_field_form_relation (field, form_id)
select field, (select id from mobile_form_details where form_name = 'FAMILY_FOLDER') from listvalue_field_form_relation where form_id = (select id from mobile_form_details where form_name = 'CFHC');


