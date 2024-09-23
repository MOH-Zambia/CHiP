insert
	into
	ocr_form_master (form_name,
	form_json,
	created_by,
	created_on,
	modified_by,
	modified_on)
values('OCR_ADD_MEMBER',
'[{"page":1,"questionsConfigurations":[{"fieldName":"relationWithHof","fieldType":"TB","lineNumber":1,"question":"Relation with hof","splitByForExtractingAnswer":":"},{"fieldName":"firstName","fieldType":"TB","lineNumber":2,"question":"First name","splitByForExtractingAnswer":":"},{"fieldName":"middleName","fieldType":"TB","lineNumber":3,"question":"Middle name","splitByForExtractingAnswer":":"},{"fieldName":"lastName","fieldType":"TB","lineNumber":4,"question":"Last name","splitByForExtractingAnswer":":"},{"fieldName":"gender","fieldType":"TB","lineNumber":5,"question":"Gender","splitByForExtractingAnswer":":"},{"fieldName":"religion","fieldType":"TB","lineNumber":6,"question":"Religion","splitByForExtractingAnswer":":"},{"fieldName":"maritalStatus","fieldType":"TB","lineNumber":7,"question":"Marital status","splitByForExtractingAnswer":":"},{"fieldName":"dob","fieldType":"DB","lineNumber":8,"question":"Date of birth","splitByForExtractingAnswer":":"},{"fieldName":"mobileNumber","fieldType":"ITB","lineNumber":9,"question":"Mobile number","splitByForExtractingAnswer":":"},{"fieldName":"isPregnant","fieldType":"RB","lineNumber":10,"question":"Is pregnant","splitByForExtractingAnswer":":"},{"fieldName":"lmp","fieldType":"DB","lineNumber":11,"question":"LMP Date","splitByForExtractingAnswer":":"},{"fieldName":"chronicDisease","fieldType":"TB","lineNumber":12,"question":"Chronic disease","splitByForExtractingAnswer":":"},{"fieldName":"onTreatment","fieldType":"RB","lineNumber":13,"question":"On treatment","splitByForExtractingAnswer":":"}]}]',-1,
now(),
-1,
now());
insert
	into
	ocr_form_master (form_name,
	form_json,
	created_by,
	created_on,
	modified_by,
	modified_on)
values('OCR_UPDATE_MEMBER',
'[{"page":1,"questionsConfigurations":[{"fieldName":"serviceDate","fieldType":"DB","lineNumber":2,"question":"Service date","splitByForExtractingAnswer":":"},{"fieldName":"firstName","fieldType":"TB","lineNumber":3,"question":"First name","splitByForExtractingAnswer":":"},{"fieldName":"middleName","fieldType":"TB","lineNumber":4,"question":"Middle name","splitByForExtractingAnswer":":"},{"fieldName":"lastName","fieldType":"TB","lineNumber":5,"question":"Last name","splitByForExtractingAnswer":":"},{"fieldName":"gender","fieldType":"TB","lineNumber":6,"question":"Gender","splitByForExtractingAnswer":":"},{"fieldName":"religion","fieldType":"TB","lineNumber":7,"question":"Religion","splitByForExtractingAnswer":":"},{"fieldName":"maritalStatus","fieldType":"TB","lineNumber":8,"question":"Marital status","splitByForExtractingAnswer":":"},{"fieldName":"dob","fieldType":"DB","lineNumber":9,"question":"Date of birth","splitByForExtractingAnswer":":"},{"fieldName":"mobileNumber","fieldType":"ITB","lineNumber":10,"question":"Mobile number","splitByForExtractingAnswer":":"},{"fieldName":"isPregnant","fieldType":"RB","lineNumber":11,"question":"Is pregnant","splitByForExtractingAnswer":":"},{"fieldName":"lmp","fieldType":"DB","lineNumber":12,"question":"LMP Date","splitByForExtractingAnswer":":"},{"fieldName":"chronicDisease","fieldType":"TB","lineNumber":13,"question":"Chronic disease","splitByForExtractingAnswer":":"},{"fieldName":"onTreatment","fieldType":"RB","lineNumber":14,"question":"On treatment","splitByForExtractingAnswer":":"}]}]',
	-1,
now(),
-1,
now());

