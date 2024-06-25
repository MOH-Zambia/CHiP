drop table if exists ocr_form_master;

create table if not exists ocr_form_master (
	id serial primary key,
	form_name text,
	form_json text,
	created_by integer not null,
  	created_on timestamp without time zone not null,
  	modified_by integer,
  	modified_on timestamp without time zone
);

insert
	into
	public.ocr_form_master
    (
        form_name,
	form_json,
	created_by,
	created_on,
	modified_by,
	modified_on)
values(
    'OCR_ACTIVE_MALARIA',
    '[{"page" : 1,"questionsConfigurations" : [{"fieldName":"serviceDate","fieldType":"DB","lineNumber":1,"question":"Service date","splitByForExtractingAnswer":":"},{"fieldName":"memberStatus","fieldType":"TB","lineNumber":2,"question":"Member status","splitByForExtractingAnswer":":"},{"fieldName":"otherMalariaSymtoms","fieldType":"TB","lineNumber":3,"question":"Symptoms","splitByForExtractingAnswer":":"},{"fieldName":"rdtTestStatus","fieldType":"TB","lineNumber":4,"question":"RDT status","splitByForExtractingAnswer":":"},{"fieldName":"isIndexCase","fieldType":"RB","lineNumber":5,"question":"Index case","splitByForExtractingAnswer":":"},{"fieldName":"havingTravelHistory","fieldType":"RB","lineNumber":6,"question":"Having travel history","splitByForExtractingAnswer":":"},{"fieldName":"malariaTreatmentHistory","fieldType":"RB","lineNumber":7,"question":"Malaria treatment history","splitByForExtractingAnswer":":"},{"fieldName":"isTreatmentBeingGiven","fieldType":"RB","lineNumber":8,"question":"Treatment given","splitByForExtractingAnswer":":"},{"fieldName":"lmpDate","fieldType":"DB","lineNumber":9,"question":"LMP date","splitByForExtractingAnswer":":"},{"fieldName":"referralDone","fieldType":"RB","lineNumber":10,"question":"Referral required","splitByForExtractingAnswer":":"},{"fieldName":"referralReason","fieldType":"TB","lineNumber":11,"question":"Referral reason","splitByForExtractingAnswer":":"},{"fieldName":"isIecGiven","fieldType":"RB","lineNumber":12,"question":"IEC Given","splitByForExtractingAnswer":":"}]}]',
    -1,
    now(),
    -1,
    now());

insert
	into
	mobile_beans_feature_rel (bean,
	feature)
values
         ('OcrFormBean',
'CBV_MY_PEOPLE');

insert
	into
	public.ocr_form_master
    (
        form_name,
	form_json,
	created_by,
	created_on,
	modified_by,
	modified_on)
values(
    'OCR_PASSIVE_MALARIA',
    '[{"page":1,"questionsConfigurations":[{"fieldName":"serviceDate","fieldType":"DB","lineNumber":1,"question":"Servicedate","splitByForExtractingAnswer":":"},{"fieldName":"memberStatus","fieldType":"TB","lineNumber":2,"question":"Memberstatus","splitByForExtractingAnswer":":"},{"fieldName":"otherMalariaSymtoms","fieldType":"TB","lineNumber":3,"question":"Symptoms","splitByForExtractingAnswer":":"},{"fieldName":"rdtTestStatus","fieldType":"TB","lineNumber":4,"question":"RDTstatus","splitByForExtractingAnswer":":"},{"fieldName":"havingTravelHistory","fieldType":"RB","lineNumber":5,"question":"Havingtravelhistory","splitByForExtractingAnswer":":"},{"fieldName":"malariaTreatmentHistory","fieldType":"RB","lineNumber":6,"question":"Malariatreatmenthistory","splitByForExtractingAnswer":":"},{"fieldName":"isTreatmentBeingGiven","fieldType":"RB","lineNumber":7,"question":"Treatmentgiven","splitByForExtractingAnswer":":"},{"fieldName":"lmpDate","fieldType":"DB","lineNumber":8,"question":"LMPdate","splitByForExtractingAnswer":":"},{"fieldName":"referralDone","fieldType":"RB","lineNumber":9,"question":"Referralrequired","splitByForExtractingAnswer":":"},{"fieldName":"referralReason","fieldType":"TB","lineNumber":10,"question":"Referralreason","splitByForExtractingAnswer":":"},{"fieldName":"isIecGiven","fieldType":"RB","lineNumber":11,"question":"IECGiven","splitByForExtractingAnswer":":"}]}]',
    -1,
    now(),
    -1,
    now());

