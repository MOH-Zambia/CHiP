INSERT INTO public.notification_type_master(created_by, created_on, 
modified_by, modified_on, code, name, type, role_id, state)
VALUES (-1,now(),-1,now(),'FHW_DEATH_CONF','FHW Death Confirmation','MO',30,'ACTIVE');

INSERT INTO public.notification_type_master(created_by, created_on, 
modified_by, modified_on, code, name, type, role_id, state)
VALUES (-1,now(),-1,now(),'FHW_DELIVERY_CONF','FHW Delivery Confirmation','MO',30,'ACTIVE');

INSERT INTO public.notification_type_master(created_by, created_on, 
modified_by, modified_on, code, name, type, role_id, state)
VALUES (-1,now(),-1,now(),'FHW_MEMBER_MIGRATION','FHW Member Migration','MO',30,'ACTIVE');

INSERT INTO public.notification_type_master(created_by, created_on, 
modified_by, modified_on, code, name, type, role_id, state)
VALUES (-1,now(),-1,now(),'FHW_FAMILY_MIGRATION','FHW Family Migration','MO',30,'ACTIVE');

INSERT INTO public.notification_type_master(created_by, created_on, 
modified_by, modified_on, code, name, type, role_id, state)
VALUES (-1,now(),-1,now(),'FHW_FAMILY_SPLIT','FHW family Split','MO',30,'ACTIVE');


CREATE TABLE rch_asha_reported_event_master (
	id bigserial PRIMARY KEY,
	event_type text,
	family_id bigint,
	member_id bigint,
	location_id bigint,
	reported_on timestamp without time zone,
        action text,
        action_on timestamp without time zone,
        action_by bigint,
	created_by bigint,
	created_on timestamp without time zone,
	modified_by bigint,
	modified_on timestamp without time zone
);