insert
	into
	ocr_form_master (form_name,
	form_json,
	created_by,
	created_on,
	modified_by,
	modified_on)
values('OCR_HOUSEHOLD_LINE_LIST',
'[{"page":1,"questionsConfigurations":[{"fieldName":"houseNumber","fieldType":"TB","lineNumber":1,"question":"House number","splitByForExtractingAnswer":":"},{"fieldName":"address","fieldType":"TB","lineNumber":2,"question":"address","splitByForExtractingAnswer":":"},{"fieldName":"typeOfToilet","fieldType":"TB","lineNumber":3,"question":"Type of toilet","splitByForExtractingAnswer":":"},{"fieldName":"outdoorCookingPractices","fieldType":"TB","lineNumber":4,"question":"Outdoor cooking practices","splitByForExtractingAnswer":":"},{"fieldName":"handWashAvailable","fieldType":"RB","lineNumber":5,"question":"Hand wash available","splitByForExtractingAnswer":":"},{"fieldName":"wasteDisposalAvailable","fieldType":"RB","lineNumber":6,"question":"Waste disposal available","splitByForExtractingAnswer":":"},{"fieldName":"wasteDisposalMethod","fieldType":"TB","lineNumber":7,"question":"Waste disposal type","splitByForExtractingAnswer":":"},{"fieldName":"drinkingWaterSource","fieldType":"TB","lineNumber":8,"question":"Source of drinking water","splitByForExtractingAnswer":":"},{"fieldName":"dishrackAvailable","fieldType":"RB","lineNumber":9,"question":"Dish rack available","splitByForExtractingAnswer":":"},{"fieldName":"complaintOfInsects","fieldType":"RB","lineNumber":10,"question":"Complaint of insects","splitByForExtractingAnswer":":"},{"fieldName":"complaintOfRodents","fieldType":"RB","lineNumber":11,"question":"Complaint of rodents","splitByForExtractingAnswer":":"},{"fieldName":"seperateLivestockShelter","fieldType":"RB","lineNumber":12,"question":"Seperate livestock shelter","splitByForExtractingAnswer":":"},{"fieldName":"noMosquitoNetsAvailable","fieldType":"TB","lineNumber":13,"question":"Number of mosquito net available","splitByForExtractingAnswer":":"},{"fieldName":"isIecGiven","fieldType":"RB","lineNumber":14,"question":"Is iec given","splitByForExtractingAnswer":":"}]}]',
-1,
now(),
-1,
now());
--delete from ocr_form_master where form_name='FHW_WPD';
insert
	into
	ocr_form_master (form_name,
	form_json,
	created_by,
	created_on,
	modified_by,
	modified_on)
