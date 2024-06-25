DELETE FROM public.query_master where code = 'update_lmp_date';
INSERT INTO public.query_master(
    created_by, created_on, code, params, query, returns_result_set, state, description)
VALUES (1, localtimestamp, 'update_lmp_date', 'member_id,last_lmp_date,pregnancy_reg_det_id', 
    'update rch_pregnancy_registration_det set lmp_date = #last_lmp_date# where member_id = #member_id#;
    update imt_member set lmp = #last_lmp_date# where id = #member_id#;
    update event_mobile_notification_pending set base_date = #last_lmp_date# 
        where member_id = #member_id# and ref_code = #pregnancy_reg_det_id#;', 
    false, 'ACTIVE', 'It will update the lmp_date in imt_member, rch_pregnancy_registration_det and event_mobile_notification_pending');


DELETE FROM public.query_master where code = 'mob_notification_reschedule';
INSERT INTO public.query_master(
    created_by, created_on, code, params, query, returns_result_set, state, description)
VALUES (1, localtimestamp, 'mob_notification_reschedule', 'expiary_days_add,action_by,due_days_add,schedule_days_add,notification_id', 
    'update techo_notification_master set state = ''RESCHEDULE'', 
        modified_by = #action_by#, modified_on = now(), 
        schedule_date = current_date + #schedule_days_add# * INTERVAL ''1 day'', 
        due_on = case when ''#due_days_add#'' != ''null'' then (current_date + #schedule_days_add# * INTERVAL ''1 day'') + #due_days_add# * INTERVAL ''1 day'' else null end,
        expiry_date = case when ''#expiary_days_add#'' != ''null'' then (current_date + #schedule_days_add# * INTERVAL ''1 day'') + #expiary_days_add# * INTERVAL ''1 day'' else expiry_date end
        where id = #notification_id#;', 
    false, 'ACTIVE', 'It will mark the mobile notification as RESCHEDULE');


DELETE FROM public.query_master where code = 'mob_notification_mark_as_complete';
INSERT INTO public.query_master(
    created_by, created_on, code, params, query, returns_result_set, state, description)
VALUES (1, localtimestamp, 'mob_notification_mark_as_complete', 'action_by,notification_id', 
    'update techo_notification_master set state = ''COMPLETED'', 
        action_by = #action_by#, modified_by = #action_by#, modified_on = now() 
        where id = #notification_id#;', 
    false, 'ACTIVE', 'It will mark the mobile notification as COMPLETE');


DELETE FROM public.query_master where code = 'mark_as_wrongly_pregnancy_mark';
INSERT INTO public.query_master(
    created_by, created_on, code, params, query, returns_result_set, state, description)
VALUES (1, localtimestamp, 'mark_as_wrongly_pregnancy_mark', 'member_id,action_by,last_lmp_date,created_by', 
    'update techo_notification_master set state = ''MARK_AS_WRONGLY_PREGNANT'', 
        modified_on = now(), modified_by = #action_by# 
        where member_id = #member_id# and state in (''PENDING'',''RESCHEDULE'') 
        and notification_type_id in (17/*FHW WPD*/,13/*ANC*/);
    update event_mobile_notification_pending set is_completed = true, state = ''MARK_AS_WRONGLY_PREGNANT'', 
        modified_by = #action_by#, modified_on = now() from event_mobile_configuration 
        where event_mobile_notification_pending.notification_configuration_type_id = event_mobile_configuration.id 
        and member_id = #member_id# and state = ''PENDING'';
    update imt_member set is_pregnant = false, lmp = ''#last_lmp_date#'', 
        modified_by = #created_by#, modified_on = now() where id = #member_id#;', 
    false, 'ACTIVE', 'It will mark the mobile notification as WRONGLY_PREGNANT');


DELETE FROM public.query_master where code = 'mark_member_as_migrated';
INSERT INTO public.query_master(
    created_by, created_on, code, params, query, returns_result_set, state, description)
VALUES (1, localtimestamp, 'mark_member_as_migrated', 'member_id,action_by', 
    'update techo_notification_master set state = ''MARK_AS_MIGRATED'', modified_on = now(), modified_by = #action_by# 
        where member_id = #member_id# and state in (''PENDING'',''RESCHEDULE'');
    update event_mobile_notification_pending set is_completed = true, state = ''MARK_AS_MIGRATED'', 
        modified_by = #action_by#, modified_on = now() from event_mobile_configuration 
        where event_mobile_notification_pending.notification_configuration_type_id = event_mobile_configuration.id
        and member_id = #member_id# and state = ''PENDING'';
    update imt_member set state = ''com.argusoft.imtecho.member.state.migrated'', 
        modified_on = now(), modified_by = #action_by# 
        where imt_member.id = #member_id#;', 
    false, 'ACTIVE', 'It will mark the member as MIGRATED');


DELETE FROM public.query_master where code = 'mark_member_as_death';
INSERT INTO public.query_master(
    created_by, created_on, code, params, query, returns_result_set, state, description)
VALUES (1, localtimestamp, 'mark_member_as_death', 'member_id,action_by,family_id,date_of_death,death_reason', 
    'update techo_notification_master set state = ''MARK_AS_DEATH'', 
        modified_on = now(), modified_by = #action_by# 
        where member_id = #member_id# and state in (''PENDING'',''RESCHEDULE'');
    update event_mobile_notification_pending set is_completed = true, state = ''MARK_AS_DEATH'', 
        modified_by = #action_by#, modified_on = now() from event_mobile_configuration 
        where event_mobile_notification_pending.notification_configuration_type_id = event_mobile_configuration.id 
        and member_id = #member_id# and state = ''PENDING'';
    INSERT INTO public.rch_member_death_deatil(
        member_id, family_id, dod, death_reason, created_on, created_by
    )
    VALUES(
        #member_id#, #family_id#, ''#date_of_death#'', ''#death_reason#'', now(), #action_by#
    );
    update imt_member set death_detail_id = rch_member_death_deatil.id, state = ''com.argusoft.imtecho.member.state.dead'', 
        modified_on = now(), modified_by = #action_by# from  rch_member_death_deatil 
        where imt_member.id = #member_id# and rch_member_death_deatil.member_id = imt_member.id;', 
    false, 'ACTIVE', 'It will mark the member as DEAD');


DELETE FROM public.query_master where code = 'generate_lmp_followup';
INSERT INTO public.query_master(
    created_by, created_on, code, params, query, returns_result_set, state, description)
VALUES (1, localtimestamp, 'generate_lmp_followup', 'member_id,family_id,schedule_date,member_location_id,created_by', 
    'INSERT INTO public.techo_notification_master(
        notification_type_id, notification_code, location_id, 
        family_id, member_id, schedule_date, due_on, expiry_date, 
        state, created_by, created_on, modified_by, modified_on
    )
    VALUES(
        12, 0, #member_location_id#, #family_id#, #member_id#, ''#schedule_date#'', 
        to_timestamp(''#schedule_date#'', ''MM/DD/YYYY'') + interval ''1'' day * 3, null, 
        ''PENDING'', #created_by#, now(), #created_by#, now()
    );', 
    false, 'ACTIVE', 'It will generate notification for Lmp Follow Up visit');