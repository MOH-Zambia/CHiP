delete from system_configuration where system_key in ('ELASTIC_HOST', 'ELASTIC_PORT');
INSERT INTO system_configuration
(system_key, is_active, key_value)
VALUES('ELASTIC_HOST', true, 'localhost');

INSERT INTO system_configuration
(system_key, is_active, key_value)
VALUES('ELASTIC_PORT', true, '9200');


