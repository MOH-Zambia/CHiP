DELETE FROM QUERY_MASTER WHERE CODE='COVID_19_ICMR_Specimen_Referral_Form';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'a3a0581e-23d2-4347-a725-f64f6853eefc', 74840,  current_date , 74840,  current_date , 'COVID_19_ICMR_Specimen_Referral_Form',
'labTestIds',
'select
concat_ws('' '',clt.first_name,clt.middle_name,clt.last_name) as "patientName",
case
    when clt.age is null then null
    when clt.age < 2 and clt.age_month < 2 then concat_ws('' '', clt.age, ''year'', case when clt.age_month is null then 0 else clt.age_month end, ''month'')
    when clt.age_month < 2 and clt.age > 2 then concat_ws('' '', clt.age, ''years'', case when clt.age_month is null then 0 else clt.age_month end, ''month'')
    when clt.age_month > 2 and clt.age < 2 then concat_ws('' '', clt.age, ''year'', case when clt.age_month is null then 0 else clt.age_month end, ''months'')
    when clt.age_month > 2 and clt.age < 2 then concat_ws('' '', clt.age, ''year'', case when clt.age_month is null then 0 else clt.age_month end, ''months'')
    when clt.age_month is null then concat_ws('' '', clt.age, ''years'', case when clt.age_month is null then 0 else clt.age_month end, ''month'')
    else concat_ws('' '', clt.age, ''years'', case when clt.age_month is null then 0 else clt.age_month end, ''months'')
end as "age",
clt.gender as "gender",
cast(''N/A'' as text) as "villageLocation",
clt.contact_number as "mobileNumber",
case
    when clt.contact_number is not null then cast(''Self''as text)
    else cast(''N/A'' as text)
