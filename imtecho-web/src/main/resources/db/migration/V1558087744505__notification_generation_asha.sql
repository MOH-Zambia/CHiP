DELETE FROM notification_type_master where code = 'ASHA_PNC';
INSERT INTO notification_type_master (
    created_by, created_on, modified_by, modified_on, code, name, type, role_id, state, notification_for
)
VALUES (
    -1, now(), -1, now(), 'ASHA_PNC', 'ASHA Post Natal Care Alerts', 'MO', 24, 'ACTIVE', 'MEMBER'
);

DELETE FROM notification_type_master where code = 'ASHA_CS';
INSERT INTO notification_type_master (
    created_by, created_on, modified_by, modified_on, code, name, type, role_id, state, notification_for
)
VALUES (
    -1, now(), -1, now(), 'ASHA_CS', 'ASHA Child Services Alerts', 'MO', 24, 'ACTIVE', 'MEMBER'
);