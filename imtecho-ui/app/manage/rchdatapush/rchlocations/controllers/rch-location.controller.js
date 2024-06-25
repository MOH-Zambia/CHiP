// (function () {
//     function RchLocationController(Mask, QueryDAO, GeneralUtil, $timeout, $uibModal, toaster, AuthenticateService) {
//         var ctrl = this;
//         ctrl.appName = GeneralUtil.getAppName();
//         ctrl.selectedLocation = null;
//         ctrl.rchLocationList = [];
//         ctrl.loggedInUser = null;

//         const init = function () {
//             Mask.show();
//             AuthenticateService.getLoggedInUser().then(user => {
//                 ctrl.loggedInUser = user.data;
//             }, GeneralUtil.showMessageOnApiCallFailure).finally(Mask.hide);
//         }

//         ctrl.searchLocations = function (toggleFilter) {
//             if (ctrl.locationId) {
//                 let dtoList = [];
//                 let getRchLocations = {
//                     code: 'retrieval_next_level_rch_locations',
//                     parameters: {
//                         id: ctrl.locationId
//                     },
//                     sequence: 1
//                 }
//                 dtoList.push(getRchLocations);
//                 Mask.show();
//                 QueryDAO.executeAll(dtoList).then(function (res) {
//                     ctrl.rchLocationList = res[0].result;
//                     if (toggleFilter) {
//                         ctrl.toggleFilter();
//                     }
//                     if (ctrl.rchLocationList.length === 0) {
//                         toaster.pop('error', 'No record found.');
//                     }
//                 }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
//                     $timeout(function () {
//                         $(".header-fixed").tableHeadFixer();
//                     });
//                     Mask.hide();
//                 });
//             }
//         }

//         ctrl.toggleFilter = function () {
//             if (angular.element('.filter-div').hasClass('active')) {
//                 angular.element('body').css("overflow", "auto");
//             } else {
//                 angular.element('body').css("overflow", "hidden");
//             }
//             angular.element('.cst-backdrop').fadeToggle();
//             angular.element('.filter-div').toggleClass('active');
//         }

//         ctrl.editRchLocation = function (locationIdParam, rchLocationObj) {
//             let modalInstance = $uibModal.open({
//                 windowClass: 'cst-modal',
//                 backdrop: 'static',
//                 size: 'lg',
//                 templateUrl: 'app/manage/rchdatapush/rchlocations/views/add-edit-rch-location.modal.html',
//                 controllerAs: 'ctrl',
//                 controller: function ($uibModalInstance, locationId, rchLocation, loggedInUserId) {
//                     let editCtrl = this;
//                     editCtrl.locationId = locationId;
//                     editCtrl.rchLocation = rchLocation;
//                     editCtrl.loggedInUserId = loggedInUserId;
//                     editCtrl.lgdCode = editCtrl.rchLocation.rchCode;
//                     editCtrl.ashaId = editCtrl.rchLocation.ashaId;
//                     editCtrl.anmId = editCtrl.rchLocation.anmId;
//                     editCtrl.rchLocationHierarchy;
//                     editCtrl.isAdd = false;
//                     const _init = () => {
//                         if (!editCtrl.rchLocation.parentRchCode) {
//                             return;
//                         }
//                         let dtoList = [];
//                         let retrieveRchLocationHierarchy = {
//                             code: 'retrieve_rch_location_hierarchy',
//                             parameters: {
//                                 anmolLocationMasterId: editCtrl.rchLocation.anmolId
//                             },
//                             sequence: 1
//                         }
//                         dtoList.push(retrieveRchLocationHierarchy);
//                         Mask.show();
//                         QueryDAO.executeAll(dtoList).then(function (responses) {
//                             editCtrl.rchLocationHierarchy = responses[0].result[0].rchLocationHierarchy;
//                         }, GeneralUtil.showMessageOnApiCallFailure).finally(Mask.hide);
//                     }