insert
	into
	public.ocr_form_master
        (
            form_name,
	form_json,
	created_by,
	created_on,
	modified_by,
	modified_on)
values(
        'OCR_COVID_SCREENING',
        '[{"page":1,"questionsConfigurations":[{"fieldName":"serviceDate","fieldType":"DB","lineNumber":1,"question":"Service date","splitByForExtractingAnswer":":"},{"fieldName":"isDoseOneTaken","fieldType":"RB","lineNumber":2,"question":"Is dose 1 taken ?","splitByForExtractingAnswer":":"},{"fieldName":"doseOneName","fieldType":"TB","lineNumber":3,"question":"Vaccine name (Dose 1)","splitByForExtractingAnswer":":"},{"fieldName":"doseOneDate","fieldType":"DB","lineNumber":4,"question":"Vaccine date (Dose 1)","splitByForExtractingAnswer":":"},{"fieldName":"isDoseTwoTaken","fieldType":"RB","lineNumber":5,"question":"Is dose 2 taken ?","splitByForExtractingAnswer":":"},{"fieldName":"doseTwoName","fieldType":"TB","lineNumber":6,"question":"Vaccine name (Dose 2)","splitByForExtractingAnswer":":"},{"fieldName":"doseTwoDate","fieldType":"DB","lineNumber":7,"question":"Vaccine date (Dose 2)","splitByForExtractingAnswer":":"},{"fieldName":"willingForBoosterVaccine","fieldType":"RB","lineNumber":8,"question":"Willing to take booster vaccine ?","splitByForExtractingAnswer":":"},{"fieldName":"boosterName","fieldType":"TB","lineNumber":9,"question":"Booster vaccine name","splitByForExtractingAnswer":":"},{"fieldName":"boosterDate","fieldType":"DB","lineNumber":10,"question":"Booster vaccine date","splitByForExtractingAnswer":":"},{"fieldName":"reactionAndEffects","fieldType":"TB","lineNumber":11,"question":"Experienced effects","splitByForExtractingAnswer":":"}]},{"page":2,"questionsConfigurations":[{"fieldName":"referralDone","fieldType":"RB","lineNumber":1,"question":"Is referral required ?","splitByForExtractingAnswer":":"},{"fieldName":"referralReason","fieldType":"TB","lineNumber":2,"question":"Referral reason","splitByForExtractingAnswer":":"},{"fieldName":"isIecGiven","fieldType":"RB","lineNumber":3,"question":"Is IEC given ?","splitByForExtractingAnswer":":"}]}]',
        -1,
        now(),
        -1,
        now());

insert
	into
	public.ocr_form_master
        (
            form_name,
	form_json,
	created_by,
	created_on,
	modified_by,
	modified_on)
values(
        'OCR_TB_SCREENING',
        '[{"page":1,"questionsConfigurations":[{"fieldName":"serviceDate","fieldType":"DB","lineNumber":1,"question":"Service date","splitByForExtractingAnswer":":"},{"fieldName":"otherTbSymptoms","fieldType":"TB","lineNumber":2,"question":"Tuberculosis symptoms","splitByForExtractingAnswer":":"},{"fieldName":"tbTestType","fieldType":"TB","lineNumber":3,"question":"Test Type","splitByForExtractingAnswer":":"},{"fieldName":"isTbSuspected","fieldType":"RB","lineNumber":4,"question":"Is Tuberculosis Suspected","splitByForExtractingAnswer":":"},{"fieldName":"isTbCured","fieldType":"RB","lineNumber":5,"question":"Is Tuberculosis Cured","splitByForExtractingAnswer":":"},{"fieldName":"isPatientTakingMedicines","fieldType":"RB","lineNumber":6,"question":"Is patient taking medicines ?","splitByForExtractingAnswer":":"},{"fieldName":"lmpDate","fieldType":"DB","lineNumber":7,"question":"LMP Date","splitByForExtractingAnswer":":"},{"fieldName":"anyReactionOrSideEffect","fieldType":"RB","lineNumber":8,"question":"Any side effects ?","splitByForExtractingAnswer":":"},{"fieldName":"referralDone","fieldType":"RB","lineNumber":9,"question":"Referral required","splitByForExtractingAnswer":":"},{"fieldName":"referralReason","fieldType":"TB","lineNumber":10,"question":"Referral reason","splitByForExtractingAnswer":":"},{"fieldName":"isIecGiven","fieldType":"RB","lineNumber":11,"question":"IEC Given","splitByForExtractingAnswer":":"}]}]',
        -1,
        now(),
        -1,
        now());

