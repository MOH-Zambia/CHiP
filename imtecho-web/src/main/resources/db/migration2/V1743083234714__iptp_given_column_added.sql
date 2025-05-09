alter table rch_anc_master add column if not exists iptp_given boolean;

update system_configuration set key_value = '126' where system_key = 'MOBILE_FORM_VERSION';