values('OCR_WPD',
'[{"page":1,"questionsConfigurations":[{"fieldName":"serviceDate","fieldType":"DB","lineNumber":2,"question":"Service date","splitByForExtractingAnswer":":"},{"fieldName":"deliveryDate","fieldType":"DB","lineNumber":3,"question":"Delivery date","splitByForExtractingAnswer":":"},{"fieldName":"deliveryTime","fieldType":"TB","lineNumber":4,"question":"Delivery time","splitByForExtractingAnswer":":"},{"fieldName":"isCorticoInjected","fieldType":"RB","lineNumber":5,"question":"Is cortico injected","splitByForExtractingAnswer":":"},{"fieldName":"pregnancyOutcome","fieldType":"TB","lineNumber":6,"question":"Pregnanct outcome","splitByForExtractingAnswer":":"},{"fieldName":"typeOfDelivery","fieldType":"TB","lineNumber":7,"question":"Type of delivery","splitByForExtractingAnswer":":"},{"fieldName":"deliveryPlace","fieldType":"TB","lineNumber":8,"question":"Delivery place","splitByForExtractingAnswer":":"},{"fieldName":"breastFeedingInOneHour","fieldType":"RB","lineNumber":9,"question":"Breast feeding in one hour","splitByForExtractingAnswer":":"},{"fieldName":"deliveryPerformedBy","fieldType":"TB","lineNumber":10,"question":"Delivery performed by","splitByForExtractingAnswer":":"},{"fieldName":"motherReferalRequired","fieldType":"RB","lineNumber":11,"question":"Mother referal required","splitByForExtractingAnswer":":"},{"fieldName":"motherReferalReason","fieldType":"TB","lineNumber":12,"question":"Mother referal reason","splitByForExtractingAnswer":":"},{"fieldName":"gender","fieldType":"TB","lineNumber":13,"question":"Gender","splitByForExtractingAnswer":":"},{"fieldName":"babyWeight","fieldType":"TB","lineNumber":14,"question":"Baby weight","splitByForExtractingAnswer":":"},{"fieldName":"childReferalRequired","fieldType":"RB","lineNumber":15,"question":"Child referral required","splitByForExtractingAnswer":":"},{"fieldName":"childReferralReason","fieldType":"TB","lineNumber":16,"question":"Child referral reason","splitByForExtractingAnswer":":"},{"fieldName":"iecGiven","fieldType":"RB","lineNumber":17,"question":"Iec given","splitByForExtractingAnswer":":"}]}]',
-1,
now(),
-1,
now());
insert
	into
	ocr_form_master (form_name,
	form_json,
	created_by,
	created_on,
	modified_by,
	modified_on)
values('OCR_PNC',
'[{"page":1,"questionsConfigurations":[{"fieldName":"serviceDate","fieldType":"DB","lineNumber":2,"question":"Service date","splitByForExtractingAnswer":":"},{"fieldName":"pncDoneAt","fieldType":"TB","lineNumber":3,"question":"Delivery place","splitByForExtractingAnswer":":"},{"fieldName":"ifaTabletsGiven","fieldType":"TB","lineNumber":4,"question":"Ifa tablets given","splitByForExtractingAnswer":":"},{"fieldName":"calciumTabletsGiven","fieldType":"TB","lineNumber":5,"question":"Calcium tablets given","splitByForExtractingAnswer":":"},{"fieldName":"isReferralRequired","fieldType":"RB","lineNumber":6,"question":"Is referral required","splitByForExtractingAnswer":":"},{"fieldName":"referralReason","fieldType":"TB","lineNumber":7,"question":"Referral reason","splitByForExtractingAnswer":":"},{"fieldName":"familyPlanningMethod","fieldType":"TB","lineNumber":8,"question":"Family planning required","splitByForExtractingAnswer":":"},{"fieldName":"cptStarted","fieldType":"RB","lineNumber":9,"question":"Has cpt started","splitByForExtractingAnswer":":"},{"fieldName":"eidStarted","fieldType":"RB","lineNumber":10,"question":"Has eid started for hiv","splitByForExtractingAnswer":":"},{"fieldName":"dangerSigns","fieldType":"RB","lineNumber":11,"question":"Danger signs","splitByForExtractingAnswer":":"},{"fieldName":"childWeight","fieldType":"TB","lineNumber":12,"question":"Child weight","splitByForExtractingAnswer":":"},{"fieldName":"childReferalRequired","fieldType":"RB","lineNumber":13,"question":"Child referral required","splitByForExtractingAnswer":":"},{"fieldName":"childReferralReason","fieldType":"TB","lineNumber":14,"question":"Child referral reason","splitByForExtractingAnswer":":"},{"fieldName":"isIecGiven","fieldType":"RB","lineNumber":15,"question":"Iec given","splitByForExtractingAnswer":":"}]}]'
,-1,
now(),
-1,
now());

