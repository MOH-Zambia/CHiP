// (function () {
//     function ManageAbsentUsersController(AuthenticateService, QueryDAO, toaster, PagingService) {

//         var manageabsentuserscontroller = this;
//         manageabsentuserscontroller.pagingService = PagingService.initialize();
//         manageabsentuserscontroller.noUsers = false;

//         manageabsentuserscontroller.init = function () {
//             AuthenticateService.getLoggedInUser().then(function (res) {
//                 manageabsentuserscontroller.currentUser = res.data;
//             });
//         }

//         manageabsentuserscontroller.getAbsentUsersByCriteria = function () {
//             manageabsentuserscontroller.absentDetailsDto = {
//                 code: "fetch_user_absent_details",
//                 parameters: {
//                     limit: manageabsentuserscontroller.pagingService.limit,
//                     offset: manageabsentuserscontroller.pagingService.offSet
//                 }
//             }
//             var usersList = manageabsentuserscontroller.absentUsersList;
//             PagingService.getNextPage(function (absentDetailsDto) {
//                 return QueryDAO.executeQuery(absentDetailsDto).then(function (response) {
//                     return response.result;
//                 }).catch(function (err) {
//                     return err;
//                 })
//             }, manageabsentuserscontroller.absentDetailsDto, usersList, null).then(function (response) {
//                 manageabsentuserscontroller.absentUsersList = response;
//                 manageabsentuserscontroller.absentUsersList.forEach(function (user) {
//                     if (user.contactNumber == null || user.contactNumber == '') {
//                         user.contactNumber = "Not available"
//                     }
//                     user.absentResponse = null;
//                     user.absentResponseOther = null;
//                 });
//             });
//         }

//         manageabsentuserscontroller.saveUserResponse = function (user, index) {
//             if (user.absentResponse == null || user.absentResponse === '') {
//                 return;
//             } else if (user.absentResponse === 'Other' && (user.absentResponseOther == null || user.absentResponseOther == '')) {
//                 return;
//             } else {
//                 var absentResponseDto = {
//                     code: "insert_user_absent_response",
//                     parameters: {
//                         userId: user.userId,
//                         absentResponse: user.absentResponse,
//                         absentResponseOther: user.absentResponse === 'Other' ? user.absentResponseOther : null,
//                         createdBy: manageabsentuserscontroller.currentUser.id
//                     }
//                 }
//                 QueryDAO.executeQuery(absentResponseDto).then(function (response) {
//                     var statusAlterDto = {
//                         code: "update_user_absent_detail_status",
//                         parameters: {
//                             userId: user.userId,
//                             status: "COMPLETED"
//                         }
//                     }
//                     QueryDAO.executeQuery(statusAlterDto).then(function (res) {
//                         manageabsentuserscontroller.absentUsersList.splice(index, 1);
//                         toaster.pop('success', 'Response saved successfully');
//                     });
//                 });
//             }
//         }

//         manageabsentuserscontroller.init();
//     }
//     angular.module('imtecho.controllers').controller('ManageAbsentUsersController', ManageAbsentUsersController);
// })();
