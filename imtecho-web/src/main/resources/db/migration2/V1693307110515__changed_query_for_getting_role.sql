DELETE FROM QUERY_MASTER WHERE CODE='retrieve_roles_for_lms_dashboard_based_on_course';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'b830475c-e7ae-41ad-a24e-fe44cd3781c5', 97074,  current_date , 97074,  current_date , 'retrieve_roles_for_lms_dashboard_based_on_course',
'courseId',
'SELECT DISTINCT urm.id, urm.name
FROM um_role_master urm
INNER JOIN tr_course_role_rel tcrr ON tcrr.role_id = urm.id
WHERE (#courseId# IS NULL OR tcrr.course_id = #courseId#)
  AND tcrr.course_id IN (
    SELECT course_id
    FROM tr_course_master
    WHERE course_state = ''ACTIVE''
      AND course_type = ''ONLINE''
  );',
null,
true, 'ACTIVE');