update system_configuration set key_value = '61' where system_key = 'MOBILE_FORM_VERSION';

ALTER TABLE imt_member_cfhc_master
     ALTER COLUMN current_studying_standard
         TYPE character varying(50);

alter table imt_family
add column if not exists other_motorized_vehicle text;