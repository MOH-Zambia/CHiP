(function () {
    function ImmunisationDAO($resource, APP_CONFIG) {
        var api = $resource(APP_CONFIG.apiPath + '/managepnc/:action', {},
            {
                getDueImmunisationsForChild: {
                    method: 'GET',
                    isArray: true
                },
                vaccinationValidationChild: {
                    method: 'GET',
                    transformResponse: function (res) {
                        return { result: res };
                    }
                }
            }
        );
        return {
            getDueImmunisationsForChild: function (dateOfBirth, givenImmunisations) {
                return api.getDueImmunisationsForChild({ action: 'getimmunisationsforchild', dateOfBirth: dateOfBirth, givenImmunisations: givenImmunisations }).$promise;
            },
            vaccinationValidationChild: function (dob, givenDate, currentVaccine, givenImmunisations) {
                return api.vaccinationValidationChild({ action: 'vaccinationvalidationforchild', dob: dob, givenDate: givenDate, currentVaccine: currentVaccine, givenImmunisations: givenImmunisations }).$promise;
            }
        };
    }
    angular.module('imtecho.service').factory('ImmunisationDAO', ['$resource', 'APP_CONFIG', ImmunisationDAO]);
})();
