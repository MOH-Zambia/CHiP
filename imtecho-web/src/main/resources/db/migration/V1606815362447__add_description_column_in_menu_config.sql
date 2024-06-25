-- Add new column description in menu_config which will used in role feature.

ALTER table menu_config
drop column if exists description,
ADD COLUMN description character varying(500)