// (function () {
//     function Manage104CallsController(Mask, QueryDAO, GeneralUtil, $stateParams, toaster, $state, AuthenticateService, LocationService, $uibModal) {
//         var manage104CallsCtrl = this;
//         manage104CallsCtrl.todayDate = moment();
//         manage104CallsCtrl.controls = [];
//         manage104CallsCtrl.countryList = [];
//         manage104CallsCtrl.contactList = [];
//         manage104CallsCtrl.showContact = true;

//         manage104CallsCtrl.init = () => {
//             if (!!$stateParams.id) {
//                 manage104CallsCtrl.covid19CallId = Number($stateParams.id);
//                 manage104CallsCtrl.headerText = 'Update COVID-19 Case'
//                 manage104CallsCtrl.editMode = true;
//                 manage104CallsCtrl.getCovid19Cases();
//             } else {
//                 manage104CallsCtrl.editMode = false;
//                 manage104CallsCtrl.covid19Call = {};
//                 manage104CallsCtrl.covid19Call.locations = [];
//                 manage104CallsCtrl.headerText = 'Add COVID-19 Case';
//             }
//             Mask.show();
//             AuthenticateService.getLoggedInUser().then((res) => {
//                 manage104CallsCtrl.currentUser = res.data;
//                 return QueryDAO.execute({
//                     code: 'retrieve_locations_by_type',
//                     parameters: {
//                         type: ['D','C']
//                     }
//                 });
//             }).then((response) => {
//                 manage104CallsCtrl.districtLocations = response.result;
//                 setTimeout(function () {
//                     $('#locationId').trigger("chosen:updated");
//                 });
//                 return QueryDAO.execute({
//                     code: 'fetch_listvalue_detail_from_field',
//                     parameters: {
//                         field: 'Countries list'
//                     }
//                 });
//             }).then((response) => {
//                 manage104CallsCtrl.countryList = response.result;
//                 setTimeout(function () {
//                     $('#contactCountry').trigger("chosen:updated");
//                 });
//             }).catch((error) => {
//                 GeneralUtil.showMessageOnApiCallFailure(error);
//             }).finally(() => {
//                 Mask.hide();
//             });
//         };

//         manage104CallsCtrl.addContactPerson = () => {
//             if (Array.isArray(manage104CallsCtrl.contactList)) {
//                 if (manage104CallsCtrl.contactObj != null && manage104CallsCtrl.contactObj.name) {
//                     if (manage104CallsCtrl.contactObj.districtLocationId) {
//                         let district = manage104CallsCtrl.districtLocations.filter((location) => {
//                             return location.id === manage104CallsCtrl.contactObj.districtLocationId;
//                         });
//                         manage104CallsCtrl.contactObj.districtName = district[0].name
//                     }
//                     manage104CallsCtrl.contactList.push(manage104CallsCtrl.contactObj);
//                     manage104CallsCtrl.contactObj = {};
//                     manage104CallsCtrl.showContact = false;
//                 } else {
//                     toaster.pop('error', 'Please enter Name')
//                 }
//             }
//         }

//         manage104CallsCtrl.deleteContactPerson = (index) => {
//             var modalInstance = $uibModal.open({
//                 templateUrl: 'app/common/views/confirmation.modal.html',
//                 controller: 'ConfirmModalController',
//                 windowClass: 'cst-modal',
//                 size: 'med',
//                 resolve: {
//                     message: function () {
//                         return "Are you sure to remove this contact?";
//                     }
//                 }
//             });
//             modalInstance.result.then(() => {
//                 manage104CallsCtrl.contactList.splice(index, 1);
//             });
//         }

//         manage104CallsCtrl.getCovid19Cases = () => {
//             Mask.show();
//             QueryDAO.execute({
//                 code: 'retrieve_gvk_covid_104_calls_response_by_id',
//                 parameters: {
//                     id: manage104CallsCtrl.covid19CallId
//                 }
//             }).then(function (response) {
//                 manage104CallsCtrl.covid19Call = response.result[0];
//                 return QueryDAO.execute({
//                     code: 'retrieve_gvk_covid_104_calls_contact_response_by_id',
//                     parameters: {
//                         id: manage104CallsCtrl.covid19CallId
//                     }
//                 });
//             }).then((response) => {
//                 manage104CallsCtrl.contactList = response.result;
//             }).catch((error) => {
//                 GeneralUtil.showMessageOnApiCallFailure(error);
//             }).finally(() => {
//                 Mask.hide();
//             });
//         }

