(function () {
    let search = function (QueryDAO, SEARCH_TERM, $uibModal, $q, toaster,GeneralUtil) {
        return {
            restrict: 'E',
            scope: {
                terms: "<?",
                memberType: "<?",
                searchFn: "&",
                closeFn: "&",
                searchForm: "=",
                search: "=",
                selectedLocation: "=?",
                selectedLocationId: "=?"
            },
            templateUrl: 'app/common/directives/search/search-template.html',
            link: function ($scope, element, attrs) {
                const init = function () {

                    $scope.env = GeneralUtil.getEnv();
                    if (!$scope.memberType) {
                        $scope.memberType = [];
                    }

                    $scope.selectedIndex = null;

                    $scope.clearFilters = function(){
                        $scope.search = {};
                        $scope.searchForm.$setPristine()
                    }
    
                    $scope.minPhoneNoLength = $scope.env === 'imomcare'? 9 : 10;
                    $scope.baseTerms = [
                        { name: SEARCH_TERM.memberId, value: 'member id', order: 1, config: {}, searchFor: $scope.memberType },
                        { name: SEARCH_TERM.familyId, value: 'family id', order: 2, config: {}, searchFor: $scope.memberType },
                        { name: SEARCH_TERM.mobileNumber, value: 'mobile number', order: 3, config: { minlength: $scope.minPhoneNoLength, maxlength: 10 }, searchFor: $scope.memberType },
                        { name: SEARCH_TERM.location, value: 'location', order: 4, config: {}, searchFor: $scope.memberType },
                        { name: SEARCH_TERM.villageName, value: 'village name', order: 5, config: {}, searchFor: $scope.memberType },
                        { name: SEARCH_TERM.name, value: 'name', order: 6, config: {}, searchFor: $scope.memberType },
                        { name: SEARCH_TERM.lmp, value: 'lmp', order: 7, config: {}, searchFor: $scope.memberType },
                        { name: SEARCH_TERM.edd, value: 'edd', order: 8, config: {}, searchFor: $scope.memberType },
                        // { name: SEARCH_TERM.maaVatsalya, value: 'maaVatsalya', order: 11, config: {}, searchFor: $scope.memberType },
                        { name: SEARCH_TERM.dob, value: 'dob', order: 12, config: {}, searchFor: $scope.memberType },
                        { name: SEARCH_TERM.username, value: 'username', order: 15, config: {}, searchFor: $scope.memberType },
                        { name: SEARCH_TERM.contactNumber, value: 'contact number', order: 15, config: {}, searchFor: $scope.memberType }
                    ];

                    if (!$scope.terms) {
                        $scope.terms = [];
                    }

                    if (!$scope.searchForm) {
                        $scope.searchForm = {};
                    }

                    if (!$scope.selectedLocation) {
                        $scope.selectedLocation = {}
                    }

                    if (!$scope.selectedLocationId) {
                        $scope.selectedLocationId = ''
                    }

                    $scope.filteredLabels = [];

                    if ($scope.terms.length > 0) {
                        $scope.filterTerms();
                    }

                    if ($scope.terms.length === 0 || $scope.filteredLabels.length === 0) {
                        $scope.filteredLabels = $scope.baseTerms;
                    }

                    if ($scope.filteredLabels.length > 1) {
                        $scope.filteredLabels = $scope.filteredLabels.sort($scope.compareOrder)
                    }

                }

                $scope.locationSelectizeWpd = {
                    create: false,
                    valueField: 'id',
                    labelField: 'hierarchy',
                    dropdownParent: 'body',
                    highlight: true,
                    searchField: ['_searchField'],
                    maxItems: 1,
                    render: {
                        item: function (location, escape) {
                            let returnString = "<div>" + location.hierarchy + "</div>";
                            return returnString;
                        },
                        option: function (location, escape) {
                            let returnString = "<div>" + location.hierarchy + "</div>";
                            return returnString;
                        }
                    },
                    onFocus: function () {
                        this.onSearchChange("");
                    },
                    onBlur: function () {
                        let selectize = this;
                        let value = this.getValue();
                        setTimeout(function () {
                            if (!value) {
                                selectize.clearOptions();
                                selectize.refreshOptions();
                            }
                        }, 200);
                    },
                    load: function (query, callback) {
                        let selectize = this;
                        let value = this.getValue();
                        if (!value) {
                            selectize.clearOptions();
                            selectize.refreshOptions();
                        }
                        let promise;
                        let queryDto = {
                            code: 'location_search_for_web',
                            parameters: {
                                locationString: query,
                            }
                        };
                        if (query !== null && query !== '') {
                            promise = QueryDAO.execute(queryDto);
                            promise.then(function (res) {
                                angular.forEach(res.result, function (result) {
                                    result._searchField = query;
                                });
                                callback(res.result);
                            }, function () {
                                callback();
                            });
                        }
                    }
                }

                $scope.$watch('selectedLocation', function (newValue) {
                    $scope.selectedLocationId = newValue['locationId'];
                }, true)

                $scope.$watch('search.searchFor', function (newValue) {
                    if (newValue != undefined) {
                        $scope.filteredLabels = [];
                        if ($scope.terms.length === 0) {
                            $scope.filteredLabels = $scope.baseTerms;
                        } else {
                            $scope.filterTerms();
                        }
                        $scope.filteredLabels = $scope.filteredLabels.filter(label => label.searchFor.includes($scope.search.searchFor))
                        if ($scope.filteredLabels.length > 1) {
                            $scope.filteredLabels.sort($scope.compareOrder)
                        }
                        $scope.search.searchBy = null
                        $scope.resetSearchString()
                    }
                }, true)

                $scope.$watch('search.searchBy', function (newValue) {
                    if (newValue != undefined && newValue != null) {
                        $scope.selectedIndex = $scope.filteredLabels.map(label => label.value).indexOf(newValue);
                    } else {
                        $scope.selectedIndex = null;
                    }
                })

                $scope.compareOrder = (a, b) => {
                    if (a.order < b.order) {
                        return -1
                    } else if (a.order > b.order) {
                        return 1
                    } else {
                        return 0
                    }
                }

                $scope.filterTerms = () => {
                    $scope.baseTerms.forEach(baseTerm => {
                        $scope.terms.forEach(term => {
                            if (baseTerm.name === term.name) {
                                if (term.order != undefined) {
                                    baseTerm.order = term.order;
                                }
                                if (term.config != undefined) {
                                    baseTerm.config = term.config;
                                }
                                if (term.searchFor != undefined) {
                                    baseTerm.searchFor = term.searchFor;
                                }
                                $scope.filteredLabels.push(baseTerm);
                            }
                        });
                    });
                }

                $scope.resetSearchString = () => {
                    if ($scope.search.searchString != null) {
                        $scope.search.searchString = null;
                    }
                    $scope.search.familyMobileNumber = null;
                    $scope.selectedLocation = {};
                    $scope.searchForm.$setPristine()
                };

                // $scope.validateAbhaNumber = (healthIdNumber) => {
                //     if (healthIdNumber != undefined) {
                //         let newValue = healthIdNumber.split('-').join('').slice(2);
                //         let finalValue = healthIdNumber.slice(0, 2);

                //         if (newValue.length > 0) {
                //             newValue = newValue.match(new RegExp('.{1,4}', 'g')).join('-');
                //             finalValue = finalValue + '-' + newValue;
                //             if (finalValue.length >= 17) {
                //                 $scope.search.searchString = healthIdNumber.slice(0, 17);
                //                 $scope.searchForm['abhaNumber'].$setValidity("healthid", true);
                //             } else {
                //                 $scope.search.searchString = finalValue;
                //                 $scope.searchForm['abhaNumber'].$setValidity("healthid", false);
                //             }
                //         }
                //     }
                // }

                // Pass the required validation through resolve if it is required to be implemented globally 
                $scope.webcam = function () {

                    let defer = $q.defer();

                    $uibModal.open({
                        windowClass: 'cst-modal',
                        backdrop: 'static',
                        keyboard: false,
                        size: 'm',
                        templateUrl: 'app/common/views/qr-code-scan.modal.html',
                        controller: 'QRCodeScanModalController',
                        resolve: {
                            validInput: function () {
                                return ''
                            }
                        }
                    }).result.then(function (data) {
                        defer.resolve();
                    }, function () {
                        defer.reject();
                    });
                    return defer.promise;
                }

                init();
            }
        }
    };

    angular.module('imtecho.directives').directive('search', search);
})();