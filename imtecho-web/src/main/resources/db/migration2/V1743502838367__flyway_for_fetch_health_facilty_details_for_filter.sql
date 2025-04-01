DELETE FROM QUERY_MASTER WHERE CODE='fetch_health_facilty_details_for_filter';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'836285dd-fbf2-4809-bb49-85b1ade155c4', 97921,  current_date , 97921,  current_date , 'fetch_health_facilty_details_for_filter',
'loggedInUserId,location_id',
'SELECT hid.name AS healthfacility, hid.location_id as location_id, hid.id as "healthInfraId"
FROM location_hierchy_closer_det lhcd
INNER JOIN um_user_location uul ON uul.loc_id = lhcd.child_id
INNER JOIN um_user uu ON uul.user_id = uu.id AND (uu.role_id = 245 or uu.role_id = 249)
INNER JOIN user_health_infrastructure uhi ON uu.id = uhi.user_id
INNER JOIN health_infrastructure_details hid ON uhi.health_infrastrucutre_id = hid.id
WHERE lhcd.parent_id = #location_id#
AND (
  (SELECT role_id FROM um_user WHERE id = #loggedInUserId#) != 249
  OR uu.id = #loggedInUserId#
)
GROUP BY hid.name, hid.location_id, hid.id;',
'fetch health facilty details for filter',
true, 'ACTIVE');