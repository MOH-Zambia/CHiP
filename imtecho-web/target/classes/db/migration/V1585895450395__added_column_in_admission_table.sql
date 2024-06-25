
alter table covid19_admission_detail
add column location_id_by_geo_is_precessed boolean default false;

alter table covid19_admission_detail
add column location_id_by_geo integer;

alter table covid19_admission_detail
add column address_lat text;

alter table covid19_admission_detail
add column address_lng text;

alter table covid19_admission_detail
add column address_gapi_response text;

alter table covid19_admission_detail
add column base_location_id integer;
