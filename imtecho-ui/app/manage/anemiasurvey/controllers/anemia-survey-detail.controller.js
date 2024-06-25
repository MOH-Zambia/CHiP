// (function () {
//     function AnemiaSurveyDetailController($state, toaster, AnemiaSurveyDAO, $uibModal, $stateParams, PagingForQueryBuilderService, GeneralUtil, AuthenticateService, QueryDAO, Mask) {
//         var ctrl = this;
//         ctrl.approvedData = {};
//         ctrl.Anemia_Conjunctiva = null;
//         ctrl.Anemia_External_Left_Eye = null;
//         ctrl.Anemia_External_Right_Eye = null;
//         ctrl.Anemia_Fingernails_Closed = null;
//         ctrl.Anemia_Fingernails_Open = null;
//         ctrl.Anemia_Tongue = null;
//         ctrl.selectAnemia_Conjunctiva = true;
//         ctrl.selectAnemia_External_Left_Eye = true;
//         ctrl.selectAnemia_External_Right_Eye = true;
//         ctrl.selectAnemia_Fingernails_Closed = true;
//         ctrl.selectAnemia_Fingernails_Open = true;
//         ctrl.selectAnemia_Tongue = true;

//         ctrl.isApprovable = false;

//         var init = function () {
//             Mask.show();
//             AuthenticateService.getLoggedInUser().then(function (res) {
//                 ctrl.user = res.data;
//                 if ($state.params.id) {
//                     ctrl.anemiaSurveyId = $state.params.id;
//                     ctrl.getAnemiaSurveyDetailsById(ctrl.anemiaSurveyId);
//                 }
//             }).finally(function () {
//                 Mask.hide();
//             });

//         }

//         ctrl.getAnemiaSurveyDetailsById = (id) => {
//             ctrl.selectAnemia_Conjunctiva = true;
//             ctrl.selectAnemia_External_Left_Eye = true;
//             ctrl.selectAnemia_External_Right_Eye = true;
//             ctrl.selectAnemia_Fingernails_Closed = true;
//             ctrl.selectAnemia_Fingernails_Open = true;
//             ctrl.selectAnemia_Tongue = true;
//             var queryDto = {
//                 code: 'get_anemia_survey_details_by_anemia_survey_id',
//                 parameters: {
//                     anemiaSurveyId: Number(id)
//                 }
//             };

//             QueryDAO.execute(queryDto).then(function (res) {
//                 if (res?.result.length > 0) {
//                     ctrl.anemiaSurveyDetail = res.result[0];
//                     if (ctrl.anemiaSurveyDetail.is_anemia_conjunctiva_approved != null) {
//                         ctrl.selectAnemia_Conjunctiva = ctrl.anemiaSurveyDetail.is_anemia_conjunctiva_approved;
//                     } else if (ctrl.anemiaSurveyDetail.status == 'VERIFIED') {
//                         ctrl.selectAnemia_Conjunctiva = null
//                     }

//                     if (ctrl.anemiaSurveyDetail.is_anemia_external_left_eye_approved != null) {
//                         ctrl.selectAnemia_External_Left_Eye = ctrl.anemiaSurveyDetail.is_anemia_external_left_eye_approved;
//                     } else if (ctrl.anemiaSurveyDetail.status == 'VERIFIED') {
//                         ctrl.selectAnemia_External_Left_Eye = null
//                     }

//                     if (ctrl.anemiaSurveyDetail.is_anemia_external_right_eye_approved != null) {
//                         ctrl.selectAnemia_External_Right_Eye = ctrl.anemiaSurveyDetail.is_anemia_external_right_eye_approved;
//                     } else if (ctrl.anemiaSurveyDetail.status == 'VERIFIED') {
//                         ctrl.selectAnemia_External_Right_Eye = null
//                     }