//         manage104CallsCtrl.save = function () {
//             if (!!manage104CallsCtrl.mangeCovid19CaseForm.$valid) {
//                 if (!!manage104CallsCtrl.covid19Call.id) {
//                     Mask.show();
//                     QueryDAO.execute({
//                         code: 'update_gvk_covid_104_calls_response',
//                         parameters: {
//                             id: manage104CallsCtrl.covid19Call.id,
//                             dateOfCalling: moment(manage104CallsCtrl.covid19Call.dateOfCalling).format('DD-MM-YYYY'),
//                             personName: manage104CallsCtrl.covid19Call.name,
//                             age: manage104CallsCtrl.covid19Call.age,
//                             gender: manage104CallsCtrl.covid19Call.gender,
//                             contactNo: manage104CallsCtrl.covid19Call.contact_no,
//                             address: manage104CallsCtrl.covid19Call.address,
//                             pinCode: manage104CallsCtrl.covid19Call.pinCode,
//                             district: manage104CallsCtrl.covid19Call.district_locationId,
//                             block: manage104CallsCtrl.covid19Call.taluka_locationId,
//                             village: manage104CallsCtrl.covid19Call.locationId,
//                             isInformationCall: manage104CallsCtrl.covid19Call.isInformationCall,
//                             hasFever: manage104CallsCtrl.covid19Call.isHavingFever,
//                             feverDays: manage104CallsCtrl.covid19Call.feverDays,
//                             havingCough: manage104CallsCtrl.covid19Call.isHavingCough,
//                             coughDays: manage104CallsCtrl.covid19Call.coughDays,
//                             hasShortnessOfBreath: manage104CallsCtrl.covid19Call.isHavingShortnessBreath,
//                             travelAbroad: manage104CallsCtrl.covid19Call.isTravelAbroad,
//                             country: manage104CallsCtrl.covid19Call.contactCountry,
//                             arrivalDate: moment(manage104CallsCtrl.covid19Call.dateOfArrival).format('DD-MM-YYYY') || null,
//                             inTouchWithAnyone: manage104CallsCtrl.covid19Call.isInTouchWithRecentTraveller,
//                             modifiedBy: manage104CallsCtrl.currentUser.id
//                         }
//                     }).then(function () {
//                         if (Array.isArray(manage104CallsCtrl.contactList) && manage104CallsCtrl.contactList.length) {
//                             const dtoList = [];
//                             manage104CallsCtrl.contactList.forEach((contact, index) => {
//                                 dtoList.push({
//                                     code: 'insert_gvk_covid_104_calls_contact_response',
//                                     parameters: {
//                                         gvkId: manage104CallsCtrl.covid19Call.id,
//                                         personName: contact.name,
//                                         contactNo: contact.contactNo,
//                                         district: contact.districtLocationId,
//                                         otherDetails: contact.otherDetail || null,
//                                     },
//                                     sequence: index + 1
//                                 });
//                             });
//                             return QueryDAO.executeAll(dtoList);
//                         } else {
//                             return Promise.resolve();
//                         }
//                     }).then(() => {
//                         toaster.pop('success', 'Details Updated Successfully');
//                         $state.go('techo.manage.104calls');
//                     }).catch((error) => {
//                         GeneralUtil.showMessageOnApiCallFailure(error);
//                     }).finally(() => {
//                         Mask.hide();
//                     });

