// (function () {
//     function BcgSurveyFillForm($rootScope, $state, BcgSurveyService, QueryDAO, Mask, GeneralUtil, AuthenticateService, toaster, $q, $uibModal) {
//         let bcgForm = this;

//         bcgForm.beneficiaries = [];
//         bcgForm.beneficiary_type = false;
//         bcgForm.bmi = 0;
//         bcgForm.bcgId = parseInt($state.params.bcgId);
//         bcgForm.checkNikshayId = 'true';
//         bcgForm.memberIsInAnyBeneficiary = false;

//         bcgForm.parameterList = [
//             'tb_treatment', 
//             'tb_prevent_therapy', 
//             'tb_diagnosed', 
//             'cough_for_two_weeks', 
//             'fever_for_two_weeks', 
//             'significant_weight_loss', 
//             'blood_in_sputum', 
//             'consent_unavailable', 
//             'bed_ridden', 
//             'is_pregnant', 
//             'is_hiv', 
//             'is_cancer', 
//             'on_medication', 
//             'organ_transplant', 
//             'blood_transfusion', 
//             'bcg_allergy', 
//             'is_high_risk', 
//             'beneficiary_type', 
//             'bcg_willing', 
//             'reason_for_not_willing', 
//             'nikshay_id',
//             'bcg_eligible', 
//             'other_reason_if_any',
//             'height', 
//             'weight', 
//             'bmi',  
//             'bcgId'
//         ];

//         bcgForm.init = function() {
//             Mask.show();
//             AuthenticateService.getLoggedInUser().then(function (user) {
//                 bcgForm.userId = user.data.id;

//                 let queryDto;
//                 queryDto = {
//                     code: 'bcg_fetch_member_for_survey_form',
//                     parameters: {
//                         member_id : parseInt($state.params.memberId)
//                     }
//                 };
//                 Mask.show();
//                 QueryDAO.execute(queryDto).then(function (res) {
//                     bcgForm.memberDetails = res.result[0];
//                 }, function (err) {
//                     GeneralUtil.showMessageOnApiCallFailure(err);
//                 }).finally(function () {
//                     Mask.hide();
//                 });

//             }).catch(function (error) {
//                 GeneralUtil.showMessageOnApiCallFailure(error);
//             }).finally(function () {
//                 Mask.hide();
//             });

//         }

//         bcgForm.goBack = function() {
//             $state.go("techo.manage.bcgsurveyform");
//         }

//         bcgForm.setBeneficiaryType = function(beneficiaryType) {
//             if (!bcgForm.beneficiaries.includes(beneficiaryType)){
//                 if (beneficiaryType !== 'NONE') {
//                     bcgForm.memberIsInAnyBeneficiary = true;
//                 }
//                 bcgForm.beneficiaries.push(beneficiaryType);
//                 bcgForm.beneficiary_type = true;
//             } else {
//                 bcgForm.deleteStringFromArray(bcgForm.beneficiaries, beneficiaryType)
//             }
//             bcgForm.deleteStringFromArray(bcgForm.beneficiaries, 'NONE')
//             bcgForm.bcgSurveyForm.NONE = false;
//         }

//         bcgForm.noneBeneficiaryType = function() {
//             bcgForm.bcgSurveyForm.NONE = true;
//             bcgForm.bcgSurveyForm.TB_LAST_5_YR = false;
//             bcgForm.bcgSurveyForm.TB_CONTACT_LAST_3_YR = false;
//             bcgForm.bcgSurveyForm.GT_60_YR_POPULATION = false;
//             bcgForm.bcgSurveyForm.SELF_REPORTED_SMOKER = false;
//             bcgForm.bcgSurveyForm.SELF_REPORTED_DIABETES = false;

//             bcgForm.beneficiaries = [];

//             bcgForm.memberIsInAnyBeneficiary = false;

//             if (!bcgForm.beneficiaries.includes('NONE')){
//                 bcgForm.beneficiaries.push('NONE');
//                 bcgForm.beneficiary_type = true;
//             } else {
//                 bcgForm.deleteStringFromArray(bcgForm.beneficiaries, 'NONE')
//             }
//         }

