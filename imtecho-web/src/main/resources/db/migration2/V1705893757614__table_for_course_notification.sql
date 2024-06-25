CREATE TABLE If NOT EXISTS tr_course_notification_type_rel (
	id serial4 ,
	course_id int4 ,
	push_notification_type_id int4 ,
	"day" int4 ,
	created_on timestamp ,
	created_by int4 ,
	modified_on timestamp ,
	modified_by int4 ,
	CONSTRAINT tr_course_notification_type_rel_pkey PRIMARY KEY (id)
);

-- new column in tr_course_master
alter table if exists tr_course_master
add column if not exists has_notification_configuration boolean;