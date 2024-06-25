'use strict';
(function () {
    function AttendanceService($resource, APP_CONFIG) {
        var api = $resource(APP_CONFIG.apiPath + '/attendance/:action/:subaction/:id', {}, {
            saveAttendance: {
                method: 'PUT',
                params: {
                    action: 'update'
                }
            },
            getAttendancesByTrainingAndDate: {
                method: 'GET',
                isArray: true,
                params: {
                    action: 'retrieve'
                }
            }
        });
        return {
            saveAttendance: function (attendance) {
                return api.saveAttendance({}, attendance).$promise;
            },
            getAttendancesByTrainingAndDate: function (trainingId, date) {
                var params = {
                    trainingId: trainingId,
                    forDate: date
                };
                return api.getAttendancesByTrainingAndDate(params).$promise;
            }
        };
    }
    angular.module('imtecho.service').factory('AttendanceService', AttendanceService);
})();
