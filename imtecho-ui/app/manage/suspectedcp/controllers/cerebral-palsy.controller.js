// /* global moment */
// (function () {
//     function CerebralPalsyController(QueryDAO, Mask, $stateParams, toaster, $state, GeneralUtil) {
//         var cerebralpalsy = this;
//         cerebralpalsy.MS_PER_DAY = 1000 * 60 * 60 * 24;
//         cerebralpalsy.todayDate = moment();

//         cerebralpalsy.init = function () {
//             cerebralpalsy.immunisationDisplay = "";
//             var queryDtos = [];
//             var basicDetails = {
//                 code: 'cerebral_palsy_retrieve_by_id',
//                 parameters: {
//                     id: Number($stateParams.id)
//                 },
//             };
//             QueryDAO.execute(basicDetails).then(function (res) {
//                 cerebralpalsy.additionalInfo = JSON.parse(res.result[0].additionalInfo);
//                 cerebralpalsy.cpObject = res.result[0];
//                 var immunisationDetails = {
//                     code: 'cerebral_palsy_retrieve_immunisation_anc_danger_signs_by_id',
//                     parameters: {
//                         id: cerebralpalsy.cpObject.id
//                     },
//                     sequence: 1
//                 };
//                 queryDtos.push(immunisationDetails);
//                 var deliveryPlaceDto = {
//                     code: 'cerebral_palsy_retrieve_delivery_place_by_id',
//                     parameters: {
//                         id: cerebralpalsy.cpObject.id
//                     },
//                     sequence: 2
//                 };
//                 queryDtos.push(deliveryPlaceDto);
//                 var pncDangerSignsDto = {
//                     code: 'cerebral_palsy_retrieve_pnc_danger_signs_by_id',
//                     parameters: {
//                         id: cerebralpalsy.cpObject.id
//                     },
//                     sequence: 3
//                 };
//                 queryDtos.push(pncDangerSignsDto);
//                 var wpdDangerSignsDto = {
//                     code: 'cerebral_palsy_retrieve_wpd_danger_signs_by_id',
//                     parameters: {
//                         id: cerebralpalsy.cpObject.id
//                     },
//                     sequence: 4
//                 };
//                 queryDtos.push(wpdDangerSignsDto);
//                 var previousCpDataDto = {
//                     code: 'retrieve_previous_cp_data',
//                     parameters: {
//                         id: cerebralpalsy.cpObject.id,
//                         childServiceId: Number($stateParams.id)
//                     },
//                     sequence: 5
//                 };
//                 queryDtos.push(previousCpDataDto);
//                 Mask.show();
//                 QueryDAO.executeAll(queryDtos).then(function (response) {
//                     Mask.hide();
//                     cerebralpalsy.cpObject.dob = moment(cerebralpalsy.cpObject.dob).format("DD-MM-YYYY");
//                     cerebralpalsy.cpObject.childServiceDate = moment(cerebralpalsy.cpObject.childServiceDate).format("DD-MM-YYYY");
//                     cerebralpalsy.cpObject.age = cerebralpalsy.getAge(new Date(cerebralpalsy.cpObject.dob.replace(/(\d{2})-(\d{2})-(\d{4})/, "$2/$1/$3")), new Date());
//                     cerebralpalsy.cpObject.immunisationDisplay = response[0].result[0].immunisation;
//                     cerebralpalsy.cpObject.ancDangerSigns = response[0].result[0].ancdangersigns;
//                     cerebralpalsy.cpObject.deliveryPlace = response[1].result[0].delivery_place;
//                     cerebralpalsy.cpObject.typeOfDelivery = response[1].result[0].type_of_delivery;
//                     cerebralpalsy.cpObject.pncDangerSigns = response[2].result[0].pncDangerSigns;
//                     cerebralpalsy.cpObject.wpdDangerSigns = response[3].result[0].wpdDangerSigns;
//                     cerebralpalsy.cpObject.deliveryPlace = cerebralpalsy.cpObject.deliveryPlace == 'HOSP' ? 'HOSPITAL' : 'HOME'
//                     cerebralpalsy.previousCpData = response[4].result;
//                     cerebralpalsy.previousCpData.forEach(function (data) {
//                         data.remarks_date = moment(data.remarks_date).format("DD-MM-YYYY");
//                     })
//                     var locationHierarchyDto = {
//                         code: 'retrieve_location_hierarchy_by_location_id',
//                         parameters: {
//                             locationId: cerebralpalsy.cpObject.location_id
//                         }
//                     };
//                     QueryDAO.execute(locationHierarchyDto).then(function (location) {
//                         cerebralpalsy.cpObject.locationHierarchy = location.result[0].location_id;
//                     })
//                 }, function (err) {
//                     Mask.hide();
//                     GeneralUtil.showMessageOnApiCallFailure(err);
//                 })
//             })
//         }

