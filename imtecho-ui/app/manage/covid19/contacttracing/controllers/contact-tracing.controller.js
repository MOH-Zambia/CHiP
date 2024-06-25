(function () {
    function CovidCasesController(Mask, QueryDAO, GeneralUtil, AuthenticateService, $state) {
        var covidCasesCtrl = this;
        covidCasesCtrl.covid19Cases = [];

        covidCasesCtrl.init = function () {
            covidCasesCtrl.getCovid19Case();
            AuthenticateService.getLoggedInUser().then(function (res) {
                covidCasesCtrl.currentUser = res.data;
            });
        };

        covidCasesCtrl.getCovid19Case = function () {
            var dto = {
                code: 'covid19_get_pending_contact_tracing_detail',
                parameters: {
                }
            };
            Mask.show();
            QueryDAO.execute(dto).then(function (res) {
                covidCasesCtrl.covid19Cases = res.result;
            }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                Mask.hide();
            });
        };

        covidCasesCtrl.onAddEditClick = function (id) {
            $state.go('techo.manage.manageCovidCases', { id: id });
        };

        covidCasesCtrl.manageTravelHistory = function (contactId) {
            $state.go('techo.manage.manageCovidTravelHistory', { contactId: contactId });
        }

        covidCasesCtrl.init();
    }
    angular.module('imtecho.controllers').controller('CovidCasesController', CovidCasesController);
})();
