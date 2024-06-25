(function (angular) {
    function FamilyReportViewController(QueryDAO, toaster, Mask, PagingService, GeneralUtil) {
        var familyreport = this;
        familyreport.appName = GeneralUtil.getAppName();
        familyreport.reports = [];
        familyreport.printReportData = [];
        familyreport.selectedFamilyIds = [];
        familyreport.selectedLocation = null;
        familyreport.isPregnantWomen = false;
        familyreport.moreThan3children = false;
        familyreport.pagingService = PagingService.initialize();
        familyreport.imagesPath = GeneralUtil.getImagesPath();

        familyreport.retrieveAll = (reset) => {
            if (reset) {
                familyreport.pagingService.resetOffSetAndVariables();
                familyreport.reports = [];
                familyreport.allSelected = false;
            }
            let dto = {
                code: 'fhs_report_family_search',
                parameters: {
                    is_pregnant_req: familyreport.isPregnantWomen,
                    is_less_then_five_req: familyreport.moreThan3children,
                    location_id: familyreport.selectedLocationId,
                    limit: familyreport.pagingService.limit,
                    offset: familyreport.pagingService.offSet
                }
            };
            Mask.show();
            PagingService.getNextPage(QueryDAO.executeQueryForFamilyReport, dto, familyreport.reports).then((response) => {
                if (response) {
                    familyreport.reports = response;
                    if (familyreport.allSelected) {
                        familyreport.selectAll();
                    }
                }
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        };

        familyreport.retrieveFilteredReports = () => {
            familyreport.locationForm.$setSubmitted();
            if (familyreport.locationForm.$valid) {
                familyreport.toggleFilter();
                familyreport.retrieveAll(true);
            }
        };

        familyreport.toggleFilter = () => {
            if (angular.element('.filter-div').hasClass('active')) {
                angular.element('body').css("overflow", "auto");
            } else {
                angular.element('body').css("overflow", "hidden");
            }
            angular.element('.cst-backdrop').fadeToggle();
            angular.element('.filter-div').toggleClass('active');
        };

        familyreport.printReport = () => {
            if (Array.isArray(familyreport.selectedFamilyIds) && familyreport.selectedFamilyIds.length) {
                Mask.show();
                QueryDAO.execute({
                    code: 'family_report_detail',
                    parameters: {
                        family_ids: familyreport.selectedFamilyIds,
                    }
                }).then((res) => {
                    familyreport.printReportData = res.result;
                    familyreport.printReportData.forEach((report) => {
                        report.member_detail = JSON.parse(report.member_detail);
                        report.loc_details = JSON.parse(report.loc_details);
                        report.member_detailForDiseases = report.member_detail.filter((detail) => {
                            return detail.chronic_disease_detail !== null || detail.eye_issue_detail !== null || detail.current_disease_detail !== null;
                        });
                    })
                    $('#printableDiv').printThis({
                        debug: false,
                        importCSS: false,
                        loadCSS: ['styles/css/printable.css'],
                        base: "./",
                        pageTitle: familyreport.appName
                    });
                    familyreport.selectedFamilyIds = [];
                    familyreport.reports.map(report => report.isSelected = false);
                    familyreport.allSelected = false;
                }).catch((error) => {
                    GeneralUtil.showMessageOnApiCallFailure(error);
                }).finally(function () {
                    Mask.hide();
                });
            } else {
                toaster.pop('error', "Please select atleast one report to print");
            }
        };

        familyreport.changeSelection = (action) => {
            if (!action) {
                familyreport.allSelected = false;
            }
            familyreport.selectedFamilyIds = [];
            familyreport.reports.forEach((report) => {
                if (report.isSelected) {
                    familyreport.selectedFamilyIds.push(report.family_id);
                }
            });
        };

        familyreport.selectAll = () => {
            familyreport.selectedFamilyIds = [];
            if (familyreport.allSelected) {
                familyreport.reports.forEach((report) => {
                    report.isSelected = true;
                    familyreport.selectedFamilyIds.push(report.family_id);
                });
            } else {
                familyreport.reports.map((report) => report.isSelected = false);
            }
        };
    }
    angular.module('imtecho.controllers').controller('FamilyReportViewController', FamilyReportViewController);
})(window.angular);
