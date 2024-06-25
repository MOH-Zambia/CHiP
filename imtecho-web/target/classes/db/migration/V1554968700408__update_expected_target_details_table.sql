


alter table cm_dashboard_expected_target_details
add column created_by bigint,
add column created_on timestamp without time zone,
add column modified_by bigint,
add column modified_on timestamp without time zone;


alter table cm_dashboard_expected_target_details rename to location_wise_expected_target;

