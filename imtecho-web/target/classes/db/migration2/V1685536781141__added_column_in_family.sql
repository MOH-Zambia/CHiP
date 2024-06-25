update system_configuration set key_value = '62' where system_key = 'MOBILE_FORM_VERSION';

insert into mobile_beans_master(bean, depends_on_last_sync)
 values ('MoConfirmedBean', false),
('DrugInventoryBean', false);

insert into mobile_beans_feature_rel(feature,bean)
	values('FHW_NCD_WEEKLY_VISIT', 'MoConfirmedBean'),
	('FHW_NOTIFICATION', 'MoConfirmedBean'),
	('FHW_NCD_WEEKLY_VISIT', 'DrugInventoryBean'),
	('FHW_NOTIFICATION', 'DrugInventoryBean');

alter table imt_family
drop column if exists anyone_travelled_foreign,
add column anyone_travelled_foreign boolean;