//                 } else {
//                     Mask.show();
//                     QueryDAO.execute({
//                         code: 'insert_gvk_covid_104_calls_response',
//                         parameters: {
//                             dateOfCalling: moment(manage104CallsCtrl.covid19Call.dateOfCalling).format('DD-MM-YYYY'),
//                             personName: manage104CallsCtrl.covid19Call.name,
//                             age: manage104CallsCtrl.covid19Call.age,
//                             gender: manage104CallsCtrl.covid19Call.gender,
//                             contactNo: manage104CallsCtrl.covid19Call.contact_no,
//                             address: manage104CallsCtrl.covid19Call.address,
//                             pinCode: manage104CallsCtrl.covid19Call.pinCode,
//                             district: manage104CallsCtrl.covid19Call.district_locationId,
//                             block: manage104CallsCtrl.covid19Call.taluka_locationId,
//                             village: manage104CallsCtrl.covid19Call.locationId,
//                             isInformationCall: manage104CallsCtrl.covid19Call.isInformationCall,
//                             hasFever: manage104CallsCtrl.covid19Call.isHavingFever,
//                             feverDays: manage104CallsCtrl.covid19Call.feverDays,
//                             havingCough: manage104CallsCtrl.covid19Call.isHavingCough,
//                             coughDays: manage104CallsCtrl.covid19Call.coughDays,
//                             hasShortnessOfBreath: manage104CallsCtrl.covid19Call.isHavingShortnessBreath,
//                             travelAbroad: manage104CallsCtrl.covid19Call.isTravelAbroad,
//                             country: manage104CallsCtrl.covid19Call.contactCountry,
//                             arrivalDate: moment(manage104CallsCtrl.covid19Call.dateOfArrival).format('DD-MM-YYYY') || null,
//                             inTouchWithAnyone: manage104CallsCtrl.covid19Call.isInTouchWithRecentTraveller,
//                             createdBy: manage104CallsCtrl.currentUser.id,
//                             modifiedBy: manage104CallsCtrl.currentUser.id
//                         }
//                     }).then(function (response) {
//                         const gvkId = response.result[0].id;
//                         if (gvkId) {
//                             if (Array.isArray(manage104CallsCtrl.contactList) && manage104CallsCtrl.contactList.length) {
//                                 const dtoList = [];
//                                 manage104CallsCtrl.contactList.forEach((contact, index) => {
//                                     dtoList.push({
//                                         code: 'insert_gvk_covid_104_calls_contact_response',
//                                         parameters: {
//                                             gvkId: gvkId,
//                                             personName: contact.name,
//                                             contactNo: contact.contactNo,
//                                             district: contact.districtLocationId,
//                                             otherDetails: contact.otherDetail || null,
//                                         },
//                                         sequence: index + 1
//                                     });
//                                 });
//                                 return QueryDAO.executeAll(dtoList);
//                             } else {
//                                 return Promise.resolve();
//                             }
//                         } else {
//                             return Promise.reject({ data: { message: 'Some problem occured' } });
//                         }
//                     }).then((response) => {
//                         toaster.pop('success', 'Details saved successfully');
//                         $state.go('techo.manage.104calls');
//                     }).catch((error) => {
//                         GeneralUtil.showMessageOnApiCallFailure(error);
//                     }).finally(() => {
//                         Mask.hide();
//                     });
//                 }
//             }
//         }

//         manage104CallsCtrl.selectedArea = function () {
//             manage104CallsCtrl.locationForm.$setSubmitted();
//             if (manage104CallsCtrl.selectedLocation.finalSelected !== null) {
//                 let selectedobj;
//                 if (manage104CallsCtrl.selectedLocation.finalSelected.optionSelected) {
//                     selectedobj = {
//                         locationId: manage104CallsCtrl.selectedLocation.finalSelected.optionSelected.id,
//                         type: manage104CallsCtrl.selectedLocation.finalSelected.optionSelected.type,
//                         level: manage104CallsCtrl.selectedLocation.finalSelected.level,
//                         name: manage104CallsCtrl.selectedLocation.finalSelected.optionSelected.name

//                     };
//                 } else {
//                     selectedobj = {
//                         locationId: manage104CallsCtrl.selectedLocation["level" + (manage104CallsCtrl.selectedLocation.finalSelected.level - 1)].id,
//                         type: manage104CallsCtrl.selectedLocation["level" + (manage104CallsCtrl.selectedLocation.finalSelected.level - 1)].type,
//                         level: manage104CallsCtrl.selectedLocation.finalSelected.level - 1,
//                         name: manage104CallsCtrl.selectedLocation["level" + (manage104CallsCtrl.selectedLocation.finalSelected.level - 1)].name

