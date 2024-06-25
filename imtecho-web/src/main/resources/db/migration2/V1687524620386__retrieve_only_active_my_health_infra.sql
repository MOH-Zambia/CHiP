DELETE FROM QUERY_MASTER WHERE CODE='my_health_infrastructure_retrieval';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'3b1c4098-14e4-4418-b33f-34e9fd2864f2', 97084,  current_date , 97084,  current_date , 'my_health_infrastructure_retrieval',
'offset,limit,loggedInUserId',
'select
    hid.hfr_facility_id as hfrFacilityId,
    hid.*,
    get_location_hierarchy(hid.location_id) as "locationHierarchy"
    from user_health_infrastructure uhi
    inner join health_infrastructure_details hid on uhi.health_infrastrucutre_id = hid.id
    where uhi.user_id = #loggedInUserId#
    and uhi.state = ''ACTIVE'' and hid.state = ''ACTIVE''
    limit #limit# offset #offset#',
'Retrieve My Health Infrastructures',
true, 'ACTIVE');