//         bcgForm.setBmi = function(height, weight){
//             if (!height || height=='' || height==undefined) {
//                 height = 0;
//             }if (!weight || weight=='' || weight==undefined) {
//                 weight = 0;
//             }
//             if (height > 0 && weight > 0) {
//                 bcgForm.bmi = (weight)/((height/100)*(height/100));
//             }
//             if(bcgForm.bmi == NaN || bcgForm.bmi == Infinity) {
//                 bcgForm.bmi = 0;
//             }
//         }

//         bcgForm.deleteStringFromArray = function(array, stringToDelete) {
//             var index = array.indexOf(stringToDelete);
//             if (index !== -1) {
//                 array.splice(index, 1);
//             }
//         }

//         bcgForm.isFormValid = false;
        
//         bcgForm.reminderModal = function (modalMessage) {
//             var modalInstance = $uibModal.open({
//                 templateUrl: 'app/common/views/confirmation.modal.html',
//                 controller: 'ConfirmModalController',
//                 windowClass: 'cst-modal',
//                 size: 'med',
//                 resolve: {
//                     message: function () {
//                         return modalMessage;
//                     }
//                 }
//             });
//             modalInstance.result.then(function () {
//                 let bcgWebFormDto = {
//                     memberId : parseInt($state.params.memberId),
//                     tbTreatment : bcgForm.parameters.tb_treatment,
//                     tbPreventTherapy : bcgForm.parameters.tb_prevent_therapy,
//                     tbDiagnosed : bcgForm.parameters.tb_diagnosed,
//                     coughForTwoWeeks : bcgForm.parameters.cough_for_two_weeks,
//                     feverForTwoWeeks : bcgForm.parameters.fever_for_two_weeks,
//                     significantWeightLoss : bcgForm.parameters.significant_weight_loss,
//                     bloodInSputum : bcgForm.parameters.blood_in_sputum,
//                     consentUnavailable : bcgForm.parameters.consent_unavailable,
//                     bedRidden : bcgForm.parameters.bed_ridden,
//                     isPregnant : bcgForm.parameters.is_pregnant,
//                     isHiv : bcgForm.parameters.is_hiv,
//                     isCancer : bcgForm.parameters.is_cancer,
//                     onMedication : bcgForm.parameters.on_medication,
//                     organTransplant : bcgForm.parameters.organ_transplant,
//                     bloodTransfusion : bcgForm.parameters.blood_transfusion,
//                     bcgAllergy : bcgForm.parameters.bcg_allergy,
//                     isHighRisk : bcgForm.parameters.is_high_risk,
//                     beneficiaryType : bcgForm.parameters.beneficiary_type,
//                     bcgWilling : bcgForm.parameters.bcg_willing,
//                     reasonForNotWilling : bcgForm.parameters.reason_for_not_willing,
//                     nikshayId : bcgForm.parameters.nikshay_id,
//                     hic : null,
//                     bcgEligible : bcgForm.parameters.bcg_eligible,
//                     height : bcgForm.parameters.height,
//                     weight : bcgForm.parameters.weight,
//                     bmi : bcgForm.parameters.bmi,
//                     filledFrom : 'BCG_WEB',
//                     userId : bcgForm.userId,
//                     memberId: parseInt($state.params.memberId),
//                     other_reason : bcgForm.parameters.other_reason_if_any
//                 }

//                 Mask.show();
//                 BcgSurveyService.storeBcgFormWeb(bcgWebFormDto).then(function (res) {
//                     toaster.pop('success', 'BCG Survey Form Data Saved Successfully');
//                     $state.go("techo.manage.bcgsurveyform");
//                 }, function (err) {
//                     GeneralUtil.showMessageOnApiCallFailure(err);
//                 }).finally(function () {
//                     Mask.hide();
//                 });

//             }, function () {
//             });
//         };


//         bcgForm.validateNikshayId = function() {
//             var defer = $q.defer();
//             if (bcgForm.bcgSurveyForm.nikshay_id && bcgForm.bcgSurveyForm.nikshay_id !== '') {
//                 return BcgSurveyService.isNikshayIdAvailable(bcgForm.bcgSurveyForm.nikshay_id).then(function (res) {
//                     bcgForm.checkNikshayId = res.result;
//                     if(bcgForm.checkNikshayId === 'false') {
//                         bcgForm.bcgSurveyFormManage.nikshay_id.$setValidity('nikshayduplicate', false);
//                     } else {
//                         bcgForm.bcgSurveyFormManage.nikshay_id.$setValidity('nikshayduplicate', true);
//                     }
//                 }).finally(function () {
//                 });
//             } else {
//                 defer.reject();
//                 return defer.promise;
//             }
//         }

