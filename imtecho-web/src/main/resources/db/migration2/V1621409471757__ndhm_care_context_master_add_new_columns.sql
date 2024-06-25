ALTER table ndhm_care_context_master
drop column if exists pref_auth_mode,
ADD COLUMN pref_auth_mode varchar(250),
drop column if exists is_preferred,
ADD COLUMN is_preferred boolean;

comment on column ndhm_care_context_master.pref_auth_mode is 'Preferred auth mode';
comment on column ndhm_care_context_master.is_preferred is 'Is health id preferred or not';


ALTER table ndhm_care_context_service_info
drop column if exists care_context_request_id,
ADD COLUMN care_context_request_id varchar(250);

comment on column ndhm_care_context_service_info.care_context_request_id is 'Request id for consent';