drop table if exists ocr_form_master;

create table if not exists ocr_form_master (
	id serial primary key,
	form_name text,
	form_json text,
	created_by integer not null,
  	created_on timestamp without time zone not null,
  	modified_by integer,
  	modified_on timestamp without time zone
);

insert
	into
	public.ocr_form_master
    (
        form_name,
	form_json,
	created_by,
	created_on,
	modified_by,
	modified_on)
values(
    'OCR_ACTIVE_MALARIA',
    '[{"page" : 1,"questionsConfigurations" : [{"fieldName":"serviceDate","fieldType":"DB","lineNumber":1,"question":"Service date","splitByForExtractingAnswer":":"},{"fieldName":"memberStatus","fieldType":"TB","lineNumber":2,"question":"Member status","splitByForExtractingAnswer":":"},{"fieldName":"otherMalariaSymtoms","fieldType":"TB","lineNumber":3,"question":"Symptoms","splitByForExtractingAnswer":":"},{"fieldName":"rdtTestStatus","fieldType":"TB","lineNumber":4,"question":"RDT status","splitByForExtractingAnswer":":"},{"fieldName":"isIndexCase","fieldType":"RB","lineNumber":5,"question":"Index case","splitByForExtractingAnswer":":"},{"fieldName":"havingTravelHistory","fieldType":"RB","lineNumber":6,"question":"Having travel history","splitByForExtractingAnswer":":"},{"fieldName":"malariaTreatmentHistory","fieldType":"RB","lineNumber":7,"question":"Malaria treatment history","splitByForExtractingAnswer":":"},{"fieldName":"isTreatmentBeingGiven","fieldType":"RB","lineNumber":8,"question":"Treatment given","splitByForExtractingAnswer":":"},{"fieldName":"lmpDate","fieldType":"DB","lineNumber":9,"question":"LMP date","splitByForExtractingAnswer":":"},{"fieldName":"referralDone","fieldType":"RB","lineNumber":10,"question":"Referral required","splitByForExtractingAnswer":":"},{"fieldName":"referralReason","fieldType":"TB","lineNumber":11,"question":"Referral reason","splitByForExtractingAnswer":":"},{"fieldName":"isIecGiven","fieldType":"RB","lineNumber":12,"question":"IEC Given","splitByForExtractingAnswer":":"}]}]',
    -1,
    now(),
    -1,
    now());

insert
	into
	mobile_beans_feature_rel (bean,
	feature)
values
         ('OcrFormBean',
'CBV_MY_PEOPLE');

insert
	into
	public.ocr_form_master
    (
        form_name,
	form_json,
	created_by,
	created_on,
	modified_by,
	modified_on)
values(
    'OCR_PASSIVE_MALARIA',
    '[{"page":1,"questionsConfigurations":[{"fieldName":"serviceDate","fieldType":"DB","lineNumber":1,"question":"Servicedate","splitByForExtractingAnswer":":"},{"fieldName":"memberStatus","fieldType":"TB","lineNumber":2,"question":"Memberstatus","splitByForExtractingAnswer":":"},{"fieldName":"otherMalariaSymtoms","fieldType":"TB","lineNumber":3,"question":"Symptoms","splitByForExtractingAnswer":":"},{"fieldName":"rdtTestStatus","fieldType":"TB","lineNumber":4,"question":"RDTstatus","splitByForExtractingAnswer":":"},{"fieldName":"havingTravelHistory","fieldType":"RB","lineNumber":5,"question":"Havingtravelhistory","splitByForExtractingAnswer":":"},{"fieldName":"malariaTreatmentHistory","fieldType":"RB","lineNumber":6,"question":"Malariatreatmenthistory","splitByForExtractingAnswer":":"},{"fieldName":"isTreatmentBeingGiven","fieldType":"RB","lineNumber":7,"question":"Treatmentgiven","splitByForExtractingAnswer":":"},{"fieldName":"lmpDate","fieldType":"DB","lineNumber":8,"question":"LMPdate","splitByForExtractingAnswer":":"},{"fieldName":"referralDone","fieldType":"RB","lineNumber":9,"question":"Referralrequired","splitByForExtractingAnswer":":"},{"fieldName":"referralReason","fieldType":"TB","lineNumber":10,"question":"Referralreason","splitByForExtractingAnswer":":"},{"fieldName":"isIecGiven","fieldType":"RB","lineNumber":11,"question":"IECGiven","splitByForExtractingAnswer":":"}]}]',
    -1,
    now(),
    -1,
    now());

