
insert into mobile_beans_feature_rel(feature, bean)
values('FHW_NCD_REGISTER', 'NcdMemberBean'),
('FHW_NOTIFICATION', 'NcdMemberBean'),
('NCD_MO_CONFIRMED','NcdMemberBean'),
('FHW_NCD_WEEKLY_VISIT','NcdMemberBean'),
('FHW_NCD_SCREENING', 'NcdMemberBean');

alter table if exists imt_member_ncd_detail
add column if not exists evening_availability boolean,
add column if not exists reference_due boolean;