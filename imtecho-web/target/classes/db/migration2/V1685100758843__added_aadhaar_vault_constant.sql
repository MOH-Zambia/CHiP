delete from system_configuration where system_key = 'AADHAAR_VAULT_URL';

insert into system_configuration (system_key, is_active, key_value)
    values ('AADHAAR_VAULT_URL', true, 'http://localhost:8081');

delete from system_configuration where system_key = 'AADHAAR_VAULT_CLIENT_ID';

insert into system_configuration (system_key, is_active, key_value)
    values ('AADHAAR_VAULT_CLIENT_ID', true, 'aadhaar-client');

delete from system_configuration where system_key = 'AADHAAR_VAULT_CLIENT_SECRET';

insert into system_configuration (system_key, is_active, key_value)
    values ('AADHAAR_VAULT_CLIENT_SECRET', true, 'aadhaar-secret');

delete from system_configuration where system_key = 'AADHAAR_VAULT_USERNAME';

insert into system_configuration (system_key, is_active, key_value)
    values ('AADHAAR_VAULT_USERNAME', true, 'aadhaar-user');

delete from system_configuration where system_key = 'AADHAAR_VAULT_PASSWORD';

insert into system_configuration (system_key, is_active, key_value)
        values ('AADHAAR_VAULT_PASSWORD', true, 'argusadmin');