//         bcgForm.saveBcgData = function() {
//             bcgForm.bcgSurveyFormManage.$setSubmitted();
//             bcgForm.uiFields = [];

//             for (let i = 0; i < bcgForm.bcgSurveyFormManage.$$controls.length; i++) {
//                 bcgForm.uiFields.push(bcgForm.bcgSurveyFormManage.$$controls[i].$name);
//             }


//             for (const property in bcgForm.bcgSurveyForm) {
//                 if (bcgForm.parameterList.includes(property) && !bcgForm.uiFields.includes(property)){
//                     bcgForm.bcgSurveyForm[property] = null;
//                 }
//             }

//             if(bcgForm.bcgSurveyFormManage.$valid && (bcgForm.bcgSurveyForm.tb_treatment === true || bcgForm.bcgSurveyForm.tb_prevent_therapy === true ? bcgForm.checkNikshayId === 'true' : bcgForm.checkNikshayId === 'true' || bcgForm.bcgSurveyFormManage.$valid) && (bcgForm.bcgSurveyForm.is_high_risk === false ? bcgForm.beneficiaries.length > 0 : true)) {
//                 bcgForm.bcg_eligible = true;

//                 bcgForm.beneficiary_type = bcgForm.beneficiaries.join(',')


//                 if (bcgForm.bcgSurveyForm.tb_treatment ||
//                     bcgForm.bcgSurveyForm.tb_prevent_therapy ||
//                     bcgForm.bcgSurveyForm.tb_diagnosed ||
//                     bcgForm.bcgSurveyForm.cough_for_two_weeks ||
//                     bcgForm.bcgSurveyForm.fever_for_two_weeks ||
//                     bcgForm.bcgSurveyForm.significant_weight_loss ||
//                     bcgForm.bcgSurveyForm.blood_in_sputum ||
//                     bcgForm.bcgSurveyForm.consent_unavailable ||
//                     bcgForm.bcgSurveyForm.bed_ridden ||
//                     bcgForm.bcgSurveyForm.is_pregnant ||
//                     bcgForm.bcgSurveyForm.is_hiv || 
//                     bcgForm.bcgSurveyForm.is_cancer ||
//                     bcgForm.bcgSurveyForm.on_medication ||
//                     bcgForm.bcgSurveyForm.organ_transplant ||
//                     bcgForm.bcgSurveyForm.bcg_allergy ||
//                     bcgForm.bcgSurveyForm.is_high_risk ||
//                     (bcgForm.memberIsInAnyBeneficiary == false && bcgForm.bmi > 18)
//                     ) {
//                         bcgForm.bcg_eligible = false;
//                 }


