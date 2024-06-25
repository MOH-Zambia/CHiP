alter table if exists stock_management_details
alter column modified_by set not null,
alter column modified_on set not null,
add column medicines_and_quantity_approved text;

DELETE FROM QUERY_MASTER WHERE CODE='fetch_stock_requests_by_infra_id';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'fc0e7c25-c8cc-44a5-aeb7-d68fe3eb23ec', 97074,  current_date , 97074,  current_date , 'fetch_stock_requests_by_infra_id',
'infraId',
'SELECT
    CONCAT(um_user.first_name, '' '', um_user.middle_name, '' '', um_user.last_name) AS username,
    CAST(
        JSON_AGG(
            CONCAT(
                ''{"id":'',
                smd.id,
                '',"qty":'',
                COALESCE(
                    (SELECT CAST(COALESCE(subquery.value, ''0'') AS INTEGER)
                     FROM (SELECT (json_each_text(cast(smd.medicines_and_quantity as json))).value) AS subquery),
                    0
                ),
                '',"field_value":"'',
                COALESCE(lffd.value, ''''),

                ''"}''
            )
        ) AS TEXT
    ) AS medicine_data
FROM
    stock_management_details smd
JOIN
    um_user ON smd.created_by = um_user.id
LEFT JOIN
    listvalue_field_value_detail lffd ON lffd.id = COALESCE(
        (SELECT CAST(COALESCE(subquery.key, ''0'') AS INTEGER)
         FROM (SELECT (json_each_text(cast(smd.medicines_and_quantity as json))).key) AS subquery),
        0
    )
WHERE
    smd.health_infra_id = #infraId# and smd.approval_status = ''REQUESTED''
GROUP BY
    um_user.id,
    um_user.first_name,
    um_user.middle_name,
    um_user.last_name,
    smd.approval_status;',
null,
true, 'ACTIVE');

-----------creates feature--------------------------------------------------
INSERT INTO public.menu_config
(id, feature_json, group_id, active, is_dynamic_report, menu_name, navigation_state, sub_group_id, menu_type, only_admin, menu_display_order, "uuid", group_name_uuid, sub_group_uuid, description)
VALUES(nextval('menu_config_id_seq'::regclass), '{}', NULL, true, false, 'Medicine Stock Management', 'techo.manage.stockmanagement', NULL, 'manage', NULL, NULL, NULL, NULL, NULL, '');

INSERT INTO public.um_role_master
(id, created_by, created_on, modified_by, modified_on, code, description, "name", state, max_position, is_email_mandatory, is_contact_num_mandatory, is_aadhar_num_mandatory, is_convox_id_mandatory, short_name, is_last_name_mandatory, role_type, is_health_infra_mandatory, is_geolocation_mandatory, max_health_infra, is_smag_trained_mandatory)
VALUES(nextval('um_role_master_id_seq'::regclass), 97076, '2024-02-14 11:11:14.361', 0, NULL, 'health_stock_user', '', 'Healthcare Facility User', 'ACTIVE', NULL, false, false, false, false, '', true, '', false, false, NULL, false);

INSERT INTO public.role_management
(id, created_by, created_on, modified_by, modified_on, role_id, managed_by_user_id, managed_by_role_id, state)
VALUES(nextval('role_management_id_seq'::regclass), 97076, '2018-03-22 19:12:42.915', 1027, '2018-03-22 19:12:42.915', (SELECT id FROM um_role_master WHERE code = 'health_stock_user'), NULL, (select id from um_role_master where code = 'argusadmin'), 'ACTIVE');

INSERT INTO public.user_menu_item
(user_menu_id, designation_id, feature_json, group_id, menu_config_id, user_id, role_id, created_by, created_on, modified_by, modified_on)
VALUES(nextval('user_menu_item_user_menu_id_seq'::regclass), NULL, NULL, NULL, (select id from menu_config mc where mc.navigation_state = 'techo.manage.stockmanagement'), null, (select id from um_role_master where code = 'health_stock_user'), null, null, null, null);
