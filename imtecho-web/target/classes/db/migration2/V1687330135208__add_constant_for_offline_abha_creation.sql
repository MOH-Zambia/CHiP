delete from system_configuration where system_key = 'OFFLINE_MEMBER_ABHA_CREATION_LIMIT';

insert into system_configuration (system_key, is_active, key_value)
    values ('OFFLINE_MEMBER_ABHA_CREATION_LIMIT', true, '0');


ALTER TABLE imt_member
DROP COLUMN IF EXISTS is_abha_failed,
ADD COLUMN is_abha_failed boolean;