--- mobile_beans_master table

drop table if exists mobile_beans_master;
create table mobile_beans_master (
	bean text not null,
	depends_on_last_sync boolean,
	CONSTRAINT mobile_bean_master_pkey PRIMARY KEY (bean)
);

--- mobile_beans_feature_rel

drop table if exists mobile_beans_feature_rel;
create table mobile_beans_feature_rel (
	id serial,
	bean text,
	feature text
);

-- data entry

insert into mobile_beans_master(bean, depends_on_last_sync)
select bean, depends_on_last_sync
from
(
	values
		('AnnouncementBean', true),
		('DataQualityBean', true),
		('FamilyBean', true),
		('FhwServiceDetailBean', false),
		('HealthInfrastructureBean', true),
        ('LabelBean', true),
		('LibraryBean', true),
		('ListValueBean', true),
        ('LocationMasterBean', true),
        ('LocationTypeBean', true),
		('MemberCbacDetailBean', true),
        ('MenuBean', true),
		('MigratedFamilyBean', false),
		('MigratedMembersBean', true),
		('NotificationBean', true),
		('PregnancyStatusBean', true),
        ('SchoolBean', true)
) as feature(bean, depends_on_last_sync);


insert into mobile_beans_feature_rel(bean, feature)
select bean, feature
from (
	values
		('FHW_CFHC', 'FamilyBean'),
		('FHW_CFHC', 'ListValueBean'),
		('FHW_CFHC', 'MigratedMemberBean'),
		('FHW_DATA_QUALITY', 'DataQualityBean'),
		('FHW_SURVEILLANCE', 'FamilyBean'),
		('FHW_SURVEILLANCE', 'ListValueBean'),
		('FHW_MY_PEOPLE', 'FamilyBean'),
		('FHW_MY_PEOPLE', 'ListValueBean'),
		('FHW_MY_PEOPLE', 'MigratedMembersBean'),
		('FHW_MY_PEOPLE', 'MigratedFamilyBean'),
		('FHW_MY_PEOPLE', 'PregnancyStatusBean'),
		('FHW_MOBILE_VERIFICATION', 'FamilyBean'),
		('FHW_HIGH_RISK_WOMEN_AND_CHILD', 'FamilyBean'),
		('FHW_HIGH_RISK_WOMEN_AND_CHILD', 'ListValueBean'),
		('FHW_NCD_SCREENING', 'FamilyBean'),
		('FHW_NCD_SCREENING', 'ListValueBean'),
		('FHW_NCD_REGISTER', 'FamilyBean'),
		('FHW_NCD_REGISTER', 'ListValueBean'),
		('FHW_WORK_STATUS', 'FhwServiceDetailBean'),
		('LIBRARY', 'LibraryBean'),
		('ANNOUNCEMENTS', 'AnnouncementBean'),
		('FHW_NOTIFICATION', 'FamilyBean'),
		('FHW_NOTIFICATION', 'ListValueBean'),
		('FHW_NOTIFICATION', 'MigratedMembersBean'),
		('FHW_NOTIFICATION', 'MigratedFamilyBean'),
		('FHW_NOTIFICATION', 'NotificationBean'),
		('ASHA_FHS', 'FamilyBean'),
        ('ASHA_MY_PEOPLE', 'FamilyBean'),
        ('ASHA_MY_PEOPLE', 'ListValueBean'),
        ('ASHA_HIGH_RISK_BENEFICIARIES', 'FamilyBean'),
        ('ASHA_HIGH_RISK_BENEFICIARIES', 'ListValueBean'),
        ('ASHA_CBAC_ENTRY', 'FamilyBean'),
        ('ASHA_CBAC_ENTRY', 'ListValueBean'),
        ('ASHA_NCD_REGISTER', 'FamilyBean'),
        ('ASHA_NCD_REGISTER', 'MemberCbacDetailBean'),
        ('ASHA_NPCB_SCREENING', 'FamilyBean'),
        ('ASHA_NPCB_SCREENING', 'ListValueBean'),
        ('ASHA_NOTIFICATION', 'FamilyBean'),
        ('ASHA_NOTIFICATION', 'ListValueBean'),
        ('ASHA_NOTIFICATION', 'NotificationBean')
) as f(feature, bean);



