ALTER TABLE soh_chart_configuration 
DROP COLUMN IF EXISTS query_name;

ALTER TABLE soh_chart_configuration ADD COLUMN query_name text;