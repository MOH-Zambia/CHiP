--LMPFU table
alter table rch_lmp_follow_up
add column if not exists abortion_count smallint,
add column if not exists last_pregnancy_date date,
add column if not exists blood_group_father character varying(3),
add column if not exists sickle_cell_status_father text;

--ANC table
alter table rch_anc_master
add column if not exists hepatitis_c_test text,
add column if not exists t3_reading numeric(3,1),
add column if not exists t4_reading numeric(3,1),
add column if not exists tsh_reading numeric(3,1),
add column if not exists usg_report_date date,
add column if not exists gestational_age_from_lmp text,
add column if not exists gestational_age_from_usg bigint,
add column if not exists gestation_type text,
add column if not exists anomaly_present_flag boolean,
add column if not exists anomaly_present text,
add column if not exists single_or_multiple_gestation text,
add column if not exists shortness_of_breath boolean,
add column if not exists two_weeks_coughing boolean,
add column if not exists blood_in_sputum boolean,
add column if not exists two_weeks_fever boolean,
add column if not exists loss_of_weight boolean,
add column if not exists night_sweats boolean,
add column if not exists pmmvy_beneficiary boolean,
add column if not exists pmsma_beneficiary boolean,
add column if not exists dikari_beneficiary boolean,
add column if not exists neck_cord boolean,
add column if not exists amniotic_fluid_index smallint,
add column if not exists placenta_position TEXT,
add column if not exists foetal_weight numeric(4,1),
add column if not exists cervix_length smallint;

--list value field value
INSERT INTO public.listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code, list_order, additional_detail)
values
(true, false, -1, now(), 'History of previous prolonged labor/CPD (>1hr)', '2016', 0, 'null', NULL, NULL, NULL),
(true, false, -1, now(), 'Previous LSCS', '2016', 0, 'null', NULL, NULL, NULL),
(true, false, -1, now(), 'Heart Disease', '2016', 0, 'null', NULL, NULL, NULL),
(true, false, -1, now(), 'Asthma', '2016', 0, 'null', NULL, NULL, NULL),
(true, false, -1, now(), 'Tuberculosis(TB)', '2016', 0, 'null', NULL, NULL, NULL);