INSERT into form_master (created_by, created_on, modified_by, modified_on, code, name, state)
VALUES(1, now(), 1, now(), 'MIGRATION_IN_REQ', 'MIGRATION IN REQUEST', 'ACTIVE');

INSERT into form_master (created_by, created_on, modified_by, modified_on, code, name, state)
VALUES(1, now(), 1, now(), 'MIGRATION_OUT_REQ', 'MIGRATION OUT REQUEST', 'ACTIVE');

INSERT into form_master (created_by, created_on, modified_by, modified_on, code, name, state)
VALUES(1, now(), 1, now(), 'MIGRATION_IN_RESP', 'MIGRATION IN RESPONSE', 'ACTIVE');

INSERT into form_master (created_by, created_on, modified_by, modified_on, code, name, state)
VALUES(1, now(), 1, now(), 'MIGRATION_OUT_RESP', 'MIGRATION OUT RESPONSE', 'ACTIVE');