//                     if (ctrl.anemiaSurveyDetail.is_anemia_fingernails_closed_approved != null) {
//                         ctrl.selectAnemia_Fingernails_Closed = ctrl.anemiaSurveyDetail.is_anemia_fingernails_closed_approved;
//                     } else if (ctrl.anemiaSurveyDetail.status == 'VERIFIED') {
//                         ctrl.selectAnemia_Fingernails_Closed = null
//                     }

//                     if (ctrl.anemiaSurveyDetail.is_anemia_fingernails_open_approved != null) {
//                         ctrl.selectAnemia_Fingernails_Open = ctrl.anemiaSurveyDetail.is_anemia_fingernails_open_approved;
//                     } else if (ctrl.anemiaSurveyDetail.status == 'VERIFIED') {
//                         ctrl.selectAnemia_Fingernails_Open = null
//                     }

//                     if (ctrl.anemiaSurveyDetail.is_anemia_tongue_approved != null) {
//                         ctrl.selectAnemia_Tongue = ctrl.anemiaSurveyDetail.is_anemia_tongue_approved;
//                     } else if (ctrl.anemiaSurveyDetail.status == 'VERIFIED') {
//                         ctrl.selectAnemia_Tongue = null
//                     }
//                     ctrl.examineImage(ctrl.anemiaSurveyDetail.uuid);
//                 } else {
//                     toaster.pop("error", "No Patient found with given Id.")
//                 }
//             }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
//             });
//         }

//         ctrl.getImages = (uuid) => {
//             if (uuid) {
//                 Mask.show();
//                 ctrl.Anemia_Conjunctiva = null;
//                 ctrl.Anemia_External_Left_Eye = null;
//                 ctrl.Anemia_External_Right_Eye = null;
//                 ctrl.Anemia_Fingernails_Closed = null;
//                 ctrl.Anemia_Fingernails_Open = null;
//                 ctrl.Anemia_Tongue = null;
//                 ctrl.isApprovable = false;
//                 AnemiaSurveyDAO.getImages(uuid).then(function (res) {
//                     ctrl.images = res.data;
//                     for (var key in ctrl.images) {
//                         if (key == 'Anemia_Conjunctiva') {
//                             ctrl.Anemia_Conjunctiva = 'data:image/jpeg;base64,' + ctrl.images[key][0];
//                             ctrl.isApprovable = true;
//                         } else if (key == 'Anemia_External_Left_Eye') {
//                             ctrl.Anemia_External_Left_Eye = 'data:image/jpeg;base64,' + ctrl.images[key][0];
//                             ctrl.isApprovable = true;
//                         } else if (key == 'Anemia_External_Right_Eye') {
//                             ctrl.Anemia_External_Right_Eye = 'data:image/jpeg;base64,' + ctrl.images[key][0];
//                             ctrl.isApprovable = true;
//                         } else if (key == 'Anemia_Fingernails_Closed') {
//                             ctrl.Anemia_Fingernails_Closed = 'data:image/jpeg;base64,' + ctrl.images[key][0];
//                             ctrl.isApprovable = true;
//                         } else if (key == 'Anemia_Fingernails_Open') {
//                             ctrl.Anemia_Fingernails_Open = 'data:image/jpeg;base64,' + ctrl.images[key][0];
//                             ctrl.isApprovable = true;
//                         } else if (key == 'Anemia_Tongue') {
//                             ctrl.Anemia_Tongue = 'data:image/jpeg;base64,' + ctrl.images[key][0];
//                             ctrl.isApprovable = true;
//                         }
//                     }
//                     if(ctrl.isApprovable == true){
//                         toaster.pop("success", "Images Fetched Successfully.")
//                     }
//                 }).catch((error) => {
//                     GeneralUtil.showMessageOnApiCallFailure(error.data);
//                 }).finally(function () {
//                     Mask.hide();
//                     if(ctrl.isApprovable == false){
//                         toaster.pop("error","No Images Available For this Member,Not Able to Approve.");
//                     }
//                 });
//             } else {
//                 toaster.pop("error", "This Member Does not have UUID,Please add UUID.");
//             }
//         }

