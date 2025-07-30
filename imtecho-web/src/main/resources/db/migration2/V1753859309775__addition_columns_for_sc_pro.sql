ALTER TABLE patient_data add column if not exists status boolean;
ALTER TABLE referred_patient_data add column if not exists status boolean;
ALTER TABLE imt_member add column if not exists status boolean;