insert
	into
	public.ocr_form_master
        (
            form_name,
	form_json,
	created_by,
	created_on,
	modified_by,
	modified_on)
values(
        'OCR_COVID_SCREENING',
        '[{"page":1,"questionsConfigurations":[{"fieldName":"serviceDate","fieldType":"DB","lineNumber":1,"question":"Service date","splitByForExtractingAnswer":":"},{"fieldName":"isDoseOneTaken","fieldType":"RB","lineNumber":2,"question":"Is dose 1 taken ?","splitByForExtractingAnswer":":"},{"fieldName":"doseOneName","fieldType":"TB","lineNumber":3,"question":"Vaccine name (Dose 1)","splitByForExtractingAnswer":":"},{"fieldName":"doseOneDate","fieldType":"DB","lineNumber":4,"question":"Vaccine date (Dose 1)","splitByForExtractingAnswer":":"},{"fieldName":"isDoseTwoTaken","fieldType":"RB","lineNumber":5,"question":"Is dose 2 taken ?","splitByForExtractingAnswer":":"},{"fieldName":"doseTwoName","fieldType":"TB","lineNumber":6,"question":"Vaccine name (Dose 2)","splitByForExtractingAnswer":":"},{"fieldName":"doseTwoDate","fieldType":"DB","lineNumber":7,"question":"Vaccine date (Dose 2)","splitByForExtractingAnswer":":"},{"fieldName":"willingForBoosterVaccine","fieldType":"RB","lineNumber":8,"question":"Willing to take booster vaccine ?","splitByForExtractingAnswer":":"},{"fieldName":"boosterName","fieldType":"TB","lineNumber":9,"question":"Booster vaccine name","splitByForExtractingAnswer":":"},{"fieldName":"boosterDate","fieldType":"DB","lineNumber":10,"question":"Booster vaccine date","splitByForExtractingAnswer":":"},{"fieldName":"reactionAndEffects","fieldType":"TB","lineNumber":11,"question":"Experienced effects","splitByForExtractingAnswer":":"}]},{"page":2,"questionsConfigurations":[{"fieldName":"referralDone","fieldType":"RB","lineNumber":1,"question":"Is referral required ?","splitByForExtractingAnswer":":"},{"fieldName":"referralReason","fieldType":"TB","lineNumber":2,"question":"Referral reason","splitByForExtractingAnswer":":"},{"fieldName":"isIecGiven","fieldType":"RB","lineNumber":3,"question":"Is IEC given ?","splitByForExtractingAnswer":":"}]}]',
        -1,
        now(),
        -1,
        now());

insert
	into
	public.ocr_form_master
        (
            form_name,
	form_json,
	created_by,
	created_on,
	modified_by,
	modified_on)
