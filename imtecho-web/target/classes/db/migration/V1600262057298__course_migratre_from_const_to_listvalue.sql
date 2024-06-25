delete from listvalue_field_value_detail where field_key  = 'COURSE_MODULE_NAME';
delete from listvalue_field_master where field_key = 'COURSE_MODULE_NAME';

INSERT INTO listvalue_field_master
(field_key, field, is_active, field_type, form, role_type)
VALUES('COURSE_MODULE_NAME', 'Course Module Name', true, 'T', NULL, NULL);

INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
select true, false, 'nvora', now(), field_value , 'COURSE_MODULE_NAME', 0, NULL, NULL
from field_value_master fvm where fvm.field_id  = (select id from field_constant_master fcm  where fcm.field_name  = 'COURSE_MODULE_NAME');

update tr_course_master	
set module_id = t.new_id
from (
	select fvm.id as old_id,lfvd.id as new_id  from listvalue_field_value_detail lfvd  
	left join field_value_master fvm on fvm.field_value = lfvd.value 
	where lfvd.field_key  = 'COURSE_MODULE_NAME'
	and fvm.field_id  = (select id from field_constant_master fcm  where fcm.field_name  = 'COURSE_MODULE_NAME')
) t
where module_id = t.old_id;

DELETE FROM QUERY_MASTER WHERE CODE='get_course_module_name';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'fe99ce90-a33b-4094-85b0-3c021caafb50', 74841,  current_date , 74841,  current_date , 'get_course_module_name', 
 null, 
