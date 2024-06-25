(function (angular) {
    function RchRegisterController(APP_CONFIG, $rootScope, RchRegister, $uibModal, QueryDAO, AuthenticateService, Mask, PagingService, GeneralUtil, $timeout, RchRegisterConstant) {
        var ctrl = this;
        ctrl.reports = [];
        ctrl.pagingService = PagingService.initialize();
        ctrl.pageVal = {};
        ctrl.preDeliveryInfo = null;
        ctrl.pncVisitInfo = null;
        ctrl.deliveryResultInfo = null;
        ctrl.pncVisitChildInfo = null;

        ctrl.accessToken = $rootScope.authToken;
        ctrl.apiPath = APP_CONFIG.apiPath;

        ctrl.currentUser = {};

        var init = function () {
            ctrl.selectedLocation = null;
            //for get logged in user data
            AuthenticateService.getLoggedInUser().then(function (res) {
                ctrl.currentUser = res.data;
                //this is for fixed header for table at initial page load
                $timeout(function () {
                    $(".header-fixed").tableHeadFixer();
                });
                ctrl.toggleFilter();
            });
            ctrl.serviceType = {
                'rch_eligible_couple_service': 'Eligible Couple Service',
                'rch_mother_service': 'Mother Service',
                'rch_child_service': 'Child Service'
            }
            ctrl.specialString = ['Zeroth', 'First', 'Second', 'Third', 'Fourth', 'Fifth', 'Sixth', 'Seventh', 'Eighth', 'Ninth', 'Tenth', 'Eleventh', 'Twelfth', 'Thirteenth', 'Fourteenth', 'Fifteenth', 'Sixteenth', 'Seventeenth', 'Eighteenth', 'Nineteenth'];
            ctrl.todayDate = new Date();
            ctrl.requiredUptoLevel = 5;
            ctrl.fetchUptoLevel = 8;
            ctrl.pageTitle = 'RCH Register';
        };

        ctrl.stringifyNumber = function (n) {
            return ctrl.specialString[n];
        }

        ctrl.resetField = function () {
            ctrl.memberserviceDtoList = [];
            ctrl.filteredTypeService = null;
            ctrl.preDeliveryInfo = null;
            ctrl.pncVisitInfo = null;
            ctrl.pncVisitChildInfo = null;
            ctrl.deliveryResultInfo = null;
        }

        ctrl.searchMemberInfo = function () {
            if (ctrl.searchForm.$invalid) {
                return;
            }
            ctrl.resetField();
            ctrl.pagingService.resetOffSetAndVariables();
            ctrl.toggleFilter();
            ctrl.retrieveMemberInfo();
        }

        ctrl.getServiceTypeOfCurrentData = function () {
            if (ctrl.selectedServiceType == RchRegisterConstant.rchChildService && !!ctrl.memberserviceDtoList) {
                ctrl.isEligibleCoupleServiceSelected = false;
                ctrl.isChildServiceSelected = true;
                ctrl.isMotherServiceSelected = false;
            } else if (ctrl.selectedServiceType == RchRegisterConstant.rchMotherService && !!ctrl.memberserviceDtoList) {
                ctrl.isEligibleCoupleServiceSelected = false;
                ctrl.isChildServiceSelected = false;
                ctrl.isMotherServiceSelected = true;
            } else if (ctrl.selectedServiceType == RchRegisterConstant.rchEligibleCouple && !!ctrl.memberserviceDtoList) {
                ctrl.isEligibleCoupleServiceSelected = true;
                ctrl.isChildServiceSelected = false;
                ctrl.isMotherServiceSelected = false;
            }
        }

        ctrl.getSelectedServiceTypeCode = function () {
            var selectedServiceTypeCode = null;
            if (ctrl.selectedServiceType == RchRegisterConstant.rchChildService) {
                selectedServiceTypeCode = 'get_rch_register_child_service_basic_info';
                ctrl.isEligibleCoupleServiceSelected = false;
                ctrl.isChildServiceSelected = true;
                ctrl.isMotherServiceSelected = false;
            } else if (ctrl.selectedServiceType == RchRegisterConstant.rchMotherService) {
                selectedServiceTypeCode = 'get_rch_register_mother_service_basic_info';
                ctrl.isEligibleCoupleServiceSelected = false;
                ctrl.isChildServiceSelected = false;
                ctrl.isMotherServiceSelected = true;
            } else if (ctrl.selectedServiceType == RchRegisterConstant.rchEligibleCouple) {
                selectedServiceTypeCode = 'get_rch_register_eligible_couple_service_basic_info';
                ctrl.isEligibleCoupleServiceSelected = true;
                ctrl.isChildServiceSelected = false;
                ctrl.isMotherServiceSelected = false;
            }
            return selectedServiceTypeCode;
        }

        ctrl.retrieveMemberInfo = function (reset) {
            Mask.show();
            if (reset) {
                ctrl.pagingService.resetOffSetAndVariables();
                ctrl.memberserviceDtoList = [];
            }
            var queryCode = ctrl.getSelectedServiceTypeCode();
            var memberDto = {
                code: queryCode,
                parameters: {
                    location_id: ctrl.selectedLocation,
                    from_date: moment(ctrl.dateFrom, "DD/MM/YYYY").format("MM/DD/YYYY"),
                    to_date: moment(ctrl.dateTo, "DD/MM/YYYY").format("MM/DD/YYYY"),
                    limit: ctrl.pagingService.limit,
                    offset: ctrl.pagingService.offSet,
                    serviceType: ctrl.selectedServiceType,
                }
            };
            PagingService.getNextPage(QueryDAO.executeQueryForFamilyReport, memberDto, ctrl.memberserviceDtoList).then(function (res) {
                if (res) {
                    ctrl.memberserviceDtoList = res;
                    ctrl.filteredTypeService = ctrl.serviceType[ctrl.selectedServiceType];
                    ctrl.getServiceTypeOfCurrentData();
                }
            }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                Mask.hide();
            });
        };

        ctrl.toggleFilter = function () {
            if (angular.element('.filter-div').hasClass('active')) {
                angular.element('body').css("overflow", "auto");
            } else {
                angular.element('body').css("overflow", "hidden");
            }
            angular.element('.cst-backdrop').fadeToggle();
            angular.element('.filter-div').toggleClass('active');
        };

        ctrl.onShowMoreDetail = function (memberDetails, index) {
            if (!memberDetails.showDetials && ctrl.selectedServiceType == RchRegisterConstant.rchMotherService) {
                Mask.show();
                var motherDto = {
                    code: 'get_rch_register_mother_service_detailed_info',
                    parameters: {
                        preg_reg_id: memberDetails.ref_id
                    }
                };

                QueryDAO.execute(motherDto).then(function (res) {
                    memberDetails.detailMemberInfo = res.result[0];

                    //Previous Pregnancy Details
                    if (!!memberDetails.detailMemberInfo.previous_pregnancy_details_json)
                        memberDetails.preDeliveryDetailsInfo = JSON.parse(memberDetails.detailMemberInfo.previous_pregnancy_details_json);

                    //Pre-Delivery Care
                    if (!!memberDetails.detailMemberInfo.pre_delivery_care_json)
                        memberDetails.preDeliveryCareInfo = JSON.parse(memberDetails.detailMemberInfo.pre_delivery_care_json);

                    //Delivery Result
                    if (!!memberDetails.detailMemberInfo.delivery_result_json)
                        memberDetails.deliveryResultInfo = JSON.parse(memberDetails.detailMemberInfo.delivery_result_json);

                    //PNC Visit
                    if (!!memberDetails.detailMemberInfo.pnc_visit_json)
                        memberDetails.pncVisitInfo = JSON.parse(memberDetails.detailMemberInfo.pnc_visit_json);

                    _.each(memberDetails.pncVisitInfo, function (item, pncIndex) {
                        if (!!item.child_pnc_dto) {
                            memberDetails.pncVisitInfo[pncIndex].childPncDto = JSON.parse(item.child_pnc_dto);
                        }
                    })
                }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                    Mask.hide();
                });
            } else if (!memberDetails.showDetials && ctrl.selectedServiceType == RchRegisterConstant.rchChildService) {
                Mask.show();
                let queryDto = {
                    code: 'get_rch_register_child_service_detailed_info',
                    parameters: {
                        member_id: memberDetails.member_id
                    }
                };
                QueryDAO.execute(queryDto).then(function (res) {
                    memberDetails.detailMemberInfo = res.result[0];
                    if (!!memberDetails.detailMemberInfo.vitamin_a_dose)
                        memberDetails.vitaminADose = memberDetails.detailMemberInfo.vitamin_a_dose.split(',');
                }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                    Mask.hide();
                });
            } else if (!memberDetails.showDetials && ctrl.selectedServiceType == RchRegisterConstant.rchEligibleCouple) {
                Mask.show();
                let queryDto = {
                    code: 'get_rch_register_eligible_couple_service_detailed_info',
                    parameters: {
                        member_id: memberDetails.member_id,
                        from_date: moment(ctrl.dateFrom, "DD/MM/YYYY").format("MM/DD/YYYY"),
                        to_date: moment(ctrl.dateTo, "DD/MM/YYYY").format("MM/DD/YYYY"),
                    }
                };
                QueryDAO.execute(queryDto).then(function (res) {
                    memberDetails.detailMemberInfo = res.result[0];
                    memberDetails.lmpVisitInfo = JSON.parse(memberDetails.detailMemberInfo.lmp_visit_info);
                }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                    Mask.hide();
                });
            }
            memberDetails.showDetials = !memberDetails.showDetials;
            //for scrolling the details after selected row
            $('html, tbody').animate({
                scrollTop: $('.table .cst-tbody').find('tr').eq(index * 2).offset().top
            }, 800);
        };

        ctrl.printPdf = function () {
            if (!!ctrl.selectedServiceType && ctrl.memberserviceDtoList) {
                let modalInstanceProperties = {
                    windowClass: 'cst-modal',
                    backdrop: 'static',
                    size: 'md',
                    templateUrl: 'app/manage/rchregister/views/rch-register-pdf-download.html',
                    controllerAs: 'downloadpdfctrl',
                    controller: function ($uibModalInstance) {
                        let downloadpdfctrl = this;
                        downloadpdfctrl.selectedPDFLanguage;
                        downloadpdfctrl.ok = function () {
                            downloadpdfctrl.PDFDownloadForm.$setSubmitted();
                            if (downloadpdfctrl.PDFDownloadForm.$valid) {
                                Mask.show();
                                var queryDto = {
                                    code: ctrl.getSelectedServiceTypeCode(),
                                    parameters: {
                                        location_id: ctrl.selectedLocation,
                                        from_date: moment(ctrl.dateFrom, "DD/MM/YYYY").format("MM/DD/YYYY"),
                                        to_date: moment(ctrl.dateTo, "DD/MM/YYYY").format("MM/DD/YYYY"),
                                        limit: null,
                                        offset: 0,
                                        serviceType: ctrl.selectedServiceType,
                                        languageCode: downloadpdfctrl.selectedPDFLanguage
                                    }
                                };
                                RchRegister.downloadPdf(queryDto).then(function (res) {
                                    if (res.data !== null && navigator.msSaveBlob) {
                                        return navigator.msSaveBlob(new Blob([res.data], { type: "application/pdf;charset=UTF-8'" }));
                                    }
                                    var a = $("<a style='display: none;'/>");
                                    var url = window.URL.createObjectURL(new Blob([res.data], { type: "application/pdf;charset=UTF-8'" }));
                                    a.attr("href", url);
                                    a.attr("download", ctrl.selectedServiceType + "_" + new Date().getTime() + ".pdf");
                                    $("body").append(a);
                                    a[0].click();
                                    window.URL.revokeObjectURL(url);
                                    a.remove();

                                    downloadpdfctrl.PDFDownloadForm.$setPristine();
                                }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                                    Mask.hide();
                                    $uibModalInstance.dismiss('cancel');
                                });
                            }
                        };
                        downloadpdfctrl.cancel = function () {
                            $uibModalInstance.dismiss('cancel');
                            downloadpdfctrl.PDFDownloadForm.$setPristine();
                        };
                    },
                    resolve: {}
                };
                let modalInstance = $uibModal.open(modalInstanceProperties);
                modalInstance.result.then(function () { }, function () { });
            }
        }

        ctrl.printExcel = function () {
            if (!!ctrl.selectedServiceType && ctrl.memberserviceDtoList) {
                Mask.show();
                var queryDto = {
                    code: ctrl.getSelectedServiceTypeCode(),
                    parameters: {
                        location_id: ctrl.selectedLocation,
                        from_date: moment(ctrl.dateFrom, "DD/MM/YYYY").format("MM/DD/YYYY"),
                        to_date: moment(ctrl.dateTo, "DD/MM/YYYY").format("MM/DD/YYYY"),
                        limit: null,
                        offset: 0,
                        serviceType: ctrl.selectedServiceType,
                    }
                };
                RchRegister.downloadExcel(queryDto).then(function (res) {
                    if (res.data !== null && navigator.msSaveBlob) {
                        return navigator.msSaveBlob(new Blob([res.data], { type: '' }));
                    }
                    var a = $("<a style='display: none;'/>");
                    var url = window.URL.createObjectURL(new Blob([res.data], { type: 'application/vnd.ms-excel' }));
                    a.attr("href", url);
                    a.attr("download", ctrl.selectedServiceType + "_" + new Date().getTime() + ".xlsx");
                    $("body").append(a);
                    a[0].click();
                    window.URL.revokeObjectURL(url);
                    a.remove();

                }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                    Mask.hide();
                });
            }
        }

        init();
    }
    angular.module('imtecho.controllers').controller('RchRegisterController', RchRegisterController);
})(window.angular);