INSERT INTO public.ocr_form_master
(form_name, form_json, created_by, created_on, modified_by, modified_on)
VALUES('OCR_CS', '[{"page":1,"questionsConfigurations":[{"fieldName":"serviceDate","fieldType":"DB","lineNumber":2,"question":"Service date","splitByForExtractingAnswer":":"},{"fieldName":"gaurdianMobileNumber","fieldType":"TB","lineNumber":3,"question":"Gaurdian mobile number","splitByForExtractingAnswer":":"},{"fieldName":"motherMobileNumber","fieldType":"TB","lineNumber":4,"question":"Mother mobile number","splitByForExtractingAnswer":":"},{"fieldName":"serviceDoneAt","fieldType":"TB","lineNumber":5,"question":"Service done at","splitByForExtractingAnswer":":"},{"fieldName":"childWeight","fieldType":"TB","lineNumber":6,"question":"Child weight","splitByForExtractingAnswer":":"},{"fieldName":"ifaSyrup","fieldType":"RB","lineNumber":7,"question":"Ifa syrup","splitByForExtractingAnswer":":"},{"fieldName":"complementaryFeedingStarted","fieldType":"RB","lineNumber":8,"question":"Complementary feeding started","splitByForExtractingAnswer":":"},{"fieldName":"exclusivelyBreastfed","fieldType":"RB","lineNumber":9,"question":"Is baby exclusively breastfed","splitByForExtractingAnswer":":"},{"fieldName":"muac","fieldType":"TB","lineNumber":10,"question":"MUAC","splitByForExtractingAnswer":":"},{"fieldName":"height","fieldType":"TB","lineNumber":11,"question":"Height","splitByForExtractingAnswer":":"},{"fieldName":"pedalEdema","fieldType":"RB","lineNumber":12,"question":"Pedal edema","splitByForExtractingAnswer":":"},{"fieldName":"immunisation","fieldType":"TB","lineNumber":13,"question":"Immunisation","splitByForExtractingAnswer":":"},{"fieldName":"referralRequired","fieldType":"RB","lineNumber":14,"question":"Is referral required","splitByForExtractingAnswer":":"},{"fieldName":"referralReason","fieldType":"TB","lineNumber":15,"question":"Referral reason","splitByForExtractingAnswer":":"},{"fieldName":"isIecGiven","fieldType":"RB","lineNumber":16,"question":"Iec given","splitByForExtractingAnswer":":"}]}]',
 -1, now(), -1, now());

 insert
 	into
 	ocr_form_master (form_name,
 	form_json,
 	created_by,
 	created_on,
 	modified_by,
 	modified_on)
 values('OCR_GBV',
 '[{"page":1,"questionsConfigurations":[{"fieldName":"serviceDate","fieldType":"DB","lineNumber":2,"question":"Service date","splitByForExtractingAnswer":":"},{"fieldName":"caseDate","fieldType":"DB","lineNumber":3,"question":"Case date","splitByForExtractingAnswer":":"},{"fieldName":"threatenedWithSexualViolence","fieldType":"RB","lineNumber":4,"question":"Threatened with sexual violence","splitByForExtractingAnswer":":"},{"fieldName":"hurtWithWeaponOrPhysicallyHurt","fieldType":"RB","lineNumber":5,"question":"Hurt with weapon or physically hurt","splitByForExtractingAnswer":":"},{"fieldName":"forcedToHaveSexAgainstWill","fieldType":"RB","lineNumber":6,"question":"Forced to have sex against will","splitByForExtractingAnswer":":"},{"fieldName":"forcedToHaveSexForBasicEssentials","fieldType":"RB","lineNumber":7,"question":"Forced to have sex for basic essentials","splitByForExtractingAnswer":":"},{"fieldName":"forcedToBePregnant","fieldType":"RB","lineNumber":8,"question":"Were you forced to be pregnant","splitByForExtractingAnswer":":"},{"fieldName":"areYouPregnant","fieldType":"RB","lineNumber":9,"question":"Are you pregnant","splitByForExtractingAnswer":":"},{"fieldName":"forcedToLoosePregnancy","fieldType":"RB","lineNumber":10,"question":"Forced to loose pregnancy","splitByForExtractingAnswer":":"},{"fieldName":"forcedIntoMarriage","fieldType":"RB","lineNumber":11,"question":"Forced into marriage","splitByForExtractingAnswer":":"},{"fieldName":"referralRequired","fieldType":"RB","lineNumber":12,"question":"Is referral required","splitByForExtractingAnswer":":"},{"fieldName":"referralReason","fieldType":"TB","lineNumber":13,"question":"Referral reason","splitByForExtractingAnswer":":"}]}]'
 ,-1,
 now(),
 -1,
 now());

 insert
 	into
 	ocr_form_master (form_name,
 	form_json,
 	created_by,
 	created_on,
 	modified_by,
 	modified_on)
 values('OCR_NON_INDEX',
 '[{"page":1,"questionsConfigurations":[{"fieldName":"serviceDate","fieldType":"DB","lineNumber":1,"question":"Service date","splitByForExtractingAnswer":":"},{"fieldName":"consentSought","fieldType":"RB","lineNumber":2,"question":"Consent sought","splitByForExtractingAnswer":":"},{"fieldName":"numberOfIndividual","fieldType":"TB","lineNumber":3,"question":"Number of people in household","splitByForExtractingAnswer":":"},{"fieldName":"numberOfPeopleTested","fieldType":"TB","lineNumber":4,"question":"Number of people tested","splitByForExtractingAnswer":":"},{"fieldName":"numberOfPeopleTestedPositive","fieldType":"TB","lineNumber":5,"question":"Number of people tested positive","splitByForExtractingAnswer":":"},{"fieldName":"sprayableSurface","fieldType":"TB","lineNumber":6,"question":"Sprayable surface","splitByForExtractingAnswer":":"},{"fieldName":"nonSprayableSurface","fieldType":"TB","lineNumber":7,"question":"Non sprayable surface","splitByForExtractingAnswer":":"},{"fieldName":"lastDateOfSpray","fieldType":"DB","lineNumber":8,"question":"Last date of spray","splitByForExtractingAnswer":":"},{"fieldName":"numberOfLlinInHouse","fieldType":"TB","lineNumber":9,"question":"Number of LLIN in house","splitByForExtractingAnswer":":"},{"fieldName":"medicineToPreventMalaria","fieldType":"RB","lineNumber":10,"question":"Medicine to prevent malaria","splitByForExtractingAnswer":":"},{"fieldName":"preventiveMeasureTaken","fieldType":"RB","lineNumber":11,"question":"Preventive measure taken","splitByForExtractingAnswer":":"},{"fieldName":"referralRequired","fieldType":"RB","lineNumber":12,"question":"Is referral required","splitByForExtractingAnswer":":"}]}]'
 ,-1,
 now(),
 -1,
 now());