//                 bcgForm.parameters = {
//                     tb_treatment : bcgForm.bcgSurveyForm.tb_treatment === true || bcgForm.bcgSurveyForm.tb_treatment === false ? bcgForm.bcgSurveyForm.tb_treatment : null , 
//                     tb_prevent_therapy : bcgForm.bcgSurveyForm.tb_prevent_therapy === true || bcgForm.bcgSurveyForm.tb_prevent_therapy === false ? bcgForm.bcgSurveyForm.tb_prevent_therapy : null , 
//                     tb_diagnosed : bcgForm.bcgSurveyForm.tb_diagnosed === true || bcgForm.bcgSurveyForm.tb_diagnosed === false ? bcgForm.bcgSurveyForm.tb_diagnosed : null , 
//                     cough_for_two_weeks : bcgForm.bcgSurveyForm.cough_for_two_weeks === true || bcgForm.bcgSurveyForm.cough_for_two_weeks === false ? bcgForm.bcgSurveyForm.cough_for_two_weeks : null , 
//                     fever_for_two_weeks : bcgForm.bcgSurveyForm.fever_for_two_weeks === true || bcgForm.bcgSurveyForm.fever_for_two_weeks === false ? bcgForm.bcgSurveyForm.fever_for_two_weeks : null , 
//                     significant_weight_loss : bcgForm.bcgSurveyForm.significant_weight_loss === true || bcgForm.bcgSurveyForm.significant_weight_loss === false ? bcgForm.bcgSurveyForm.significant_weight_loss : null , 
//                     blood_in_sputum : bcgForm.bcgSurveyForm.blood_in_sputum === true || bcgForm.bcgSurveyForm.blood_in_sputum === false ? bcgForm.bcgSurveyForm.blood_in_sputum : null , 
//                     consent_unavailable : bcgForm.bcgSurveyForm.consent_unavailable === true || bcgForm.bcgSurveyForm.consent_unavailable === false ? bcgForm.bcgSurveyForm.consent_unavailable : null , 
//                     bed_ridden : bcgForm.bcgSurveyForm.bed_ridden === true || bcgForm.bcgSurveyForm.bed_ridden === false ? bcgForm.bcgSurveyForm.bed_ridden : null , 
//                     is_pregnant : bcgForm.bcgSurveyForm.is_pregnant === true || bcgForm.bcgSurveyForm.is_pregnant === false ? bcgForm.bcgSurveyForm.is_pregnant : null , 
//                     is_hiv : bcgForm.bcgSurveyForm.is_hiv === true || bcgForm.bcgSurveyForm.is_hiv === false ? bcgForm.bcgSurveyForm.is_hiv : null , 
//                     is_cancer : bcgForm.bcgSurveyForm.is_cancer === true || bcgForm.bcgSurveyForm.is_cancer === false ? bcgForm.bcgSurveyForm.is_cancer : null , 
//                     on_medication : bcgForm.bcgSurveyForm.on_medication === true || bcgForm.bcgSurveyForm.on_medication === false ? bcgForm.bcgSurveyForm.on_medication : null , 
//                     organ_transplant : bcgForm.bcgSurveyForm.organ_transplant === true || bcgForm.bcgSurveyForm.organ_transplant === false ? bcgForm.bcgSurveyForm.organ_transplant : null , 
//                     blood_transfusion : bcgForm.bcgSurveyForm.blood_transfusion === true || bcgForm.bcgSurveyForm.blood_transfusion === false ? bcgForm.bcgSurveyForm.blood_transfusion : null , 
//                     bcg_allergy : bcgForm.bcgSurveyForm.bcg_allergy === true || bcgForm.bcgSurveyForm.bcg_allergy === false ? bcgForm.bcgSurveyForm.bcg_allergy : null , 
//                     is_high_risk : bcgForm.bcgSurveyForm.is_high_risk === true || bcgForm.bcgSurveyForm.is_high_risk === false ? bcgForm.bcgSurveyForm.is_high_risk : null , 
//                     beneficiary_type : bcgForm.beneficiary_type , 
//                     bcg_willing : bcgForm.bcgSurveyForm.bcg_willing === true || bcgForm.bcgSurveyForm.bcg_willing === false ? bcgForm.bcgSurveyForm.bcg_willing : null , 
//                     reason_for_not_willing : bcgForm.bcgSurveyForm.reason_for_not_willing?.length > 0 ? bcgForm.bcgSurveyForm.reason_for_not_willing : null , 
//                     nikshay_id : bcgForm.bcgSurveyForm.nikshay_id?.length > 0 ? bcgForm.bcgSurveyForm.nikshay_id : null ,
//                     bcg_eligible : bcgForm.bcg_eligible , 
//                     height : bcgForm.bcgSurveyForm.height > 0 ? bcgForm.bcgSurveyForm.height : null , 
//                     weight : bcgForm.bcgSurveyForm.weight > 0 ? bcgForm.bcgSurveyForm.weight : null , 
//                     bmi : bcgForm.bmi > 0 ? bcgForm.bmi : null , 
//                     filled_from : 'BCG_WEB',
//                     other_reason_if_any : bcgForm.bcgSurveyForm.other_reason_if_any?.length > 0 ? bcgForm.bcgSurveyForm.other_reason_if_any : null
//                 }

//                 if (bcgForm.parameters.weight === null || bcgForm.parameters.weight === null) {
//                     bcgForm.parameters.bmi = null;
//                     bcgForm.bmi = null;
//                 }


//                 bcgForm.modalOpened = false;

//                 for (const property in bcgForm.parameters) {


//                     if(property === 'bmi') {
//                         if (bcgForm.parameters[property] > 18 && bcgForm.memberIsInAnyBeneficiary == false) {
//                             bcgForm.modalOpened = true;
//                             bcgForm.reminderModal(`Member is excluded because BMI is > 18`);
//                             break;
//                         }
//                     }


