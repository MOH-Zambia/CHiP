DELETE FROM QUERY_MASTER WHERE CODE='generate_lmp_followup';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'5a741523-88dc-4ef8-98b6-18a355ad6136', 97086,  current_date , 97086,  current_date , 'generate_lmp_followup',
'member_location_id,family_id,member_id,schedule_date,created_by',
'INSERT INTO public.techo_notification_master(
        notification_type_id, notification_code, location_id,
        family_id, member_id, schedule_date, due_on, expiry_date,
        state, created_by, created_on, modified_by, modified_on
    )
select 1, 0, #member_location_id#, #family_id#, #member_id#, to_timestamp(''#schedule_date#'',''MM/DD/YYYY'') ,to_timestamp(''#schedule_date#'', ''MM/DD/YYYY'') + interval ''1'' day * 3, null, ''PENDING'', #created_by#, now(), #created_by#, now()
from imt_member where id = #member_id# and dob between (current_date - interval ''45 year'') and (current_date  - interval ''18 year'') ;
    /*VALUES(
        1, 0, #member_location_id#, #family_id#, #member_id#, ''#schedule_date#'',
        to_timestamp(''#schedule_date#'', ''MM/DD/YYYY'') + interval ''1'' day * 3, null,
        ''PENDING'', #created_by#, now(), #created_by#, now()
    );*/',
'It will generate notification for Lmp Follow Up visit',
false, 'ACTIVE');






DELETE FROM QUERY_MASTER WHERE CODE='generate_lmp_followup';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'5a741523-88dc-4ef8-98b6-18a355ad6136', 97086,  current_date , 97086,  current_date , 'generate_lmp_followup',
'member_location_id,family_id,member_id,schedule_date,created_by',
'INSERT INTO public.techo_notification_master(
        notification_type_id, notification_code, location_id,
        family_id, member_id, schedule_date, due_on, expiry_date,
        state, created_by, created_on, modified_by, modified_on
    )
select 1, 0, #member_location_id#, #family_id#, #member_id#, to_timestamp(''#schedule_date#'',''MM/DD/YYYY'') ,to_timestamp(''#schedule_date#'', ''MM/DD/YYYY'') + interval ''1'' day * 3, null, ''PENDING'', #created_by#, now(), #created_by#, now()
from imt_member where id = #member_id# and dob between (current_date - interval ''45 year'') and (current_date  - interval ''18 year'') ;
    /*VALUES(
        1, 0, #member_location_id#, #family_id#, #member_id#, ''#schedule_date#'',
        to_timestamp(''#schedule_date#'', ''MM/DD/YYYY'') + interval ''1'' day * 3, null,
        ''PENDING'', #created_by#, now(), #created_by#, now()
    );*/',
'It will generate notification for Lmp Follow Up visit',
false, 'ACTIVE');