// (function () {
//     function ManageSevereAnemiaController(NcdDAO, GeneralUtil, $state, toaster, Mask, QueryDAO, AuthenticateService, ManageSevereAnemiaDAO) {
//         var manageSevereAnemiaCtrl = this;
//         manageSevereAnemiaCtrl.isAnaemia = false;
//         manageSevereAnemiaCtrl.today = new Date();
//         manageSevereAnemiaCtrl.minDate = new Date('2023-12-01');
//         manageSevereAnemiaCtrl.showPregnancyFields = false;
        
//         AuthenticateService.getLoggedInUser().then(function(user){
//             manageSevereAnemiaCtrl.user = user;
//         })
        
//         manageSevereAnemiaCtrl.getMemberDetails = function () {
//             QueryDAO.execute({
//                 code: 'retrival_listvalue_values_acc_field',
//                 parameters: {
//                     fieldKey:'high_risk_reasons'
//                 }
//             }).then((response)=>{
//                 if(response){
//                     manageSevereAnemiaCtrl.otherHighRisks = response.result; 
//                 }
//             })
//             QueryDAO.execute({
//                 code: 'retrival_listvalue_values_acc_field',
//                 parameters: {
//                     fieldKey:'anemia_causes'
//                 }
//             }).then((response)=>{
//                 if(response){
//                     manageSevereAnemiaCtrl.anemiaCauses = response.result;
//                     manageSevereAnemiaCtrl.anemiaCauses.push({id:'OTHER',value:'Other'})
//                 }
//             })
//             manageSevereAnemiaCtrl.startDate = moment().format("YYYY-MM-DDTHH:mm:ss.SSSZ")
//             if ($state.params.id && $state.params.id != '') {
//                 manageSevereAnemiaCtrl.notifId = Number($state.params.id);
//                 Mask.show();
//                 QueryDAO.execute({
//                     code: 'retrieve_severe_anemic_member_det',
//                     parameters: {
//                         notifId: manageSevereAnemiaCtrl.notifId
//                     }
//                 }).then(function (response) {
//                     if (response != null && response.result != null && response.result.length > 0) {
//                         manageSevereAnemiaCtrl.memberDetails = response.result[0];
//                         if (manageSevereAnemiaCtrl.memberDetails.gender == 'F'
//                             && manageSevereAnemiaCtrl.memberDetails.age_in_years >= 15) {
//                                 manageSevereAnemiaCtrl.showPregnancyFields = true;
//                             }
//                     QueryDAO.execute({
//                         code: 'retrieve_previous_anemia_survey_det',
//                         parameters: {
//                             memberId: manageSevereAnemiaCtrl.memberDetails.id
//                         }
//                     }).then(function (response) {
//                         if (response != null && response.result != null && response.result.length > 0) {
//                             manageSevereAnemiaCtrl.previousAnemiaSurveyInfo = response.result;
//                             let prevServiceDate = response.result[0].serviceDate;
//                             if (moment(prevServiceDate).isAfter(manageSevereAnemiaCtrl.minDate))
//                             manageSevereAnemiaCtrl.minServiceDate = moment(prevServiceDate).add(1,'day');
//                             else
//                             manageSevereAnemiaCtrl.minServiceDate = manageSevereAnemiaCtrl.minDate;
//                         }
//                     })    
//                     }
//                 }).finally(function () {
//                     Mask.hide();
//                 })
//             } else {
//                 toaster.pop('error', 'Member Not found. Please try again');
//                 $state.go('techo.dashboard.webtasks');
//             }
//         }

//         manageSevereAnemiaCtrl.save = function () {
//             let anemiaSurveyDetailsDto = {
//                 memberId: manageSevereAnemiaCtrl.memberDetails.id,
//                 familyId: manageSevereAnemiaCtrl.memberDetails.fid,
//                 locationId: manageSevereAnemiaCtrl.memberDetails.areaId ? manageSevereAnemiaCtrl.memberDetails.areaId : manageSevereAnemiaCtrl.memberDetails.locationId,
//                 serviceDate: manageSevereAnemiaCtrl.formDate ? moment(manageSevereAnemiaCtrl.formDate).format("YYYY-MM-DD") : null,
//                 lmpDate: manageSevereAnemiaCtrl.memberDetails.lmpDate ? manageSevereAnemiaCtrl.memberDetails.lmpDate : null,
//                 haemoglobin: manageSevereAnemiaCtrl.haemoglobin ? manageSevereAnemiaCtrl.haemoglobin : null,
//                 doneFrom: manageSevereAnemiaCtrl.user.data.roleName,
//                 notificationId: manageSevereAnemiaCtrl.notifId,
//                 isPregnantFlag: manageSevereAnemiaCtrl.memberDetails.isPregnantFlag,
//                 isLactating: manageSevereAnemiaCtrl.memberDetails.isLactating,
//                 ironDefAnemiaInj: manageSevereAnemiaCtrl.ironDefAnemiaInj,
//                 ironDefInjGivenDate: manageSevereAnemiaCtrl.ironDefInjDate ? moment(manageSevereAnemiaCtrl.ironDefInjDate).format("YYYY-MM-DD") : null,
//                 bloodTransfusion: manageSevereAnemiaCtrl.isBloodTransfusion,
//                 treatmentFacilityType: manageSevereAnemiaCtrl.referralInfraDetails.institutionType,
//                 treatmentFacility: manageSevereAnemiaCtrl.referralInfraDetails.institute,
//                 otherAnemiaCause: manageSevereAnemiaCtrl.otherAnemiaCause ? manageSevereAnemiaCtrl.otherAnemiaCause : null
//             }
//             if (!!manageSevereAnemiaCtrl.selectedHighRisks && manageSevereAnemiaCtrl.selectedHighRisks.length > 0) {
//                 anemiaSurveyDetailsDto.highRiskName = manageSevereAnemiaCtrl.selectedHighRisks;
//             }
//             if (!!manageSevereAnemiaCtrl.causeOfAnemia && manageSevereAnemiaCtrl.causeOfAnemia.length > 0) {
//                 anemiaSurveyDetailsDto.anemiaCause = manageSevereAnemiaCtrl.causeOfAnemia;
//             }
//             manageSevereAnemiaCtrl.isPregnant = manageSevereAnemiaCtrl.memberDetails.isPregnantFlag ? manageSevereAnemiaCtrl.memberDetails.isPregnantFlag : false;
//             ManageSevereAnemiaDAO.retrieveAnemiaStatus(manageSevereAnemiaCtrl.memberDetails.gender, manageSevereAnemiaCtrl.haemoglobin,
//                 manageSevereAnemiaCtrl.memberDetails.dob, manageSevereAnemiaCtrl.isPregnant).then(function(response){
//                     Mask.hide();
//                     anemiaSurveyDetailsDto.anemiaStatus = response.anemiaStatus;
//                     if (manageSevereAnemiaCtrl.highRiskForm.$valid) {
//                         Mask.show();
//                         ManageSevereAnemiaDAO.storeAnemiaSurveyDetails(anemiaSurveyDetailsDto).then(function (response) {
//                             Mask.hide();
//                             toaster.pop('success', 'Member anemia survey form filled successfully');
//                             $state.go('techo.dashboard.webtasks');
//                         }, GeneralUtil.showMessageOnApiCallFailure).then(function () {
//                             Mask.hide();
//                             $state.go('techo.dashboard.webtasks');
//                         });
//                     }
//                 })
//         }
//         manageSevereAnemiaCtrl.getMemberDetails();
//     }
//     angular.module('imtecho.controllers').controller('ManageSevereAnemiaController', ManageSevereAnemiaController);
// })();
