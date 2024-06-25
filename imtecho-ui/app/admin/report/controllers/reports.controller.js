(function (angular) {
    function ReportController(ReportDAO, $state, $uibModal, GroupDAO, Mask, PagingService, APP_CONFIG, $sessionStorage, QueryDAO, syncWithServerService) {
        var report = this;
        var paramsToPass = {
            offset: ' ',
            limit: ' ',
            reportName: ' ',
            sortBy:' ',
            sortOn:' '

        };

        var init = function () {
            report.reports = [];
            report.propertyName = 'menuType'
            report.menuTypes = APP_CONFIG.menuTypes;
            report.order = 'updatedOn';
            report.sortBy = '';
            report.pagingService = PagingService.initialize();

            if ($state.params.groupId) {
                report.parentGroupId = Number($state.params.groupId);
            }
            if ($state.params.subGroupId) {
                report.subGroupId = Number($state.params.subGroupId);
            }
            if ($state.params.reportName) {
                report.reportName = $state.params.reportName;
                report.parentGroupId = null;
                report.subGroupId = null;
            }
            report.retrieveAll(true);
        };

        report.retrieveAll = function (reset) {
            Mask.show();
            if (reset) {
                report.pagingService.resetOffSetAndVariables();
            }
            paramsToPass.limit = report.pagingService.limit;
            paramsToPass.offset = report.pagingService.offSet;
            paramsToPass.reportName = report.reportName;
            paramsToPass.parentGroupId = report.parentGroupId;
            paramsToPass.subGroupId = report.subGroupId;
            paramsToPass.menuType = report.menuType;
            paramsToPass.sortBy  = report.sortBy;
            paramsToPass.sortOn  = report.sortParam;

            PagingService.getNextPage(ReportDAO.getReports, paramsToPass, report.reports).then(function (res) {
                report.reports = res;
                //The directive code is not working so manually written
                report.reports.forEach(function (report) {
                    var state = 'techo.report.view/{"id":"' + report.uuid + '","queryParams":null}';
                    var configState = 'techo.report.config/{"id":"' + report.uuid + '"}';
                    if ($sessionStorage.asldkfjlj) {
                        $sessionStorage.asldkfjlj[state] = true;
                        $sessionStorage.asldkfjlj[configState] = true;
                    } else {
                        $sessionStorage.asldkfjlj = {};
                        $sessionStorage.asldkfjlj[state] = true;
                        $sessionStorage.asldkfjlj[configState] = true;
                    }
                });
                Mask.hide();
            });
        };

        report.retrieveFilteredReports = function () {
            report.retrieveAll(true);
        };

        report.syncWithServer = function (ReportDetails) {
            report.syncModel = syncWithServerService.syncWithServer(ReportDetails.uuid);
        }

        report.navigateToState = function (reportObject) {
            let url = $state.href('techo.report.view', { "id": "" + reportObject.uuid + "", "queryParams": null });
            window.open(url, '_blank');
        }

        report.deleteGroupModal = function (uuid) {
            var modalInstance = $uibModal.open({
                templateUrl: 'app/common/views/confirmation.modal.html',
                controller: 'ConfirmModalController',
                windowClass: 'cst-modal',
                size: 'med',
                resolve: {
                    message: function () {
                        return "Are you sure you want to delete this report?";
                    }
                }
            });
            modalInstance.result.then(function () {
                Mask.show();
                ReportDAO.deleteReport({ id: uuid }).then(function (res) {
                    report.retrieveFilteredReports();
                }).catch(function () {
                }).then(function () {
                    Mask.hide();
                });
            }, function () {
            });
        };

        report.parentGroupChanged = function (parentId) {
            if (parentId != null) {
                report.subGroup = [];
                angular.forEach(report.copyOfSubGroup, function (itr) {
                    if (itr.parentGroup === parentId) {
                        report.subGroup.push(itr);
                    }
                });
            } else {
                report.subGroupId = null;
                report.subGroup = angular.copy(report.copyOfSubGroup);
            }
        };

        report.subGroupChanged = function (subGroupId) {
            if (subGroupId !== null) {
                angular.forEach(report.copyOfSubGroup, function (itr) {
                    if (itr.id === subGroupId) {
                        report.parentGroupId = itr.parentGroup;
                    }
                });
            }
            report.parentGroupChanged(report.parentGroupId);
        };

        report.toggleFilter = function () {
            if (angular.element('.filter-div').hasClass('active')) {
                angular.element('body').css("overflow", "auto");
            } else {
                angular.element('body').css("overflow", "hidden");
            }
            angular.element('.cst-backdrop').fadeToggle();
            angular.element('.filter-div').toggleClass('active');
        };

        report.onMenuTypeChange = function () {
            Mask.show();
            GroupDAO.getReportGroups({ groupType: report.menuType, subGroupRequired: true }).then(function (res) {
                var parentGroup = [];
                report.subGroup = [];
                angular.forEach(res, function (itr) {
                    if (angular.isDefined(itr.parentGroup)) {
                        report.subGroup.push(itr);
                    } else {
                        parentGroup.push(itr);
                    }
                });
                report.parentGroup = parentGroup;
                report.copyOfSubGroup = angular.copy(report.subGroup);
                if (report.subGroupId !== null) {
                    report.subGroupChanged(report.subGroupId);
                }
            }).finally(function () {
                Mask.hide();
            });
        };

        report.sortBy = function (propertyName) {
            report.reverse = (report.propertyName === propertyName) ? !report.reverse : false;
            report.propertyName = propertyName;
        };

        report.sortByField = function (fieldName) {
            report.sortBy = fieldName;
            report.order = fieldName;
            if (report.sortOrder === 'asc') {
                report.sortOrder = 'desc';
            } else {
                report.sortOrder = 'asc';
            }
            report.sortParam = report.sortOrder;
            report.retrieveFilteredReports();
        };

        report.generateFlyway = function (reportObj) {
            var modalInstance = $uibModal.open({
                templateUrl: 'app/admin/report/views/show-flyway-query.modal.html',
                controller: 'ShowReportFlywayQueryController',
                windowClass: 'cst-modal',
                controllerAs: 'mdctrl',
                size: 'xl',
                resolve: {
                    reportObj: function () {
                        return reportObj;
                    }
                }
            });
            modalInstance.result.then(function () {
            });
        }

        init();
    }
    angular.module('imtecho.controllers').controller('ReportController', ReportController);
})(window.angular);

