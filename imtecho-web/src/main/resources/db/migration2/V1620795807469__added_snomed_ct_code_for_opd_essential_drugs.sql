-- 1001 - Acetazolamide Tablet 250mg : 330601002
INSERT into system_code_master
(table_id, table_type, code_type, code, parent_code, description, created_by, created_on, modified_by, modified_on)
VALUES((select id from listvalue_field_value_detail where field_key = (select field_key from listvalue_field_master where field = 'opdEssentialDrugs') and is_active = true and value = '1001 - Acetazolamide Tablet 250mg' limit 1), 'LIST_VALUE', 'SNOMED_CT', '330601002', NULL, '1001 - Acetazolamide Tablet 250mg', 80314, '2021-05-10 18:15:26.851', 80314, '2021-05-10 18:15:26.851')
on conflict (table_id, table_type, code_type)
DO NOTHING;

-- 1005 - Acyclovir Tablets 200mg : 324726004
INSERT INTO system_code_master
(table_id, table_type, code_type, code, parent_code, description, created_by, created_on, modified_by, modified_on)
VALUES((select id from listvalue_field_value_detail where field_key = (select field_key from listvalue_field_master where field = 'opdEssentialDrugs') and is_active = true and value = '1005 - Acyclovir Tablets 200mg' limit 1), 'LIST_VALUE', 'SNOMED_CT', '324726004', NULL, '1005 - Acyclovir Tablets 200mg', 80314, '2021-05-10 17:44:06.633', 80314, '2021-05-10 17:44:06.633')
on conflict (table_id, table_type, code_type)
DO NOTHING;

-- 1006 - Albendazole Tablets 400mg : 387558006
INSERT INTO system_code_master
(table_id, table_type, code_type, code, parent_code, description, created_by, created_on, modified_by, modified_on)
VALUES((select id from listvalue_field_value_detail where field_key = (select field_key from listvalue_field_master where field = 'opdEssentialDrugs') and is_active = true and value = '1006 - Albendazole Tablets 400mg' limit 1), 'LIST_VALUE', 'SNOMED_CT', '387558006', NULL, '1006 - Albendazole Tablets 400mg', 80314, '2021-05-10 17:44:28.561', 80314, '2021-05-10 17:44:28.561')
on conflict (table_id, table_type, code_type)
DO NOTHING;

-- 1011 - Amiodarone Tablets 200 mg : 318187007
INSERT INTO system_code_master
(table_id, table_type, code_type, code, parent_code, description, created_by, created_on, modified_by, modified_on)
VALUES((select id from listvalue_field_value_detail where field_key = (select field_key from listvalue_field_master where field = 'opdEssentialDrugs') and is_active = true and value = '1011 - Amiodarone Tablets 200 mg' limit 1), 'LIST_VALUE', 'SNOMED_CT', '318187007', NULL, '1011 - Amiodarone Tablets 200 mg', 80314, '2021-05-10 17:44:52.413', 80314, '2021-05-10 17:44:52.413')
on conflict (table_id, table_type, code_type)
DO NOTHING;

-- 1012 - Amitriptyline HCL Tablets 25mg. : 321746008
INSERT INTO system_code_master
(table_id, table_type, code_type, code, parent_code, description, created_by, created_on, modified_by, modified_on)
VALUES((select id from listvalue_field_value_detail where field_key = (select field_key from listvalue_field_master where field = 'opdEssentialDrugs') and is_active = true and value = '1012 - Amitriptyline HCL Tablets 25mg.' limit 1), 'LIST_VALUE', 'SNOMED_CT', '321746008', NULL, '1012 - Amitriptyline HCL Tablets 25mg.', 80314, '2021-05-10 17:45:10.872', 80314, '2021-05-10 17:45:10.872')
on conflict (table_id, table_type, code_type)
DO NOTHING;

-- 1013 - Amlodipine Tablets 5 mg : 319283006
INSERT INTO system_code_master
(table_id, table_type, code_type, code, parent_code, description, created_by, created_on, modified_by, modified_on)
VALUES((select id from listvalue_field_value_detail where field_key = (select field_key from listvalue_field_master where field = 'opdEssentialDrugs') and is_active = true and value = '1013 - Amlodipine Tablets 5 mg' limit 1), 'LIST_VALUE', 'SNOMED_CT', '319283006', NULL, '1013 - Amlodipine Tablets 5 mg', 80314, '2021-05-10 17:45:30.024', 80314, '2021-05-10 17:45:30.024')
on conflict (table_id, table_type, code_type)
DO NOTHING;

-- 1015 - Amoxycillin And Potassium Clavulanate Tab 625mg : 89519005
INSERT INTO system_code_master
(table_id, table_type, code_type, code, parent_code, description, created_by, created_on, modified_by, modified_on)
VALUES((select id from listvalue_field_value_detail where field_key = (select field_key from listvalue_field_master where field = 'opdEssentialDrugs') and is_active = true and value = '1015 - Amoxycillin And Potassium Clavulanate Tab 625mg' limit 1), 'LIST_VALUE', 'SNOMED_CT', '89519005', NULL, '1015 - Amoxycillin And Potassium Clavulanate Tab 625mg', 80314, '2021-05-10 17:45:48.479', 80314, '2021-05-10 17:45:48.479')
on conflict (table_id, table_type, code_type)
DO NOTHING;

-- 1016 - Amoxycillin Capsules 500mg : 783280002
INSERT INTO system_code_master
(table_id, table_type, code_type, code, parent_code, description, created_by, created_on, modified_by, modified_on)
VALUES((select id from listvalue_field_value_detail where field_key = (select field_key from listvalue_field_master where field = 'opdEssentialDrugs') and is_active = true and value = '1016 - Amoxycillin Capsules 500mg' limit 1), 'LIST_VALUE', 'SNOMED_CT', '783280002', NULL, '1016 - Amoxycillin Capsules 500mg', 80314, '2021-05-10 17:46:06.167', 80314, '2021-05-10 17:46:06.167')
on conflict (table_id, table_type, code_type)
DO NOTHING;

-- 1017 - Amoxycillin Capsules 250mg. : 783279000
INSERT INTO public.system_code_master
(table_id, table_type, code_type, code, parent_code, description, created_by, created_on, modified_by, modified_on)
VALUES((select id from listvalue_field_value_detail where field_key = (select field_key from listvalue_field_master where field = 'opdEssentialDrugs') and is_active = true and value = '1017 - Amoxycillin Capsules 250mg.' limit 1), 'LIST_VALUE', 'SNOMED_CT', '783279000', NULL, '1017 - Amoxycillin Capsules 250mg.', 80314, '2021-05-10 17:46:28.179', 80314, '2021-05-10 17:46:28.179')
on conflict (table_id, table_type, code_type)
DO NOTHING;
