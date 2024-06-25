insert into mobile_beans_master(bean, depends_on_last_sync)
 values ('CourseBean', false),
('LmsUserMetadataBean', false);

insert into mobile_beans_feature_rel(feature,bean)
	values('LEARNING_MANAGEMENT_SYSTEM', 'CourseBean'),
	('LMS_PROGRESS_REPORT', 'LmsUserMetadataBean');


insert into mobile_feature_master (mobile_constant, feature_name, mobile_display_name, state, created_on, created_by, modified_on, modified_by)
values
('LMS_PROGRESS_REPORT', 'Lms Progress Report', 'Lms Progress Report', 'ACTIVE', now(), -1, now(), -1),
('LEARNING_MANAGEMENT_SYSTEM', 'Learning Management System', 'Learning Management System', 'ACTIVE', now(), -1, now(), -1);

