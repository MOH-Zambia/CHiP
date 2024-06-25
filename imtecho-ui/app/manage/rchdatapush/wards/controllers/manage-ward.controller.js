// (function () {
//     function ManageWardController($state, QueryDAO, Mask, toaster, GeneralUtil, AuthenticateService, LocationService, $q) {
//         let ctrl = this;

//         let _init = function () {
//             ctrl.ward = {
//                 wardName: '',
//                 wardNameEnglish: '',
//                 lgdCode: '',
//                 locationId: null
//             };
//             ctrl.selectedUPHCs = [];
//             ctrl.editMode = false;
//             ctrl.wardId = $state.params.id ? Number($state.params.id) : null;
//             ctrl.isLgdCodeUnique = true;
//             if (ctrl.wardId) {
//                 ctrl.editMode = true;
//             }
//             if (ctrl.editMode) {
//                 let dtoList = [];
//                 let wardById = {
//                     code: 'loaction_ward_retrieval_by_id',
//                     parameters: {
//                         id: ctrl.wardId
//                     },
//                     sequence: 1
//                 }
//                 dtoList.push(wardById);
//                 Mask.show();
//                 QueryDAO.executeAll(dtoList).then(function (res) {
//                     ctrl.ward = res[0].result[0];
//                     try {
//                         ctrl.ward.assignedUPHCs = ctrl.ward.assignedUPHCs ? JSON.parse(ctrl.ward.assignedUPHCs) : [];
//                     } catch (error) {
//                         console.log('Error while parsing assignedUPHCs JSON :: ', error);
//                         ctrl.ward.assignedUPHCs = [];
//                     }
//                     AuthenticateService.getLoggedInUser().then(function (user) {
//                         ctrl.loggedInUser = user.data;
//                     }, function () { }).finally(function () {
//                         Mask.hide();
//                     })
//                 }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
//                     Mask.hide();
//                 });
//             } else {
//                 Mask.show();
//                 AuthenticateService.getLoggedInUser().then(function (res) {
//                     ctrl.loggedInUser = res.data;
//                 }, function () { }).finally(function () {
//                     Mask.hide();
//                 });
//             }
//         };

//         ctrl.save = function () {
//             if (ctrl.manageWardForm.$valid) {
//                 if (ctrl.editMode) {
//                     let payload = {
//                         id: ctrl.wardId,
//                         wardName: ctrl.ward.wardName,
//                         wardNameEnglish: ctrl.ward.wardNameEnglish,
//                         lgdCode: ctrl.ward.lgdCode,
//                         locationId: ctrl.updateLocation ? ctrl.selectedLocationId : ctrl.ward.locationId,
//                     }
//                     Mask.show();
//                     QueryDAO.execute({
//                         code: 'location_ward_retrieval_by_lgd_code',
//                         parameters: {
//                             id: ctrl.wardId,
//                             lgdCode: ctrl.ward.lgdCode
//                         }
//                     }).then(function (res) {
//                         if (res.result && res.result.length > 0) {
//                             ctrl.isLgdCodeUnique = false;
//                             Mask.hide();
//                         } else {
//                             ctrl.isLgdCodeUnique = true;
//                             let promises = [];
//                             promises.push(QueryDAO.execute({
//                                 code: 'location_ward_update',
//                                 parameters: payload
//                             }));
//                             if (ctrl.updateLocation) {
//                                 let payloadForUphcs = [];
//                                 ctrl.selectedUPHCs.forEach(uphcId =>
//                                     payloadForUphcs.push({
//                                         wardId: ctrl.wardId,
//                                         locationId: uphcId
//                                     })
//                                 );
//                                 promises.push(LocationService.createOrUpdateWardUPHCs(ctrl.wardId, payloadForUphcs));
//                             }
//                             $q.all(promises).then(function () {
//                                 toaster.pop('success', 'Ward Updated Successfully!')
//                                 $state.go('techo.manage.wards');
//                             }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
//                                 Mask.hide();
//                             });
//                         }
//                     }, function () {
//                         GeneralUtil.showMessageOnApiCallFailure();
//                         Mask.hide();
//                     })
//                 } else {
//                     let payload = {
//                         wardName: ctrl.ward.wardName,
//                         wardNameEnglish: ctrl.ward.wardNameEnglish,
//                         lgdCode: ctrl.ward.lgdCode,
//                         locationId: ctrl.selectedLocationId,
//                     }
//                     Mask.show();
//                     QueryDAO.execute({
//                         code: 'location_ward_retrieval_by_lgd_code',
//                         parameters: {
//                             id: 0,
//                             lgdCode: ctrl.ward.lgdCode
//                         }
//                     }).then(function (res) {
//                         if (res.result && res.result.length > 0) {
//                             ctrl.isLgdCodeUnique = false;
//                             Mask.hide();
//                         } else {
//                             ctrl.isLgdCodeUnique = true;
//                             QueryDAO.execute({
//                                 code: 'location_ward_create',
//                                 parameters: payload
//                             }).then(function (wardRes) {
//                                 let newWardId = wardRes.result[0].id;
//                                 let payloadForUphcs = [];
//                                 ctrl.selectedUPHCs.forEach(uphcId =>
//                                     payloadForUphcs.push({
//                                         wardId: newWardId,
//                                         locationId: uphcId
//                                     })
//                                 );
//                                 LocationService.createOrUpdateWardUPHCs(null, payloadForUphcs)
//                                     .then(function () {
//                                         toaster.pop('success', 'Ward Created Successfully!')
//                                         $state.go('techo.manage.wards');
//                                     }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
//                                         Mask.hide();
//                                     });
//                             }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
//                                 Mask.hide();
//                             });
//                         }
//                     }, function () {
//                         GeneralUtil.showMessageOnApiCallFailure();
//                         Mask.hide();
//                     })
//                 }
//             }
//         };

//         ctrl.fetchUPHCs = function () {
//             let selectedParentId = null;
//             ctrl.districtLevelUPHCs = [];
//             if (ctrl.selectedLocation && ctrl.selectedLocation.finalSelected && ctrl.selectedLocation.finalSelected.level == 3 && ctrl.selectedLocation.finalSelected.optionSelected) {
//                 selectedParentId = ctrl.selectedLocation.finalSelected.optionSelected.id
//                 Mask.show();
//                 QueryDAO.execute({
//                     code: 'loaction_ward_uphc_retrieval',
//                     parameters: {
//                         level: 5,
//                         parentId: selectedParentId,
//                         locationType: 'U',
//                         wardId: ctrl.wardId || 0
//                     }
//                 }).then(function (res) {
//                     ctrl.districtLevelUPHCs = res.result;
//                 }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
//                     Mask.hide();
//                 });
//             }
//         }

//         _init();
//     }
//     angular.module('imtecho.controllers').controller('ManageWardController', ManageWardController);
// })();