(function () {
    function ShowFlywayQueryController(reportObj, $uibModalInstance,$uibModal, toaster) {
        var mdctrl = this;
        mdctrl.reportObj = reportObj;

        mdctrl.init = function () {
            mdctrl.isPublicKeyword = false;
            mdctrl.text = '';
            if (mdctrl.reportObj.configJson.containers.fieldsContainer.length > 0) {
                mdctrl.reportObj.configJson.containers.fieldsContainer.forEach(function (field) {
                    if ((field.queryUUIDForParam !== undefined && field.queryUUIDForParam !== null) || (field.queryUUID !== undefined && field.queryUUID !== null)) {
                        // if (!mdctrl.isPublicKeyword && field.queryForParam !== undefined && field.queryForParam !== null) {
                        //     mdctrl.isPublicKeyword = field.queryForParam.includes('public');
                        // }
                        if (field.queryUUIDForParam !== undefined && field.queryUUIDForParam !== null)
                        mdctrl.text += 'DELETE FROM REPORT_QUERY_MASTER WHERE uuid = \'' + field.queryUUIDForParam + '\';';
                        else
                        mdctrl.text += 'DELETE FROM REPORT_QUERY_MASTER WHERE uuid = \'' + field.queryUUID + '\';';
                        mdctrl.text += '\n';
                        mdctrl.text += '\n';
                        mdctrl.text += 'INSERT INTO REPORT_QUERY_MASTER(created_by, created_on, modified_by, modified_on, query, returns_result_set, state, uuid) ';
                        mdctrl.text += '\n';
                        mdctrl.text += 'VALUES ( ';
                        mdctrl.text += '\n';
                        mdctrl.text += mdctrl.reportObj.createdBy + ', ';
                        mdctrl.text += ' current_date ' + ', ';
                        mdctrl.text += mdctrl.reportObj.createdBy + ', ';
                        mdctrl.text += ' current_date ' + ', ';
                        if (field.queryUUIDForParam !== undefined && field.queryUUIDForParam !== null)
                        {
                            if (field.queryForParam === undefined || field.queryForParam === null) {
                                mdctrl.text += 'null, ';
                            } else {
                                mdctrl.text += '\'' + field.queryForParam.replace(/[']/g, "''") + '\'' + ', ';
                            }
                        }
                        else {
                            if (field.query === undefined || field.query === null) {
                                mdctrl.text += 'null, ';
                            } else {
                                mdctrl.text += '\'' + field.query.replace(/[']/g, "''") + '\'' + ', ';
                            }
                        }
                        mdctrl.text += 'true, \'ACTIVE\', '
                        if (field.queryUUIDForParam !== undefined && field.queryUUIDForParam !== null)
                        mdctrl.text +=  '\'' + field.queryUUIDForParam + '\'' + ');';
                        else
                        mdctrl.text +=  '\'' + field.queryUUID + '\'' + ');';
                        mdctrl.text += '\n';
                        mdctrl.text += '\n';
                    }
                });
            }
            if (mdctrl.reportObj.configJson.containers.tableContainer.length > 0) {
                mdctrl.reportObj.configJson.containers.tableContainer.forEach(function (field) {
                    if (!mdctrl.isPublicKeyword) {
                        mdctrl.isPublicKeyword = field.query.includes('public');
                    }
                    mdctrl.text += 'DELETE FROM REPORT_QUERY_MASTER WHERE uuid = \'' + field.queryUUID + '\';';
                    mdctrl.text += '\n';
                    mdctrl.text += '\n';
                    mdctrl.text += 'INSERT INTO REPORT_QUERY_MASTER(created_by, created_on, modified_by, modified_on, params, query, returns_result_set, state, uuid) ';
                    mdctrl.text += '\n';
                    mdctrl.text += 'VALUES ( ';
                    mdctrl.text += '\n';
                    mdctrl.text += mdctrl.reportObj.createdBy + ', ';
                    mdctrl.text += ' current_date ' + ', ';
                    mdctrl.text += mdctrl.reportObj.createdBy + ', ';
                    mdctrl.text += ' current_date ' + ', ';
                    if (field.queryParams === undefined || field.queryParams === null) {
                        mdctrl.text += 'null, ';
                    } else {
                        mdctrl.text += '\'' + field.queryParams + '\'' + ', ';
                    }
                    mdctrl.text += '\'' + field.query.replace(/[']/g, "''") + '\'' + ', ';
                    mdctrl.text += 'true, \'ACTIVE\', '
                    mdctrl.text +=  '\'' + field.queryUUID + '\'' + ');';
                    mdctrl.text += '\n';
                    mdctrl.text += '\n';
                });
            }
            mdctrl.text += 'DELETE FROM REPORT_MASTER WHERE uuid =\'' + mdctrl.reportObj.uuid + '\';';
            mdctrl.text += '\n';
            mdctrl.text += '\n';
            mdctrl.text += 'INSERT INTO REPORT_MASTER(report_name, file_name, active, report_type, modified_on, created_by, created_on, modified_by, config_json, code, uuid)'
            mdctrl.text += '\n';
            mdctrl.text += 'VALUES ( ';
            mdctrl.text += '\n';
            mdctrl.text += '\'' + mdctrl.reportObj.name.replace(/[']/g, "''") + '\'' + ', ';
            if (mdctrl.reportObj.fileName === undefined || mdctrl.reportObj.fileName === null) {
                mdctrl.text += ' null, ';
            } else {
                mdctrl.text += '\'' + mdctrl.reportObj.fileName + '\', ';
            }
            mdctrl.text += ' true, ';
            mdctrl.text += '\'' + mdctrl.reportObj.reportType + '\'' + ', ';
            mdctrl.text += ' current_date ' + ', ';
            mdctrl.text += mdctrl.reportObj.createdBy + ', ';
            mdctrl.text += ' current_date ' + ', ';
            mdctrl.text += mdctrl.reportObj.createdBy + ', ';
            mdctrl.text += '\'' + JSON.stringify(mdctrl.reportObj.configJson).replace(/[']/g, "''") + '\', ';
            mdctrl.text += '\'' + mdctrl.reportObj.code + '\', ';
            mdctrl.text += '\'' + mdctrl.reportObj.uuid + '\' ';
            mdctrl.text += ');';
        }

        mdctrl.copyQuery = function () {
            const selBox = document.createElement('textarea');
            selBox.style.position = 'fixed';
            selBox.style.left = '0';
            selBox.style.top = '0';
            selBox.style.opacity = '0';
            selBox.value = mdctrl.text;
            document.body.appendChild(selBox);
            selBox.focus();
            selBox.select();
            document.execCommand('copy');
            document.body.removeChild(selBox);
            $uibModalInstance.close();
            toaster.pop('success', 'Query Copied');
        };

        mdctrl.askForConfirmation = function(){
            var modalInstance = $uibModal.open({
                templateUrl: 'app/common/views/confirmation.modal.html',
                controller: 'ConfirmModalController',
                windowClass: 'cst-modal',
                size: 'med',
                resolve: {
                    message: function () {
                        return "This Flyway contains keyword 'public'. Are You sure want to download?";
                    }
                }
            });
            modalInstance.result.then(function () {
                mdctrl.download();
            },function(){});
        }

        mdctrl.downloadCheckForPublicKeyword = function(){
            if(mdctrl.isPublicKeyword== true){
                mdctrl.askForConfirmation();
            }
            else{
                mdctrl.download();
            }
        }

        mdctrl.download = function () {
            var a = window.document.createElement('a');
            a.href = window.URL.createObjectURL(new Blob([mdctrl.text], { type: 'text/plain' }));
            var name = "V" + new Date().getTime() + "__CHANGE_IN_" + mdctrl.reportObj.code + '.sql';
            a.download = name;
            document.body.appendChild(a);
            a.click();
            document.body.removeChild(a);
            $uibModalInstance.close();
        };

        mdctrl.cancel = function () {
            $uibModalInstance.close();
        };

        mdctrl.init();
    }
    angular.module('imtecho.controllers').controller('ShowReportFlywayQueryController', ShowFlywayQueryController);
})();
