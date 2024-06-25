alter table anemia_member_detail
add column if not exists hemoglobin float,
add column if not exists heart_rate int,
add column if not exists hypertension boolean,
add column if not exists diabetes_mellitus boolean,
add column if not exists preeclampsia boolean,
add column if not exists anemia boolean,
add column if not exists disorders_of_blood boolean,
add column if not exists type_of_blood_disorder text,
add column if not exists cancer_or_malignancy boolean,
add column if not exists other_known_diseases text;