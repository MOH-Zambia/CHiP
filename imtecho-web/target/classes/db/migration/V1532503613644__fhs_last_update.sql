INSERT INTO system_configuration(
            system_key, is_active, key_value)
    VALUES ('FHS_LAST_UPDATE_TIME',true,extract(epoch from current_date + interval '2 hour 30 min') * 1000);