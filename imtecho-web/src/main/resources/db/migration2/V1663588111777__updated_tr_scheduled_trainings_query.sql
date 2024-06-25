DELETE FROM QUERY_MASTER WHERE CODE='tr_scheduled_trainings';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
           '40a243ce-5253-4a6d-ae6e-45c0a93f1d74', 97135,  current_date , 97135,  current_date , 'tr_scheduled_trainings',
           'offSet,locationId,limit,isShowPast,moduleId,userId,courseId',
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
                            and cm.course_state = ''ACTIVE''
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
                          r1."courseType"
                          order by r1."effectiveDate" desc
                          limit #limit# offset #offSet#',
           null,
           true, 'ACTIVE');