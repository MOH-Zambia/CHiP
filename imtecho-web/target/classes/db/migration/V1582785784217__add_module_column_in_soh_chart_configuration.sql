ALTER table soh_chart_configuration
drop column if exists module,
ADD COLUMN module character varying(255)