//                     editCtrl.submit = function () {
//                         editCtrl.editRchLocationForm.$setSubmitted();
//                         if (editCtrl.editRchLocationForm.$valid) {
//                             if (editCtrl.selectedRchLocationId !== editCtrl.locationId) {
//                                 toaster.pop('error', 'Please select correct location hierarchy.');
//                                 return;
//                             }
//                             /* if (editCtrl.ashaId === editCtrl.rchLocation.ashaId &&
//                                 editCtrl.anmId === editCtrl.rchLocation.anmId &&
//                                 editCtrl.lgdCode === editCtrl.rchLocation.rchCode) {
//                                 toaster.pop('warning', 'No change found.');
//                                 return;
//                             } */
//                             let dtoList = [];
//                             let retrieveRchLocation = {
//                                 code: 'retrieve_rch_location_by_rch_code_and_type',
//                                 parameters: {
//                                     anmolId: editCtrl.rchLocation.anmolId,
//                                     rchCode: editCtrl.lgdCode.toString(),
//                                     type: editCtrl.rchLocation.type
//                                 },
//                                 sequence: 1
//                             }
//                             dtoList.push(retrieveRchLocation);
//                             Mask.show();
//                             QueryDAO.executeAll(dtoList).then(function (res) {
//                                 if (res[0].result && res[0].result.length > 0) {
//                                     toaster.pop('error', 'RCH Location with same LGD Code and Location Type already exists. Please add another LGD Code.');
//                                     Mask.hide();
//                                     return;
//                                 }
//                                 let dList = [];
//                                 let updateRchLocation = {
//                                     code: 'update_rch_location',
//                                     parameters: {
//                                         locationId: editCtrl.locationId,
//                                         oldRchCode: editCtrl.rchLocation.rchCode.toString(),
//                                         newRchCode: editCtrl.lgdCode.toString(),
//                                         locationLevel: editCtrl.rchLocation.level,
//                                         ashaId: editCtrl.ashaId,
//                                         anmId: editCtrl.anmId,
//                                         updateParentRchCodeInMapping: editCtrl.rchLocation.isParentRchCodeMismatch,
//                                         newParentRchCode: editCtrl.rchLocation.parentRchCode,
//                                         anmolType: editCtrl.rchLocation.anmolType,
//                                     },
//                                     sequence: 1
//                                 }
//                                 dList.push(updateRchLocation);
//                                 QueryDAO.executeAll(dList).then(function () {
//                                     $uibModalInstance.close();
//                                     toaster.pop('success', 'RCH Location updated successfully.');
//                                 }, function () {
//                                     GeneralUtil.showMessageOnApiCallFailure();
//                                 }).finally(function () {
//                                     Mask.hide();
//                                 });
//                             }, function () {
//                                 GeneralUtil.showMessageOnApiCallFailure();
//                                 Mask.hide();
//                             });
//                         }
//                     }
//                     editCtrl.cancel = function () {
//                         $uibModalInstance.dismiss();
//                     }
//                     _init();
//                 },
//                 resolve: {
//                     locationId: function () {
//                         return locationIdParam
//                     },
//                     rchLocation: function () {
//                         return rchLocationObj
//                     },
//                     loggedInUserId: function () {
//                         return ctrl.loggedInUser.id;
//                     }
//                 }
//             });
//             modalInstance.result
//                 .then(function () {
//                     ctrl.searchLocations(false);
//                 }, function () { })
//         };

