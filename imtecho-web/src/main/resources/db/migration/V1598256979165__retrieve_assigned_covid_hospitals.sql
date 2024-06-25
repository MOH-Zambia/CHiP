-- Added just "is_covid_lab = true" condition at the end


DELETE FROM QUERY_MASTER WHERE CODE='retrieve_assigned_covid_hospitals';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'22e1256b-9081-4a13-9e15-407dedba7d1a', 74840,  current_date , 74840,  current_date , 'retrieve_assigned_covid_hospitals',
'userId',
'select
    health_infrastructure_details.*,
    get_location_hierarchy(health_infrastructure_details.location_id) as "healthInfraLocation",
    listvalue_field_value_detail.value as "typeOfHosiptalName"
    from health_infrastructure_details
    inner join user_health_infrastructure on health_infrastructure_details.id = user_health_infrastructure.health_infrastrucutre_id
    left join listvalue_field_value_detail on health_infrastructure_details.type = listvalue_field_value_detail.id
    where user_health_infrastructure.user_id = #userId#
    and user_health_infrastructure.state = ''ACTIVE''
    and (health_infrastructure_details.is_covid_hospital or health_infrastructure_details.is_covid_lab)
    and is_covid_lab = true',
null,
true, 'ACTIVE');