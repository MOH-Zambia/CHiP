alter table ncd_member_mental_health_detail
add column if not exists referral_done boolean;

ALTER TABLE ncd_hypertension_diabetes_mental_health_master
ALTER COLUMN hypertension_table_id TYPE integer USING (id::integer);

ALTER TABLE ncd_hypertension_diabetes_mental_health_master
ALTER COLUMN diabetes_table_id TYPE integer USING (id::integer);

ALTER TABLE ncd_hypertension_diabetes_mental_health_master
ALTER COLUMN mentalHealth_table_id TYPE integer USING (id::integer);

ALTER TABLE ncd_hypertension_diabetes_mental_health_master RENAME COLUMN hypertension_table_id TO hypertension_id;
ALTER TABLE ncd_hypertension_diabetes_mental_health_master RENAME COLUMN diabetes_table_id TO diabetes_id;
ALTER TABLE ncd_hypertension_diabetes_mental_health_master RENAME COLUMN mentalHealth_table_id TO mental_health_id;

ALTER TABLE ncd_cancer_screening_master
ALTER COLUMN oral_table_id TYPE integer USING (id::integer);

ALTER TABLE ncd_cancer_screening_master
ALTER COLUMN breast_table_id TYPE integer USING (id::integer);

ALTER TABLE ncd_cancer_screening_master
ALTER COLUMN cervical_table_id TYPE integer USING (id::integer);

ALTER TABLE ncd_cancer_screening_master RENAME COLUMN oral_table_id TO oral_id;
ALTER TABLE ncd_cancer_screening_master RENAME COLUMN breast_table_id TO breast_id;
ALTER TABLE ncd_cancer_screening_master RENAME COLUMN cervical_table_id TO cervical_id;