//         ctrl.addRchLocation = function (locationIdParam, rchLocationObj) {
//             let modalInstance = $uibModal.open({
//                 windowClass: 'cst-modal',
//                 backdrop: 'static',
//                 size: 'lg',
//                 templateUrl: 'app/manage/rchdatapush/rchlocations/views/add-edit-rch-location.modal.html',
//                 controllerAs: 'ctrl',
//                 controller: function ($uibModalInstance, locationId, rchLocation, loggedInUserId) {
//                     let addCtrl = this;
//                     addCtrl.locationId = locationId;
//                     addCtrl.rchLocation = rchLocation;
//                     addCtrl.loggedInUserId = loggedInUserId;
//                     addCtrl.lgdCode = addCtrl.rchLocation.rchCode;
//                     addCtrl.ashaId = addCtrl.rchLocation.ashaId;
//                     addCtrl.anmId = addCtrl.rchLocation.anmId;
//                     addCtrl.isAdd = true;
//                     addCtrl.submit = function () {
//                         addCtrl.addRchLocationForm.$setSubmitted();
//                         if (addCtrl.addRchLocationForm.$valid) {
//                             if (addCtrl.selectedRchLocationId !== addCtrl.locationId) {
//                                 toaster.pop('error', 'Please select correct location hierarchy.');
//                                 return;
//                             }
//                             /* if (addCtrl.ashaId === addCtrl.rchLocation.ashaId &&
//                                 addCtrl.anmId === addCtrl.rchLocation.anmId &&
//                                 addCtrl.lgdCode === addCtrl.rchLocation.rchCode) {
//                                 toaster.pop('warning', 'No change found.');
//                                 return;
//                             } */
//                             let dtoList = [];
//                             let updateRchLocation = {
//                                 code: 'retrieve_rch_location_by_rch_code_and_type',
//                                 parameters: {
//                                     anmolId: null,
//                                     rchCode: addCtrl.lgdCode.toString(),
//                                     type: addCtrl.rchLocation.type
//                                 },
//                                 sequence: 1
//                             }
//                             dtoList.push(updateRchLocation);
//                             Mask.show();
//                             QueryDAO.executeAll(dtoList).then(function (res) {
//                                 if (res[0].result && res[0].result.length > 0) {
//                                     toaster.pop('error', 'RCH Location with same LGD Code and Location Type already exists. Please add another LGD Code.');
//                                     Mask.hide();
//                                     return;
//                                 }
//                                 let dList = [];
//                                 let insertRchLocation = {
//                                     code: 'insert_rch_location',
//                                     parameters: {
//                                         locationId: addCtrl.locationId,
//                                         rchCode: addCtrl.lgdCode.toString(),
//                                         parentRchCode: addCtrl.rchLocation.parentRchCode,
//                                         locationLevel: addCtrl.rchLocation.level,
//                                         ashaId: addCtrl.ashaId,
//                                         anmId: addCtrl.anmId,
//                                         name: addCtrl.rchLocation.name,
//                                         englishName: addCtrl.rchLocation.englishName,
//                                         techoLocationType: addCtrl.rchLocation.type,
//                                         techoParentLocationType: addCtrl.rchLocation.parentType,
//                                     },
//                                     sequence: 1
//                                 }
//                                 dList.push(insertRchLocation);
//                                 if (addCtrl.rchLocation.level === 7) {
//                                     let healthFacilityType = ctrl.selectedLocation.level5 && ctrl.selectedLocation.level5.type === 'U' ? 2 : 1;
//                                     let insertRchLocationHierarchy = {
//                                         code: 'insert_rch_location_hierarchy',
//                                         parameters: {
//                                             locationId: addCtrl.locationId,
//                                             rchCode: addCtrl.lgdCode,
//                                             parentRchCode: addCtrl.rchLocation.parentRchCode,
//                                             ashaId: addCtrl.ashaId,
//                                             anmId: addCtrl.anmId,
//                                             healthFacilityType: healthFacilityType,
//                                             loggedInUserId: addCtrl.loggedInUserId
//                                         },
//                                         sequence: 2
//                                     }
//                                     dList.push(insertRchLocationHierarchy);
//                                 }
//                                 QueryDAO.executeAll(dList).then(function () {
//                                     $uibModalInstance.close();
//                                     toaster.pop('success', 'RCH Location added successfully.');
//                                 }, function () {
//                                     GeneralUtil.showMessageOnApiCallFailure();
//                                 }).finally(function () {
//                                     Mask.hide();
//                                 });
//                             }, function () {
//                                 GeneralUtil.showMessageOnApiCallFailure();
//                                 Mask.hide();
//                             });
//                         }
//                     }
//                     addCtrl.cancel = function () {
//                         $uibModalInstance.dismiss();
//                     }
//                 },
//                 resolve: {
//                     locationId: function () {
//                         return locationIdParam
//                     },
//                     rchLocation: function () {
//                         return rchLocationObj
//                     },
//                     loggedInUserId: function () {
//                         return ctrl.loggedInUser.id;
//                     }
//                 }
//             });
//             modalInstance.result
//                 .then(function () {
//                     ctrl.searchLocations(false);
//                 }, function () { })
//         };

//         ctrl.showNotAvailableRchLocations = function () {
//             let modalInstance = $uibModal.open({
//                 windowClass: 'cst-modal',
//                 backdrop: 'static',
//                 size: 'xl',
//                 templateUrl: 'app/manage/rchdatapush/rchlocations/views/not-available-rchlocations.modal.html',
//                 controllerAs: 'ctrl',
//                 controller: function ($uibModalInstance, appName) {
//                     let modalCtrl = this;
//                     modalCtrl.appName = appName;
//                     modalCtrl.locations = [];
//                     modalCtrl.locationsCount = {};
//                     modalCtrl.selectedLocationTypes = ['All'];
//                     modalCtrl.preparedSelectedLocationTypes = null;
//                     modalCtrl.locationTypes = [
//                         { type: 'All', name: 'All' },
//                         { type: 'S', name: 'State' },
//                         { type: 'D', name: 'District' },
//                         { type: 'C', name: 'Corporation' },
//                         { type: 'B', name: 'Block' },
//                         { type: 'Z', name: 'Zone' },
//                         { type: 'P', name: 'PHC' },
//                         { type: 'U', name: 'UPHC' },
//                         { type: 'SC', name: 'Sub Center' },
//                         { type: 'ANM', name: 'ANM Area' },
//                         { type: 'V', name: 'Village' },
                       
