-- 1.query for course and topic data transfer.

-- create old_id column in topic_master for store old id
ALTER TABLE tr_topic_master ADD COLUMN old_id character varying(500);
  
--transfer data form old table to new table.
INSERT INTO tr_topic_master(
        old_id,created_by, created_on, modified_by, modified_on, topic_description,topic_name, topic_order, topic_state, day)
    select topic.id,
    case 
        when creted_usr.id is null then (select id from usermanagement_system_user where user_id = 'superadmin') 
        else creted_usr.id 
    end,
    topic.created_on,updated_usr.id,topic.updated_on,topic.descr,topic.name,topic.topic_order,
    case 
        when topic.state = 'com.argusoft.imtecho.course.topic.state.active' then 'ACTIVE'
        when topic.state = 'com.argusoft.imtecho.course.topic.state.archived' then 'ARCHIVED'
        else 'INACTIVE' 
    end,
    topic.day 
    from imt_topic topic left join usermanagement_system_user creted_usr on creted_usr.user_id = topic.created_by
    left join usermanagement_system_user updated_usr on updated_usr.user_id = topic.updated_by;

-- create old_id column in course_master for store old id

ALTER TABLE tr_course_master ADD COLUMN old_id character varying(500);
  
-- transfer data from old table to new table.
INSERT INTO tr_course_master(
        old_id,created_by, created_on, modified_by, modified_on, course_description,course_name,course_state)
    select course.id,
    case 
        when creted_usr.id is null then (select id from usermanagement_system_user where user_id = 'superadmin') 
        else creted_usr.id 
    end,
    course.created_on,updated_usr.id,course.updated_on,course.descr,course.name,
    case 
        when course.state = 'com.argusoft.imtecho.course.topic.state.active' then 'ACTIVE' 
        when course.state = 'com.argusoft.imtecho.course.topic.state.archived' then 'ARCHIVED' 
        else 'INACTIVE' 
    end 
    from imt_course course left join usermanagement_system_user creted_usr on creted_usr.user_id = course.created_by
    left join usermanagement_system_user updated_usr on updated_usr.user_id = course.updated_by;

--trandsfer data for couse_topic_relation
INSERT INTO tr_course_topic_rel (course_id,topic_id)
	select course.course_id , topic.topic_id 
	from imt_course_topic_rel r left join tr_course_master course on course.old_id = r.course_id 
	left join tr_topic_master topic on topic.old_id = r.topic_id ;


-- 2.training data migration

ALTER TABLE tr_training_master ADD COLUMN old_id character varying(500);

INSERT INTO tr_training_master(
        old_id,created_by,created_on,modified_by ,modified_on ,training_descr,effective_date ,expiration_date,location_name,training_name,training_state)
        select tr.id,
        case 
            when createdby.id is null then (select id from usermanagement_system_user where user_id = 'superadmin') 
            else createdby.id 
        end,
        tr.created_on,
        case 
            when updated_usr.id is null then (select id from usermanagement_system_user where user_id = 'superadmin') 
            else updated_usr.id 
        end,
        tr.updated_on,tr.descr,tr.effective_date,tr.expiration_date,tr.location_name,tr.name,
        case 
             when tr.state = 'com.argusoft.imtecho.training.training.state.draft' then 'DRAFT'
             when tr.state = 'com.argusoft.imtecho.training.training.state.submitted' then 'SUBMITTED'
             when tr.state = 'com.argusoft.imtecho.training.training.state.saved' then 'SAVED'
             when tr.state = 'com.argusoft.imtecho.training.training.state.completed' then 'COMPLETED'
             when tr.state = 'com.argusoft.imtecho.training.training.state.archived' then 'ARCHIVED'
             else 'DRAFT'
        end from imt_training tr left join usermanagement_system_user createdby on createdby.user_id = tr.created_by
        left join usermanagement_system_user updated_usr on updated_usr.user_id = tr.updated_by;

-- 3.attendece master

ALTER TABLE tr_attendance_master ADD COLUMN old_id character varying(500);

INSERT INTO tr_attendance_master(
	old_id,created_by,created_on,modified_by ,modified_on , completed_on ,descr,effective_date ,expiration_date ,
	is_present,name,reason,remarks,state,type,training_id,user_id)
	select tr.id,
	case when createdby.id is null then (select id from usermanagement_system_user where user_id = 'superadmin') else createdby.id end,
	tr.created_on,updated_usr.id,tr.updated_on,tr.completed_on,tr.descr,tr.effective_date,tr.expiration_date,
	tr.is_present,tr.name,tr.reason,tr.remarks,
	case 
	     when tr.state = 'com.argusoft.imtecho.training.attendance.state.active' then 'ACTIVE'
	     else 'INACTIVE'
	end,
	case 
	     when tr.state = 'com.argusoft.imtecho.training.attendance.type.trainer' then 'TRAINER'
	     else 'TRAINEE'
	end,
	nt.training_id,
	cast(tr.person_id as bigint)
	from imt_attendance tr left join usermanagement_system_user createdby on createdby.user_id = tr.created_by
	left join usermanagement_system_user updated_usr on updated_usr.user_id = tr.updated_by
	left join tr_training_master nt on nt.old_id = tr.id;

-- tr_attendance_topic_rel.......................................................................................................

-- 4. tr_training_course_rel
INSERT INTO tr_training_course_rel (training_id,course_id)
	select training.training_id ,  course.course_id 
	from imt_training_course_rel r left join tr_training_master training on training.old_id = r.training_id 
	left join tr_course_master course on course.old_id = r.course_id;


