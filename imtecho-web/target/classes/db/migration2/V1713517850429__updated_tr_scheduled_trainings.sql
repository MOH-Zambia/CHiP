DELETE FROM QUERY_MASTER WHERE CODE='tr_scheduled_trainings';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'40a243ce-5253-4a6d-ae6e-45c0a93f1d74', 97084,  current_date , 97084,  current_date , 'tr_scheduled_trainings', 
'courseType,offSet,locationId,dateTo,limit,isShowPast,trainingState,moduleId,dateFrom,userId,courseId', 
'select
	r1."location" as "location",
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
            get_location_hierarchy(res.org_unit_id) as "location",
            res.training_id "trainingId",
            res.primary_trainer_id "trainerId",
            res.course_name as "courseName",
            concat(us.first_name, '' '', us.last_name) as "trainer",
            fvm.value as "module",
            total.total as "total",
            res.effective_date as "effectiveDate",
            res.expiration_date as "expirationDate",
            res.training_state as "trainingState",
            cert."completed",
            tcm.state as "pending",
            res.course_type as "courseType"
        from (
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
                    -- and
                    -- (case
                    --     when #moduleId# is not null then cm.module_id = #moduleId#
                    --     else true
                    -- end)
                    and
                    (case
                        when #courseId# is not null then tcr.course_id = #courseId#
                        else true
                    end)
                    -- and
                    -- (case
                    --     when #isShowPast# = true then true
                    --     when cm.course_type = ''ONLINE'' then true
                    --     else cast(tm.expiration_date as date) >= current_date
                    -- end)
                    and
                    (case
                        when #courseType# = ''ONLINE'' then cm.course_type = ''ONLINE''
                        when #courseType# = ''OFFLINE'' then cm.course_type = ''OFFLINE''
                        else true
                    end)
                    and 
                    (case
                        when #dateTo# is not null then tm.effective_date between cast(#dateFrom# as timestamp) and cast(#dateTo# as timestamp)
                        when #dateTo# is null then tm.effective_date>=cast(#dateFrom# as timestamp)
                        else true
                     end
                    )
                    and
                    (case
                        when #trainingState# is not null then
                            case
                                when #trainingState# = ''NOT_DRAFT'' then tm.training_state != ''DRAFT''
                                when #trainingState# = ''DRAFT_SAVED'' then tm.training_state in (''DRAFT'', ''SAVED'')
                                else tm.training_state = #trainingState#
                            end
                        else true
                    end)
        ) res
        inner join (
            select
                count(*) as "total", training_id
            from
                (
                    select attendee_id  as attendee_id,training_id
                    from tr_training_attendee_rel
                    inner join um_user on tr_training_attendee_rel.attendee_id = um_user.id
                    where um_user.state =''ACTIVE''
                    union
                    select additional_attendee_id as attendee_id ,training_id
                    from tr_training_additional_attendee_rel
                    inner join um_user on tr_training_additional_attendee_rel.additional_attendee_id = um_user.id
                    where um_user.state =''ACTIVE''
                ) r
            group by r.training_id
        ) total on res.training_id = total.training_id
        left join (
            with tr_topic_coverage_master_temp as (
                select
                    ttm."day",
                    ttcm.*
                from
                    tr_topic_master ttm
                inner join tr_topic_coverage_master ttcm on
                    ttm.topic_id = ttcm.topic_id
            ),
            days_details as(
                select
                    max(ttcmp.day),
                    ttcmp.training_id
                from
                    tr_topic_coverage_master_temp ttcmp
                group by
                    ttcmp.training_id
            ),
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
                    ttcmp.training_id
            )
            select
                td.max_topic, ttcm.topic_id, ttcm.state, ttcm.expiration_date, ttcm.training_id
            from
                tr_topic_coverage_master ttcm, training_details td
            where
                ttcm.training_id = td.training_id
                and ttcm.topic_id = td.max_topic
        ) tcm on res.training_id = tcm.training_id
        left join (
            select
                count(*) as "completed", training_id
            from
                tr_certificate_master
            where
                certificate_type = ''COURSECOMPLETION''
            group by
                training_id
        ) cert on res.training_id = cert.training_id
        left join um_user us on us.id = res.primary_trainer_id
        left join listvalue_field_value_detail fvm on fvm.id = res.module_id
    ) r1
order by r1."effectiveDate" desc
limit #limit# offset #offSet#', 
'N/A', 
true, 'ACTIVE');