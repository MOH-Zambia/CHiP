(function () {
    function HelpDeskController($scope, QueryDAO, Mask, GeneralUtil, AuthenticateService, HelpDeskDao) {
        let ctrl = this;

        ctrl.init = () => {
            AuthenticateService.getLoggedInUser().then(function (res) {
                let dto = { code: 'get_help_desk_data' };
                QueryDAO.execute(dto).then((res) => {
                    ctrl.result = res.result;

                    // Initialize editing state
                    ctrl.result.forEach(item => {
                        item.editing = false;
                        item.editStatus = item.status;
                    });
                });
            });
        };

        ctrl.saveStatus = function (item) {
            HelpDeskDao.updateStatus(item.editStatus, item.id)
                .then(() => {
                    item.status = item.editStatus;
                    item.editing = false;
                    alert("Status updated successfully!");
                })
                .catch(err => {
                    console.error("Error updating status", err);
                    alert("Failed to update status.");
                });
        };

        ctrl.init();
    }

    angular.module('imtecho.controllers').controller('HelpDeskController', HelpDeskController);
})();