//                     };
//                 }
//                 manage104CallsCtrl.duplicateEntry = false;
//                 for (let i = 0; i < manage104CallsCtrl.covid19Call.locations.length; i++) {
//                     if (manage104CallsCtrl.covid19Call.locations[i].locationId === selectedobj.locationId) {
//                         manage104CallsCtrl.duplicateEntry = true;
//                         manage104CallsCtrl.isLocationButtonDisabled = false;
//                     }
//                 }
//                 if (!manage104CallsCtrl.duplicateEntry) {
//                     manage104CallsCtrl.isNotAllowedLocation = false;
//                     if (!manage104CallsCtrl.covid19Call.locations) {
//                         manage104CallsCtrl.covid19Call.locations = [];
//                     }
//                     var itteratingLevel = 1,
//                         locationFullName = '';
//                     while (itteratingLevel < manage104CallsCtrl.selectedLocation.finalSelected.level) {
//                         if (manage104CallsCtrl.selectedLocation['level' + itteratingLevel]) {
//                             locationFullName = locationFullName.concat(manage104CallsCtrl.selectedLocation['level' + itteratingLevel].name + ',');
//                         }
//                         itteratingLevel = itteratingLevel + 1;
//                     }
//                     if (manage104CallsCtrl.selectedLocation.finalSelected.optionSelected) {
//                         locationFullName = locationFullName.concat(manage104CallsCtrl.selectedLocation.finalSelected.optionSelected.name);
//                     } else {
//                         locationFullName = locationFullName.substring(0, locationFullName.length - 1);
//                     }
//                     selectedobj.locationFullName = locationFullName;
//                     manage104CallsCtrl.covid19Call.locations.push(selectedobj);
//                     delete manage104CallsCtrl.errorMsg;
//                     delete manage104CallsCtrl.errorCode;
//                     if (manage104CallsCtrl.covid19Call.locations.length > 0) {
//                         manage104CallsCtrl.noLocationSelected = false;
//                     }
//                 }
//             }
//         };

//         manage104CallsCtrl.removeSelectedArea = function (index) {
//             manage104CallsCtrl.covid19Call.locations.splice(index, 1);
//             if (manage104CallsCtrl.covid19Call.locations.length <= 0) {
//                 manage104CallsCtrl.noLocationSelected = true;
//                 manage104CallsCtrl.duplicateEntry = false;
//                 manage104CallsCtrl.isNotAllowedLocation = false;
//             }
//         };

//         manage104CallsCtrl.cancel = function () {
//             $state.go('techo.manage.104calls');
//         };

//         manage104CallsCtrl.getChildLocation = function (districtlocationId, isDistrict) {
//             if (!!districtlocationId) {
//                 Mask.show();
//                 LocationService.retrieveNextLevelOfGivenLocationId(districtlocationId).then(function (res) {
//                     if (!!isDistrict) {
//                         manage104CallsCtrl.talukaLocation = res;
//                     } else {
//                         manage104CallsCtrl.villageLocation = res;
//                     }
//                 }).finally(function () {
//                     Mask.hide();
//                 })
//             }
//         }

//         manage104CallsCtrl.informationCallChanged = () => {
//             manage104CallsCtrl.covid19Call.isHavingFever = null;
//             manage104CallsCtrl.covid19Call.feverDays = null;
//             manage104CallsCtrl.covid19Call.isHavingCough = null;
//             manage104CallsCtrl.covid19Call.coughDays = null;
//             manage104CallsCtrl.covid19Call.isHavingShortnessBreath = null;
//             manage104CallsCtrl.covid19Call.isTravelAbroad = null;
//             manage104CallsCtrl.covid19Call.contactCountry = null;
//             manage104CallsCtrl.covid19Call.dateOfArrival = null;
//             manage104CallsCtrl.covid19Call.isInTouchWithRecentTraveller = null;
//             manage104CallsCtrl.contactList = [];
//         }

//         manage104CallsCtrl.feverChanged = () => {
//             manage104CallsCtrl.covid19Call.feverDays = null;
//         }

//         manage104CallsCtrl.coughChanged = () => {
//             manage104CallsCtrl.covid19Call.coughDays = null;
//         }

//         manage104CallsCtrl.travelAbroadChanged = () => {
//             manage104CallsCtrl.covid19Call.contactCountry = null;
//             manage104CallsCtrl.covid19Call.dateOfArrival = null;

//         }

//         manage104CallsCtrl.inTouchChanged = () => {
//             manage104CallsCtrl.contactList = [];
//         }

//         manage104CallsCtrl.init();
//     }
//     angular.module('imtecho.controllers').controller('Manage104CallsController', Manage104CallsController);
// })();
