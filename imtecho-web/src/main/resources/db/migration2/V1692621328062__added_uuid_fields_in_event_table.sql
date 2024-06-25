alter table timer_event
add column if not exists event_config_uuid uuid;

begin;

ALTER TABLE timer_event DISABLE TRIGGER log_timer_event_history;

with config_uuids as (
	select id as event_id, uuid as event_uuid
	from event_configuration
	where id in (select event_config_id from timer_event where event_config_id is not null)
)
update timer_event
set event_config_uuid = event_uuid
from config_uuids
where event_config_id = event_id and event_config_id is not null;

ALTER TABLE timer_event ENABLE TRIGGER log_timer_event_history;

commit;

alter table event_configuration_type
add column if not exists event_config_uuid uuid;

begin;

with config_uuids as (
	select id as event_id, uuid as event_uuid
	from event_configuration
	where id in (select config_id from event_configuration_type where config_id is not null)
)
update event_configuration_type
set event_config_uuid = event_uuid
from config_uuids
where config_id = event_id and config_id is not null;

commit;