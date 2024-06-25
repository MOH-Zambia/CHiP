
ALTER TABLE notification_type_master DROP COLUMN IF EXISTS UUID;

ALTER TABLE notification_type_master ADD COLUMN UUID UUID;


ALTER TABLE escalation_level_master DROP COLUMN IF EXISTS UUID;

ALTER TABLE escalation_level_master ADD COLUMN UUID UUID;


ALTER TABLE event_configuration DROP COLUMN IF EXISTS UUID;

ALTER TABLE event_configuration ADD COLUMN UUID UUID;

UPDATE public.notification_type_master
	SET uuid = uuid_generate_v4()
	WHERE uuid is null;

UPDATE public.escalation_level_master
	SET uuid = uuid_generate_v4()
	WHERE uuid is null;

UPDATE public.event_configuration
	SET uuid = uuid_generate_v4()
	WHERE uuid is null;

