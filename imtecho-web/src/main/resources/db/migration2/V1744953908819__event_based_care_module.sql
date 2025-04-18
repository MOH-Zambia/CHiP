update system_configuration set key_value = '127' where system_key = 'MOBILE_FORM_VERSION';

insert into mobile_form_details(form_name, file_name, created_on,created_by,modified_on, modified_by)
values('EVENT_BASED_CARE_MODULE', 'EVENT_BASED_CARE_MODULE', now(), -1, now(), -1);

insert into mobile_form_feature_rel (form_id, mobile_constant)
select id, 'CBV_MY_PEOPLE' from mobile_form_details where form_name = 'EVENT_BASED_CARE_MODULE';

drop table event_based_care_module;

CREATE TABLE if not exists event_based_care_module (
    id SERIAL PRIMARY KEY,
    member_status TEXT,
    service_date TIMESTAMP,
    member_id INTEGER NOT NULL,
    family_id INTEGER NOT NULL,
    events_reported TEXT,
    other_events_reported text null,
    similar_symptoms_household boolean null,
    notify_facility boolean null,
    facility text null,
    is_iec_given boolean null,
    referral_required boolean null,
    latitude TEXT,
    longitude TEXT,
    mobile_start_date TIMESTAMP NOT NULL,
    mobile_end_date TIMESTAMP NOT NULL,
    location_id INTEGER NOT NULL,
    location_hierarchy_id INTEGER NOT NULL,
    notification_id INTEGER,
    created_by INTEGER NOT NULL,
    created_on TIMESTAMP NOT NULL,
    modified_by INTEGER,
    modified_on TIMESTAMP
);

insert into listvalue_field_master(field_key, field, is_active, field_type, form, role_type)
values('eventBasedCare', 'eventBasedCare', true, 'T', 'EVENT_BASED_CARE_MODULE', 'A,F');

insert into listvalue_field_form_relation (field,form_id)
values ('eventBasedCare',(select id from mobile_form_details mfd where form_name = 'EVENT_BASED_CARE_MODULE'));

