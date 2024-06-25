(function () {
    function LMSDashboardController($scope, Mask, QueryDAO, PagingForQueryBuilderService, $sce, toaster, GeneralUtil) {
        var lms = this;
        lms.searchCourseId = null;
        lms.courseSelected = null;
        lms.pagingService = PagingForQueryBuilderService.initialize();
        lms.DashboardQueryCodeData = [
            'lms_dashboard_retrieve_modules_by_course_id',
            'lms_dashboard_retrieve_lessons_by_course_id',
            'lms_dashboard_retrieve_learning_hours_by_course_id',
            'lms_dashboard_retrieve_quizzes_by_course_id',
            'lms_dashboard_retrieve_course_engagement',
            'lms_dashboard_retrieve_not_accessed_7_days',
            'lms_dashboard_retrieve_top_scorers',
            'lms_dashboard_retrieve_course_completors'
        ];
        lms.timeFilters = ['Last 7 Days', 'Last 30 Days', 'All Time']
        lms.dtoList = [];
        lms.headerData = {};
        lms.selectedTab = 'course-engagement';
        lms.courseEngagementData = [];
        lms.TotalcourseEngagementData = {};
        lms.pieChartLabels = [
            "Participants in progress",
            "Participants completed the course",
            "Participants not yet started the course"
        ];
        lms.pieChartColors = [
            '#FFF712',
            '#31E521',
            '#9194ce'
        ];
        lms.lineColorsForModules = [
            '#f492a0'
        ]
        lms.lineColorsForLessons = [
            '#3e479b'
        ]
        lms.pieChartData = [];
        lms.pieChartOptions = {};
        lms.barChartLabels = ['>80%', '40%-80%', '<40%'];
        lms.barChartColors = ['#31E521', '#FFF712', '#FF0000'];
        lms.barChartOptions = {
            responsive: true,
            legend: {
                display: false,
            },
            scales: {
                yAxes: [{
                    scaleLabel: {
                        display: true,
                        labelString: '(% of marks scored)'
                    },
                    barPercentage: 0.4
                }],
                xAxes: [{
                    scaleLabel: {
                        display: true,
                        labelString: '(No. of participants)'
                    },
                    ticks: {
                        precision: 0
                    }
                }]
            }
        };
        lms.lineData = [];
        lms.series = [];
        lms.labels = [];
        lms.lineChartData = [];
        lms.tooltipContent = $sce.trustAsHtml(`Spent Time: Time spent by the user in viewing the course content.
         </br> Total time to complete the course: Overall time between the start time and course completion time.`);

        lms.init = () => {
            Mask.show();
            QueryDAO.execute({
                code: 'retrieve_lms_course_list',
                parameters: {}
            }).then((response) => {
                lms.courseList = response.result;
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        lms.isObjectEmpty = (headerData) => {
            return Object.keys(headerData).length > 0;
        }

        lms.retrieveDashboardByCourseId = () => {
            if (lms.searchCourseId) {
                lms.dtoList = lms.createDTOlist(lms.DashboardQueryCodeData, lms.searchCourseId);
            }
            lms.searchForm.$setSubmitted();
            if (lms.searchForm.$valid) {
                Mask.show();
                QueryDAO.executeAll(lms.dtoList).then((response) => {
                    lms.quizList = [{ quizId: '-1', quizName: 'All Quizzes' }];
                    if (response) {
                        lms.headerData.modules = angular.copy(response[0].result);
                        lms.headerData.modules.map(module => module.hoursSpent = module.frequency === 0 ? null : module.hoursSpent === 0 ? '< 1 hr' : module.hoursSpent);
                        lms.headerData.lessons = angular.copy(response[1].result);
                        lms.headerData.lessons.map(lesson => lesson.hoursSpent = lesson.frequency === 0 ? null : lesson.hoursSpent === 0 ? '< 1 hr' : lesson.hoursSpent);
                        if (response[2].result.length>0) {
                            lms.headerData.learning_time = angular.copy(response[2].result[0]);
                        } else {
                            lms.headerData.learning_time = {
                                timeSpent: null
                            };
                        }
                        lms.headerData.quizzes = angular.copy(response[3].result);
                        lms.quizList = lms.quizList.concat(angular.copy(response[3].result));
                        lms.courseEngagementData = angular.copy(response[4].result);
                        lms.headerData.enrolledCount = lms.courseEngagementData.reduce((ele, currentVal) => {return currentVal.enrolled+ele}, 0);
                        lms.notAccessed7Days = angular.copy(response[5].result);
                        lms.headerData.topScorerData = angular.copy(response[6].result);
                        lms.headerData.courseCompletorData = angular.copy(response[7].result);
                        lms.setHeaders();
                        lms.courseSelection();
                        if (lms.courseEngagementData.length) {
                            lms.calculateTotalEngagementData();
                        }
                        lms.comprehensionEffectivenessSelected('-1');
                    }
                }).catch((error) => {
                    GeneralUtil.showMessageOnApiCallFailure(error);
                }).finally(() => {
                    Mask.hide();
                    lms.toggleFilter();
                });
            }
        }


        lms.setHeaders = () => {
            lms.headerSectionDataForCol2 = [{
                key: 'Modules',
                value: lms.headerData.modules.length,
                color: 'color-box pink'
            }, {
                key: 'Lessons',
                value: lms.headerData.lessons.length,
                color: 'color-box blue'
            }, {
                key: 'Quizzes',
                value: lms.headerData.quizzes.length,
                color: 'color-box yellow'
            }, {
                key: 'Participants Enrolled',
                value: lms.headerData.enrolledCount,
                color: 'color-box purple'
            }, {
                key: 'Time Spent',
                value: lms.headerData.learning_time.timeSpent ?
                    lms.headerData.learning_time.timeSpent.substring(0, 2) + ' H ' + lms.headerData.learning_time.timeSpent.substring(3, 5) + ' M ' :
                    '00 H 00 M',
                color: 'color-box green'
            }];
        }

        lms.createDTOlist = (codeList, course_id) => {
            lms.list = [];
            codeList.forEach((code, index) => {
                    lms.list.push({
                        code: code,
                        parameters: {
                            courseId: course_id,
                            locationId: lms.selectedLocationId
                        },
                        sequence: index
                    });
            });
            return lms.list;
        }


        lms.calculateTotalEngagementData = () => {
            lms.TotalcourseEngagementData = {
                roleName: 'Total',
                enrolled: 0,
                inProgress: 0,
                completed: 0,
                notStarted: 0
            };
            lms.courseEngagementData.forEach((course) => {
                lms.TotalcourseEngagementData.enrolled = lms.TotalcourseEngagementData.enrolled + course.enrolled;
                lms.TotalcourseEngagementData.inProgress = lms.TotalcourseEngagementData.inProgress + course.inProgress;
                lms.TotalcourseEngagementData.completed = lms.TotalcourseEngagementData.completed + course.completed;
                lms.TotalcourseEngagementData.notStarted = lms.TotalcourseEngagementData.notStarted + course.notStarted;
            });
            lms.courseEngagementData.push(lms.TotalcourseEngagementData);
            lms.onRoleClick(lms.TotalcourseEngagementData);
        }

        lms.onRoleClick = (course) => {
            lms.selectedCourse = lms.courseEngagementData.find(obj => obj.roleName === course.roleName)
            lms.selectedPieChartTitle = lms.selectedCourse.roleName ? lms.selectedCourse.roleName : 'Total';
            lms.pieChartOptions = {
                responsive: true,
                legend: {
                    display: true,
                    position: 'bottom'
                },
            }
            lms.pieChartData = [
                lms.selectedCourse.inProgress,
                lms.selectedCourse.completed,
                lms.selectedCourse.notStarted
            ];
        }

        lms.comprehensionEffectivenessSelected = (quizID) => {
            Mask.show();
            QueryDAO.execute({
                code: 'lms_dashboard_retrieve_comprehension_effectiveness',
                parameters: {
                    locationId: lms.selectedLocationId,
                    quizId: quizID,
                    courseId: lms.searchCourseId
                }
            }).then((response) => {
                lms.selectedQuiz = lms.quizList.find(quiz => quiz.quizId === quizID);
                lms.barData = angular.copy(response.result[0]);
                if (lms.checkData()) {
                    lms.barChartData = [
                        lms.barData.greaterThan80,
                        lms.barData.between40_80,
                        lms.barData.lesserThan40
                    ];
                } else {
                    lms.barChartData = [];
                }
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        lms.checkData = () => {
            return Object.keys(lms.barData).reduce((sum, key) => sum + parseFloat(lms.barData[key] || 0), 0);
        }

        lms.courseStatsSelected = () => {
            console.log(lms.hearderData, 'COURSE STATS');
        }

        lms.onHeaderSelection = (key) => {
            lms.key = key;
            lms.selectedModule = lms.selectedLesson = lms.selectedQuiz = null;
            switch (key) {
                case 'Modules':
                    $("#modules_details").modal({ backdrop: 'static', keyboard: false });
                    break;
                case 'Lessons':
                    $("#lessons_details").modal({ backdrop: 'static', keyboard: false });
                    break;
                case 'Quizzes':
                    $("#quizzes_details").modal({ backdrop: 'static', keyboard: false });
                    break;
                case 'Participants Enrolled':
                    lms.retrieveEnrolledList();
                    break;
                case 'Time Spent':
                    lms.fetchWatchHourDetails();
                    break;
                default:
            }
        }

        lms.modalClose = (key) => {
            switch (key) {
                case 'Modules':
                    $("#modules_details").modal('hide');
                    break;
                case 'Lessons':
                    $("#lessons_details").modal('hide');
                    break;
                case 'Quizzes':
                    $("#quizzes_details").modal('hide');
                    break;
                case 'Participants Enrolled':
                    $("#enrolled_details").modal('hide');
                    lms.headerData.enrolled = [];
                    lms.pagingService = PagingForQueryBuilderService.initialize();
                    break;
                case 'Time Spent':
                    $("#watch_hour_details").modal('hide');
                    break;
                default:
            }
            lms.lineData = [];
            lms.series = [];
            lms.labels = [];
            lms.lineChartData = [];
            lms.selectedComponentForLineChart = null;
        }


        lms.fetchWatchHourDetails = () => {
            Mask.show();
            QueryDAO.execute({
                code: 'lms_dashboard_retrieve_userwise_watch_hours_by_course_id',
                parameters: {
                    locationId: lms.selectedLocationId,
                    courseId: lms.searchCourseId,
                }
            }).then((response) => {
                if (response) {
                    lms.headerData.watchHourData = response.result;
                }
                $("#watch_hour_details").modal({ backdrop: 'static', keyboard: false });
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        lms.fetchChartDetails = (data, key, time) => {
            lms.series = [];
            lms.selectedTimeFilter = time;
            switch (key) {
                case 'Modules':
                    lms.selectedModule = data;
                    lms.selectedComponentForLineChart = data.moduleName
                    lms.series.push(data.moduleName);
                    lms.queryDTO = {
                        code: 'lms_dashboard_retrieve_daywise_engagement_by_module',
                        parameters: {
                            locationId: lms.selectedLocationId,
                            topicId: data.moduleId,
                            time: time,

                        }
                    };
                    break;
                case 'Lessons':
                    lms.selectedLesson = data;
                    lms.selectedComponentForLineChart = data.lessonName
                    lms.series.push(data.lessonName);
                    lms.queryDTO = {
                        code: 'lms_dashboard_retrieve_daywise_engagement_by_lesson',
                        parameters: {
                            locationId: lms.selectedLocationId,
                            lessonId: data.lessonId,
                            time: time
                        }
                    };
                    break;
                case 'Quizzes':
                    lms.selectedQuiz = data;
                    lms.selectedComponentForLineChart = data.quizName;
                    lms.quizSeries = ['Users Attempted', 'Users Passed in first attempt', 'Users Failed in first attempt']
                    lms.quizLineOptions = {
                        elements: {
                            line: {
                                fill: false,
                                // borderColor : color
                            }
                        },
                        title: {
                            display: true,
                            text: data.quizName
                        },
                        legend: {
                            display: true,
                            position: 'bottom',
                        },
                        scales: {
                            yAxes: [
                                {
                                    id: 'y-axis-1',
                                    type: 'linear',
                                    display: true,
                                    position: 'left',
                                    scaleLabel: {
                                        display: true,
                                        labelString: 'No. of users'
                                    },
                                    ticks: {
                                        precision: 0
                                    }
                                }
                            ],
                            xAxes: [{
                                scaleLabel: {
                                    display: true,
                                    labelString: 'Attempted On'
                                }
                            }]
                        }
                    };
                    lms.queryDTO = {
                        code: 'lms_dashboard_retrieve_userwise_quiz_trend_by_quiz_id',
                        parameters: {
                            locationId: lms.selectedLocationId,
                            quizId: data.quizId,
                            time: time
                        }
                    };
                    break;
                default:
            }
            lms.callQueryDTO(lms.queryDTO, key);
        }

        lms.callQueryDTO = (queryDTO, key) => {
            Mask.show();
            QueryDAO.execute(queryDTO).then((response) => {
                lms.lineData = [];
                lms.labels = [];
                lms.lineChartData = [];
                lms.attemptedData = [];
                lms.passedData = [];
                lms.failedData = [];
                lms.lineData = angular.copy(response.result);
                if (lms.lineData.length > 0) {
                    if (key !== 'Quizzes') {
                        lms.lineData.forEach((obj) => {
                            lms.labels.push(obj.startedOn);
                            lms.lineChartData.push(obj.noOfUsers);
                            lms.setLineOptions(lms.selectedComponentForLineChart, key);
                        });
                    } else {
                        lms.lineData.forEach((obj) => {
                            lms.labels.push(obj.attemptedOn);
                            lms.attemptedData.push(obj.totalUsersAttempted);
                            lms.passedData.push(obj.totalUsersPassed);
                            lms.failedData.push(obj.totalUsersFailed);
                        });
                        lms.lineChartData[0] = lms.attemptedData;
                        lms.lineChartData[1] = lms.passedData;
                        lms.lineChartData[2] = lms.failedData;
                    }
                } else {
                    toaster.pop('warning', "No data available for selected time period");
                }
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        lms.retrieveEnrolledList = () => {
            Mask.show();
            lms.tempDTO = {
                code: 'lms_dashboard_retrieve_enrolled_by_course_id',
                parameters: {
                    locationId: lms.selectedLocationId,
                    courseId: lms.searchCourseId,
                    limit: lms.pagingService.limit,
                    offSet: lms.pagingService.offSet
                }
            };
            PagingForQueryBuilderService.getNextPage(QueryDAO.execute, lms.tempDTO, lms.headerData.enrolled, null).then((response) => {
                lms.headerData.enrolled = response;
                $("#enrolled_details").modal({ backdrop: 'static', keyboard: false });
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        lms.setLineOptions = (title, key) => {
            const color = key === 'Modules' ? '#f492a0' : '#3e479b';
            lms.lineOptions = {
                elements: {
                    line: {
                        fill: false,
                        borderColor: color
                    }
                },
                title: {
                    display: true,
                    text: title
                },
                scales: {
                    yAxes: [
                        {
                            id: 'y-axis-1',
                            type: 'linear',
                            display: true,
                            position: 'left',
                            scaleLabel: {
                                display: true,
                                labelString: 'No of times opened'
                            },
                            ticks: {
                                precision: 0
                            }
                        }
                    ],
                    xAxes: [{
                        scaleLabel: {
                            display: true,
                            labelString: 'Visited Date'
                        }
                    }]
                }
            };
        }

        lms.courseSelection = () => {
            lms.courseSelected = lms.courseList.find(course => course.courseId === lms.searchCourseId);
        }

        $scope.$watch('lms.searchCourseId', function (newValue, oldValue) {
            lms.oldSearchId = oldValue;
            lms.newSearchId = newValue;
        }, true);


        lms.toggleFilter = () => {
            if (angular.element('.filter-div').hasClass('active')) {
                angular.element('body').css("overflow", "auto");
            } else {
                angular.element('body').css("overflow", "hidden");
            }
            angular.element('.cst-backdrop').fadeToggle();
            angular.element('.filter-div').toggleClass('active');
        }

        lms.init();

    }
    angular.module('imtecho.controllers').controller('LMSDashboardController', LMSDashboardController);
})();
