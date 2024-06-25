create table if not exists announcement_health_infra_detail
(
	announcement integer not null,
	health_infra_id integer not null
);

alter table announcement_location_detail
alter column announcement_for type character varying(20);