-- new feature constant added

insert into mobile_feature_master (mobile_constant, feature_name, mobile_display_name, state, created_on, created_by, modified_on, modified_by)
values
('ASHA_FHS', 'ASHA FHS', 'Family Health Survey', 'ACTIVE', now(), -1, now(), -1),
('ASHA_MY_PEOPLE', 'ASHA MY PEOPLE', 'My People ASHA', 'ACTIVE', now(), -1, now(), -1),
('ASHA_NOTIFICATION', 'ASHA NOTIFICATION', 'Your Schedule', 'ACTIVE', now(), -1, now(), -1),
('ASHA_HIGH_RISK_BENEFICIARIES', 'ASHA HIGH RISK BENEFICIARIES', 'High Risk Beneficiaries', 'ACTIVE', now(), -1, now(), -1),
('ASHA_CBAC_ENTRY', 'ASHA CBAC ENTRY', 'CBAC Entry', 'ACTIVE', now(), -1, now(), -1),
('ASHA_NCD_REGISTER', 'ASHA NCD REGISTER', 'NCD Register', 'ACTIVE', now(), -1, now(), -1),
('ASHA_NPCB_SCREENING', 'ASHA NPCB SCREENING', 'NPCB Screening', 'ACTIVE', now(), -1, now(), -1),
('ASHA_WORK_REGISTER', 'ASHA WORK REGISTER', 'Work Register', 'ACTIVE', now(), -1, now(), -1),
('AWW_FHS', 'AWW FHS', 'FHS Read-only', 'ACTIVE', now(), -1, now(), -1),
('AWW_MY_PEOPLE', 'AWW MY PEOPLE', 'My People', 'ACTIVE', now(), -1, now(), -1),
('AWW_NOTIFICATION', 'AWW NOTIFICATION', 'Your Schedule', 'ACTIVE', now(), -1, now(), -1),
('DAILY_NUTRITION', 'DAILY NUTRITION', 'Daily Nutrition', 'ACTIVE', now(), -1, now(), -1),
('TAKE_HOME_RATION', 'TAKE HOME RATION', 'Take Home Ration', 'ACTIVE', now(), -1, now(), -1),
('LT_OPD', 'LT OPD', 'OPD', 'ACTIVE', now(), -1, now(), -1),
('HEAD_TO_TOE_SCREENING', 'Head To Toe Screening', 'Head To Toe Screening', 'ACTIVE', now(), -1, now(), -1);


-- ASHA

with datas as (
	insert into mobile_menu_master (menu_name, config_json, created_on, created_by, modified_on, modified_by)
	values ('ASHA Menu', '[{"mobile_constant":"ASHA_FHS","order":1},{"mobile_constant":"ASHA_MY_PEOPLE","order":2},{"mobile_constant":"FHW_SURVEILLANCE","order":3},{"mobile_constant":"ASHA_NOTIFICATION","order":4},{"mobile_constant":"ASHA_HIGH_RISK_BENEFICIARIES","order":5},{"mobile_constant":"ASHA_CBAC_ENTRY","order":6},{"mobile_constant":"ASHA_NCD_REGISTER","order":7},{"mobile_constant":"ASHA_NPCB_SCREENING","order":8},{"mobile_constant":"LIBRARY","order":9},{"mobile_constant":"ANNOUNCEMENTS","order":10},{"mobile_constant":"WORK_LOG","order":11},{"mobile_constant":"ASHA_WORK_REGISTER","order":12}]',
	now(), -1, now(), -1)
	returning id
)
insert into mobile_menu_role_relation (menu_id, role_id)
select id, (select id from um_role_master urm where name = 'ASHA') from datas;