//         ctrl.callApproveModal = function () {
//             const modalInstance = $uibModal.open({
//                 templateUrl: 'app/common/views/confirmation.modal.html',
//                 controller: 'ConfirmModalController',
//                 windowClass: 'cst-modal',
//                 size: 'med',
//                 resolve: {
//                     message: function () {
//                         return "If you have Discarded Images,All the Images Discarded will be Deleted.We won't be able to recover It. Are you sure you want to proceed?";
//                     }
//                 }
//             });
//             modalInstance.result.then(function () {
//                 ctrl.approveImages();
//             }, function () { });
//         }

//         ctrl.approveImages = () => {
//             Mask.show();
//             ctrl.approvedData = {};
//             ctrl.approvedData.uuid = ctrl.anemiaSurveyDetail.uuid;
//             ctrl.approvedData.anemia_survey_id = ctrl.anemiaSurveyDetail.id;
//             ctrl.approvedData.anemia_survey_member_id = ctrl.anemiaSurveyDetail.member_id;
//             ctrl.approvedData.verificationDate = new Date();

//             ctrl.approvedData.Anemia_Conjunctiva = null;
//             ctrl.approvedData.Anemia_External_Left_Eye = null;
//             ctrl.approvedData.Anemia_External_Right_Eye = null;
//             ctrl.approvedData.Anemia_Fingernails_Closed = null;
//             ctrl.approvedData.Anemia_Fingernails_Open = null;
//             ctrl.approvedData.Anemia_Tongue = null;

//             if (ctrl.Anemia_Conjunctiva) {
//                 ctrl.approvedData.Anemia_Conjunctiva = ctrl.selectAnemia_Conjunctiva;
//             }
//             if (ctrl.Anemia_External_Left_Eye) {
//                 ctrl.approvedData.Anemia_External_Left_Eye = ctrl.selectAnemia_External_Left_Eye;
//             }
//             if (ctrl.Anemia_External_Right_Eye) {
//                 ctrl.approvedData.Anemia_External_Right_Eye = ctrl.selectAnemia_External_Right_Eye;
//             }
//             if (ctrl.Anemia_Fingernails_Closed) {
//                 ctrl.approvedData.Anemia_Fingernails_Closed = ctrl.selectAnemia_Fingernails_Closed;
//             }
//             if (ctrl.Anemia_Fingernails_Open) {
//                 ctrl.approvedData.Anemia_Fingernails_Open = ctrl.selectAnemia_Fingernails_Open;
//             }
//             if (ctrl.Anemia_Tongue) {
//                 ctrl.approvedData.Anemia_Tongue = ctrl.selectAnemia_Tongue;
//             }

