/* global moment */
(function () {
    function QueryManagement(QueryManagementDao, GeneralUtil, Mask, toaster, $uibModal, $q, QueryDAO, AuthenticateService, ReportDAO, $timeout, $scope) {
        var querymanagement = this;
        querymanagement.errorData = null;
        querymanagement.dBstateQuery = "select pid,query,wait_event_type,state_change,cast (now()-state_change as TEXT) as Since from pg_stat_activity where state = 'active' order by state_change";
        querymanagement.isTableLoading = false;
        querymanagement.isHistoryLoading = false;
        querymanagement.isFetchLockedQuery = false;
        querymanagement.dBlockedQuery="select cast(pid as text) as pid, cast(usename as text) as usename, cast(pg_blocking_pids(pid) as text) as blocked_by, datname as Database_Name,cast(query as text) as blocked_query from pg_stat_activity where cardinality(pg_blocking_pids(pid)) > 0";
        querymanagement.downloadExcel = function () {
            if (!!querymanagement.query) {
                var paramObject = {
                    query: querymanagement.query
                };
                var reportExcelDto = {
                    paramObj: paramObject
                };
                Mask.show();
                ReportDAO.downloadExcel('d91d249f-c8e1-4397-a84d-6ce6eb33eb48', reportExcelDto).then(function (res) {
                    if (res.data !== null && navigator.msSaveBlob) {
                        return navigator.msSaveBlob(new Blob([res.data], { type: '' }));
                    }
                    var a = $("<a style='display: none;'/>");
                    var url = window.URL.createObjectURL(new Blob([res.data], { type: 'application/vnd.ms-excel' }));
                    a.attr("href", url);
                    a.attr("download", (!!querymanagement.fileName ? querymanagement.fileName : "rename") + "_" + new Date().getTime() + ".xlsx");
                    $("body").append(a);
                    a[0].click();
                    window.URL.revokeObjectURL(url);
                    a.remove();
                }).catch(function (error) {
                    $timeout(function () {
                        GeneralUtil.showMessageOnApiCallFailure(error);
                    });
                }).finally(function () {
                    $timeout(function () {
                        Mask.hide();
                    });
                });
            } else {
                toaster.pop('error', 'Query can not be null');
            }
        };

        querymanagement.loadQueryHistory = function () {
            querymanagement.isHistoryLoading = true;
            AuthenticateService.getLoggedInUser().then(function (user) {
                Mask.show();
                var queryDto = {
                    code: 'retrieve_limited_query_history',
                    parameters: {
                        userId: user.data.id,
                        limit: 100,
                        searchKey : querymanagement.searchHistory || null
                    }
                };

                QueryDAO.execute(queryDto).then(function (res) {
                    querymanagement.historyTables = res.result;
                    Mask.hide();
                    querymanagement.isHistoryLoading = false;
                }).catch(function (error) {
                    $timeout(function () {
                        GeneralUtil.showMessageOnApiCallFailure(error);
                    });
                }).finally(function () {
                    Mask.hide();
                    querymanagement.isHistoryLoading = false;
                });
            });
        };

        querymanagement.toggleTableList = function() {
            $scope.toggle1 = !$scope.toggle1;
            if(!querymanagement.tables && $scope.toggle1){
                querymanagement.isTableLoading = true;
                QueryDAO.executeWithTimeout({ code: 'retrieve_all_tables' }).then((res) =>{
                    querymanagement.tables = res.result;
                }).catch(function (error) {
                    $('#collapse1').toggle();
                    $scope.toggle1 = !$scope.toggle1;
                    GeneralUtil.showMessageOnApiCallFailure(error);
                }).finally(function (){
                    querymanagement.isTableLoading = false;
                });
            }
        };

        querymanagement.toggleQueryHistory = function() {
            $scope.toggle2 = !$scope.toggle2;
            if(!querymanagement.historyTables){
                querymanagement.loadQueryHistory();
            }
        };

        querymanagement.showWarning = function (msg) {
            var modalInstance = $uibModal.open({
                templateUrl: 'app/common/views/confirmation.modal.html',
                controller: 'ConfirmModalController',
                windowClass: 'cst-modal',
                size: 'med',
                resolve: {
                    message: function () {
                        return msg;
                    }
                }
            });
            return modalInstance.result.then(function () {
                return $q(function (resolve) {
                    resolve(true);
                });
            }, function () {
                return $q(function (resolve) {
                    resolve(false);
                });
            });
        };

        querymanagement.killProcess = function (pid) {
            var str = "Are you sure you want to kill process id " + pid + " ?";
            querymanagement.showWarning(str).then(function (res) {
                if (res) {
                    querymanagement.query = "select pg_terminate_backend( " + pid + " )";
                    querymanagement.retrieveFinalQuery(querymanagement.query).then((value)=>{
                        if(querymanagement.isFetchLockedQuery = true){
                            querymanagement.query = angular.copy(querymanagement.dBlockedQuery);
                        }
                        else{
                            querymanagement.query = angular.copy(querymanagement.dBstateQuery);
                        }
                        querymanagement.retrieveFinalQuery(querymanagement.query);
                    })
                    
                }
            });
        };
        querymanagement.popuateDBstateQuery = function () {
            querymanagement.query = angular.copy(querymanagement.dBstateQuery);
            querymanagement.retrieveFinalQuery(querymanagement.query);
        };


        querymanagement.tableHistoryClicked = function (data) {
            querymanagement.query = data;
        };

        querymanagement.tableClicked = function (tablename) {
            querymanagement.query = "select * from " + tablename + " limit 100";
            querymanagement.retrieveFinalQuery(querymanagement.query);
        };

        querymanagement.isWhereIncluded = function () {
            if (querymanagement.query.toUpperCase().includes("WHERE")) {
                return $q(function (resolve) {
                    resolve(true);
                });
            } else {
                var msg = "The query does not include where clause. Are you sure you want to proceed ?";
                return querymanagement.showWarning(msg);
            }
        };

        querymanagement.executeQuery = function () {
            if (angular.isDefined(querymanagement.query) && querymanagement.query!= '') {
                querymanagement.isWhereIncluded().then(function (res) {
                    if (res) {
                        querymanagement.executeFinalQuery(querymanagement.query);
                    }
                });
            } else {
                toaster.pop('error', "Please enter query");
                delete querymanagement.tableData;
            }
        };
        querymanagement.retrieveQuery = function () {
            if (angular.isDefined(querymanagement.query) && querymanagement.query!= '') {
                querymanagement.isWhereIncluded().then(function (res) {
                    if (res) {
                        querymanagement.errorData = null;
                        querymanagement.retrieveFinalQuery(querymanagement.query);
                    }
                });
            } else {
                toaster.pop('error', "Please enter query");
                delete querymanagement.tableData;
            }
        };

        querymanagement.executeFinalQuery = function (query) {
            querymanagement.errorData = null;
            Mask.show();

            QueryManagementDao.execute(query).then(function (response) {
                toaster.pop('success', "Query Executed Successfully");
                if (response !== null && response.length > 0) {
                    querymanagement.tableData = response;
                    querymanagement.headers = Object.keys(querymanagement.tableData[0]);
                    querymanagement.loadQueryHistory();
                } else {
                    delete querymanagement.tableData;
                    delete querymanagement.headers;
                }
                Mask.hide();

            }, function (error) {
                Mask.hide();
                toaster.pop('error', error.data.message);
                if (error.data.errorcode !== 1) {
                    querymanagement.errorData = error.data.message;
                }
                delete querymanagement.tableData;
                delete querymanagement.headers;
            });
        };

        querymanagement.retrieveFinalQuery = function (query) {
            Mask.show();
            return QueryManagementDao.retrieveQuery(query).then(function (response) {
                if (response !== null && response.length > 0) {
                    querymanagement.tableData = response;
                    querymanagement.headers = Object.keys(querymanagement.tableData[0]);
                    toaster.pop('success', "Query Executed Successfully");
                    querymanagement.loadQueryHistory();
                } else {
                    toaster.pop('info', "No data found");
                    delete querymanagement.tableData;
                }
                Mask.hide();
            }, function (error) {
                toaster.pop('error', error.data.message);
                if (error.data.errorcode !== 1) {
                    querymanagement.errorData = error.data.message;
                }
                delete querymanagement.tableData;
                Mask.hide();
            });
        };

        querymanagement.fetchDBLockedQueries = function () {
            querymanagement.isFetchLockedQuery = true;
            querymanagement.query = angular.copy(querymanagement.dBlockedQuery);
            querymanagement.retrieveFinalQuery(querymanagement.query);

        }
    }
    angular.module('imtecho.controllers').controller('QueryManagement', QueryManagement);
})();
