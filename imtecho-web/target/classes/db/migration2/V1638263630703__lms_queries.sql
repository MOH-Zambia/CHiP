-- Added type field
ALTER TABLE tr_course_master DROP COLUMN IF EXISTS course_type,
    ADD COLUMN course_type varchar(250);
-- Created table to store video id or link for online course topic
drop table if exists tr_topic_media_master;
drop table if exists tr_topic_video_master;
CREATE TABLE tr_topic_video_master (
    id serial,
    topic_id integer NOT NULL,
    video_id bigint,
    video_file_name varchar(1000),
    url varchar(1000),
    title varchar(1000),
    description text,
    created_by integer NOT NULL,
    created_on timestamp without time zone NOT NULL,
    modified_by integer,
    modified_on timestamp without time zone,
    CONSTRAINT tr_online_topic_video_pkey PRIMARY KEY (id)
);
-- Create new module to upload documents for training
delete from document_module_master
where module_name = 'TRAINING';
INSERT INTO document_module_master(
        module_name,
        base_path,
        created_by,
        created_on
    )
VALUES ('TRAINING', 'training', -1, now());
ALTER table IF EXISTS tr_topic_video_master
    RENAME TO tr_topic_media_master;
ALTER SEQUENCE IF EXISTS tr_topic_video_master_id_seq
RENAME TO tr_topic_media_master_id_seq;
DO $$ BEGIN BEGIN
ALTER TABLE IF EXISTS tr_topic_media_master
    RENAME COLUMN video_id TO media_id;
EXCEPTION
WHEN others THEN RAISE NOTICE 'Column rename failed';
END;
END;
$$;
DO $$ BEGIN BEGIN
ALTER TABLE IF EXISTS tr_topic_media_master
    RENAME COLUMN video_id TO media_id;
EXCEPTION
WHEN others THEN RAISE NOTICE 'Column rename failed';
END;
END;
$$;
DO $$ BEGIN BEGIN
ALTER TABLE IF EXISTS tr_topic_media_master
    RENAME COLUMN video_file_name TO media_file_name;
EXCEPTION
WHEN others THEN RAISE NOTICE 'Column rename failed';
END;
END;
$$;
ALTER TABLE IF EXISTS tr_topic_media_master Drop column if EXISTS media_type,
    add column media_type varchar(250);
ALTER TABLE IF EXISTS tr_topic_media_master Drop column if EXISTS media_order,
    add column media_order Integer;
ALTER TABLE IF EXISTS tr_topic_media_master Drop column if EXISTS transcript_file_id,
    add column transcript_file_id bigint;
ALTER TABLE IF EXISTS tr_topic_media_master Drop column IF EXISTS transcript_file_name,
    add column transcript_file_name varchar(250);
update tr_course_master
set course_type = 'OFFLINE'
where course_type is null;
ALTER TABLE tr_course_master
ALTER COLUMN course_type
SET NOT NULL;
-- Changes related to online course
DROP TABLE IF EXISTS tr_question_set_configuration;
CREATE TABLE tr_question_set_configuration (
    id serial PRIMARY KEY,
    ref_id int not null,
    ref_type varchar(255) not null,
    question_set_name varchar(255),
    status varchar(255),
    minimum_marks int,
    created_by integer not null,
    created_on timestamp without time zone not null,
    modified_by integer not null,
    modified_on timestamp without time zone not null
);
DROP TABLE IF EXISTS tr_question_bank_configuration;
CREATE TABLE tr_question_bank_configuration (
    id serial PRIMARY KEY,
    question_set_id int not null,
    config_json text,
    created_by integer not null,
    created_on timestamp without time zone not null,
    modified_by integer not null,
    modified_on timestamp without time zone not null
);
DELETE FROM QUERY_MASTER
WHERE CODE = 'get_tr_question_bank_configuration_by_id';
INSERT INTO QUERY_MASTER (
        uuid,
        created_by,
        created_on,
        modified_by,
        modified_on,
        code,
        params,
        query,
        description,
        returns_result_set,
        state
    )
