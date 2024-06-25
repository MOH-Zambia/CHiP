(function () {
    let daterangepicker = function ($templateCache) {
        return {
            restrict: 'AE',
            scope: {
                ngDisabled: "=",
                ngModel: '=',
                minDate: '=',
                maxDate: '=',
                ngRequired: '=?',
                dateRangeOptions: '=',
                dateRangeType: '&',
                showCustomRangeLabel: '='
            },
            replace: true,
            template: $templateCache.get('app/common/directives/daterangepicker/daterangepicker.html'),
            link: function (scope, element, attrs) {
                scope.isOpen = false;
                scope.ngModel = {
                    startDate: null,
                    endDate: null
                }
                scope.options = {
                    locale: {
                        format: "DD/MM/YYYY"
                    },
                    label: "Select Date Range",
                    opens: "left",
                    drops: "down",
                    showCustomRangeLabel: false,
                    separator: " / "
                }

                scope.$watch("ngModel", function (newVal) {
                    if (newVal) {
                        let fromDate = moment(newVal.startDate).startOf('day');
                        let toDate = moment(newVal.endDate).endOf('day');

                        if (scope.options?.ranges?.hasOwnProperty('Last Week')
                            && scope.options.ranges['Last Week'][0].isSame(moment(fromDate))
                            && scope.options.ranges['Last Week'][1].isSame(toDate)) {
                            scope.dateRangeType({ dateRangeType: 'Last Week' });
                        }
                        else if (scope.options?.ranges?.hasOwnProperty('Last Month')
                            && scope.options.ranges['Last Month'][0].isSame(fromDate)
                            && scope.options.ranges['Last Month'][1].isSame(toDate)) {
                            scope.dateRangeType({ dateRangeType: 'Last Month' });
                        }
                        else if (scope.options?.ranges?.hasOwnProperty('Last Year')
                            && scope.options.ranges['Last Year'][0].isSame(fromDate)
                            && scope.options.ranges['Last Year'][1].isSame(toDate)) {
                            scope.dateRangeType({ dateRangeType: 'Last Year' });
                        }
                        else if (scope.options?.ranges?.hasOwnProperty('Current Financial Year')
                            && scope.options.ranges['Current Financial Year'][0].isSame(fromDate)
                            && scope.options.ranges['Current Financial Year'][1].isSame(toDate)) {
                            scope.dateRangeType({ dateRangeType: 'Current Financial Year' });
                        }
                        else if (scope.options?.ranges?.hasOwnProperty('Quarter 1 (Current F.Y.)')
                            && scope.options.ranges['Quarter 1 (Current F.Y.)'][0].isSame(fromDate)
                            && scope.options.ranges['Quarter 1 (Current F.Y.)'][1].isSame(toDate)) {
                            scope.dateRangeType({ dateRangeType: 'Quarter 1 (Current F.Y.)' });
                        }
                        else if (scope.options?.ranges?.hasOwnProperty('Quarter 2 (Current F.Y.)')
                            && scope.options.ranges['Quarter 2 (Current F.Y.)'][0].isSame(fromDate)
                            && scope.options.ranges['Quarter 2 (Current F.Y.)'][1].isSame(toDate)) {
                            scope.dateRangeType({ dateRangeType: 'Quarter 2 (Current F.Y.)' });
                        }
                        else if (scope.options?.ranges?.hasOwnProperty('Quarter 3 (Current F.Y.)')
                            && scope.options.ranges['Quarter 3 (Current F.Y.)'][0].isSame(fromDate)
                            && scope.options.ranges['Quarter 3 (Current F.Y.)'][1].isSame(toDate)) {
                            scope.dateRangeType({ dateRangeType: 'Quarter 3 (Current F.Y.)' });
                        }
                        else if (scope.options?.ranges?.hasOwnProperty('Quarter 4 (Current F.Y.)')
                            && scope.options.ranges['Quarter 4 (Current F.Y.)'][0].isSame(fromDate)
                            && scope.options.ranges['Quarter 4 (Current F.Y.)'][1].isSame(toDate)) {
                            scope.dateRangeType({ dateRangeType: 'Quarter 4 (Current F.Y.)' });
                        }
                        else if (scope.options?.ranges?.hasOwnProperty('Current Academic Year')
                            && scope.options.ranges['Current Academic Year'][0].isSame(fromDate)
                            && scope.options.ranges['Current Academic Year'][1].isSame(toDate)) {
                            scope.dateRangeType({ dateRangeType: 'Current Academic Year' });
                        }
                        else if (scope.options?.ranges?.hasOwnProperty('Quarter 1 (Current A.Y.)')
                            && scope.options.ranges['Quarter 1 (Current A.Y.)'][0].isSame(fromDate)
                            && scope.options.ranges['Quarter 1 (Current A.Y.)'][1].isSame(toDate)) {
                            scope.dateRangeType({ dateRangeType: 'Quarter 1 (Current A.Y.)' });
                        }
                        else if (scope.options?.ranges?.hasOwnProperty('Quarter 2 (Current A.Y.)')
                            && scope.options.ranges['Quarter 2 (Current A.Y.)'][0].isSame(fromDate)
                            && scope.options.ranges['Quarter 2 (Current A.Y.)'][1].isSame(toDate)) {
                            scope.dateRangeType({ dateRangeType: 'Quarter 2 (Current A.Y.)' });
                        }
                        else if (scope.options?.ranges?.hasOwnProperty('Quarter 3 (Current A.Y.)')
                            && scope.options.ranges['Quarter 3 (Current A.Y.)'][0].isSame(fromDate)
                            && scope.options.ranges['Quarter 3 (Current A.Y.)'][1].isSame(toDate)) {
                            scope.dateRangeType({ dateRangeType: 'Quarter 3 (Current A.Y.)' });
                        }
                        else if (scope.options?.ranges?.hasOwnProperty('Quarter 4 (Current A.Y.)')
                            && scope.options.ranges['Quarter 4 (Current A.Y.)'][0].isSame(fromDate)
                            && scope.options.ranges['Quarter 4 (Current A.Y.)'][1].isSame(toDate)) {
                            scope.dateRangeType({ dateRangeType: 'Quarter 4 (Current A.Y.)' });
                        }
                        else {
                            scope.dateRangeType({ dateRangeType: null });
                        }
                    };
                });

                scope.$watch('showCustomRangeLabel', function(newVal) {
                    if(newVal) {
                        scope.options.showCustomRangeLabel = newVal;
                    }
                })

                scope.$watch('minDate', function (newVal) {
                    if (newVal) {
                        scope.options.minDate = scope.minDate;
                    }
                });
                scope.$watch('maxDate', function (newVal) {
                    if (newVal) {
                        scope.options.maxDate = scope.maxDate;
                    }
                });

                scope.$watch('dateRangeOptions', function (newVal) {
                    if (newVal && Object.keys(newVal).length > 0) {
                        scope.options.ranges = {};
                        if (newVal.isLastWeek) {
                            scope.options.ranges['Last Week'] = [moment().startOf('day').subtract(6, 'days'), moment().endOf('day')]
                        }
                        if (newVal.isLastMonth) {
                            scope.options.ranges['Last Month'] = [moment().startOf('day').subtract(1, 'month'), moment().endOf('day')]
                        }
                        if (newVal.isLastYear) {
                            scope.options.ranges['Last Year'] = [moment().startOf('day').subtract(1, 'year'), moment().endOf('day')]
                        }
                        if (newVal.isFinancialYear) {
                            if (moment().month() < 3) {
                                scope.options.ranges['Current Financial Year'] = [moment().subtract(1, 'year').startOf('year').month(3).date(1), moment().startOf('year').month(2).date(31).endOf('day')];
                            }
                            else {
                                scope.options.ranges['Current Financial Year'] = [moment().startOf('year').month(3).date(1), moment().add(1, 'year').startOf('year').month(2).date(31).endOf('day')];
                            }
                        }
                        if (newVal.isFinancialYearQuarters) {
                            if (moment().month() < 3) {
                                scope.options.ranges['Quarter 1 (Current F.Y.)'] = [moment().subtract(1, 'year').startOf('year').month(3).date(1), moment().subtract(1, 'year').startOf('year').month(5).date(30).endOf('day')];
                                scope.options.ranges['Quarter 2 (Current F.Y.)'] = [moment().subtract(1, 'year').startOf('year').month(6).date(1), moment().subtract(1, 'year').startOf('year').month(8).date(30).endOf('day')];
                                scope.options.ranges['Quarter 3 (Current F.Y.)'] = [moment().subtract(1, 'year').startOf('year').month(9).date(1), moment().subtract(1, 'year').startOf('year').month(11).date(31).endOf('day')];
                                scope.options.ranges['Quarter 4 (Current F.Y.)'] = [moment().startOf('year').month(0).date(1), moment().startOf('year').month(2).date(31).endOf('day')];
                            }
                            else {
                                scope.options.ranges['Quarter 1 (Current F.Y.)'] = [moment().startOf('year').month(3).date(1), moment().startOf('year').month(5).date(30).endOf('day')];
                                scope.options.ranges['Quarter 2 (Current F.Y.)'] = [moment().startOf('year').month(6).date(1), moment().startOf('year').month(8).date(30).endOf('day')];
                                scope.options.ranges['Quarter 3 (Current F.Y.)'] = [moment().startOf('year').month(9).date(1), moment().startOf('year').month(11).date(31).endOf('day')];
                                scope.options.ranges['Quarter 4 (Current F.Y.)'] = [moment().add(1, 'year').startOf('year').month(0).date(1), moment().add(1, 'year').startOf('year').month(2).date(31).endOf('day')];
                            }
                        }
                        if (newVal.isAcademicYear) {
                            if (moment().isBefore(moment().month(5).date(12))) {
                                scope.options.ranges['Current Academic Year'] = [moment().subtract(1, 'year').startOf('year').month(5).date(12), moment().startOf('year').month(5).date(11).endOf('day')];
                            }
                            else {
                                scope.options.ranges['Current Academic Year'] = [moment().startOf('year').month(5).date(12), moment().add(1, 'year').startOf('year').month(5).date(11).endOf('day')];
                            }
                        }
                        if (newVal.isAcademicYearQuarters) {
                            if (moment().isBefore(moment().month(5).date(12))) {
                                scope.options.ranges['Quarter 1 (Current A.Y.)'] = [moment().subtract(1, 'year').startOf('year').month(5).date(12), moment().subtract(1, 'year').startOf('year').month(8).date(11).endOf('day')];
                                scope.options.ranges['Quarter 2 (Current A.Y.)'] = [moment().subtract(1, 'year').startOf('year').month(8).date(12), moment().subtract(1, 'year').startOf('year').month(11).date(11)].endOf('day');
                                scope.options.ranges['Quarter 3 (Current A.Y.)'] = [moment().subtract(1, 'year').startOf('year').month(11).date(12), moment().startOf('year').month(2).date(11).endOf('day')];
                                scope.options.ranges['Quarter 4 (Current A.Y.)'] = [moment().startOf('year').month(2).date(12), moment().startOf('year').month(5).date(11).endOf('day')];
                            }
                            else {
                                scope.options.ranges['Quarter 1 (Current A.Y.)'] = [moment().startOf('year').month(5).date(12), moment().startOf('year').month(8).date(11).endOf('day')];
                                scope.options.ranges['Quarter 2 (Current A.Y.)'] = [moment().startOf('year').month(8).date(12), moment().startOf('year').month(11).date(11).endOf('day')];
                                scope.options.ranges['Quarter 3 (Current A.Y.)'] = [moment().startOf('year').month(11).date(12), moment().add(1, 'year').startOf('year').month(2).date(11).endOf('day')];
                                scope.options.ranges['Quarter 4 (Current A.Y.)'] = [moment().add(1, 'year').startOf('year').month(2).date(12), moment().add(1, 'year').startOf('year').month(5).date(11).endOf('day')];
                            }
                        }
                    }
                    if(scope.options.ranges && Object.keys(scope.options.ranges).length > 0){
                        scope.ngModel = {
                            startDate : scope.options.ranges[Object.keys(scope.options.ranges)[0]][0],
                            endDate : scope.options.ranges[Object.keys(scope.options.ranges)[0]][1]
                        }
                    }
                    else{
                        scope.options.showCustomRangeLabel = true;
                    }
                });

                scope.open = function () {
                    if (element[0].style.display == 'none' || !element[0].style.display) {
                        $(".datepicker").focus();
                    }
                    else {
                        $(".datepicker").blur();
                    }
                }
            }
        };
    }

    angular.module('imtecho.directives').directive('daterangepicker', daterangepicker);
})();