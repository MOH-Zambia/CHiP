insert into notification_type_master (created_by, created_on, modified_by, modified_on, code, name, type, role_id, state, notification_for)
values (-1, now(), -1, now(), 'TT2_ALERT', 'TT2 Alert', 'MO', 30, 'ACTIVE', 'MEMBER');

insert into notification_type_master (created_by, created_on, modified_by, modified_on, code, name, type, role_id, state, notification_for)
values (-1, now(), -1, now(), 'IRON_SUCROSE_ALERT', 'Iron Sucrose Alert', 'MO', 30, 'ACTIVE', 'MEMBER');

insert into form_master (created_by, created_on, modified_by, modified_on, code, name, state)
values(-1, now(), -1, now(), 'TT2_ALERT', 'TT2 Alert', 'ACTIVE');

insert into form_master (created_by, created_on, modified_by, modified_on, code, name, state)
values(-1, now(), -1, now(), 'IRON_SUCROSE_ALERT', 'Iron Sucrose Alert', 'ACTIVE');