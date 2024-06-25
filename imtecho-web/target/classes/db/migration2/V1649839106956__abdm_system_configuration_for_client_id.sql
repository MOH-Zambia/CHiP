delete from system_configuration where system_key = 'ABDM_CLIENT_ID';

insert into system_configuration (system_key, is_active, key_value)
    values ('ABDM_CLIENT_ID', true, 'ARGUSOFT_164189');

delete from system_configuration where system_key = 'ABDM_CLIENT_SECRET';

insert into system_configuration (system_key, is_active, key_value)
    values ('ABDM_CLIENT_SECRET', true, '6d4566e2-9cd6-4bc8-9055-8c3a42a6d317');