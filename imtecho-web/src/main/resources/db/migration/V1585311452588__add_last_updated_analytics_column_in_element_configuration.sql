ALTER table soh_element_configuration
drop column if exists last_updated_analytics,
ADD COLUMN last_updated_analytics timestamp without time zone;