values(
        'OCR_TB_SCREENING',
        '[{"page":1,"questionsConfigurations":[{"fieldName":"serviceDate","fieldType":"DB","lineNumber":1,"question":"Service date","splitByForExtractingAnswer":":"},{"fieldName":"otherTbSymptoms","fieldType":"TB","lineNumber":2,"question":"Tuberculosis symptoms","splitByForExtractingAnswer":":"},{"fieldName":"tbTestType","fieldType":"TB","lineNumber":3,"question":"Test Type","splitByForExtractingAnswer":":"},{"fieldName":"isTbSuspected","fieldType":"RB","lineNumber":4,"question":"Is Tuberculosis Suspected","splitByForExtractingAnswer":":"},{"fieldName":"isTbCured","fieldType":"RB","lineNumber":5,"question":"Is Tuberculosis Cured","splitByForExtractingAnswer":":"},{"fieldName":"isPatientTakingMedicines","fieldType":"RB","lineNumber":6,"question":"Is patient taking medicines ?","splitByForExtractingAnswer":":"},{"fieldName":"lmpDate","fieldType":"DB","lineNumber":7,"question":"LMP Date","splitByForExtractingAnswer":":"},{"fieldName":"anyReactionOrSideEffect","fieldType":"RB","lineNumber":8,"question":"Any side effects ?","splitByForExtractingAnswer":":"},{"fieldName":"referralDone","fieldType":"RB","lineNumber":9,"question":"Referral required","splitByForExtractingAnswer":":"},{"fieldName":"referralReason","fieldType":"TB","lineNumber":10,"question":"Referral reason","splitByForExtractingAnswer":":"},{"fieldName":"isIecGiven","fieldType":"RB","lineNumber":11,"question":"IEC Given","splitByForExtractingAnswer":":"}]}]',
        -1,
        now(),
        -1,
        now());

insert
	into
	public.ocr_form_master
          (
               form_name,
	form_json,
	created_by,
	created_on,
	modified_by,
	modified_on)
values(
           'OCR_LMPFU',
           '[{"page":1,"questionsConfigurations":[{"fieldName":"serviceDate","fieldType":"DB","lineNumber":1,"question":"Service date","splitByForExtractingAnswer":":"},{"fieldName":"livingWithPartnerOrSpouse","fieldType":"RB","lineNumber":2,"question":"Living with partner or spouse","splitByForExtractingAnswer":":"},{"fieldName":"startDateOfLivingWithPartner","fieldType":"DB","lineNumber":3,"question":"Start date of living with partner","splitByForExtractingAnswer":":"},{"fieldName":"isUsingFamilyPlanningMethod","fieldType":"RB","lineNumber":4,"question":"Is using family planning method","splitByForExtractingAnswer":":"},{"fieldName":"familyPlanningMethod","fieldType":"TB","lineNumber":5,"question":"Family planning method used","splitByForExtractingAnswer":":"},{"fieldName":"pregnancyTestDone","fieldType":"RB","lineNumber":6,"question":"Is pregnancy test done ?","splitByForExtractingAnswer":":"},{"fieldName":"isPregnant","fieldType":"RB","lineNumber":7,"question":"Is she pregnant ?","splitByForExtractingAnswer":":"},{"fieldName":"currentGravida","fieldType":"ITB","lineNumber":8,"question":"Current gravida","splitByForExtractingAnswer":":"},{"fieldName":"currentPara","fieldType":"ITB","lineNumber":9,"question":"Current para","splitByForExtractingAnswer":":"},{"fieldName":"lmp","fieldType":"DB","lineNumber":10,"question":"LMP Date","splitByForExtractingAnswer":":"},{"fieldName":"phoneNumber","fieldType":"ITB","lineNumber":11,"question":"Phone number","splitByForExtractingAnswer":":"}]}]',
           -1,
           now(),
           -1,
           now());

insert
	into
	public.ocr_form_master
          (
               form_name,
	form_json,
	created_by,
	created_on,
	modified_by,
	modified_on)
values(
           'OCR_FAMILY_PLANNING',
           '[{"page":1,"questionsConfigurations":[{"fieldName":"serviceDate","fieldType":"DB","lineNumber":1,"question":"Service date","splitByForExtractingAnswer":":"},{"fieldName":"usingFpMethod","fieldType":"RB","lineNumber":2,"question":"Are you using family planning method ?","splitByForExtractingAnswer":":"},{"fieldName":"familyPlanningStage","fieldType":"TB","lineNumber":3,"question":"Stage of family planning","splitByForExtractingAnswer":":"},{"fieldName":"familyPlanningMethod","fieldType":"TB","lineNumber":4,"question":"Which family planning method do you use ?","splitByForExtractingAnswer":":"},{"fieldName":"isIecGiven","fieldType":"RB","lineNumber":5,"question":"Is IEC given ?","splitByForExtractingAnswer":":"}]}]',
           -1,
           now(),
           -1,
           now());

insert
	into
	public.ocr_form_master
          (
               form_name,
	form_json,
	created_by,
	created_on,
	modified_by,
	modified_on)