end as "mobileNumberBelongsTo",
get_location_hierarchy_from_ditrict(clt.location_id) as "disctrictLocation",
cast(''Gujarat'' as text) as "state",
cast(''Indian'' as text) as "Nationality",
cast(null as boolean) as "isBALETA",
cast(null as boolean) as "isTSNPSNS",
cast(null as boolean) as "isBloodInEDTA",
cast(null as boolean) as "isAcuteSera",
cast(null as boolean) as "isCovalescentSera",
cast(null as boolean) as "isOtherSpecimenType",
to_char(cltd.lab_collection_on, ''DD/MM/YY'')  as "collectionDate",
cast(cltd.lab_test_id as text) as "label",
cast(cltd.lab_test_id as text) as "labcode",
cast(case when cltd.test_count > 1 then true else false end as boolean) as "isRepeatedSample",
(select name_in_english from health_infrastructure_details where id = cltd.sample_health_infra)  as "sampleCollectionFacilityName",
cast(null as text) as "collectionFacilityPincode",
case when clt.indications =''Symtomatic Person with International Travel History (last 14 days)'' then true else false end as "isSymptomaticInternational",
case when clt.indications =''Symtomatic Contacts of Laboratory Confirmed Positive Cases'' then true else false end as "isSymptomaticContact",
case when clt.indications =''Symtomatic Health Care Workers'' then true else false end as "isSymptomaticHealthcare",
case when clt.indications =''Hospitalized SARI Patient'' then true else false end as "isHospitalizedSARI",
case when clt.indications =''Asymtomatic Direct / High Risk Contact of Postivie Contact (>5 and < 14 days)'' then true else false end as "isAsymptomaticDirect",
case when clt.indications =''Healthcare worker examined Positive Case without PPE'' then true else false end as "isAsymptomaticHealthcare",
clt.address as "presentPatientAddress",
clt.pincode as "pinCode",
to_char(clt.dob, ''DD/MM/YY'') as "dateOfBirth",
cast(''N/A'' as text) as  "patientPassportNo",
cast(''N/A'' as text) as  "emailId",
cast(''N/A'' as text) as  "aadharNo",
case when clt.travel_history = ''international'' then true else false end as "travelToForeignCountry",
cast(case when clt.travel_history = ''international'' then clt.travelled_place else '''' end as text) as "travelledPlace",
cast(''N/A'' as text) as  "stayTravelDuration",
case when clt.in_contact_with_covid19_paitent = ''yes'' then true else false end as "inContactWithCovid19Paitent",
cast(case when clt.in_contact_with_covid19_paitent = ''yes'' then clt.abroad_contact_details else '''' end as text) as "confirmedPatient",
cast(''N/A'' as text) as  "isQuarantined",
cast(''N/A'' as text) as  "quarantinedPlace",
cast(''No'' as text) as  "isHealthWorker",
to_char(clt.date_of_onset_symptom, ''DD/MM/YY'') as "dateOfOnsetSymptom",
cast(''N/A'' as text) as  "firstSymptom",
clt.is_cough as "isCough",
cast(null as boolean) as "isDiarrhoea",
cast(null as boolean) as "isVomiting",
cast(null as boolean) as "isFeverAtEvaluation",
clt.is_breathlessness as "isBreathlessness",
cast(null as boolean) as "isNausea",
cast(null as boolean) as "isHaemoptysis",
cast(null as boolean) as "isBodyAche",
cast(null as boolean) as "isSoreThroat",
cast(null as boolean) as "isChestPain",
cast(null as boolean) as "isNasalDischarge",
cast(null as boolean) as "isSputum",
cast(null as boolean) as "isAbdominalPain",
cast(case when clt.is_sari then ''Yes'' else ''No'' end as text) as "isSARI",
cast(null as boolean) as "isARI",
clt.is_copd as "isCopd",
cast(null as boolean) as "isBronchitis",
clt.is_diabetes as "isDiabetes",
clt.is_hypertension as "isHypertension",
clt.is_renal_condition as "isRenalCondition",
clt.is_malignancy as "isMalignancy",
clt.is_heart_patient as "isHeartPatient",
cast(null as boolean) as "isAsthma",
cast(case when clt.is_immunocompromized then ''Yes'' else ''No'' end as text) as "isImmunocompromized",
clt.other_co_mobidity as "otherUnderlyingConditions",
to_char(clt.admission_date, ''DD/MM/YY'') as "hospitalizationDate",
cast(''N/A'' as text) as "diagnosis",
cast(''N/A'' as text) as "differentialDiagnosis",
cast(''N/A'' as text) as "etiologyIdentified",
cast(''N/A'' as text) as "atypicalPresentation",
cast(''N/A'' as text) as "unusalCourse",
cast(''N/A'' as text) as "outcome",
cast(''N/A'' as text) as "outcomeDate",
cast(''N/A'' as text) as "hospitalPhoneNo",
(select name_in_english from health_infrastructure_details where id = clt.health_infra_id) as "hospitalName",
cast(''N/A'' as text) as "nameOfDoctor",
cast(''N/A'' as text) as "hospitalEmailId",
clt.discharge_status as "dischargeStatus",
to_char(clt.discharge_date, ''DD/MM/YY'') as "dischargeDate",
to_char(cltd.lab_sample_received_on, ''DD/MM/YY'') as "dateOfSampleRecipt",
cast(case when cltd.lab_sample_received_on is not null and cltd.lab_sample_rejected_on is null then ''Accepted''
when cltd.lab_sample_received_on is not null and cltd.lab_sample_rejected_on is not null then ''Rejected''
else null end as text) as "sampleAcceptedRejected",
to_char(cltd.lab_result_entry_on, ''DD/MM/YY'') as "dateOfTesting",
cltd.lab_result as "testResult",
cast(''N/A'' as text) as "repeatedSampleRequired"
from covid19_lab_test_detail cltd
inner join covid19_admission_detail clt on cltd.covid_admission_detail_id = clt.id
where cltd.id in ( #labTestIds# )',
null,
true, 'ACTIVE');