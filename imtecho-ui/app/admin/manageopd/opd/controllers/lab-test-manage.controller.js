// (function (angular) {
//     function LabTestManage(Mask, GeneralUtil, QueryDAO, toaster, $stateParams, LabTestService, $state) {
//         var manageLabTest = this;

//         var init = function () {
//             manageLabTest.labTestFormSubmitted = false;
//             manageLabTest.labTestObj = {};
//             manageLabTest.fetchCategoryList();
//             manageLabTest.fetchHealthInfraType();
//             manageLabTest.fetchFormDetails();
//             if ($stateParams.id) {
//                 manageLabTest.isUpdateForm = true;
//             } else {
//                 manageLabTest.isUpdateForm = false;
//             }
//         };

//         manageLabTest.getLabTestById = function (id) {
//             QueryDAO.execute({
//                 code: 'get_lab_test_details_by_id',
//                 parameters: {
//                     id: id
//                 }
//             }).then(function (res) {
//                 manageLabTest.labTestObj = res.result[0];
//                 console.log(manageLabTest.labTestObj)
//                 let infraIds = manageLabTest.labTestObj.infraType ? manageLabTest.labTestObj.infraType.split(',') : [];
//                 manageLabTest.healthInfraTypeList.forEach(element => {
//                     let infraType = infraIds.find(x => x == element.id);
//                     if (infraType) {
//                         element.isChecked = true;
//                     } else {
//                         element.isChecked = false;
//                     }
//                 });
//             }, GeneralUtil.showMessageOnApiCallFailure);
//         }

//         manageLabTest.fetchCategoryList = function () {
//             QueryDAO.execute({
//                 code: 'fetch_listvalue_detail_from_field',
//                 parameters: {
//                     field: 'OPD Lab Test Category'
//                 }
//             }).then(function (res) {
//                 manageLabTest.categoryList = res.result;
//             }, GeneralUtil.showMessageOnApiCallFailure);
//         }

//         manageLabTest.fetchFormDetails = function () {
//             QueryDAO.execute({
//                 code: 'fetch_form_details'
//             }).then(function (res) {
//                 manageLabTest.formList = res.result;
//                 console.log(manageLabTest.formList)
//             }, GeneralUtil.showMessageOnApiCallFailure);
//         }

//         manageLabTest.fetchHealthInfraType = function () {
//             QueryDAO.execute({
//                 code: 'fetch_listvalue_detail_from_field',
//                 parameters: {
//                     field: 'Health Infrastructure Type'
//                 }
//             }).then(function (res) {
//                 manageLabTest.healthInfraTypeList = res.result;
//                 manageLabTest.healthInfraTypeList.forEach(element => {
//                     element.isChecked = false;
//                 });
//                 if ($stateParams.id) {
//                     manageLabTest.getLabTestById(Number($stateParams.id))
//                 }
//             }, GeneralUtil.showMessageOnApiCallFailure);
//         }

//         manageLabTest.action = function (form) {
//             manageLabTest.labTestFormSubmitted = true;
//             manageLabTest.labTestForm.$setSubmitted();
//             if (manageLabTest.labTestForm.$valid) {
//                 var labTestObj = angular.copy(manageLabTest.labTestObj);
//                 labTestObj.isActive = true;
//                 let infraTypeIds = manageLabTest.healthInfraTypeList.filter(x => {
//                     if (x.isChecked) {
//                         return x
//                     }
//                 }).map(x => {
//                     return x.id
//                 })
//                 labTestObj.infraTypeIds = infraTypeIds;
//                 if (manageLabTest.isUpdateForm) {
//                     manageLabTest.updateLabTest(form, labTestObj);
//                 } else {
//                     manageLabTest.createLabTest(form, labTestObj);
//                 }
//             }
//         }

//         manageLabTest.createLabTest = function (form, labTestObj) {
//             Mask.show();
//             LabTestService.createLabTest(labTestObj).then(function (res) {
//                 if (!!res) {
//                     toaster.pop('success', 'Lab test created successfully!');
//                     manageLabTest.cancel(form);
//                     $state.go('techo.manage.manageOpdLabTest');
//                 }
//             }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
//                 Mask.hide();
//             })
//         }

//         manageLabTest.updateLabTest = function (form, labTestObj) {
//             Mask.show();
//             labTestObj.id = $stateParams.id;
//             LabTestService.updateLabTest(labTestObj).then(function (res) {
//                 if (!!res) {
//                     toaster.pop('success', 'Lab test updated successfully!');
//                     manageLabTest.cancel(form);
//                     $state.go('techo.manage.manageOpdLabTest');
//                 }
//             }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
//                 Mask.hide();
//             })
//         }

//         manageLabTest.cancel = function (form) {
//             form.$setPristine();
//             manageLabTest.labTestObj = null;
//             manageLabTest.healthInfraTypeList.forEach(element => {
//                 element.isChecked = false;
//             });
//             manageLabTest.labTestFormSubmitted = false;
//         };

//         init();
//     }
//     angular.module('imtecho.controllers').controller('LabTestManage', LabTestManage);
// })(window.angular);
