alter table hu_medical_history_detail
add column if not exists upt text,
add column if not exists other_presentation text,
add column if not exists other_placenta text,
add column if not exists severity_flag boolean;


alter table hu_preg_outcome_detail
add column if not exists other_intranatal_complications text,
add column if not exists delivery_date DATE,
add column if not exists delivery_place text,
add column if not exists other_prenatal_complications text;