(function () {
    function Labinfrastructures(Mask, $state, QueryDAO, AuthenticateService, GeneralUtil) {
        var labinfrastructures = this;
        labinfrastructures.healthInfrastructuresList = [];
        labinfrastructures.today = moment();

        labinfrastructures.init = () => {
            Mask.show();
            AuthenticateService.getLoggedInUser().then((user) => {
                labinfrastructures.user = user.data
                return QueryDAO.execute({
                    code: 'retrieve_assigned_covid_hospitals',
                    parameters: {
                        userId: labinfrastructures.user.id
                    }
                });
            }).then((response) => {
                labinfrastructures.healthInfrastructuresList = response.result;
                labinfrastructures.healthInfrastructuresList.forEach((infra) => {
                    infra.details = infra.name_in_english ? infra.name.concat('<br> (').concat(infra.name_in_english).concat(')') : infra.name
                })
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        labinfrastructures.update = (healthInfrastructure) => {
            $state.go("techo.manage.updatelabinfrastructure", { id: healthInfrastructure.id });
        }

        labinfrastructures.init();
    }
    angular.module('imtecho.controllers').controller('Labinfrastructures', Labinfrastructures);
})();