insert
	into
	ocr_form_master (form_name,
	form_json,
	created_by,
	created_on,
	modified_by,
	modified_on)
values('OCR_INDEX',
'[{"page":1,"questionsConfigurations":[{"fieldName":"serviceDate","fieldType":"DB","lineNumber":1,"question":"Service date","splitByForExtractingAnswer":":"},{"fieldName":"daysSincePatientDiagnosed","fieldType":"TB","lineNumber":2,"question":"Days since patient diagnosed","splitByForExtractingAnswer":":"},{"fieldName":"patientAdheredToTreatment","fieldType":"RB","lineNumber":3,"question":"Patient adhered to treatment","splitByForExtractingAnswer":":"},{"fieldName":"treatmentDay","fieldType":"TB","lineNumber":4,"question":"Treatment day","splitByForExtractingAnswer":":"},{"fieldName":"evidenceOfFever","fieldType":"RB","lineNumber":5,"question":"Evidence of fever","splitByForExtractingAnswer":":"},{"fieldName":"anySignsShown","fieldType":"RB","lineNumber":6,"question":"Any signs shown","splitByForExtractingAnswer":":"},{"fieldName":"signShown","fieldType":"TB","lineNumber":7,"question":"Signs shown","splitByForExtractingAnswer":":"},{"fieldName":"dbsCollected","fieldType":"RB","lineNumber":8,"question":"DBS collected","splitByForExtractingAnswer":":"},{"fieldName":"dbsResultAvailable","fieldType":"RB","lineNumber":9,"question":"DBS result available","splitByForExtractingAnswer":":"},{"fieldName":"dbsValue","fieldType":"TB","lineNumber":10,"question":"DBS value","splitByForExtractingAnswer":":"}]}]'
,-1,
now(),
-1,
now());