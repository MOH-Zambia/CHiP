(function () {
    function ReportOfflineCtrl(Mask, GeneralUtil, $rootScope, AuthenticateService,
        OfflineReportStatus, APP_CONFIG, ReportDAO,
        ServerManageDAO) {

        var reportOfflineCtrl = this;
        reportOfflineCtrl.offlineReports = [];
        reportOfflineCtrl.offlineReportStatus = OfflineReportStatus
        reportOfflineCtrl.init = () => {
            reportOfflineCtrl.apiPath = APP_CONFIG.apiPath;
            reportOfflineCtrl.authToken = $rootScope.authToken;
            Mask.show();
            AuthenticateService.getLoggedInUser().then((response) => {
                reportOfflineCtrl.currentUser = response.data;
                reportOfflineCtrl.getNumberOfDaysToDeleteFile();
                reportOfflineCtrl.retrieveOfflineReports();
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        };

        reportOfflineCtrl.getNumberOfDaysToDeleteFile = () => {
            ServerManageDAO.retrieveKeyValueBySystemKey('NUMBER_OF_DAYS_TO_DELETE_FILE_IN_OFFLINE_REPORT')
                .then(function (response) {
                    reportOfflineCtrl.noOfDays = response.keyValue;
                });
        }
        reportOfflineCtrl.retrieveOfflineReports = () => {
            Mask.show();
            ReportDAO.retrieveOfflineReportsByUserId(reportOfflineCtrl.currentUser.id).then((response) => {
                reportOfflineCtrl.offlineReports = response;
                reportOfflineCtrl.offlineReports.forEach(offlineReport => {
                    offlineReport.reportParameters = !!offlineReport.reportParameters ?
                        JSON.parse(offlineReport.reportParameters) : [];
                })
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        };

        reportOfflineCtrl.onDownloadClick = (reportOffline) => {
            Mask.show();
            ReportDAO.getFileById(reportOffline.fileId).then(res => {
                if (res.data !== null && navigator.msSaveBlob) {
                    return navigator.msSaveBlob(new Blob([res.data], { type: '' }));
                }
                var a = $("<a style='display: none;'/>");
                var url, extention;
                if (reportOffline.fileType === 'PDF') {
                    url = window.URL.createObjectURL(new Blob([res.data], { type: 'application/pdf' }));
                    extention = ".pdf";
                } else if (reportOffline.fileType === 'EXCEL') {
                    url = window.URL.createObjectURL(new Blob([res.data], { type: 'application/vnd.ms-excel' }));
                    extention = ".xlsx";
                }
                a.attr("href", url);
                a.attr("download", reportOffline.reportName + "_" + new Date().getTime() + extention);
                $("body").append(a);
                a[0].click();
                window.URL.revokeObjectURL(url);
                a.remove();
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(function () {
                Mask.hide();
            })
        }


        reportOfflineCtrl.onRefreshClick = () => {
            // Refresh all the reports
            reportOfflineCtrl.retrieveOfflineReports();
        }


        reportOfflineCtrl.init();

    }
    angular.module('imtecho.controllers').controller('ReportOfflineCtrl', ReportOfflineCtrl);
})();
