(function (angular) {
    function UserHealthApprovalsController($uibModal, QueryDAO, Mask, GeneralUtil, $timeout) {
        var uha = this;
        uha.userDetailList = [];

        var init = function () {
            //this is for fixed header for table at initial page load
            $timeout(function () {
                $(".header-fixed").tableHeadFixer();
            });
            uha.statusOptionsArray = [
                { option: "PENDING", value: "PENDING" },
                { option: "APPROVED", value: "ACTIVE" },
                { option: "DISAPPROVED", value: "INACTIVE" },
            ];
            uha.selectedStatusOption = uha.statusOptionsArray[0];
            uha.retrieveUserList();
        };

        //Retrieve user details
        uha.retrieveUserList = function () {
            uha.userDetailList = [];
            Mask.show();
            var dto = {
                code: 'retrieve_user_for_health_approval',
                parameters: {
                    state: uha.selectedStatusOption.value
                }
            };
            QueryDAO.execute(dto).then(function (res) {
                if (res.result) {
                    uha.userDetailList = res.result;
                }
                Mask.hide();
            }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                Mask.hide();
            });
        };

        uha.approvedisapproveuser = function (userId, isApprove) {
            Mask.show();
            var modalInstance = $uibModal.open({
                templateUrl: !!isApprove ? 'app/manage/sohuserapproval/views/soh-user-approve.modal.html' : 'app/manage/sohuserapproval/views/soh-user-disapprove.modal.html',
                controller: !!isApprove ? 'ApprovedUserLocationForHelathApproval' : 'DisApprovedUserReasonForHelathApproval',
                controllerAs: !!isApprove ? 'approvedUser' : 'disApprovedUser',
                size: 'lg',
                backdrop: 'static',
                resolve: {
                    userId: function () {
                        return userId;
                    }
                }
            });
            modalInstance.result.then(function (res) {
                {
                    if (res == 1) {
                        uha.userDetailList.forEach(function (member, index) {
                            if (member.id === userId) {
                                uha.userDetailList.splice(index, 1);
                            }
                        })
                    }
                    if (!(res === 'cancel' || res === 'escape key press')) {
                        throw res;
                    }
                }
            }, function () {
                uha.retrieveUserList();
            });

            Mask.hide();
        }

        init();
    }
    angular.module('imtecho.controllers').controller('UserHealthApprovalsController', UserHealthApprovalsController);
})(window.angular);
