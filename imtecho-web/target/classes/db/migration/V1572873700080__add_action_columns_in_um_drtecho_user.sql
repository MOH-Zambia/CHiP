-- For feature https://argusgit.argusoft.com/mhealth-projects/imtecho/issues/2219

ALTER TABLE um_drtecho_user
DROP COLUMN IF EXISTS action_by,
ADD COLUMN action_by bigint;

ALTER TABLE um_drtecho_user
DROP COLUMN IF EXISTS action_on,
ADD COLUMN action_on timestamp without time zone;