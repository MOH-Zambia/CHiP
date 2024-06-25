INSERT INTO system_configuration(
            system_key, is_active, key_value)
    VALUES ('LAST_INDEX_DATE_OF_LOCATION_FOR_ELASTICSEARCH', true, now());

INSERT INTO system_configuration(
            system_key, is_active, key_value)
    VALUES ('LAST_INDEX_DATE_OF_MEMBER_FOR_ELASTICSEARCH', true, now());