-- 5.tr_training_org_unit_rel
INSERT INTO tr_training_org_unit_rel (training_id,org_unit_id)
	select training.training_id ,   cast(r.org_unit_id as bigint)
	from imt_training_org_unit_rel r left join tr_training_master training on training.old_id = r.training_id;

-- 6.tr_training_attendee_rel

INSERT INTO tr_training_attendee_rel (training_id,attendee_id)
	select training.training_id ,  cast(r.attendee_id as bigint)
	from imt_training_attendee_rel r left join tr_training_master training on training.old_id = r.training_id;

-- 7.tr_training_additional_attendee_rel

INSERT INTO tr_training_additional_attendee_rel (training_id,additional_attendee_id)
	select training.training_id ,  cast(r.additional_attendee_id as bigint)
	from imt_training_additional_attendee_rel r left join tr_training_master training on training.old_id = r.training_id;

-- 8.tr_training_primary_trainer_rel

INSERT INTO tr_training_primary_trainer_rel (training_id,primary_trainer_id)
	select training.training_id ,  cast(r.primary_trainer_id as bigint)
	from imt_training_primary_trainer_rel r left join tr_training_master training on training.old_id = r.training_id;

-- 9.tr_training_optional_trainer_rel

INSERT INTO tr_training_optional_trainer_rel (training_id,optional_trainer_id)
	select training.training_id ,  cast(r.optional_trainer_id as bigint)
	from imt_training_optional_trainer_rel r left join tr_training_master training on training.old_id = r.training_id;

-- 10.tr_training_target_role_rel

INSERT INTO tr_training_target_role_rel (training_id,target_role_id)
	select training.training_id ,  cast(r.role_id as bigint)
	from imt_training_role_rel r left join tr_training_master training on training.old_id = r.training_id;

-- 11.tr_training_trainer_role_rel

-- 12.tr_topic_coverage_master

ALTER TABLE tr_topic_coverage_master ADD COLUMN old_id character varying(500);

INSERT INTO tr_topic_coverage_master(
	old_id,created_by,created_on,modified_by,modified_on,course_id,completed_on,
	descr,effective_date,expiration_date,name,reason,remarks,state,submitted_on,topic_id,training_id)
	
	select tr.id,
	case when createdby.id is null then (select id from usermanagement_system_user where user_id = 'superadmin') else createdby.id end,
	tr.created_on,updated_usr.id,tr.updated_on,
	tc.course_id,tr.completed_on,
	tr.descr,tr.effective_date,tr.expiration_date,
	tr.name,tr.reason,tr.remarks,
	case 
	     when tr.state = 'com.argusoft.imtecho.training.topiccoverage.state.pending' then 'PENDING'
	     when tr.state = 'com.argusoft.imtecho.training.topiccoverage.state.submitted' then 'SUBMITTED'
	     when tr.state = 'com.argusoft.imtecho.training.topiccoverage.state.completed' then 'COMPLETED'
	     else 'LATE_COMPLETED'
	end,
	tr.submitted_on,
	tn.topic_id,nt.training_id
	from imt_topic_coverage tr left join usermanagement_system_user createdby on createdby.user_id = tr.created_by
	left join usermanagement_system_user updated_usr on updated_usr.user_id = tr.updated_by
	left join tr_topic_master tn on tn.old_id = tr.topic_id
	left join tr_training_master nt on nt.old_id = tr.training_id
	left join tr_course_master tc on tc.old_id = tr.course_id;

-- 13.

ALTER TABLE tr_certificate_master ADD COLUMN old_id character varying(500);
  
INSERT INTO tr_certificate_master(
	old_id, created_by,created_on,modified_by,modified_on,
	certificate_descr,certificate_name,remarks,certificate_state,certificate_type,
	certification_on,course_id,grade_type,training_id,user_id)
	
	select tr.id,
	case when createdby.id is null then (select id from usermanagement_system_user where user_id = 'superadmin') else createdby.id end,
	tr.created_on,
	case when updated_usr.id is null then (select id from usermanagement_system_user where user_id = 'superadmin') else updated_usr.id end,
	tr.updated_on,tr.descr,tr.name,tr.remarks,
	case 
	     when tr.state = 'com.argusoft.imtecho.training.certificate.state.active' then 'ACTIVE'
	     else 'INACTIVE'
	end,
	case 
	     when tr.type = 'com.argusoft.imtecho.training.certificate.type.coursecompletion' then 'COURSECOMPLETION'
	     else 'COURSECOMPLETION_FAILED'
	end,
	tr.certification_on,
	tc.course_id,
	case 
	     when tr.grade_type = 'com.argusoft.imtecho.training.certificate.grade_type.trained' then 'TRAINED'
	     else 'FAILED'
	end,
	nt.training_id, cast( tr.id as bigint) 
	from imt_certificate tr left join usermanagement_system_user createdby on createdby.user_id = tr.created_by
	left join usermanagement_system_user updated_usr on updated_usr.user_id = tr.updated_by
	left join tr_training_master nt on nt.old_id = tr.training_id
	left join tr_course_master tc on tc.old_id = tr.course_id;



Alter table tr_topic_master DROP old_id;
Alter table tr_course_master DROP old_id;
Alter table tr_training_master DROP old_id;
Alter table tr_attendance_master DROP old_id;
Alter table tr_certificate_master DROP old_id;
Alter table tr_topic_coverage_master DROP old_id;