//             ctrl.folderList = [];
//             if (ctrl.Anemia_Conjunctiva && ctrl.approvedData.Anemia_Conjunctiva == false) {
//                 ctrl.folderList.push("Anemia_Conjunctiva");
//             }
//             if (ctrl.Anemia_External_Left_Eye && ctrl.approvedData.Anemia_External_Left_Eye == false) {
//                 ctrl.folderList.push("Anemia_External_Left_Eye");
//             }
//             if (ctrl.Anemia_External_Right_Eye && ctrl.approvedData.Anemia_External_Right_Eye == false) {
//                 ctrl.folderList.push("Anemia_External_Right_Eye");
//             }
//             if (ctrl.Anemia_Fingernails_Closed && ctrl.approvedData.Anemia_Fingernails_Closed == false) {
//                 ctrl.folderList.push("Anemia_Fingernails_Closed");
//             }
//             if (ctrl.Anemia_Fingernails_Open && ctrl.approvedData.Anemia_Fingernails_Open == false) {
//                 ctrl.folderList.push("Anemia_Fingernails_Open");
//             }
//             if (ctrl.Anemia_Tongue && ctrl.approvedData.Anemia_Tongue == false) {
//                 ctrl.folderList.push("Anemia_Tongue");
//             }
//             var queryDto = {
//                 code: 'insert_into_anemia_survey_verification_details',
//                 parameters: {
//                     anemiaSurveyId: ctrl.approvedData.anemia_survey_id,
//                     memberId: ctrl.approvedData.anemia_survey_member_id,
//                     verificationDate: ctrl.approvedData.verificationDate,
//                     isAnemiaConjunctivaApproved: ctrl.approvedData.Anemia_Conjunctiva,
//                     isAnemiaExternalLeftEyeApproved: ctrl.approvedData.Anemia_External_Left_Eye,
//                     isAnemiaExternalRightEyeApproved: ctrl.approvedData.Anemia_External_Right_Eye,
//                     isAnemiaFingernailsClosedApproved: ctrl.approvedData.Anemia_Fingernails_Closed,
//                     isAnemiaFingernailsOpenApproved: ctrl.approvedData.Anemia_Fingernails_Open,
//                     isAnemiaTongueApproved: ctrl.approvedData.Anemia_Tongue
//                 }
//             };
//             QueryDAO.execute(queryDto).then(function (res) {
//                 toaster.pop("success", "Approved Successfully!");
//                 if (ctrl.folderList.length > 0) {
//                     AnemiaSurveyDAO.deleteImages(ctrl.approvedData.uuid, ctrl.folderList).then(function (res) {
//                         toaster.pop('success', 'Images Deleted successfully!');
//                         $state.go("techo.manage.anemiasurveylist");
//                     }).catch((error) => {
//                         GeneralUtil.showMessageOnApiCallFailure(error.data);
//                     }).finally(function () {
//                         Mask.hide();
//                     });
//                 }else{
//                     Mask.hide();
//                     $state.go("techo.manage.anemiasurveylist");
//                 }
//             }).catch((error) => {
//                 GeneralUtil.showMessageOnApiCallFailure(error.data);
//             }).finally(function () {
//             });
//         }

//         ctrl.examineImage = (uuid) => {
//             if (uuid) {
//                 Mask.show();
//                 AnemiaSurveyDAO.examineImage(uuid).then(function (res) {
//                     // ctrl.getImages(uuid);
//                 }).catch((error) => {
//                     GeneralUtil.showMessageOnApiCallFailure(error.data);
//                 }).finally(function () {
//                     ctrl.getImages(uuid);
//                     Mask.hide();
//                 });
//             } else {
//                 toaster.pop("error", "Images Can't be exatracted because UUID is Unavailable.");
//             }

//         }

//         ctrl.downloadFile = (uuid) => {
//             if (uuid) {
//                 Mask.show();
//                 AnemiaSurveyDAO.downloadMultipleFolders(uuid).then(function (res) {
//                     toaster.pop('success', 'File downloaded successfully!');
//                     if (res.data !== null && navigator.msSaveBlob) {
//                         return navigator.msSaveBlob(new Blob([res.data], { type: "application/zip" }));
//                     }
//                     let a = $("<a style='display: none;'/>");
//                     let url = window.URL.createObjectURL(new Blob([res.data], { type: "application/zip" }));
//                     a.attr("href", url);
//                     a.attr("download", 'download.zip');
//                     $("body").append(a);
//                     a[0].click();
//                     window.URL.revokeObjectURL(url);
//                     a.remove();
//                 }).catch((error) => {
//                     GeneralUtil.showMessageOnApiCallFailure(error.data);
//                 }).finally(function () {
//                     Mask.hide();
//                 });

//             } else {
//                 toaster.pop("error", "This Member Does not have UUID,Please add UUID.");
//             }
//         }
//         init();

//     }
//     angular.module('imtecho.controllers').controller('AnemiaSurveyDetailController', AnemiaSurveyDetailController);
// })();