values(
           'OCR_HIV_POSITIVE',
           '[{"page":1,"questionsConfigurations":[{"fieldName":"serviceDate","fieldType":"DB","lineNumber":1,"question":"Service date","splitByForExtractingAnswer":":"},{"fieldName":"expectedDeliveryPlace","fieldType":"TB","lineNumber":2,"question":"Expected place of delivery ?","splitByForExtractingAnswer":":"},{"fieldName":"isOnArt","fieldType":"RB","lineNumber":3,"question":"Is ART done ?","splitByForExtractingAnswer":":"},{"fieldName":"isReferralDone","fieldType":"RB","lineNumber":4,"question":"Is referral required ?","splitByForExtractingAnswer":":"},{"fieldName":"referralReason","fieldType":"TB","lineNumber":5,"question":"Referral reason ","splitByForExtractingAnswer":":"}]}]',
           -1,
           now(),
           -1,
           now());

insert
	into
	public.ocr_form_master
          (
               form_name,
	form_json,
	created_by,
	created_on,
	modified_by,
	modified_on)
values(
           'OCR_EMTCT',
           '[{"page":1,"questionsConfigurations":[{"fieldName":"serviceDate","fieldType":"DB","lineNumber":1,"question":"Service date","splitByForExtractingAnswer":":"},{"fieldName":"dbsTestDone","fieldType":"RB","lineNumber":2,"question":"Is DBS test done ?","splitByForExtractingAnswer":":"},{"fieldName":"dbsResult","fieldType":"TB","lineNumber":3,"question":"DBS test result ?","splitByForExtractingAnswer":":"}]}]',
           -1,
           now(),
           -1,
           now());

insert
	into
	public.ocr_form_master
          (
               form_name,
	form_json,
	created_by,
	created_on,
	modified_by,
	modified_on)
values(
           'OCR_CHILD_HIV_SCREENING',
           '[{"page":1,"questionsConfigurations":[{"fieldName":"serviceDate","fieldType":"DB","lineNumber":1,"question":"Service date","splitByForExtractingAnswer":":"},{"fieldName":"hivTestResult","fieldType":"RB","lineNumber":2,"question":"Is child HIV positive ?","splitByForExtractingAnswer":":"},{"fieldName":"childCurrentlyOnArt","fieldType":"RB","lineNumber":3,"question":"Is on ART","splitByForExtractingAnswer":":"},{"fieldName":"childArtEnrollmentNumber","fieldType":"ITB","lineNumber":4,"question":"ART Enrollment number","splitByForExtractingAnswer":":"},{"fieldName":"childMotherHivPositive","fieldType":"RB","lineNumber":5,"question":"Is mother hiv positive ?","splitByForExtractingAnswer":":"},{"fieldName":"childParentDead","fieldType":"RB","lineNumber":6,"question":"Are any of the parents dead ?","splitByForExtractingAnswer":":"},{"fieldName":"childSick","fieldType":"RB","lineNumber":7,"question":"Sick or admitted in 6 months ?","splitByForExtractingAnswer":":"},{"fieldName":"pusNearEar","fieldType":"RB","lineNumber":8,"question":"Is PUS coming out from ear ?","splitByForExtractingAnswer":":"},{"fieldName":"referralRequired","fieldType":"RB","lineNumber":9,"question":"Is referral required ?","splitByForExtractingAnswer":":"}]}]',
           -1,
           now(),
           -1,
           now());

insert
	into
	public.ocr_form_master
          (
               form_name,
	form_json,
	created_by,
	created_on,
	modified_by,
	modified_on)
