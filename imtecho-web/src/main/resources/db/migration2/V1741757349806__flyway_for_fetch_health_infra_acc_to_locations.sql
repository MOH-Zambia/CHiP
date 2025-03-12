DELETE FROM QUERY_MASTER WHERE CODE='fetch_health_infra_acc_to_locations';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'188a7073-9f28-4b7e-82a3-0f052d2de91a', 97339,  current_date , 97339,  current_date , 'fetch_health_infra_acc_to_locations',
'location_id',
'with locations as (
    select
        lm.id as location_id,
        lm.english_name as location_name
    from location_master lm
    inner join location_hierchy_closer_det lhcd on lm.id = lhcd.child_id
    where lhcd.parent_id = #location_id#  and lhcd.depth = 0
)

select l.location_id,hid.name from locations l
left join location_hierchy_closer_det lhcd on l.location_id = lhcd.parent_id
left join health_infrastructure_details hid on hid .location_id = lhcd.child_id where hid.name is not null group by 1,2',
'Fetches health infrastructure in accordance with',
true, 'ACTIVE');