update menu_config  
    set feature_json  = '{"canAbsentVerification":true,"canFamilyVerification":true,
                            "canGvkImmunisationVerification":true,
                            "canHighriskFollowupVerification":true,
                            "canPregnancyRegistrationsVerification":true,
                            "canHighriskFollowupVerificationFowFhw":false,
                            "canPregnancyRegistrationsPhoneNumberVerification":false,
                            "canMemberMigrationOutVerification":false,
                            "canMemberMigrationInVerification":false}'
        where navigation_state = 'techo.dashboard.gvkverification';

alter table migration_master
add column gvk_call_status text,
add column  call_attempt int default 0,
add column  migration_reason text,
add column schedule_date timestamp without time zone;

update migration_master 
set schedule_date = now(),
call_attempt = 0,
gvk_call_status = 'com.argusoft.imtecho.gvk.call.to-be-processed'
where state = 'REPORTED';

DROP TABLE IF EXISTS public.gvk_member_migration_call_response;
CREATE TABLE public.gvk_member_migration_call_response(
id bigserial NOT NULL,
member_id bigserial,
migration_id bigserial, 
gvk_call_response_status text,
performed_action text,
is_fhw_called boolean,
is_asha_called boolean,
is_beneficiary_called boolean,
processing_time bigint,
created_by bigint NOT NULL,
created_on timestamp without time zone NOT NULL,
modified_by bigint,
modified_on timestamp without time zone,
CONSTRAINT gvk_member_migration_call_response_pkey PRIMARY KEY (id)
);