values(
           'OCR_ADULT_HIV_SCREENING',
           '[{"page":1,"questionsConfigurations":[{"fieldName":"serviceDate","fieldType":"DB","lineNumber":1,"question":"Service date","splitByForExtractingAnswer":":"},{"fieldName":"hivTestResult","fieldType":"RB","lineNumber":2,"question":"Is child HIV positive ?","splitByForExtractingAnswer":":"},{"fieldName":"receivingArt","fieldType":"RB","lineNumber":3,"question":"Is on ART","splitByForExtractingAnswer":":"},{"fieldName":"clientArtNumber","fieldType":"ITB","lineNumber":4,"question":"ART Enrollment number","splitByForExtractingAnswer":":"},{"fieldName":"symptoms","fieldType":"RB","lineNumber":5,"question":"Is mother hiv positive ?","splitByForExtractingAnswer":":"},{"fieldName":"privatePartsSymptoms","fieldType":"RB","lineNumber":6,"question":"Are any of the parents dead ?","splitByForExtractingAnswer":":"},{"fieldName":"exposedToHiv","fieldType":"RB","lineNumber":7,"question":"Sick or admitted in 6 months ?","splitByForExtractingAnswer":":"},{"fieldName":"unprotectedSexInLast6Months","fieldType":"RB","lineNumber":8,"question":"Is PUS coming out from ear ?","splitByForExtractingAnswer":":"}]}]',
           -1,
           now(),
           -1,
           now());

insert
	into
	public.ocr_form_master
          (
               form_name,
	form_json,
	created_by,
	created_on,
	modified_by,
	modified_on)
values(
           'OCR_KNOWN_POSITIVE',
           '[{"page":1,"questionsConfigurations":[{"fieldName":"serviceDate","fieldType":"DB","lineNumber":1,"question":"Service date","splitByForExtractingAnswer":":"},{"fieldName":"septrin","fieldType":"RB","lineNumber":2,"question":"Have you taken septrin ?","splitByForExtractingAnswer":":"},{"fieldName":"duration","fieldType":"DB","lineNumber":3,"question":"From how long are you taking septrin ?","splitByForExtractingAnswer":":"},{"fieldName":"arvTaken","fieldType":"RB","lineNumber":4,"question":"Have you ever taken ARV (Antiretroviral) ?","splitByForExtractingAnswer":":"},{"fieldName":"otherMedicationAlong","fieldType":"RB","lineNumber":5,"question":"Are you taking other medications along with ART ?","splitByForExtractingAnswer":":"},{"fieldName":"enoughMedication","fieldType":"RB","lineNumber":6,"question":"Do you have medication for 1 Week ?","splitByForExtractingAnswer":":"},{"fieldName":"viralLoadTest","fieldType":"RB","lineNumber":7,"question":"Is viral load test done ?","splitByForExtractingAnswer":":"},{"fieldName":"viralLoadSuppressed","fieldType":"RB","lineNumber":8,"question":"Is viral suppressed ?","splitByForExtractingAnswer":":"},{"fieldName":"unprotectedSex","fieldType":"RB","lineNumber":9,"question":"Unprotected sex in last 6 months ?","splitByForExtractingAnswer":":"},{"fieldName":"hivStatusOfMemberKnown","fieldType":"RB","lineNumber":10,"question":"Is partner HIV positive ?","splitByForExtractingAnswer":":"},{"fieldName":"name","fieldType":"TB","lineNumber":11,"question":"Name of partner with whom you had unprotected sex ?","splitByForExtractingAnswer":":"}]},{"page":2,"questionsConfigurations":[{"fieldName":"phoneNumber","fieldType":"ITB","lineNumber":1,"question":"Phone number of partner with whom you had unprotected sex ?","splitByForExtractingAnswer":":"},{"fieldName":"address","fieldType":"TB","lineNumber":2,"question":"Address of partner with whom you had unprotected sex ?","splitByForExtractingAnswer":":"},{"fieldName":"lmpDate","fieldType":"DB","lineNumber":3,"question":"LMP Date","splitByForExtractingAnswer":":"},{"fieldName":"arvDuringPregnancy","fieldType":"RB","lineNumber":4,"question":"ARV taken during pregnancy or breastfeeding ?","splitByForExtractingAnswer":":"},{"fieldName":"stoppedArt","fieldType":"RB","lineNumber":5,"question":"Have you stopped ART due to side effects ?","splitByForExtractingAnswer":":"},{"fieldName":"takenArt","fieldType":"RB","lineNumber":6,"question":"Have you taken ARV in the past ?","splitByForExtractingAnswer":":"},{"fieldName":"placeReceivedArt","fieldType":"TB","lineNumber":7,"question":"Where did you receive ARV from ?","splitByForExtractingAnswer":":"}]}]',
           -1,
           now(),
           -1,
           now());

alter table rch_hiv_screening_master
rename column  child_hiv_test to previous_hiv_test_result;