//                     if (bcgForm.parameters[property] === true && bcgForm.parameters[property] !== null && property !== 'bcg_willing' && property !== 'bcg_eligible') {
//                         switch(property) {
//                             case 'tb_treatment':
//                                 bcgForm.modalOpened = true;
//                                 bcgForm.reminderModal(`Member is excluded because he/she is "On Tuberculosis treatment"`);
//                             break;
//                             case 'tb_prevent_therapy':
//                                 bcgForm.modalOpened = true;
//                                 bcgForm.reminderModal(`Member is excluded because he/she is "On Tuberculosis Preventive Therapy"`);
//                             break;
//                             case 'tb_diagnosed':
//                                 bcgForm.modalOpened = true;
//                                 bcgForm.reminderModal(`Member is excluded because he/she is "Known Case of TB". Refer to PHC`);
//                             break;
//                             case 'cough_for_two_weeks':
//                                 bcgForm.modalOpened = true;
//                                 bcgForm.reminderModal(`Member is excluded because he/she is "Suspected case of TB". Refer to PHC`);
//                             break;
//                             case 'fever_for_two_weeks':
//                                 bcgForm.modalOpened = true;
//                                 bcgForm.reminderModal(`Member is excluded because he/she is "Suspected case of TB". Refer to PHC`);
//                             break;
//                             case 'significant_weight_loss':
//                                 bcgForm.modalOpened = true;
//                                 bcgForm.reminderModal(`Member is excluded because he/she is "Suspected case of TB". Refer to PHC`);
//                             break;
//                             case 'blood_in_sputum':
//                                 bcgForm.modalOpened = true;
//                                 bcgForm.reminderModal(`Member is excluded because he/she is "Suspected case of TB". Refer to PHC`);
//                             break;
//                             case 'consent_unavailable':
//                                 bcgForm.modalOpened = true;
//                                 bcgForm.reminderModal(`Member is excluded because he/she is "Unable to give consent"`);
//                             break;
//                             case 'bed_ridden':
//                                 bcgForm.modalOpened = true;
//                                 bcgForm.reminderModal(`Member is excluded because he/she is "seriously ill/bed ridden"`);
//                             break;
//                             case 'is_pregnant':
//                                 bcgForm.modalOpened = true;
//                                 bcgForm.reminderModal(`Member is excluded because he/she is "currently pregnant/lactating"`);
//                             break;
//                             case 'is_hiv':
//                                 bcgForm.modalOpened = true;
//                                 bcgForm.reminderModal(`Member is excluded because he/she is "known case of HIV"`);
//                             break;
//                             case 'is_cancer':
//                                 bcgForm.modalOpened = true;
//                                 bcgForm.reminderModal(`Member is excluded because he/she is "known case of Cancer"`);
//                             break;
//                             case 'on_medication':
//                                 bcgForm.modalOpened = true;
//                                 bcgForm.reminderModal(`Member is excluded because he/she is "On immunosuppresent medications"`);
//                             break;
//                             case 'organ_transplant':
//                                 bcgForm.modalOpened = true;
//                                 bcgForm.reminderModal(`Member is excluded because he/she is "case of organ transplant"`);
//                             break;
//                             case 'blood_transfusion':
//                                 bcgForm.modalOpened = true;
//                                 bcgForm.reminderModal(`Member is excluded because he/she is "Recieved Blood transfusion in last 3 months"`);
//                             break;
//                             case 'bcg_allergy':
//                                 bcgForm.modalOpened = true;
//                                 bcgForm.reminderModal(`Member is excluded because he/she is "Allergic to BCG vaccine"`);
//                             break;
//                             case 'is_high_risk':
//                                 bcgForm.modalOpened = true;
//                                 bcgForm.reminderModal(`Member is excluded because he/she is "Belongs to High Risk Group"`);
//                             break;
//                             default:
//                                 bcgForm.modalOpened = true;
//                                 bcgForm.reminderModal(`Submit Form?`);
//                         }
//                     }
//                 }
//                 if (!bcgForm.modalOpened){
//                     bcgForm.reminderModal(`Submit Form?`);
//                 }
//             } else {
//                 if(bcgForm.bcgSurveyForm.is_high_risk === false && bcgForm.beneficiaries.length == 0){
//                     toaster.pop('error', 'Please enter beneficiary!');
//                 }
//             }
//         }


//         bcgForm.init();
//     }
//     angular.module('imtecho.controllers').controller('BcgSurveyFillForm', BcgSurveyFillForm);
// })();