INSERT INTO public.listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code, list_order, additional_detail, constant)
VALUES
(true, false, -1, now(), 'Sudden weakness in hands and feet or sudden inability to use hands and feet', 'eventBasedCare', 0, NULL, NULL, NULL, NULL, 'sudden_weakness_limbs_ebcm'),
(true, false, -1, now(), 'Three or more loose stools in less than 24 hours', 'eventBasedCare', 0, NULL, NULL, NULL, NULL, 'loose_stools_ebcm'),
(true, false, -1, now(), 'Unexplained illness or death with fever and bleeding', 'eventBasedCare', 0, NULL, NULL, NULL, NULL, 'fever_bleeding_death_ebcm'),
(true, false, -1, now(), 'Diarrhea, stomach pain and stool with visible blood', 'eventBasedCare', 0, NULL, NULL, NULL, NULL, 'bloody_diarrhea_ebcm'),
(true, false, -1, now(), 'Skin wound with worms coming out', 'eventBasedCare', 0, NULL, NULL, NULL, NULL, 'wound_with_worms_ebcm'),
(true, false, -1, now(), 'Fever with yellow eyes', 'eventBasedCare', 0, NULL, NULL, NULL, NULL, 'fever_yellow_eyes_ebcm'),
(true, false, -1, now(), 'Fever, cough, throat pain or runny nose', 'eventBasedCare', 0, NULL, NULL, NULL, NULL, 'fever_respiratory_symptoms_ebcm'),
(true, false, -1, now(), 'Fever and neck stiffness', 'eventBasedCare', 0, NULL, NULL, NULL, NULL, 'fever_neck_stiffness_ebcm'),
(true, false, -1, now(), 'Fever with rash', 'eventBasedCare', 0, NULL, NULL, NULL, NULL, 'fever_rash_ebcm'),
(true, false, -1, now(), 'Death of a woman while pregnant or within 42 days after delivery', 'eventBasedCare', 0, NULL, NULL, NULL, NULL, 'maternal_death_ebcm'),
(true, false, -1, now(), 'New born normal at birth but becomes stiff, unable to suck or has convulsions and fits after 2 days', 'eventBasedCare', 0, NULL, NULL, NULL, NULL, 'neonatal_tetanus_ebcm'),
(true, false, -1, now(), 'Lumps under the skin', 'eventBasedCare', 0, NULL, NULL, NULL, NULL, 'skin_lumps_ebcm'),
(true, false, -1, now(), 'Swelling under the arms or groin area. May also have cough, chest pain and fever', 'eventBasedCare', 0, NULL, NULL, NULL, NULL, 'swelling_with_fever_ebcm'),
(true, false, -1, now(), 'Cough, fast breathing or difficulty breathing', 'eventBasedCare', 0, NULL, NULL, NULL, NULL, 'respiratory_difficulty_ebcm'),
(true, false, -1, now(), 'Acting strange and having fever, headache and weakness after a bite from a dog or other animal', 'eventBasedCare', 0, NULL, NULL, NULL, NULL, 'rabies_symptoms_ebcm'),
(true, false, -1, now(), 'Discharge from the private parts or sores and pain on private parts', 'eventBasedCare', 0, NULL, NULL, NULL, NULL, 'std_symptoms_ebcm'),
(true, false, -1, now(), 'Prolonged fever for more than 3 weeks', 'eventBasedCare', 0, NULL, NULL, NULL, NULL, 'fever_3weeks_ebcm'),
(true, false, -1, now(), 'Fever and two or more other symptoms like headache, vomiting, fever, diarrhea, weakness and bleeding or person who died with these symptoms', 'eventBasedCare', 0, NULL, NULL, NULL, NULL, 'fever_with_bleeding_ebcm'),
(true, false, -1, now(), 'Fever and two or more other symptoms like headache, vomiting, fever, diarrhea, weakness and yellow eyes or person who died with these symptoms', 'eventBasedCare', 0, NULL, NULL, NULL, NULL, 'fever_with_jaundice_ebcm'),
(true, false, -1, now(), 'Abortion attempt', 'eventBasedCare', 0, NULL, NULL, NULL, NULL, 'abortion_attempt_ebcm'),
(true, false, -1, now(), 'Burns', 'eventBasedCare', 0, NULL, NULL, NULL, NULL, 'burns_ebcm'),
(true, false, -1, now(), 'Dog bites or other animal bite', 'eventBasedCare', 0, NULL, NULL, NULL, NULL, 'animal_bite_ebcm'),
(true, false, -1, now(), 'Diabetes', 'eventBasedCare', 0, NULL, NULL, NULL, NULL, 'diabetes_ebcm'),
(true, false, -1, now(), 'Epilepsy', 'eventBasedCare', 0, NULL, NULL, NULL, NULL, 'epilepsy_ebcm'),
(true, false, -1, now(), 'High blood pressure', 'eventBasedCare', 0, NULL, NULL, NULL, NULL, 'hypertension_ebcm'),
(true, false, -1, now(), 'Broken limbs or bones', 'eventBasedCare', 0, NULL, NULL, NULL, NULL, 'bone_fracture_ebcm'),
(true, false, -1, now(), 'Malnutrition (adults)', 'eventBasedCare', 0, NULL, NULL, NULL, NULL, 'malnutrition_adults_ebcm'),
(true, false, -1, now(), 'Mental Health Issues', 'eventBasedCare', 0, NULL, NULL, NULL, NULL, 'mental_health_ebcm'),
(true, false, -1, now(), 'Palliative care', 'eventBasedCare', 0, NULL, NULL, NULL, NULL, 'palliative_care_ebcm'),
(true, false, -1, now(), 'Suicide attempt', 'eventBasedCare', 0, NULL, NULL, NULL, NULL, 'suicide_attempt_ebcm'),
(true, false, -1, now(), 'Wounds and cuts', 'eventBasedCare', 0, NULL, NULL, NULL, NULL, 'wounds_and_cuts_ebcm'),
(true, false, -1, now(), 'Unexplained dying of groups of animals within one week', 'eventBasedCare', 0, NULL, NULL, NULL, NULL, 'animal_deaths_group_ebcm');
