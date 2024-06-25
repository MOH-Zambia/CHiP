ALTER TABLE migration_master
DROP COLUMN IF EXISTS out_of_state,
ADD COLUMN out_of_state boolean,
DROP COLUMN IF EXISTS has_children,
ADD COLUMN has_children boolean,
DROP COLUMN IF EXISTS is_temporary,
ADD COLUMN is_temporary boolean,
DROP COLUMN IF EXISTS area_migrated_to,
ADD COLUMN area_migrated_to bigint,
DROP COLUMN IF EXISTS area_migrated_from,
ADD COLUMN area_migrated_from bigint,
DROP COLUMN IF EXISTS district_id,
ADD COLUMN district_id bigint,
DROP COLUMN IF EXISTS village_name,
ADD COLUMN village_name text,
DROP COLUMN IF EXISTS fhw_asha_name,
ADD COLUMN fhw_asha_name text,
DROP COLUMN IF EXISTS fhw_asha_phone,
ADD COLUMN fhw_asha_phone text,
DROP COLUMN IF EXISTS mobile_data,
ADD COLUMN mobile_data text;

ALTER TABLE techo_notification_master
DROP COLUMN IF EXISTS header,
ADD COLUMN header text;

DROP TABLE IF EXISTS migration_child_rel;
CREATE TABLE migration_child_rel
(
  migration_id bigint NOT NULL,
  child_id bigint NOT NULL,
  PRIMARY KEY (migration_id, child_id),
  FOREIGN KEY (migration_id)
      REFERENCES migration_master (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);


delete from form_master where code in ('MR', 'MIGRATION_REVERTED');

delete from form_master where code = 'MIG_IN';
INSERT INTO public.form_master(
    created_by, created_on, modified_by, modified_on, code, name, state)
VALUES (1, now(), 1, now(), 'MIG_IN', 'MIGRATION IN', 'ACTIVE');

delete from form_master where code = 'MIG_OUT';
INSERT INTO public.form_master(
    created_by, created_on, modified_by, modified_on, code, name, state)
VALUES (1, now(), 1, now(), 'MIG_OUT', 'MIGRATION OUT', 'ACTIVE');

delete from form_master where code = 'MIG_IN_CONF';
INSERT INTO public.form_master(
    created_by, created_on, modified_by, modified_on, code, name, state)
VALUES (1, now(), 1, now(), 'MIG_IN_CONF', 'MIGRATION IN CONFIRMATION', 'ACTIVE');

delete from form_master where code = 'MIG_OUT_CONF';
INSERT INTO public.form_master(
    created_by, created_on, modified_by, modified_on, code, name, state)
VALUES (1, now(), 1, now(), 'MIG_OUT_CONF', 'MIGRATION OUT CONFIRMATION', 'ACTIVE');

delete from form_master where code = 'MIG_REVERT';
INSERT INTO public.form_master(
    created_by, created_on, modified_by, modified_on, code, name, state)
VALUES (1, now(), 1, now(), 'MIG_REVERT', 'REVERT MIGRATION', 'ACTIVE');

   
delete from notification_type_master where code = 'READ_ONLY';
INSERT INTO public.notification_type_master(
    created_by, created_on, modified_by, modified_on, code, name, type, role_id, state)
VALUES ( 1, now(), 1, now(), 'READ_ONLY', 'Read Only Notification', 'MO', (select id from um_role_master where code = 'FHW'), 'ACTIVE');