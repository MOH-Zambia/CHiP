(function () {
    var PagingForFormConfiguratorQueryService = function (APP_CONFIG, $q) {
        var ctrl = this;
        ctrl.paginationResponseObjects = {};
        this.initialize = function (fieldName) {
            ctrl.paginationResponseObjects[fieldName] = {
                busy: false,
                offSet: 0,
                limit: APP_CONFIG.limit
            };
            ctrl.resetOffSetAndVariables(fieldName);
            return ctrl;
        };
        this.resetOffSetAndVariables = function (fieldName) {
            ctrl.paginationResponseObjects[fieldName] = {
                busy: false,
                offSet: 0,
                limit: APP_CONFIG.limit,
                allRetrieved: false
            };
        };
        this.getNextPage = function (nextPageFunctionWithPromise, paramsToPass, list, pathVariables, fieldName) {
            if (list === null) {
                list = [];
            }
            var deferred = $q.defer();
            if (ctrl.paginationResponseObjects[fieldName].busy || ctrl.paginationResponseObjects[fieldName].allRetrieved) {
                deferred.resolve(list);
            } else {
                ctrl.paginationResponseObjects[fieldName].busy = true;
                if (pathVariables) {
                    nextPageFunctionWithPromise(pathVariables, paramsToPass, fieldName).then(function (res) {
                        if (!list || ctrl.paginationResponseObjects[fieldName].offSet === 0) {
                            list = [];
                        }
                        list = list.concat(res.result);
                        if (list.length === 0 || list.length < ctrl.paginationResponseObjects[fieldName].limit || list.length === ctrl.paginationResponseObjects[fieldName].offSet) {
                            ctrl.paginationResponseObjects[fieldName].allRetrieved = true;
                        }
                        ctrl.paginationResponseObjects[fieldName].offSet = list.length;
                        ctrl.paginationResponseObjects[fieldName].busy = false;
                        if (res.result != null) {
                            deferred.resolve(list);
                        } else {
                            deferred.resolve();
                        }
                    }).catch(function (e) {
                        if (e && e.status === 500) {
                            ctrl.paginationResponseObjects[fieldName].allRetrieved = true;
                        }
                        ctrl.paginationResponseObjects[fieldName].busy = false;
                        deferred.reject(e);
                    });
                } else {
                    nextPageFunctionWithPromise(paramsToPass, fieldName).then(function (res) {
                        if (!list || ctrl.paginationResponseObjects[fieldName].offSet === 0) {
                            list = [];
                        }
                        list = list.concat(res.result);
                        if (list.length === 0 || list.length < ctrl.paginationResponseObjects[fieldName].limit || list.length === ctrl.paginationResponseObjects[fieldName].offSet) {
                            ctrl.paginationResponseObjects[fieldName].allRetrieved = true;
                        }
                        ctrl.paginationResponseObjects[fieldName].offSet = list.length;
                        ctrl.paginationResponseObjects[fieldName].busy = false;
                        if (res.result != null) {
                            deferred.resolve(list);
                        } else {
                            deferred.resolve();
                        }
                    }).catch(function (e) {
                        if (e && e.status === 500) {
                            ctrl.paginationResponseObjects[fieldName].allRetrieved = true;
                        }
                        ctrl.paginationResponseObjects[fieldName].busy = false;
                        deferred.reject(e);
                    });
                }
            }
            return deferred.promise;
        };
    };
    angular.module("imtecho.service").service('PagingForFormConfiguratorQueryService', PagingForFormConfiguratorQueryService);
})();
