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