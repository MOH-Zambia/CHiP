ALTER TABLE rch_member_death_deatil 
DROP COLUMN IF EXISTS place_of_death,
ADD COLUMN place_of_death character varying(20);

ALTER TABLE rch_member_death_deatil 
DROP COLUMN IF EXISTS location_id,
ADD COLUMN location_id bigint;

ALTER TABLE rch_member_death_deatil 
DROP COLUMN IF EXISTS location_hierarchy_id,
ADD COLUMN location_hierarchy_id bigint;

UPDATE query_master set params = 'member_id,location_id,location_hierarchy_id,action_by,family_id,date_of_death,death_reason,place_of_death',
query = 'update techo_notification_master set state = ''MARK_AS_DEATH'', modified_on = now(), modified_by = #action_by# where member_id = #member_id# and state in (''PENDING'',''RESCHEDULE'');
update event_mobile_notification_pending set is_completed = true, state = ''MARK_AS_DEATH'', modified_by = #action_by#, modified_on = now() from event_mobile_configuration where event_mobile_notification_pending.notification_configuration_type_id = event_mobile_configuration.id and member_id = #member_id# and state = ''PENDING'';
INSERT INTO public.rch_member_death_deatil(
	member_id, family_id, location_id, location_hierarchy_id, dod, death_reason, place_of_death, created_on, created_by
)
VALUES(
	#member_id#, #family_id#, #location_id#, #location_hierarchy_id#, ''#date_of_death#'', #death_reason#, ''#place_of_death#'', now(), #action_by#
);
update imt_member set death_detail_id = rch_member_death_deatil.id, state = ''com.argusoft.imtecho.member.state.dead'', modified_on = now(), modified_by = #action_by# from rch_member_death_deatil where imt_member.id = #member_id# and rch_member_death_deatil.member_id = imt_member.id;' 
where code = 'mark_member_as_death';