DELETE FROM QUERY_MASTER WHERE CODE='delete_scheduled_training';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'497cb168-d4b9-4837-a505-74f37753771f', 97084,  current_date , 97084,  current_date , 'delete_scheduled_training', 
'training_id', 
'with delete_tr_attendance_master as(
    delete from tr_attendance_master tam where training_id in (#training_id#)
    ),delete_tr_topic_coverage_master as(
    delete from tr_topic_coverage_master tam where training_id in (#training_id#)
    ),delete_tr_training_additional_attendee_rel as(
    delete from tr_training_additional_attendee_rel tam where training_id in (#training_id#)
    ),delete_tr_training_attendee_rel as(
    delete from tr_training_attendee_rel tam where training_id in (#training_id#)
    ),delete_tr_training_optional_trainer_rel as(
    delete from tr_training_optional_trainer_rel tam where training_id in (#training_id#)
    ),delete_tr_training_org_unit_rel as(
    delete from tr_training_org_unit_rel tam where training_id in (#training_id#)
    ),delete_tr_training_target_role_rel as(
    delete from tr_training_target_role_rel tam where training_id in (#training_id#)
    ),delete_tr_training_primary_trainer_rel as(
    delete from tr_training_primary_trainer_rel tam where training_id in (#training_id#)
    ),delete_tr_training_course_rel as(
    delete from tr_training_course_rel tam where training_id in (#training_id#)
    ),delete_tr_certificate_master as(
    delete from tr_certificate_master tcm  where training_id in (#training_id#)
    )
    delete from tr_training_master tam where training_id in (#training_id#);', 
'Deletes training scheduled 1 day or afterwards in future.', 
false, 'ACTIVE');