//         cerebralpalsy.dateDiffInDays = function (a, b) {
//             var utc1 = Date.UTC(a.getFullYear(), a.getMonth(), a.getDate());
//             var utc2 = Date.UTC(b.getFullYear(), b.getMonth(), b.getDate());

//             return Math.floor((utc2 - utc1) / cerebralpalsy.MS_PER_DAY);
//         }

//         cerebralpalsy.goBack = function () {
//             window.history.back();
//         }

//         cerebralpalsy.save = function () {
//             if (cerebralpalsy.cpObject.status === 'DELAYED_DEVELOPMENT') {
//                 cerebralpalsy.additionalInfo.cpState = 'DD';
//             } else if (cerebralpalsy.cpObject.status === 'NORMAL_DEVELOPMENT') {
//                 cerebralpalsy.additionalInfo.cpState = 'ND';
//             } else if (cerebralpalsy.cpObject.status === 'TREATMENT_COMMENCED') {
//                 cerebralpalsy.additionalInfo.cpState = 'TC';
//             }
//             cerebralpalsy.cerebralpalsyForm.$setSubmitted();
//             var dto = {
//                 code: 'cerebral_palsy_update_remarks_and_status',
//                 parameters: {
//                     id: Number($stateParams.id),
//                     remarks: cerebralpalsy.cpObject.remarks,
//                     status: cerebralpalsy.cpObject.status,
//                     additionalInfo: JSON.stringify(cerebralpalsy.additionalInfo),
//                     childId: cerebralpalsy.cpObject.id
//                 }
//             };
//             QueryDAO.execute(dto).then(function (response) {
//                 toaster.pop("success", "Remarks Saved Successfully");
//                 $state.go("techo.manage.cerebralpalsysearch");
//             }, function (err) {
//                 Mask.hide();
//                 GeneralUtil.showMessageOnApiCallFailure(err);
//             });
//         }

//         cerebralpalsy.getAge = function (date_1, date_2) {
//             var date2_UTC = new Date(Date.UTC(date_2.getUTCFullYear(), date_2.getUTCMonth(), date_2.getUTCDate()));
//             var date1_UTC = new Date(Date.UTC(date_1.getUTCFullYear(), date_1.getUTCMonth(), date_1.getUTCDate()));
//             var yAppendix, mAppendix, dAppendix;
//             var days = date2_UTC.getDate() - date1_UTC.getDate();
//             if (days < 0) {
//                 date2_UTC.setMonth(date2_UTC.getMonth() - 1);
//                 days += cerebralpalsy.daysInMonth(date2_UTC);
//             }
//             var months = date2_UTC.getMonth() - date1_UTC.getMonth();
//             if (months < 0) {
//                 date2_UTC.setFullYear(date2_UTC.getFullYear() - 1);
//                 months += 12;
//             }
//             var years = date2_UTC.getFullYear() - date1_UTC.getFullYear();
//             if (years > 1)
//                 yAppendix = " years";
//             else
//                 yAppendix = " year";
//             if (months > 1)
//                 mAppendix = " months";
//             else
//                 mAppendix = " month";
//             if (days > 1)
//                 dAppendix = " days";
//             else
//                 dAppendix = " day";
//             return years + yAppendix + ", " + months + mAppendix + ", and " + days + dAppendix + " old.";
//         }

//         cerebralpalsy.daysInMonth = function (date2_UTC) {
//             var monthStart = new Date(date2_UTC.getFullYear(), date2_UTC.getMonth(), 1);
//             var monthEnd = new Date(date2_UTC.getFullYear(), date2_UTC.getMonth() + 1, 1);
//             var monthLength = (monthEnd - monthStart) / (1000 * 60 * 60 * 24);
//             return monthLength;
//         }

//         cerebralpalsy.init();
//     }
//     angular.module('imtecho.controllers').controller('CerebralPalsyController', CerebralPalsyController);
// })();
