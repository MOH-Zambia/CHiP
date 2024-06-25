-- form constant created to add form constant for revert family migration

delete from form_master where code = 'FAM_MIG_REVERT';

insert into form_master(created_by, created_on, modified_by, modified_on, code, name, state)
values (1, now(), 1, now(), 'FAM_MIG_REVERT', 'REVERT FAMILY MIGRATION', 'ACTIVE');