VALUES (
        '9bc7d1dc-19a3-457d-b49b-90f432f12fb2',
        84954,
        current_date,
        84954,
        current_date,
        'get_tr_question_bank_configuration_by_id',
        'id',
        'select * from tr_question_bank_configuration where question_set_id = #id#',
        null,
        true,
        'ACTIVE'
    );
DELETE FROM QUERY_MASTER
WHERE CODE = 'insert_into_tr_question_bank_configuration';
INSERT INTO QUERY_MASTER (
        uuid,
        created_by,
        created_on,
        modified_by,
        modified_on,
        code,
        params,
        query,
        description,
        returns_result_set,
        state
    )
VALUES (
        '263be7c4-1b08-4629-9455-c11c2fadde4a',
        84954,
        current_date,
        84954,
        current_date,
        'insert_into_tr_question_bank_configuration',
        'questionSetId,configJson,loggedInUserId',
        'delete from tr_question_bank_configuration where question_set_id = #questionSetId#;
INSERT INTO tr_question_bank_configuration
(question_set_id, config_json, created_by, created_on, modified_by, modified_on)
VALUES
(#questionSetId#, #configJson#, #loggedInUserId#, now(), #loggedInUserId#, now());',
        null,
        false,
        'ACTIVE'
    );
DELETE FROM QUERY_MASTER
WHERE CODE = 'tr_scheduled_trainings';
INSERT INTO QUERY_MASTER (
        uuid,
        created_by,
        created_on,
        modified_by,
        modified_on,
        code,
        params,
        query,
        description,
        returns_result_set,
        state
    )
VALUES (
        '40a243ce-5253-4a6d-ae6e-45c0a93f1d74',
        75398,
        current_date,
        75398,
        current_date,
        'tr_scheduled_trainings',
        'locationId,isShowPast,moduleId,userId,courseId',
        'select
	string_agg(r1."location", '','') as "location",
	r1."trainingId",
	r1."trainerId",
	r1."courseName",
	r1."trainer",
	r1."effectiveDate",
	r1."expirationDate",
	r1."module",
	r1."total",
	r1."trainingState",
	r1."completed",
	r1."pending",
	r1."courseType"
from
	(
	select
		string_agg(lm.name, ''>'' order by lhcd.depth desc) as "location", res.training_id "trainingId", res.primary_trainer_id "trainerId" , res.course_name as "courseName", concat(us.first_name, '' '', us.last_name) as "trainer", fvm.value as "module", total.total as "total", res.effective_date as "effectiveDate", res.expiration_date as "expirationDate", res.training_state as "trainingState", cert."completed", tcm.state as "pending", res.course_type as "courseType"
	from
		(
		select
			tm.training_id, ptr.primary_trainer_id, cm.course_id, cm.course_name, cm.module_id, torg.org_unit_id, tm.effective_date, tm.expiration_date, tm.training_state, cm.course_type
		from
			tr_training_master tm
		inner join tr_training_course_rel tcr on
			tm.training_id = tcr.training_id
		inner join tr_training_org_unit_rel torg on
			tm.training_id = torg.training_id
		left join tr_training_primary_trainer_rel ptr on
			ptr.training_id = tm.training_id
		inner join tr_course_master cm on
			tcr.course_id = cm.course_id
		where
			torg.org_unit_id in (
			select
				child_id
			from
				location_hierchy_closer_det
			where
				((#locationId# is null
				and parent_id in (
				select
					loc_id
				from
					um_user_location
				where
					user_id = #userId#
					and state = ''ACTIVE''))
				or #locationId# is not null
				and parent_id = #locationId#))
			and
			(case
				when #moduleId# is not null then cm.module_id = #moduleId#
				else true
			end)
			and
			(case
				when #courseId# is not null then tcr.course_id = #courseId#
				else true
			end)
			and
			(case
				when #isShowPast# = true then true
				when cm.course_type = ''ONLINE'' then true
				else tm.expiration_date\:\:date >= current_date
			end)) res
	inner join (
		select
			count(*) as "total", training_id
		from
			(
			select
				*
			from
				tr_training_attendee_rel
		union
			select
				*
			from
				tr_training_additional_attendee_rel)r
		group by
			r.training_id) total on
		res.training_id = total.training_id
	left join (with tr_topic_coverage_master_temp as (
		select
			ttm."day",
			ttcm.*
		from
			tr_topic_master ttm
		inner join tr_topic_coverage_master ttcm on
			ttm.topic_id = ttcm.topic_id ),
		days_details as(
		select
			max(ttcmp.day),
			ttcmp.training_id
		from
			tr_topic_coverage_master_temp ttcmp
		group by
			ttcmp.training_id ),
		training_details as (
		select
			max(ttcmp.topic_id) as max_topic,
			ttcmp.training_id
		from
			tr_topic_coverage_master_temp ttcmp
		inner join days_details on
			ttcmp."day" = days_details.max
			and ttcmp.training_id = days_details.training_id
		group by
			ttcmp.training_id )
		select
			td.max_topic, ttcm.topic_id, ttcm.state, ttcm.expiration_date, ttcm.training_id
		from
			tr_topic_coverage_master ttcm, training_details td
		where
			ttcm.training_id = td.training_id
			and ttcm.topic_id = td.max_topic ) tcm on
		res.training_id = tcm.training_id
	left join (
		select
			count(*) as "completed", training_id
		from
			tr_certificate_master
		where
			certificate_type = ''COURSECOMPLETION''
		group by
			training_id) cert on
		res.training_id = cert.training_id
	inner join location_hierchy_closer_det lhcd on
		lhcd.child_id = res.org_unit_id
	inner join location_master lm on
		lm.id = lhcd.parent_id
	left join um_user us on
		us.id = res.primary_trainer_id
	left join listvalue_field_value_detail fvm on
		fvm.id = res.module_id
	group by
		res.training_id, res.primary_trainer_id, res.course_name, us.first_name, us.last_name, fvm.value, res.effective_date, res.expiration_date, total.total, res.training_state, cert."completed", tcm.state, res.org_unit_id, res.course_type) r1
group by
	r1."trainingId",
	r1."trainerId",
	r1."courseName",
	r1."trainer",
	r1."effectiveDate",
	r1."expirationDate",
	r1."module",
	r1."total",
	r1."trainingState",
	r1."completed",
	r1."pending",
	r1."courseType"',
        null,
        true,
        'ACTIVE'
    );
DROP TABLE if exists tr_question_set_answer;
CREATE TABLE tr_question_set_answer (
    id serial NOT NULL,
    user_id integer,
    question_set_id integer,
    marks_scored integer,
    passing_marks integer,
    is_passed boolean,
    answer_json text,
    created_on timestamp without time zone,
    created_by integer,
    modified_on timestamp without time zone,
    modified_by integer,
    PRIMARY KEY (id)
);
ALTER TABLE tr_course_master
ALTER COLUMN course_description TYPE text;
ALTER TABLE tr_topic_master
ALTER COLUMN topic_description TYPE text;
ALTER TABLE tr_topic_media_master DROP COLUMN IF EXISTS media_state,
    ADD COLUMN media_state varchar(255);
update tr_topic_media_master
set media_state = 'ACTIVE'
where media_state is null;
alter table tr_training_master
alter column training_descr type text;
alter table tr_topic_coverage_master
alter column descr type text;
INSERT INTO listvalue_form_master (
        form_key,
        form,
        is_active,
        is_training_req,
        query_for_training_completed
    )
SELECT 'WEB_TRAINING',
    'WEB Training',
    TRUE,
    FALSE,
    null
WHERE NOT EXISTS (
        SELECT 1
        FROM listvalue_form_master
        WHERE form_key = 'WEB_TRAINING'
    );
INSERT INTO listvalue_field_master(field_key, field, is_active, field_type, form)
SELECT 'lms_question_set_types',
    'LMS Question Set types',
    true,
    'T',
    'WEB_TRAINING'
WHERE NOT EXISTS (
        SELECT 1
        FROM listvalue_field_master
        WHERE field_key = 'lms_question_set_types'
    );
INSERT INTO listvalue_field_value_detail(
        is_active,
        is_archive,
        last_modified_by,
        last_modified_on,
        value,
        field_key,
        file_size
    )
SELECT true,
    false,
    'dhirpara',
    now(),
    'Comprehension Quiz',
    'lms_question_set_types',
    0
WHERE NOT EXISTS (
        SELECT 1
        FROM listvalue_field_value_detail
        WHERE field_key = 'lms_question_set_types'
            AND value = 'Comprehension Quiz'
    );
INSERT INTO listvalue_field_value_detail(
        is_active,
        is_archive,
        last_modified_by,
        last_modified_on,
        value,
        field_key,
        file_size
    )
SELECT true,
    false,
    'dhirpara',
    now(),
    'Evaluation Quiz',
    'lms_question_set_types',
    0
WHERE NOT EXISTS (
        SELECT 1
        FROM listvalue_field_value_detail
        WHERE field_key = 'lms_question_set_types'
            AND value = 'Evaluation Quiz'
    );
ALTER TABLE tr_question_set_configuration DROP COLUMN IF EXISTS question_set_type,
    ADD COLUMN question_set_type integer;
ALTER TABLE tr_course_master DROP COLUMN IF EXISTS test_config_json,
    ADD COLUMN test_config_json text;
ALTER TABLE tr_question_set_configuration DROP COLUMN IF EXISTS course_id,
    ADD COLUMN course_id int;
DELETE FROM QUERY_MASTER WHERE CODE='update_tr_question_set_configuration';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'3c7e1c6d-1382-4d97-bc02-c7a973dc1fd3', 80335,  current_date , 80335,  current_date , 'update_tr_question_set_configuration',
'quizAtSecond,refType,refId,questionSetType,loggedInUserId,id,minimumMarks,courseId,questionSetName,status',
'UPDATE tr_question_set_configuration
SET
ref_id=#refId#,
ref_type=#refType#,
question_set_name=#questionSetName#,
question_set_type=#questionSetType#,
status=#status#,
minimum_marks=#minimumMarks#,
course_id=#courseId#,
quiz_at_second=#quizAtSecond#,
modified_by=#loggedInUserId#,
modified_on=now()
WHERE id=#id#;',
null,
false, 'ACTIVE');
update tr_question_set_configuration
set course_id = tcm.course_id
from tr_course_master tcm
where case
        when tr_question_set_configuration.ref_type = 'COURSE' then tr_question_set_configuration.ref_id = tcm.course_id
        when tr_question_set_configuration.ref_type = 'MODULE' then (
            select course_id
            from tr_course_topic_rel
            where topic_id = tr_question_set_configuration.ref_id
        ) = tcm.course_id
        when tr_question_set_configuration.ref_type = 'LESSON' then (
            select course_id
            from tr_course_topic_rel
            where topic_id = (
                    select topic_id
                    from tr_topic_media_master
                    where id = tr_question_set_configuration.ref_id
                )
        ) = tcm.course_id
        else false
    end
    and tr_question_set_configuration.course_id is null;
DELETE FROM QUERY_MASTER
WHERE CODE = 'training_eligible_count';
INSERT INTO QUERY_MASTER (
        uuid,
        created_by,
        created_on,
        modified_by,
        modified_on,
        code,
        params,
        query,
        description,
        returns_result_set,
        state
    )
VALUES (
        'fe17992c-bd9f-483b-b371-981e0f2867ce',
        84954,
        current_date,
        84954,
        current_date,
        'training_eligible_count',
        'locationId,roleId,courseId',
        'with location_det as(
select
	child_id as loc_id
from
	location_hierchy_closer_det
where
	parent_id in (#locationId#) ),
users as (
select
	tcrr.role_id,
	tcrr.course_id,
	uu.id,
	tr_course_master.module_id,
	concat(uu.first_name, '' '', uu.last_name) as FullName,
	uu.contact_number as user_mobile_number,
	tr_course_master.course_name as courseName,
	tr_course_master.course_type as courseType,
	urm.name as roleName
from
	tr_course_master
inner join tr_course_role_rel tcrr on
	tcrr.course_id = tr_course_master.course_id
	and tr_course_master.course_state = ''ACTIVE''
inner join um_user uu on
	uu.role_id = tcrr.role_id
	and uu.state = ''ACTIVE''
inner join um_user_location ul on
	ul.state = ''ACTIVE''
	and ul.user_id = uu.id
inner join location_det ld on
	ld.loc_id = ul.loc_id
inner join um_role_master urm on
	urm.id = uu.role_id
where
	uu.role_id in (#roleId#)
	and tr_course_master.course_id = #courseId# ),
totalUser as (
select
	distinct on
	(u.id) id,
	FullName,
	courseName,
	user_mobile_number,
	roleName
from
	users u) ,
scheduled as (
select
	us.id ,
	us.course_id,
	us.role_id,
	us.FullName,
	us.user_mobile_number,
	us.roleName
from
	tr_training_master tr
inner join tr_training_course_rel tcr on
	tr.training_id = tcr.training_id
inner join (
	select
		*
	from
		tr_training_attendee_rel
union
	select
		*
	from
		tr_training_additional_attendee_rel) r on
	tr.training_id = r.training_id
right join users us on
	us.id = r.attendee_id
	and us.course_id = tcr.course_id
where
	(case when us.courseType = ''ONLINE'' then tr.expiration_date is null else tr.expiration_date >= current_date end)
	and tr.training_state = ''DRAFT'' ),
practiced as (
select
	us.id,
	us.role_id,
	us.course_id,
	us.FullName,
	us.user_mobile_number,
	us.roleName
from
	tr_certificate_master tcm
inner join users us on
	us.id = tcm.user_id
	and tcm.course_id = us.course_id
inner join listvalue_field_value_detail fvm on
	fvm.id = us.module_id
left join user_form_access ufa on
	ufa.form_code = fvm.value
	and ufa.user_id = us.id
where
	tcm.certificate_type = ''COURSECOMPLETION''
	and us.course_id in (1, 7, 10, 11)
	and ufa.form_code is null ) ,
production as (
select
	us.id id,
	us.role_id,
	us.course_id,
	us.FullName,
	us.user_mobile_number,
	us.roleName
from
	tr_certificate_master tcm
inner join users us on
	us.id = tcm.user_id
	and tcm.course_id = us.course_id
where
	tcm.certificate_type = ''COURSECOMPLETION''
	and us.course_id not in (1, 7, 10, 11)
union all
select
	us.id id,
	us.role_id,
	us.course_id,
	us.FullName,
	us.user_mobile_number,
	us.roleName
from
	tr_certificate_master tcm
inner join users us on
	us.id = tcm.user_id
	and tcm.course_id = us.course_id
inner join listvalue_field_value_detail fvm on
	fvm.id = us.module_id
inner join user_form_access ufa on
	ufa.form_code = fvm.value
	and ufa.user_id = us.id
where
	tcm.certificate_type = ''COURSECOMPLETION''
	and us.course_id in (1, 7, 10, 11)
	and ufa.state = ''MOVE_TO_PRODUCTION'' ),
pending as (
select
	*
from
	scheduled
union all
select
	*
from
	practiced
union all
select
	*
from
	production ),
userByType as (
select
	id,
	fullName as "name",
	''pending'' as "type",
	user_mobile_number as "mobileNumber",
	roleName as "roleName"
from
	totalUser tu
where
	tu.id not in (
	select
		id
	from
		pending )
union
select
	id,
	fullName as "name",
	''completed'' as "type",
	user_mobile_number as "mobileNumber",
	roleName as "roleName"
from
	Pending ),
userByLocation as (
select
	us.id,
	string_agg(distinct(lm.name), '','') as location
from
	users us
inner join um_user_location uul on
	uul.user_id = us.id
inner join location_master lm on
	uul.loc_id = lm.id
group by
	us.id )
select
	ut.*,
	ul.location
from
	userByType ut
left join userByLocation ul on
	ut.id = ul.id',
        null,
        true,
        'ACTIVE'
    );
insert into listvalue_field_role (role_id, field_key)
select id,
    'lms_question_set_types'
from um_role_master
where name = 'FHW';
ALTER TABLE tr_question_set_answer drop column if exists start_date,
    drop column if exists end_date,
    add column start_date timestamp without time zone,
    add column end_date timestamp without time zone;
DROP TABLE if exists tr_mobile_event_master;
CREATE TABLE tr_mobile_event_master (
    checksum text primary key,
    user_id integer,
    mobile_date timestamp without time zone,
    event_type text,
    event_data text,
    status text,
    action_date timestamp without time zone,
    error_message text,
    exception text,
    mail_sent boolean
);
DROP TABLE if exists tr_user_meta_data;
CREATE TABLE tr_user_meta_data (
    id serial primary key,
    user_id integer,
    course_id integer,
    quiz_meta_data text,
    lesson_meta_data text,
    created_by integer,
    created_on timestamp without time zone,
    modified_by integer,
    modified_on timestamp without time zone
);
ALTER TABLE tr_course_master DROP COLUMN IF EXISTS estimated_time_in_hrs,
    ADD COLUMN estimated_time_in_hrs integer;
ALTER TABLE IF EXISTS tr_topic_media_master Drop column if EXISTS is_user_feedback_required,
    add column is_user_feedback_required boolean;
DELETE FROM QUERY_MASTER
WHERE CODE = 'get_tr_question_set_configuration_by_name';
INSERT INTO QUERY_MASTER (
        uuid,
        created_by,
        created_on,
        modified_by,
        modified_on,
        code,
        params,
        query,
        description,
        returns_result_set,
        state
    )
VALUES (
        'da4612e0-a00f-4ce4-931c-9925e9c7161f',
        78434,
        current_date,
        78434,
        current_date,
        'get_tr_question_set_configuration_by_name',
        'id,questionSetName,refId,refType',
        '
SELECT
tqsc.*
FROM
tr_question_set_configuration tqsc
where
tqsc.question_set_name = #questionSetName#
and (''#id#'' = ''null'' or tqsc.id != #id#)
and tqsc.ref_id = #refId# and tqsc.ref_type = #refType#;
',
        null,
        true,
        'ACTIVE'
    );
alter table tr_user_meta_data drop column if exists is_course_completed,
    drop column if exists last_accessed_lesson_on,
    drop column if exists last_accessed_quiz_on,
    add column is_course_completed boolean,
    add column last_accessed_lesson_on timestamp without time zone,
    add column last_accessed_quiz_on timestamp without time zone;
ALTER TABLE tr_question_set_configuration DROP COLUMN IF EXISTS total_marks,
    ADD COLUMN total_marks integer;
DELETE FROM QUERY_MASTER
WHERE CODE = 'update_total_marks_tr_question_set_configuration';
INSERT INTO QUERY_MASTER (
        uuid,
        created_by,
        created_on,
        modified_by,
        modified_on,
        code,
        params,
        query,
        description,
        returns_result_set,
        state
    )
VALUES (
        '5606b03f-7f05-4752-a911-e32eac5cfa12',
        78434,
        current_date,
        78434,
        current_date,
        'update_total_marks_tr_question_set_configuration',
        'id,totalMarks,loggedInUserId',
        '
UPDATE tr_question_set_configuration
SET
total_marks=#totalMarks#,
modified_by=#loggedInUserId#,
modified_on=now()
WHERE id=#id#;
',
        null,
        false,
        'ACTIVE'
    );
update tr_question_set_configuration
set total_marks = 0;
with question_data as (
    select id,
        question_set_id,
        json_array_elements(config_json::json)->'questions' as "question",
        json_array_elements(
            json_array_elements(config_json::json)->'questions'
        )->>'questionType' as question_type,
        json_array_length(
            (
                json_array_elements(
                    json_array_elements(config_json::json)->'questions'
                )->>'answers'
            )::json
        ) as answers,
        json_array_length(
            (
                json_array_elements(
                    json_array_elements(config_json::json)->'questions'
                )->>'lhs'
            )::json
        ) as lhs
    from tr_question_bank_configuration
    where config_json is not null
        and config_json != ''
),
question_marks as (
    select question_set_id,
        sum(
            case
                when question_type in ('SINGLE_SELECT', 'MULTI_SELECT') then 1
                when question_type = 'FILL_IN_THE_BLANKS' then answers
                when question_type = 'MATCH_THE_FOLLOWING' then lhs
            end
        ) as total_marks
    from question_data
    group by question_set_id
)
update tr_question_set_configuration
set total_marks = qm.total_marks
from question_marks qm
where qm.question_set_id = tr_question_set_configuration.id;
DELETE FROM QUERY_MASTER
WHERE CODE = 'get_all_tr_question_set_configuration';
INSERT INTO QUERY_MASTER (
        uuid,
        created_by,
        created_on,
        modified_by,
        modified_on,
        code,
        params,
        query,
        description,
        returns_result_set,
        state
    )
VALUES (
        'ced166c6-c5cd-422b-aa66-781798dc794d',
        78434,
        current_date,
        78434,
        current_date,
        'get_all_tr_question_set_configuration',
        'refId,refType',
        '
SELECT
tqsc.id,
tqsc.ref_id as "refId",
tqsc.ref_type as "refType",
tqsc.question_set_name as "questionSetName",
tqsc.status,
tqsc.minimum_marks as "minimumMarks",
tqsc.total_marks as "totalMarks",
tqsc.question_set_type as "questionSetType",
list.value as "questionSetTypeName",
tcm.course_id as "courseId",
tcm.course_name as "courseName",
ttm.topic_id as "topicId",
ttm.topic_name as "topicName",
ttvm.id as "mediaId",
ttvm.title as "mediaName"
FROM
tr_question_set_configuration tqsc
left join tr_course_master tcm on
    case
        when tqsc.ref_type = ''COURSE'' then tqsc.ref_id = tcm.course_id
        when tqsc.ref_type = ''MODULE'' then (select course_id from tr_course_topic_rel where topic_id = tqsc.ref_id) = tcm.course_id
        when tqsc.ref_type = ''LESSON'' then (select course_id from tr_course_topic_rel where topic_id = (select topic_id from tr_topic_media_master where id = tqsc.ref_id)) = tcm.course_id
        else false
    end
left join tr_topic_master ttm on
    case
        when tqsc.ref_type = ''MODULE'' then tqsc.ref_id = ttm.topic_id
        when tqsc.ref_type = ''LESSON'' then (select topic_id from tr_topic_media_master where id = tqsc.ref_id) = ttm.topic_id
        else false
    end
left join tr_topic_media_master ttvm on
    case
        when tqsc.ref_type = ''LESSON'' then tqsc.ref_id = ttvm.id
        else false
    end
left join listvalue_field_value_detail list on list.id = tqsc.question_set_type
where tqsc.ref_id = #refId# and tqsc.ref_type = #refType#
',
        null,
        true,
        'ACTIVE'
    );
ALTER TABLE tr_course_master DROP COLUMN IF EXISTS course_image_json,
    ADD COLUMN course_image_json text;
ALTER TABLE tr_course_master DROP COLUMN IF EXISTS is_allowed_to_skip_lessons,
    ADD COLUMN is_allowed_to_skip_lessons boolean default false;
ALTER TABLE tr_question_set_configuration DROP COLUMN IF EXISTS quiz_at_second,
    ADD COLUMN quiz_at_second int;
DELETE FROM QUERY_MASTER
WHERE CODE = 'get_tr_question_set_configuration_by_id';
INSERT INTO QUERY_MASTER (
        uuid,
        created_by,
        created_on,
        modified_by,
        modified_on,
        code,
        params,
        query,
        description,
        returns_result_set,
        state
    )
VALUES (
        '8334fcd3-34d9-4caa-8f67-198e646d5b52',
        78434,
        current_date,
        78434,
        current_date,
        'get_tr_question_set_configuration_by_id',
        'id',
        '
SELECT
tqsc.id,
tqsc.ref_id as "refId",
tqsc.ref_type as "refType",
tqsc.question_set_name as "questionSetName",
tqsc.question_set_type as "questionSetType",
list.value as "questionSetTypeName",
tqsc.status,
tqsc.minimum_marks as "minimumMarks",
tqsc.total_marks as "totalMarks",
tqsc.quiz_at_second as "quizAtSecond",
tcm.course_id as "courseId",
tcm.course_name as "courseName",
ttm.topic_id as "topicId",
ttm.topic_name as "topicName",
ttvm.id as "mediaId",
ttvm.title as "mediaName"
FROM
tr_question_set_configuration tqsc
left join tr_course_master tcm on
    case
        when tqsc.ref_type = ''COURSE'' then tqsc.ref_id = tcm.course_id
        when tqsc.ref_type = ''MODULE'' then (select course_id from tr_course_topic_rel where topic_id = tqsc.ref_id) = tcm.course_id
        when tqsc.ref_type = ''LESSON'' then (select course_id from tr_course_topic_rel where topic_id = (select topic_id from tr_topic_media_master where id = tqsc.ref_id)) = tcm.course_id
        else false
    end
left join tr_topic_master ttm on
    case
        when tqsc.ref_type = ''MODULE'' then tqsc.ref_id = ttm.topic_id
        when tqsc.ref_type = ''LESSON'' then (select topic_id from tr_topic_media_master where id = tqsc.ref_id) = ttm.topic_id
        else false
    end
left join tr_topic_media_master ttvm on
    case
        when tqsc.ref_type = ''LESSON'' then tqsc.ref_id = ttvm.id
        else false
    end
left join listvalue_field_value_detail list on list.id = tqsc.question_set_type
where tqsc.id = #id#;
',
        null,
        true,
        'ACTIVE'
    );
DELETE FROM QUERY_MASTER
WHERE CODE = 'insert_into_tr_question_set_configuration';
INSERT INTO QUERY_MASTER (
        uuid,
        created_by,
        created_on,
        modified_by,
        modified_on,
        code,
        params,
        query,
        description,
        returns_result_set,
        state
    )
VALUES (
        'b5fd4d27-97be-42c1-8644-b3165f470cfc',
        78434,
        current_date,
        78434,
        current_date,
        'insert_into_tr_question_set_configuration',
        'refId,refType,questionSetName,questionSetType,status,minimumMarks,quizAtSecond,loggedInUserId,courseId',
        '
INSERT INTO tr_question_set_configuration
(ref_id, ref_type, question_set_name, question_set_type, status, minimum_marks, course_id, quiz_at_second, created_by, created_on, modified_by, modified_on)
VALUES
(#refId#, #refType#, #questionSetName#, #questionSetType#, #status#, #minimumMarks#, #courseId#, #quizAtSecond#, #loggedInUserId#, now(), #loggedInUserId#, now());
',
        null,
        false,
        'ACTIVE'
    );
DELETE FROM QUERY_MASTER
WHERE CODE = 'get_question_sets_by_second';
INSERT INTO QUERY_MASTER (
        uuid,
        created_by,
        created_on,
        modified_by,
        modified_on,
        code,
        params,
        query,
        description,
        returns_result_set,
        state
    )
VALUES (
        '59208411-4989-45ae-8d28-60dc68f01690',
        78434,
        current_date,
        78434,
        current_date,
        'get_question_sets_by_second',
        'refId,refType,quizAtSecond,id',
        '
select
    *
from
    tr_question_set_configuration
where
    ref_id = #refId#
    and ref_type = #refType#
    and quiz_at_second = #quizAtSecond#
    and id != #id#;
',
        null,
        true,
        'ACTIVE'
    );
alter table tr_question_set_answer drop column if exists is_locked,
    add column is_locked boolean;