//                     ]
//                     modalCtrl.pagingService = {
//                         offset: 0,
//                         limit: 100,
//                         index: 0,
//                         allRetrieved: false,
//                         pagingRetrivalOn: false
//                     };

//                     const _setOffsetLimit = function () {
//                         modalCtrl.pagingService.limit = 100;
//                         modalCtrl.pagingService.offset = modalCtrl.pagingService.index * 100;
//                         modalCtrl.pagingService.index = modalCtrl.pagingService.index + 1;
//                     };

//                     const _prepareSelectedLocationTypes = function () {
//                         if (!modalCtrl.selectedLocationTypes || modalCtrl.selectedLocationTypes.length === 0) {
//                             return '';
//                         }
//                         if (modalCtrl.selectedLocationTypes.includes('All')) {
//                             return `'${modalCtrl.locationTypes.map(locationType => locationType.type).join('\',\'')}'`;
//                         } else {
//                             return `'${modalCtrl.selectedLocationTypes.join('\',\'')}'`;
//                         }
//                     }

//                     modalCtrl.retrieveAll = function (initMode) {
//                         if (!modalCtrl.pagingService.pagingRetrivalOn && !modalCtrl.pagingService.allRetrieved && modalCtrl.preparedSelectedLocationTypes) {
//                             modalCtrl.pagingService.pagingRetrivalOn = true;
//                             _setOffsetLimit();
//                             let dtoList = [];
//                             let fetchLocations = {
//                                 code: 'retrieve_lower_level_not_available_rch_locations',
//                                 parameters: {
//                                     id: ctrl.locationId,
//                                     limit: modalCtrl.pagingService.limit,
//                                     offset: modalCtrl.pagingService.offset,
//                                     selectedTypes: modalCtrl.preparedSelectedLocationTypes
//                                 },
//                                 sequence: 1
//                             };
//                             dtoList.push(fetchLocations);
//                             if (initMode) {
//                                 let fetchLocationsCount = {
//                                     code: 'retrieve_lower_level_not_available_rch_locations_count',
//                                     parameters: {
//                                         id: ctrl.locationId
//                                     },
//                                     sequence: 2
//                                 };
//                                 dtoList.push(fetchLocationsCount);
//                             }
//                             Mask.show();
//                             QueryDAO.executeAll(dtoList).then(function (res) {
//                                 let locations = res[0].result;
//                                 if (initMode) {
//                                     modalCtrl.locationsCount = res[1].result[0];
//                                 }
//                                 if (locations.length === 0 || locations.length < modalCtrl.pagingService.limit) {
//                                     modalCtrl.pagingService.allRetrieved = true;
//                                     modalCtrl.locations = modalCtrl.locations.concat(locations);
//                                 } else {
//                                     modalCtrl.pagingService.allRetrieved = false;
//                                     modalCtrl.locations = modalCtrl.locations.concat(locations);
//                                 }
//                             }, function (err) {
//                                 GeneralUtil.showMessageOnApiCallFailure(err);
//                                 modalCtrl.pagingService.allRetrieved = true;
//                             }).finally(function () {
//                                 modalCtrl.pagingService.pagingRetrivalOn = false;
//                                 Mask.hide();
//                             });
//                         }
//                     }

//                     const _getData = function () {
//                         modalCtrl.pagingService = {
//                             offset: 0,
//                             limit: 100,
//                             index: 0,
//                             allRetrieved: false,
//                             pagingRetrivalOn: false
//                         };
//                         modalCtrl.locations = [];
//                         modalCtrl.preparedSelectedLocationTypes = _prepareSelectedLocationTypes();
//                         modalCtrl.retrieveAll(true);
//                     }

//                     const _init = function () {
//                         _getData();
//                     }

//                     modalCtrl.onLocationTypeSelection = function () {
//                         _getData();
//                     }

//                     modalCtrl.ok = function () {
//                         $uibModalInstance.close();
//                     }

//                     modalCtrl.cancel = function () {
//                         $uibModalInstance.dismiss();
//                     }

//                     _init();
//                 },
//                 resolve: {
//                     appName: () => {
//                         return ctrl.appName;
//                     }
//                 }
//             });
//             modalInstance.result.then(function () { }, function () { })
//         };

//         init();
//     }
//     angular.module('imtecho.controllers').controller('RchLocationController', RchLocationController);
// })();
