(function () {
    function LMSDashboardControllerV2($http, Mask, QueryDAO, UserDAO, $filter, toaster, GeneralUtil, AuthenticateService, $sce, PagingForQueryBuilderService) {
        var lms = this;
        lms.showWeeklyGraph = true;
        lms.showCompletionGraph = true;
        lms.noData = false
        lms.headerData = {};
        lms.TotalcourseEngagementData = {}
        lms.best_loc_data = []
        lms.poor_loc_data = []
        lms.loc_type = '';
        lms.pagingService = PagingForQueryBuilderService.initialize();
        lms.DashboardQueryCodeData = [
            'lms_dashboard_retrieve_modules_by_course_id_v2',
            'lms_dashboard_retrieve_lessons_by_course_id_v2',
            'lms_dashboard_retrieve_learning_hours_by_course_id_v2',
            'lms_dashboard_retrieve_quizzes_by_course_id_v2',
            'lms_course_engagement_data',
            'lms_dashboard_retrieve_course_engagement_v2',
            'lms_dashboard_retrieve_top_scorers_v2',
            'lms_dashboard_retrieve_course_completors_v2',
            'lms_dashboard_retrieve_total_users_v2'
        ];

        lms.tooltipContent = $sce.trustAsHtml(`Spent Time: Time spent by the user in viewing the course content.
         </br> Total time to complete the course: Overall time between the start time and course completion time.`);
        lms.timeFilters = ['Last 7 Days', 'Last 30 Days', 'All Time']

        var width1 = 354, height1 = 300;
        var projection1 = d3.geoMercator().scale(2);

        var path1 = d3.geoPath()
            .projection(projection1)
            .pointRadius(2);
        lms.randomMapId1 = "chart1234";
        document.getElementById(lms.randomMapId1).innerHTML = "";   // clear previous chart

        var svg1 = d3.select("#" + lms.randomMapId1).append("svg")
            .attr("width", width1)
            .attr("height", height1);

        var g1 = svg1.append("g");

        var NAME_MAPPING_MAP = {
            'Jam Kandorna': 'Jamkandorna',
            'Vinchhiya': 'Vinchchiya',
            'Kotda Sangani': 'Kotada sangani',
            'Gir Somnath': 'Gir Somnath',
            'Kachchh': 'Kutch',
            'Mahesana': 'mehsana',
            'Hanumakonda': 'Warangal Urban',
            // 'Ahmedabad': 'Adilabad'
        };

        lms.mapCode1 = "telangana";
        lms.mapPropertyName1 = "district";

        lms.init = () => {
            Mask.show();
            AuthenticateService.getLoggedInUser().then(function (res) {
                UserDAO.retrieveById(res.data.id).then(function (response) {
                    lms.userDetails = response
                    lms.getRoleWiseGraphs(lms.userDetails.roleId)
                    Mask.show();
                    QueryDAO.execute({
                        code: 'retrieve_lms_course_list',
                        parameters: {}
                    }).then((response) => {
                        lms.courseList = response.result;
                        if (lms.courseList.length > 0) {
                            lms.selectedCourse = lms.courseList[0]
                            lms.getRolesForSearch()
                            if (!lms.selectedLocationId && lms.userDetails.addedLocations.length > 0) {
                                lms.selectedLocationId = lms.userDetails.addedLocations[0].locationId
                            }
                            lms.setCourseWiseTrend();
                        }
                    }).catch((error) => {
                        GeneralUtil.showMessageOnApiCallFailure(error);
                    }).finally(() => {
                        Mask.hide();
                    });
                }).finally(function () {
                    Mask.hide();
                });
            });
        }

        lms.getRolesForSearch = () => {
            Mask.show()
            QueryDAO.execute({
                code: 'retrieve_roles_for_lms_dashboard_based_on_course',
                parameters: {
                    courseId: lms.searchCourseId==='all'?null:lms.searchCourseId
                }
            }).then((response) => {
                lms.roleList = response.result
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        lms.getBestPoorLoc = (location_id, course_id) => {
            Mask.show()
            if(lms.searchCourseId==null || lms.searchCourseId=='all'){
                qCode = 'lms_dashboard_course_completion_rate_by_location_for_all_role_v2'
            }
            else{
                qCode = 'lms_dashboard_course_completion_rate_by_location'
            }
            QueryDAO.execute({
                code: qCode,
                parameters: {
                    location_id: location_id,
                    course_id: course_id==='all'?null:course_id
                }
            }).then((response) => {
                lms.best_poor_loc_data = response.result;
                lms.best_loc_data = []
                lms.poor_loc_data = []
                if (lms.best_poor_loc_data.length > 0) {
                    for (let i = 0; i < lms.best_poor_loc_data.length; i++) {
                        if (lms.best_poor_loc_data[i].count_type == 'Min') {
                            lms.poor_loc_data.push(lms.best_poor_loc_data[i])
                        } else if (lms.best_poor_loc_data[i].count_type == 'Max') {
                            lms.best_loc_data.push(lms.best_poor_loc_data[i])
                        }
                    }
                }
                if (!lms.best_loc_data[0]?.loc_type) {
                    lms.loc_type = lms.poor_loc_data[0]?.loc_type
                } else {
                    lms.loc_type = lms.best_loc_data[0]?.loc_type
                }

            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        lms.getRoleWiseGraphs = (id) => {
            Mask.show();
            QueryDAO.execute({
                code: 'retrieve_lms_dashboard_kpi_codes_by_role_id',
                parameters: {
                    roleId: id
                }
            }).then((response) => {
                lms.rights = response.result
                lms.stateKpi = lms.rights.find(function (e) {
                    return e.code == 'state-map'
                });
                lms.learningUsageKpi = lms.rights.find(function (e) {
                    return e.code == 'learningapp-usage-kpi'
                });
                lms.userCountKpi = lms.rights.find(function (e) {
                    return e.code == 'user-count-kpi'
                });
                lms.courseTrendKpi = lms.rights.find(function (e) {
                    return e.code == 'course-trend-kpi'
                })
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        lms.toggleFilter = () => {
            if (angular.element('.filter-div').hasClass('active')) {
                angular.element('body').css("overflow", "auto");
            } else {
                angular.element('body').css("overflow", "hidden");
            }
            angular.element('.cst-backdrop').fadeToggle();
            angular.element('.filter-div').toggleClass('active');
        }

        lms.retrieveDashboardByCourseId = () => {
            // if (lms.searchCourseId && lms.selectedLocationId) {
            //     lms.dtoList = lms.createDTOlist(lms.DashboardQueryCodeData, lms.searchCourseId, lms.selectedLocationId);
            // }
            if (lms.searchForm.$valid) {
                // lms.loadCourseKPI(lms.searchCourseId)
                lms.setCourseWiseTrend(true);
                lms.searchForm.$setSubmitted();
                lms.toggleFilter();
                
                // Mask.show();
                // QueryDAO.executeAll(lms.dtoList).then((response) => {
                //     lms.quizList = [{ quizId: '-1', quizName: 'All Quizzes' }];
                //     if (response) {
                //         lms.headerData.modules = angular.copy(response[0].result);
                //         lms.headerData.modules.map(module => module.hoursSpent = module.frequency === 0 ? null : module.hoursSpent === 0 ? '< 1 hr' : module.hoursSpent);
                //         lms.headerData.lessons = angular.copy(response[1].result);
                //         lms.headerData.lessons.map(lesson => lesson.hoursSpent = lesson.frequency === 0 ? null : lesson.hoursSpent === 0 ? '< 1 hr' : lesson.hoursSpent);
                //         if (response[2].result.length > 0) {
                //             lms.headerData.learning_time = angular.copy(response[2].result[0]);
                //         } else {
                //             lms.headerData.learning_time = {
                //                 timeSpent: null
                //             };
                //         }
                //         lms.headerData.quizzes = angular.copy(response[3].result);
                //         lms.quizList = lms.quizList.concat(angular.copy(response[3].result));
                //         lms.courseWiseTrendData = angular.copy(response[4].result);
                //         lms.courseEngagementData = angular.copy(response[5].result);
                //         lms.headerData.topScorerData = angular.copy(response[6].result);
                //         lms.headerData.courseCompletorData = angular.copy(response[7].result);

                //         if (lms.learningUsageKpi) {
                //             Mask.show()
                //             QueryDAO.execute({
                //                 code: 'lms_dashboard_learning_app_usage_active_users',
                //                 parameters: {
                //                     courseId: lms.searchCourseId,
                //                     locationId: lms.selectedLocationId,
                //                     roleId: lms.roleId
                //                 }
                //             }).then((res) => {
                //                 lms.learningUsageActiveUsersData = res.result
                //                 lms.setLearningAppUsage();
                //             }).catch((error) => {
                //                 GeneralUtil.showMessageOnApiCallFailure(error);
                //             }).finally(() => {
                //                 Mask.hide();
                //             });
                //         }
                //         if (lms.userCountKpi) {
                //             Mask.show()
                //             lms.dtoList2 = [
                //                 {
                //                     code: 'lms_count_of_users_coursewise_weekly',
                //                     parameters: {
                //                         courseId: lms.searchCourseId,
                //                         locationId: lms.selectedLocationId,
                //                         roleId: lms.roleId
                //                     },
                //                     sequence: 0
                //                 },
                //                 {
                //                     code: 'lms_count_of_users_coursewise_monthly',
                //                     parameters: {
                //                         courseId: lms.searchCourseId,
                //                         locationId: lms.selectedLocationId,
                //                         roleId: lms.roleId
                //                     },
                //                     sequence: 1
                //                 }
                //             ]
                //             QueryDAO.executeAll(lms.dtoList2).then((responses) => {
                //                 lms.weeklyActiveUserCounts = angular.copy(responses[0].result);
                //                 lms.monthlyActiveUserCounts = angular.copy(responses[1].result);
                //                 lms.setUserCount();
                //             }).catch((error) => {
                //                 GeneralUtil.showMessageOnApiCallFailure(error);
                //             }).finally(() => {
                //                 Mask.hide();
                //             });
                //         }
                //         if (lms.stateKpi) {
                //             Mask.show()
                //             QueryDAO.execute({
                //                 code: 'lms_heatmap_data',
                //                 parameters: {
                //                     courseId: lms.searchCourseId,
                //                     roleId: lms.roleId
                //                     // locationId: lms.selectedLocationId
                //                 }
                //             }).then((resp) => {
                //                 lms.heatMapData = resp.result
                //                 lms.setHeatMap()
                //             }).catch((error) => {
                //                 GeneralUtil.showMessageOnApiCallFailure(error);
                //             }).finally(() => {
                //                 Mask.hide();
                //             });
                //         }

                //         lms.headerData.enrolledCount = lms.courseEngagementData.reduce((ele, currentVal) => { return currentVal.enrolled + ele }, 0);

                //         lms.setHeaders();
                //         lms.courseSelection();
                //         lms.calculateTotalEngagementData();
                //         lms.setCourseWiseTrend(true);
                //     }
                // }).catch((error) => {
                //     GeneralUtil.showMessageOnApiCallFailure(error);
                // }).finally(() => {
                //     lms.toggleFilter();
                //     Mask.hide()
                // });
            }
        }

        lms.createDTOlist = (codeList, course_id, location_id) => {
            lms.list = [];
            if (lms.userDetails.addedLocations.length > 0) {
                codeList.forEach((code, index) => {
                    if (code !== 'lms_course_engagement_data' && code !== 'lms_dashboard_retrieve_course_engagement_v2' && code !== 'lms_dashboard_retrieve_total_users_v2') {
                        lms.list.push({
                            code: code,
                            parameters: {
                                courseId: course_id==='all'?null:course_id,
                                // locationId: lms.selectedLocationId
                                locationId: location_id
                            },
                            sequence: index
                        });
                    }
                    if (code === 'lms_dashboard_retrieve_course_engagement_v2') {
                        lms.list.push({
                            code: code,
                            parameters: {
                                courseId: course_id==='all'?null:course_id,
                                locationId: location_id,
                                roleId: lms.roleId
                            },
                            sequence: index
                        });
                    }
                    if (code === 'lms_course_engagement_data') {
                        lms.list.push({
                            code: code,
                            parameters: {
                                // locationId: lms.selectedLocationId
                                locationId: location_id,
                                roleId: lms.roleId
                            },
                            sequence: index
                        });
                    }
                    if (code === 'lms_dashboard_retrieve_total_users_v2') {
                        lms.list.push({
                            code: code,
                            parameters: {
                                locationId: location_id,
                            },
                            sequence: index
                        });
                    }
                });
            }
            else {
                toaster.pop("Error", "No locations are assigned to you")
            }
            return lms.list;
        }

        lms.setHeaders = () => {
            lms.headerSectionDataForCol2 = [{
                key: 'Participants Enrolled',
                value: lms.headerData.enrolledCount,
                color: 'color-box purple'
            }, {
                key: 'ANMs have installed the app',
                value: lms.headerData.totalUserData[0].appInstalled + ' out of ' + lms.headerData.totalUserData[0].totalUsers,
                color: 'color-box green'
            }, {
                //     key: 'Lessons',
                //     value: lms.headerData.lessons.length,
                //     color: 'color-box blue'
                // }, {
                key: 'Modules',
                value: lms.headerData.modules.length,
                color: 'color-box pink'
            }, {
                key: 'Quizzes',
                value: lms.headerData.quizzes.length,
                color: 'color-box yellow'
                // }, {
                //     key: 'Time Spent',
                //     value: lms.headerData.learning_time.timeSpent ?
                //         lms.headerData.learning_time.timeSpent.substring(0, 2) + ' H ' + lms.headerData.learning_time.timeSpent.substring(3, 5) + ' M ' :
                //         '00 H 00 M',
                //     color: 'color-box green'
            }
            // , {
            //     key:'App Installed Count',
            //     value: lms.headerData.appInstalledCount,
            //     color: 'color-box blue'
            // }
            ];
            
        }

        lms.courseSelection = () => {
            lms.courseSelected = lms.courseList.find(course => course.courseId === lms.searchCourseId);
            if(lms.searchCourseId === 'all' || lms.searchCourseId === null){lms.courseSelected = true}
            
        }

        lms.calculateTotalEngagementData = () => {
            lms.TotalcourseEngagementData = {
                roleName: 'Total',
                enrolled: 0,
                inProgress: 0,
                completed: 0,
                notStarted: 0,
                appInstalled : 0
            };
            if (lms.courseEngagementData.length > 0) {
                lms.courseEngagementData.forEach((course) => {
                    lms.TotalcourseEngagementData.enrolled = lms.TotalcourseEngagementData.enrolled + course.enrolled;
                    lms.TotalcourseEngagementData.inProgress = lms.TotalcourseEngagementData.inProgress + course.inProgress;
                    lms.TotalcourseEngagementData.completed = lms.TotalcourseEngagementData.completed + course.completed;
                    lms.TotalcourseEngagementData.appInstalled = lms.TotalcourseEngagementData.appInstalled + course.appInstalled;
                    lms.TotalcourseEngagementData.notStarted = lms.TotalcourseEngagementData.appInstalled - lms.TotalcourseEngagementData.completed - lms.TotalcourseEngagementData.inProgress;

                });
            }
            lms.courseEngagementData.push(lms.TotalcourseEngagementData);
        }

        lms.getGradientBar = function (item) {
            // return { 'background': "linear-gradient(to right,Green " + (lms.TotalcourseEngagementData.completed * 100) / lms.TotalcourseEngagementData.enrolled + "%, Yellow " + (lms.TotalcourseEngagementData.inProgress * 100) / lms.TotalcourseEngagementData.enrolled + "%,Red " + (lms.TotalcourseEngagementData.notStarted * 100) / lms.TotalcourseEngagementData.enrolled + "%)" }

            var finalValue;
            // console.log(lms.TotalcourseEngagementData);
            switch (item) {
                case 'completed':
                    finalValue = (lms.TotalcourseEngagementData.completed * 100) / (lms.TotalcourseEngagementData.appInstalled);
                    break;
                case 'inprogress':
                    finalValue = (lms.TotalcourseEngagementData.inProgress * 100) / (lms.TotalcourseEngagementData.appInstalled);
                    break;
                case 'notstarted':
                    finalValue = ((lms.TotalcourseEngagementData.appInstalled - lms.TotalcourseEngagementData.completed - lms.TotalcourseEngagementData.inProgress) * 100) / (lms.TotalcourseEngagementData.appInstalled);
                    break;

            }
            // console.log(lms.TotalcourseEngagementData);
            // if(lms.searchCourseId==null) return finalValue/2;
            return finalValue;
        }

        lms.setLearningAppUsage = () => {
            //fetch data
            lms.pieChartLabels = [
                "Users who have completed all modules",
                "Users who have started the course",
                "Users who have not started the course"
            ];
            lms.pieChartColors = [
                '#31E521',
                '#FFF712',
                '#9194ce'
            ];
            lms.pieChartOptions = {
                responsive: true,
                legend: {
                    display: true,
                    position: 'bottom'
                },
                title: {
                    display: true,
                    text: 'Learning App Usage'
                },
                plugins: {
                    labels: [{
                        render: function (args) {
                            return args.value;
                        }
                    }]
                }
            }
            lms.pieChartData = [
                lms.TotalcourseEngagementData.completed,
                lms.TotalcourseEngagementData.inProgress,
                lms.TotalcourseEngagementData.notStarted
            ]

            lms.pieChartLabels2 = [
                "100% course completed",
                "75% course completed",
                "50% course completed",
                "25-50% course completed",
                "Less than 25% course completed",
                "Not started"
            ];
            lms.pieChartColors2 = [
                '#31E521',
                '#9194ce',
                '#00ccff',
                '#ff9933',
                '#FFF712',
                '#ff9966'
            ];
            lms.pieChartData2 = [];
            lms.pieChartOptions2 = {
                responsive: true,
                legend: {
                    display: true,
                    position: 'bottom'
                },
                title: {
                    display: true,
                    text: 'Learning App Usage'
                },
                plugins: {
                    labels: [{
                        render: function (args) {
                            return args.value;
                        }
                    }]
                }
            }
            // console.log(lms);
            lms.pieChartData2 = [
                lms.learningUsageActiveUsersData[0]['100%completed'],
                lms.learningUsageActiveUsersData[0]['75%completed'],
                lms.learningUsageActiveUsersData[0]['50%completed'],
                lms.learningUsageActiveUsersData[0]['25%complete'],
                lms.learningUsageActiveUsersData[0]['lessthan25%completed'],
                lms.TotalcourseEngagementData.notStarted
            ];
        }

        lms.setUserCount = () => {
            lms.barChartOptions = {
                responsive: true,
                layout: {
                    padding: {
                        top: 30
                    }
                },
                legend: {
                    display: true,
                    position: "bottom",
                    align: "middle"
                },
                plugins: {
                    labels: [{
                        render: function (args) {
                            return args.value;
                        },
                        position: 'outside',
                    }]
                },
                scales: {
                    yAxes: [
                        {
                            display: true,
                            gridLines: {
                                display: true
                            },
                            ticks: {
                                beginAtZero: true
                            }
                        },
                    ],
                    xAxes: [{
                        display: true,
                        gridLines: {
                            display: false
                        },
                        // barPercentage: 0.4
                    }]
                }
            }
            lms.barChartOptions2 = {
                responsive: true,
                layout: {
                    padding: {
                        top: 30
                    }
                },
                legend: {
                    display: true,
                    position: "bottom",
                    align: "middle"
                },
                plugins: {
                    labels: [{
                        render: function (args) {
                            return args.value;
                        },
                        position: 'outside',
                    }]
                },
                scales: {
                    yAxes: [
                        {
                            display: true,
                            gridLines: {
                                display: true
                            },
                            ticks: {
                                beginAtZero: true
                            }
                        },
                    ],
                    xAxes: [{
                        display: true,
                        gridLines: {
                            display: false
                        },
                        // barPercentage: 0.4
                    }]
                }
            }
            var labels = []
            var data = []
            lms.weeklyActiveUserCounts.forEach((item) => {
                var date = new Date();
                // console.log(date + item.week);
                var diff = new Date(item.week);
                var timeDiff = Math.abs(diff.getTime() - date.getTime());
                var diffDays = Math.ceil(timeDiff / (1000 * 3600 * 24));
                var day
                switch (diffDays) {
                    case 1:
                        day = 'Today';
                        break;
                    case 2:
                        day = 'Yesterday';
                        break;
                    default:
                        day = 'Before ' + (diffDays - 2) + ' days';
                        break;
                }
                // labels.push(day + '\n (' + $filter('date')(item.week, "dd/MM") + ')')
                labels.push([day, '(' + $filter('date')(item.week, "dd/MM") + ')'])
                data.push(item.count)
            })
            var labels2 = []
            var data2 = []
            lms.monthlyActiveUserCounts.forEach((item) => {
                var date = new Date();
                // console.log(date + item.week);
                var diff = new Date(item.month);
                var timeDiff = Math.abs(diff.getTime() - date.getTime());
                var diffMonths = Math.ceil(timeDiff / (1000 * 3600 * 24 * 30));
                var month;
                switch (diffMonths) {
                    case 1:
                        month = 'This Month';
                        break;
                    case 2:
                        month = 'Previous Month';
                        break;
                    default:
                        month = 'Before ' + (diffMonths - 2) + ' months';
                        // month = '';
                        break;
                }
                // labels2.push(month + '\n (' + $filter('date')(item.month, "MMM-yy") + ')')
                labels2.push([month, '(' + $filter('date')(item.month, "MMM-yy") + ')'])
                data2.push(item.count)
            })
            lms.barChartData = [data]
            lms.barChartLabels = labels
            lms.barChartData2 = [data2]
            lms.barChartLabels2 = labels2
            lms.barChartSeries = ['Active users']
            lms.barChartColors = ['#31E521']
            lms.barChartSeries2 = ['Active users']
            lms.barChartColors2 = ['#31E521']

        }

        lms.setCourseWiseTrend = (fromSearch) => {
            if (lms.selectedLocationId) {
                Mask.show()
                QueryDAO.execute({
                    code: 'lms_course_engagement_data',
                    parameters: {
                        // courseId: lms.searchCourseId,
                        locationId: lms.selectedLocationId,
                        roleId: lms.roleId
                    }
                }).then((response) => {
                    lms.courseWiseTrendData = response.result;
                    if (lms.courseWiseTrendData.length > 0) {
                        lms.noData = false
                        if (!fromSearch && lms.selectedCourse) {
                            lms.activated_course = lms.selectedCourse.courseId
                            lms.loadCourseKPI(lms.selectedCourse.courseId)
                        }
                        else {
                            lms.loadCourseKPI(lms.searchCourseId)
                        }
                        lms.barChartSeries3 = ['Completion Rate'];
                        lms.barChartColors3 = ['#00ccff'];
                        lms.barChartLabels3 = []
                        lms.barChartOptions3 = {};
                        lms.barChartData3 = [];
                        lms.barChartOptions3 = {
                            responsive: true,
                            layout: {
                                padding: {
                                    top: 30
                                }
                            },
                            legend: {
                                display: true,
                                position: "bottom",
                                align: "middle"
                            },
                            plugins: {
                                labels: [{
                                    render: function (args) {
                                        return args.value + "%";
                                    },
                                    position: 'outside',
                                }]
                            },
                            scales: {
                                yAxes: [
                                    {
                                        display: true,
                                        gridLines: {
                                            display: true
                                        },
                                        ticks: {
                                            beginAtZero: true,
                                            steps: 10,
                                            max: 100,
                                            padding: 20,
                                            callback: function (value, index, values) {
                                                return value + "%";
                                            }
                                        }
                                    },
                                ],
                                xAxes: [{
                                    display: true,
                                    gridLines: {
                                        display: false
                                    },
                                    barPercentage: 0.4
                                }]
                            }
                        }
                        var labels = []
                        var data = []
                        var timeSpent = []
                        lms.courseWiseTrendData.forEach((item) => {
                            labels.push(item.course_name)
                            data.push(item.completion_rate)
                            if (item.time_spent != null) {
                                timeSpent.push(item.time_spent.toFixed(2))
                            }
                            else {
                                timeSpent.push(0)
                            }
                        })
                        lms.barChartData3 = [data];
                        lms.barChartLabels3 = labels;

                        lms.lineChartSeries = ['Time Spent'];
                        lms.lineChartColors = ['green'];
                        lms.lineChartLabels = []
                        lms.lineChartOptions = {};
                        lms.lineChartData2 = [];
                        lms.lineChartOptions = {
                            responsive: true,
                            legend: {
                                display: true,
                                position: "bottom",
                                align: "middle"
                            },
                            plugins: {
                                labels: [{
                                    render: function (args) {
                                        return args.value + " sec";
                                    },
                                    position: 'outside',
                                }]
                            },
                            elements: {
                                line: {
                                    fill: false
                                }
                            },
                            scales: {
                                yAxes: [
                                    {
                                        display: true,
                                        gridLines: {
                                            display: true
                                        },
                                        ticks: {
                                            beginAtZero: true,
                                            steps: 10,
                                            padding: 20,
                                            callback: function (value, index, values) {
                                                return value + " minutes";
                                            }
                                        }
                                    },
                                ],
                                xAxes: [{
                                    display: true,
                                    gridLines: {
                                        display: false
                                    }
                                }]
                            }
                        }
                        lms.lineChartData2 = [timeSpent];
                        lms.lineChartLabels = labels;
                    }
                    else{
                        lms.noData = true
                    }
                }).catch((error) => {
                    GeneralUtil.showMessageOnApiCallFailure(error);
                }).finally(() => {
                    Mask.hide();
                });
            }
        }

        function getMappingName(name) {
            return NAME_MAPPING_MAP[name] || name;
        }

        lms.setHeatMap = () => {
            // lms.stateData2 = [{ "x_axis_label": "Adilabad", "series_label": 97.27, "color": "Green" }, { "x_axis_label": "Hyderabad", "series_label": 98.58, "color": "yellow" }, { "x_axis_label": "Jagitial", "series_label": 98.11, "color": "Red" }, { "x_axis_label": "Jangoan", "series_label": 97.33, "color": "Yellow" }, { "x_axis_label": "Mulugu", "series_label": 99.70, "color": "Green" }, { "x_axis_label": "Jogulamba Gadwal", "series_label": 96.72, "color": "Green" }, { "x_axis_label": "Kamareddy", "series_label": 99.80, "color": "Red" }, { "x_axis_label": "Karimnagar", "series_label": 97.76, "color": "yellow" }, { "x_axis_label": "Khammam", "series_label": 96.07, "color": "Green" }, { "x_axis_label": "Kumuram Bheem Asifabad", "series_label": 97.77, "color": "yellow" }, { "x_axis_label": "Mahabubabad", "series_label": 97.00, "color": "Red" }, { "x_axis_label": "Mahabubnagar", "series_label": 100.55, "color": "Green" }, { "x_axis_label": "Mancherial", "series_label": 98.23, "color": "Green" }, { "x_axis_label": "Medak", "series_label": 99.54, "color": "Green" }, { "x_axis_label": "Medchal Malkajgiri", "series_label": 98.46, "color": "Red" }, { "x_axis_label": "Nagarkurnool", "series_label": 96.12, "color": "Green" }, { "x_axis_label": "Nalgonda", "series_label": 94.13, "color": "Yellow" }, { "x_axis_label": "Nirmal", "series_label": 98.53, "color": "Red" }, { "x_axis_label": "Nizamabad", "series_label": 97.01, "color": "Green" }, { "x_axis_label": "Peddapalli", "series_label": 99.86, "color": "Green" }, { "x_axis_label": "Rajanna Sircilla", "series_label": 98.85, "color": "Green" }, { "x_axis_label": "Ranga Reddy", "series_label": 97.97, "color": "Yellow" }, { "x_axis_label": "Sangareddy", "series_label": 97.42, "color": "Red" }, { "x_axis_label": "Siddipet", "series_label": 98.02, "color": "Green" }, { "x_axis_label": "Suryapet", "series_label": 94.16, "color": "Yellow" }, { "x_axis_label": "Vikarabad", "series_label": 98.01, "color": "Green" }, { "x_axis_label": "Wanaparthy", "series_label": 96.01, "color": "Red" }, { "x_axis_label": "Warangal", "series_label": 93.57, "color": "Yellow" }, { "x_axis_label": "Hanumakonda", "series_label": 98.21, "color": "Green" }, { "x_axis_label": "Yadadri Bhuvanagiri", "series_label": 97.58, "color": "Red" }, { "x_axis_label": "Bhadradri Kothagudem", "series_label": 99.59, "color": "Green" }, { "x_axis_label": "Jayashankar", "series_label": 96.82, "color": "Green" }, { "x_axis_label": "Narayanpet", "series_label": 97.14, "color": "Green" }, { "x_axis_label": "Warangal Rural", "series_label": 97.18, "color": "Yellow" }, { "x_axis_label": "Devbhumi Dwarka", "series_label": 101.21, "color": "Green" }, { "x_axis_label": "Bhavnagar Corporation", "series_label": 92.31, "color": "Yellow" }, { "x_axis_label": "Anand", "series_label": 97.73, "color": "Green" }, { "x_axis_label": "Gir Somnath", "series_label": 97.67, "color": "Red" }, { "x_axis_label": "Vadodara Corporation", "series_label": 96.70, "color": "Green" }, { "x_axis_label": "Sabarkantha", "series_label": 98.00, "color": "Green" }, { "x_axis_label": "Dahod", "series_label": 97.84, "color": "Yellow" }];
            lms.stateData2 = lms.heatMapData
            $http.get('telangana-topo-2.json').then(function (response) {
                lms.data1 = response.data;
                setBaseGrapth1(lms.data1);
            });
        }

        function setBaseGrapth1(data) {
            centerZoom1(data);
            drawSubUnits1(data);
            Mask.hide()
        }

        function centerZoom1(data) {
            var o = topojson.mesh(data, data.objects[lms.mapCode1], function (x, y) {
                return x === y;
            });
            projection1
                .scale(1)
                .translate([0, 0]);
            var b = path1.bounds(o),
                s = 1 / Math.max((b[1][0] - b[0][0]) / width1, (b[1][1] - b[0][1]) / height1);
            projection1
                .scale(s)
                .translate([(width1 - s * (b[1][0] + b[0][0])) / 2, (height1 - s * (b[1][1] + b[0][1])) / 2]);
            return o;
        }

        function drawSubUnits1(data) {
            Mask.show()
            document.getElementById(lms.randomMapId1).innerHTML = "";   // clear previous chart

            var svg1 = d3.select("#" + lms.randomMapId1).append("svg")
                .attr("width", width1)
                .attr("height", height1)
                .attr("fill", "none");

            var g1 = svg1.append("g");
            var tooltip = d3.select("body").append("div")
                .attr("class", "covid-19-tooltip")
                .style("opacity", 0);

            var subunits = g1.selectAll(".subunit")
                .data(topojson.feature(data, data.objects[lms.mapCode1]).features)
                .enter().append("path")
                .attr("class", "subunit")
                .attr("d", path1)
                // .style("opacity", function (d) {
                //     for (let stateData of lms.stateData2) {
                //         if (d.properties[lms.mapPropertyName1] && d.properties[lms.mapPropertyName1].toLowerCase() == getMappingName(stateData.x_axis_label).toLowerCase()) {
                //             if (stateData.opacity == 0) {
                //                 return 0.1;
                //             } else {
                //                 return stateData.opacity;
                //             }
                //         }
                //     }
                // })
                .style("fill", function (d) {
                    for (let stateData of lms.stateData2) {
                        if (d.properties[lms.mapPropertyName1] && d.properties[lms.mapPropertyName1].toLowerCase() == getMappingName(stateData.x_axis_label).toLowerCase()) {
                            return stateData.color;
                        }
                    }
                })
                .style("stroke", "#000")
                .style("stroke-width", "1px")
                .on('mouseover', function (d) {
                    element = lms.stateData2.find(state => d.properties.district == getMappingName(state.x_axis_label));
                    if (!!element) {
                        tooltip.transition()
                            .duration(200)
                            .style("opacity", .9);
                        tooltip.html(d.properties.district + ":" + element.series_label + "%")
                            .style("left", (d3.event.pageX) + "px")
                            .style("top", (d3.event.pageY - 28) + "px");
                    }
                })
                .on('mouseout', function () {
                    tooltip.transition()
                        .duration(500)
                        .style("opacity", 0);
                });
            Mask.hide()
            return subunits;
        }

        lms.loadCourseKPI = (course_id) => {
            lms.searchCourseId = course_id
            lms.activated_course = course_id
            if (lms.selectedLocationId) {
                lms.dtoList = lms.createDTOlist(lms.DashboardQueryCodeData, lms.searchCourseId, lms.selectedLocationId);
            }
            lms.getBestPoorLoc(lms.selectedLocationId, lms.searchCourseId);
            Mask.show();
            QueryDAO.executeAll(lms.dtoList).then((response) => {
                lms.quizList = [{ quizId: '-1', quizName: 'All Quizzes' }];
                if (response) {
                    lms.headerData.modules = angular.copy(response[0].result);
                    lms.headerData.modules.map(module => module.hoursSpent = module.frequency === 0 ? null : module.hoursSpent === 0 ? '< 1 hr' : module.hoursSpent);
                    lms.headerData.lessons = angular.copy(response[1].result);
                    lms.headerData.lessons.map(lesson => lesson.hoursSpent = lesson.frequency === 0 ? null : lesson.hoursSpent === 0 ? '< 1 hr' : lesson.hoursSpent);
                    if (response[2].result.length > 0) {
                        lms.headerData.learning_time = angular.copy(response[2].result[0]);
                    } else {
                        lms.headerData.learning_time = {
                            timeSpent: null
                        };
                    }
                    lms.headerData.quizzes = angular.copy(response[3].result);
                    lms.quizList = lms.quizList.concat(angular.copy(response[3].result));
                    lms.courseWiseTrendData = angular.copy(response[4].result);
                    lms.courseEngagementData = angular.copy(response[5].result);
                    lms.headerData.topScorerData = angular.copy(response[6].result);
                    lms.headerData.courseCompletorData = angular.copy(response[7].result);
                    lms.headerData.totalUserData = angular.copy(response[8].result);

                    if (lms.learningUsageKpi) {
                        if(lms.searchCourseId==null || lms.searchCourseId=='all'){
                            qCode = 'lms_dashboard_learning_app_usage_active_users_for_all_role'
                        }
                        else{
                            qCode = 'lms_dashboard_learning_app_usage_active_users'
                        }
                        Mask.show()
                        QueryDAO.execute({
                            code: qCode,
                            parameters: {
                                courseId: lms.searchCourseId==='all'?null:lms.searchCourseId,
                                locationId: lms.selectedLocationId,
                                roleId: lms.roleId
                            }
                        }).then((res) => {
                            lms.learningUsageActiveUsersData = res.result
                            lms.setLearningAppUsage();
                        }).catch((error) => {
                            GeneralUtil.showMessageOnApiCallFailure(error);
                        }).finally(() => {
                            Mask.hide();
                        });
                    }
                    if (lms.userCountKpi) {
                        Mask.show()
                        lms.dtoList2 = [
                            {
                                code: 'lms_count_of_users_coursewise_weekly',
                                parameters: {
                                    courseId: lms.searchCourseId==='all'?null:lms.searchCourseId,
                                    locationId: lms.selectedLocationId,
                                    roleId: lms.roleId
                                },
                                sequence: 0
                            },
                            {
                                code: 'lms_count_of_users_coursewise_monthly',
                                parameters: {
                                    courseId: lms.searchCourseId==='all'?null:lms.searchCourseId,
                                    locationId: lms.selectedLocationId,
                                    roleId: lms.roleId
                                },
                                sequence: 1
                            }
                        ]
                        QueryDAO.executeAll(lms.dtoList2).then((responses) => {
                            lms.weeklyActiveUserCounts = angular.copy(responses[0].result);
                            lms.monthlyActiveUserCounts = angular.copy(responses[1].result);
                            lms.setUserCount();
                        }).catch((error) => {
                            GeneralUtil.showMessageOnApiCallFailure(error);
                        }).finally(() => {
                            Mask.hide();
                        });
                    }
                    if (lms.stateKpi) {
                        Mask.show()
                        QueryDAO.execute({
                            code: 'lms_heatmap_data',
                            parameters: {
                                courseId: lms.searchCourseId==='all'?null:lms.searchCourseId,
                                roleId: lms.roleId
                                // locationId: lms.selectedLocationId
                            }
                        }).then((resp) => {
                            lms.heatMapData = resp.result
                            lms.setHeatMap()
                        }).catch((error) => {
                            GeneralUtil.showMessageOnApiCallFailure(error);
                        }).finally(() => {
                            Mask.hide();
                        });
                    }

                    lms.headerData.enrolledCount = lms.courseEngagementData.reduce((ele, currentVal) => { return currentVal.enrolled + ele }, 0);
                    lms.headerData.appInstalledCount = lms.courseEngagementData.reduce((ele, currentVal) => { return currentVal.appInstalled + ele }, 0);

                    lms.setHeaders();
                    lms.courseSelection();
                    lms.calculateTotalEngagementData();
                }
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                // lms.toggleFilter();
                Mask.hide()
            });
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

        lms.retrieveEnrolledList = () => {
            Mask.show();
            lms.tempDTO = {
                code: 'lms_dashboard_retrieve_enrolled_by_course_id_v2',
                parameters: {
                    locationId: lms.selectedLocationId,
                    courseId: lms.searchCourseId==='all'?null:lms.searchCourseId,
                    limit: lms.pagingService.limit,
                    offSet: lms.pagingService.offSet
                }
            };
            PagingForQueryBuilderService.getNextPage(QueryDAO.execute, lms.tempDTO, lms.headerData.enrolled, null).then((response) => {
                lms.headerData.enrolled = response;
                console.log(response);
                $("#enrolled_details").modal({ backdrop: 'static', keyboard: false });
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
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

        lms.printExcel = () => {
            lms.pagingService = PagingForQueryBuilderService.initialize();
            Mask.show();
            var queryDto = {
                code: 'lms_dashboard_retrieve_enrolled_by_course_id_v2',
                parameters: {
                    locationId: lms.selectedLocationId,
                    courseId: lms.searchCourseId==='all'?null:lms.searchCourseId,
                    limit: null,
                    offSet: 0
                }
            };
            var entrolledUsers = []
            PagingForQueryBuilderService.getNextPage(QueryDAO.execute, queryDto, entrolledUsers, null).then((response) => {
                // console.log(response);
                if (response.length > 0) {
                    excelData = []
                    response.forEach((member) => {
                        excelData.push({
                            "Participant Name": member.userName,
                            "Role Name": member.roleName,
                            "Course Started On": member.courseStartedOn ? member.courseStartedOn : '-',
                            "Course Completed On": member.courseStatus === 'COMPLETED' ? member.courseEndedOn ?
                                member.courseEndedOn : '-' :
                                '-',
                            "Course Status": member.courseStatus === 'COMPLETED' ? 'Completed' : member.courseStatus === 'IN_PROGRESS' ? 'In Progress' : member.courseStatus === 'NOT_YET_STARTED' ? 'Not yet Started' : '-',
                            "App installed?": member.isLoggedIn,
                        });
                    });
                    lms.processAndDownloadExcel(excelData)
                }
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        lms.processAndDownloadExcel = (data) => {
            let mystyle = {
                headers: true,
                column: { style: { Font: { Bold: "1" } } }
            };
            let fileName = "Enrolled participant";
            let dataCopy = [];
            dataCopy = data;
            dataCopy = JSON.parse(JSON.stringify(dataCopy));
            alasql('SELECT * INTO XLSX("' + fileName + '",?) FROM ?', [mystyle, dataCopy]);
        }

        lms.init();
    }
    angular.module('imtecho.controllers').controller('LMSDashboardControllerV2', LMSDashboardControllerV2);
})();
