ALTER TABLE soh_chart_configuration 
DROP COLUMN IF EXISTS chart_type;

ALTER TABLE soh_chart_configuration ADD COLUMN chart_type varchar(50);