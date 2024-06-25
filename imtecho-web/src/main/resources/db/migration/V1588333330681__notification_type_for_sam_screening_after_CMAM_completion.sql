INSERT INTO notification_type_master (
     created_by, created_on, modified_by, modified_on, code, name, type,role_id, state
)
VALUES (
    -1, now(), -1, now(),'FHW_SAM_AFTER_CMAM', 'FHW SAM Screening after CMAM', 'MO', 30, 'ACTIVE'
);

INSERT INTO notification_type_role_rel (notification_type_id , role_id)
select id, role_id from notification_type_master where code = 'FHW_SAM_AFTER_CMAM';