'select id, 
cast(null as text) as "fieldId", 
value as "fieldValue" from listvalue_field_value_detail lfvd where lfvd.field_key = ''COURSE_MODULE_NAME''
order by value;', 
null, 
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='tr_scheduled_trainings';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'40a243ce-5253-4a6d-ae6e-45c0a93f1d74', 74841,  current_date , 74841,  current_date , 'tr_scheduled_trainings', 
'locationId,isShowPast,moduleId,userId,courseId', 
'select string_agg(r1."location",'','') as "location",r1."trainingId",r1."trainerId",r1."courseName",r1."trainer",r1."effectiveDate",r1."expirationDate",r1."module",
r1."total",r1."trainingState",r1."completed",r1."pending" from
(select string_agg(lm.name,''>'' order by lhcd.depth desc) as "location",res.training_id "trainingId",res.primary_trainer_id "trainerId"
,res.course_name as "courseName",concat(us.first_name,'' '',us.last_name) as "trainer",fvm.value as "module",total.total as "total",
res.effective_date as "effectiveDate",res.expiration_date as "expirationDate",res.training_state as "trainingState",cert."completed",
tcm.state as "pending"
from
(select tm.training_id,ptr.primary_trainer_id,cm.course_id,cm.course_name,cm.module_id,torg.org_unit_id,
tm.effective_date,tm.expiration_date,tm.training_state
from
tr_training_master tm inner join tr_training_course_rel tcr on tm.training_id = tcr.training_id
inner join tr_training_org_unit_rel torg on tm.training_id = torg.training_id
inner join tr_training_primary_trainer_rel ptr on ptr.training_id = tm.training_id
inner join tr_course_master cm on tcr.course_id = cm.course_id
where torg.org_unit_id in (select child_id from location_hierchy_closer_det where
((#locationId# is null and parent_id in (select loc_id from um_user_location where user_id = #userId# and state = ''ACTIVE''))
or #locationId# is not null and  parent_id  = #locationId#))
and (case when #moduleId# is not null then cm.module_id = #moduleId# else true end)
and (case when #courseId# is not null then tcr.course_id =  #courseId# else true end)
and (case when #isShowPast# = true then true else tm.expiration_date\:\:date >= current_date end)) res
inner join
(select count(*) as "total",training_id from
(select * from tr_training_attendee_rel union select * from tr_training_additional_attendee_rel)r group by r.training_id) total
on res.training_id = total.training_id
left join (with tr_topic_coverage_master_temp as (
select ttm."day", ttcm.*  from tr_topic_master ttm inner join tr_topic_coverage_master ttcm on ttm.topic_id = ttcm.topic_id
),
days_details as(
select max(ttcmp.day),ttcmp.training_id from tr_topic_coverage_master_temp ttcmp
group by ttcmp.training_id
),
training_details as
(select max(ttcmp.topic_id) as max_topic,ttcmp.training_id  from tr_topic_coverage_master_temp ttcmp inner join days_details on ttcmp."day" = days_details.max and
ttcmp.training_id = days_details.training_id group by ttcmp.training_id
)
select td.max_topic,ttcm.topic_id, ttcm.state, ttcm.expiration_date, ttcm.training_id from tr_topic_coverage_master ttcm,training_details td where ttcm.training_id = td.training_id
and ttcm.topic_id = td.max_topic
) tcm
on res.training_id = tcm.training_id
left join
(select count(*) as "completed",training_id from tr_certificate_master
where certificate_type = ''COURSECOMPLETION''
group by training_id) cert
on res.training_id= cert.training_id
inner join location_hierchy_closer_det lhcd on lhcd.child_id = res.org_unit_id
inner join location_master lm on lm.id = lhcd.parent_id
inner join um_user us on us.id = res.primary_trainer_id
left join listvalue_field_value_detail fvm on fvm.id = res.module_id
group by res.training_id,res.primary_trainer_id,res.course_name,us.first_name,us.last_name,fvm.value,res.effective_date,
res.expiration_date,total.total,res.training_state,cert."completed",tcm.state,res.org_unit_id) r1
group by r1."trainingId",r1."trainerId",r1."courseName",r1."trainer",r1."effectiveDate",r1."expirationDate",r1."module",
r1."total",r1."trainingState",r1."completed",r1."pending"', 
null, 
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='training_eligible_count';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'fe17992c-bd9f-483b-b371-981e0f2867ce', 74841,  current_date , 74841,  current_date , 'training_eligible_count', 
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
	tr_course_master.course_name as courseName,
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
	roleName
from
	users u) ,
scheduled as (
select
	us.id ,
	us.course_id,
	us.role_id,
	us.FullName
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
	(tr.expiration_date >= current_date)
	and tr.training_state = ''DRAFT'' ),
practiced as (
select
	us.id,
	us.role_id,
	us.course_id,
	us.FullName
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
	us.FullName
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
	us.FullName
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
	''pending'' as "type"
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
	''completed'' as "type"
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
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='training_dashboard_pending_list';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'eaf13434-a4e9-49c8-8c5f-9d05c76cf9c9', 74841,  current_date , 74841,  current_date , 'training_dashboard_pending_list', 
'locationId,userId', 
'with location_det as(
select child_id as loc_id from location_hierchy_closer_det  
where parent_id in (select distinct case when #locationId# is not null then  #locationId# else loc_id end from um_user_location where user_id = #userId# and state = ''ACTIVE'')
),users AS (
SELECT tcrr.role_id, tcrr.course_id, uu.id,tr_course_master.module_id FROM 
	tr_course_master
	inner join tr_course_role_rel tcrr on tcrr.course_id = tr_course_master.course_id and tr_course_master.course_state = ''ACTIVE''
	INNER JOIN um_user uu ON uu.role_id = tcrr.role_id and uu.state = ''ACTIVE''
	inner join um_user_location ul on ul.state = ''ACTIVE'' and ul.user_id = uu.id
       	inner join location_det ld on ld.loc_id = ul.loc_id

),totalUser as 
(select u.course_id,u.role_id,COALESCE(count(distinct u.id),0) total from users u GROUP BY u.course_id,u.role_id)
,scheduled as (
		select count(distinct us.id) as scheduled,us.course_id,us.role_id from tr_training_master tr
		inner join tr_training_course_rel tcr on tr.training_id = tcr.training_id
                 inner join (select * from tr_training_attendee_rel union select * from tr_training_additional_attendee_rel) r 
                 on tr.training_id = r.training_id 
	         right join users us on us.id = r.attendee_id and us.course_id = tcr.course_id
                 where (tr.expiration_date >= current_date) and tr.training_state = ''DRAFT''
                 --where tr.training_state = ''DRAFT''
                 group by us.course_id,us.role_id
),
practiced as (
	SELECT us.role_id, us.course_id, COALESCE(count(distinct us.id),0) as practiced from tr_certificate_master tcm 
	INNER JOIN users us on us.id = tcm.user_id and tcm.course_id = us.course_id
	inner join listvalue_field_value_detail fvm on fvm.id = us.module_id
	left join user_form_access ufa on ufa.form_code = fvm.value and ufa.user_id = us.id
	--INNER JOIN tr_training_master ttm ON tcm.training_id = ttm.training_id
	--INNER JOIN tr_course_master cm on cm.course_id = tcm.course_id
	where tcm.certificate_type = ''COURSECOMPLETION'' and us.course_id in (1,7,10,11,26)
	and ufa.form_code is null
	--ttm.training_state = ''SUBMITTED'' and tcm.certificate_type = ''COURSECOMPLETION'' 
	--and us.state = ''ACTIVE'' and cm.course_state=''ACTIVE''
	group by us.course_id,us.role_id
),production as (
	SELECT us.role_id, us.course_id, count(distinct us.id) as production from tr_certificate_master tcm 
	INNER JOIN users us on us.id = tcm.user_id and tcm.course_id = us.course_id
	--inner join listvalue_field_value_detail fvm on fvm.id = us.module_id
	--left join user_form_access ufa on ufa.form_code = fvm.value
	--INNER JOIN tr_training_master ttm ON tcm.training_id = ttm.training_id
	--INNER JOIN tr_course_master cm on cm.course_id = tcm.course_id
	where tcm.certificate_type = ''COURSECOMPLETION'' and us.course_id not in (1,7,10,11,26)
	--and ufa.form_code is null
	--ttm.training_state = ''SUBMITTED'' and tcm.certificate_type = ''COURSECOMPLETION'' 
	--and us.state = ''ACTIVE'' and cm.course_state=''ACTIVE''
	group by us.course_id,us.role_id
	union all
	SELECT us.role_id, us.course_id, count(distinct us.id) as production from tr_certificate_master tcm 
	INNER JOIN users us on us.id = tcm.user_id and tcm.course_id = us.course_id
	inner join listvalue_field_value_detail fvm on fvm.id = us.module_id
	inner join user_form_access ufa on ufa.form_code = fvm.value and ufa.user_id = us.id
	--INNER JOIN tr_training_master ttm ON tcm.training_id = ttm.training_id
	--INNER JOIN tr_course_master cm on cm.course_id = tcm.course_id
	where tcm.certificate_type = ''COURSECOMPLETION'' and us.course_id in (1,7,10,11,26) and ufa.state=''MOVE_TO_PRODUCTION''
	--and ufa.form_code is not null
	--ttm.training_state = ''SUBMITTED'' and tcm.certificate_type = ''COURSECOMPLETION'' 
	--and us.state = ''ACTIVE'' and cm.course_state=''ACTIVE''
	group by us.course_id,us.role_id
),
pending as (
	SELECT totalUser.total - (COALESCE(scheduled,0)+ COALESCE(practiced,0)+COALESCE(production,0)) as pending,totalUser.course_id ,totalUser.role_id from totalUser

	LEFT JOIN scheduled ON totalUser.course_id = scheduled.course_id AND totalUser.role_id = scheduled.role_id
	LEFT JOIN practiced ON totalUser.course_id = practiced.course_id AND totalUser.role_id = practiced.role_id
LEFT JOIN production ON totalUser.course_id = production.course_id AND totalUser.role_id = production.role_id
	INNER JOIN tr_course_master tcm ON totalUser.course_id = tcm.course_id
	INNER JOIN um_role_master urm ON totalUser.role_id = urm.id
)
SELECT  totalUser.course_id as "id",
	tcm.course_name as "courseName",
	urm.name as role,
	totalUser.role_id as "roleId",
	totalUser.total, 
	COALESCE(scheduled,0) as scheduled,
	COALESCE(practiced,0) as practicing,
	COALESCE(production,0) as production , 
        pending 
	FROM totalUser
	
	LEFT JOIN production ON totalUser.course_id = production.course_id AND totalUser.role_id = production.role_id
	LEFT JOIN scheduled ON totalUser.course_id = scheduled.course_id AND totalUser.role_id = scheduled.role_id
	LEFT JOIN practiced ON totalUser.course_id = practiced.course_id AND totalUser.role_id = practiced.role_id
	LEFT JOIN pending ON totalUser.course_id = pending.course_id AND totalUser.role_id = pending.role_id
	INNER JOIN tr_course_master tcm ON totalUser.course_id = tcm.course_id
	INNER JOIN um_role_master urm ON totalUser.role_id = urm.id;', 
null, 
true, 'ACTIVE');