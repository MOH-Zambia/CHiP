(function () {
    function LMSDashboardControllerV2New(Mask, QueryDAO, GeneralUtil, $filter, $http, PagingForQueryBuilderService, AuthenticateService, toaster) {
        var lms = this;
        lms.showWeeklyGraph = true;
        lms.activeGraph = {}
        lms.activeGraph.user = 'active'
        var width1 = 330, height1 = 350;
        var projection1 = d3.geoMercator().scale(2);
        lms.districtPerformanceOrder = 'desc'
        lms.leadershipBoardOption = 'TS'
        var path1 = d3.geoPath()
            .projection(projection1)
            .pointRadius(2);
        lms.randomMapId1 = "chart1234";
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
        lms.pagingService = PagingForQueryBuilderService.initialize();
        lms.headerDataList = []
        lms.assignedLocType = []
        lms.assignedLocations = []
        lms.assignedLocationIds = []
        lms.childLocType = []
        lms.childLocations = []

        lms.init = function () {
            AuthenticateService.getLoggedInUser().then(function (user) {
                lms.user = user.data
                lms.fetchAssignedLocationTypes()
                lms.fetchAssignedLocations()
            });
        }

        lms.fetchAssignedLocationTypes = function () {
            Mask.show();
            QueryDAO.execute({
                code: 'retrive_location_type_by_level',
                parameters: { level: Number(lms.user.minLocationLevel) }
            }).then((response) => {
                response.result.forEach(element => {
                    lms.assignedLocType.push(element.type.toString())
                });
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        lms.fetchAssignedLocations = function () {
            Mask.show();
            QueryDAO.execute({
                code: 'retrieve_user_assigned_location_by_user_id_and_location_type',
                parameters: {
                    userId: lms.user.id,
                    level: Number(lms.user.minLocationLevel)
                }
            }).then((response) => {
                lms.assignedLocations = response.result
                lms.displayLocationName = ''
                if (response.result.length > 0) {
                    response.result.forEach(element => {
                        lms.assignedLocationIds.push(Number(element.id))
                        if (lms.displayLocationName == '') {
                            lms.displayLocationName = element.name
                        }
                        else {
                            lms.displayLocationName = lms.displayLocationName + " , " + element.name;
                        }
                    });
                    lms.updateAllGraphs()
                }
                else {
                    toaster.pop("info", "We cannot show anything as no Location is assigned to you.")
                }
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        lms.updateAllGraphs = function () {
            lms.fetchChildLocationType()
            lms.fetchCourses()
            lms.setHeaders()
            lms.setUserStatisticsGraph()
            lms.setAllCourseOverviewGraph()
            lms.setDistrictPerformanceData(null)
            lms.setCourseWiseGraph(lms.assignedLocationIds)
            lms.setLearningAppUsageGraph()
            lms.setUserStatusGraph(lms.assignedLocationIds)
            if (lms.user.minLocationLevel == 1) {
                lms.setHeatMap()
            }
            lms.setLeadershipBoard(null)
            lms.setCourseStatistics()
        }

        lms.fetchChildLocationType = function () {
            Mask.show();
            QueryDAO.execute({
                code: 'retrive_location_type_by_level',
                parameters: { level: Number(lms.user.minLocationLevel) + 1 }
            }).then((response) => {
                lms.displayChildLocation = ''
                response.result.forEach(element => {
                    lms.childLocType.push(element.type.toString())
                    if (lms.displayChildLocation == '') {
                        lms.displayChildLocation = element.name
                    }
                    else {
                        lms.displayChildLocation = lms.displayChildLocation + " / " + element.name;
                    }
                });
                lms.fetchChildLocations()
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        lms.fetchChildLocations = function () {
            Mask.show();
            QueryDAO.execute({
                code: 'retrieve_child_locations_by_type_and_user_id',
                parameters: {
                    locationId: lms.assignedLocationIds
                }
            }).then((response) => {
                lms.childLocations = response.result
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            })
        }

        lms.fetchCourses = function () {
            Mask.show();
            QueryDAO.execute({
                code: 'retrieve_lms_course_list',
                parameters: {
                    parentIds: lms.assignedLocationIds
                }
            }).then((response) => {
                lms.courses = response.result
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            })
        }

        lms.setHeaders = function () {
            //fetch values for header
            QueryDAO.execute({
                code: 'lms_header_data_for_total_users',
                parameters: {
                    locationId: lms.assignedLocationIds
                }
            }).then((response) => {
                if (response.result.length > 0) {
                    lms.headerData = response.result[0]
                    lms.headerSectionDataForCol = [{
                        key: 'Total Registered',
                        value: lms.headerData.totalEnrolled,
                        color: 'color-box green',
                        tooltip: 'The users who are enrolled in different courses.'
                    }, {
                        key: 'Total App Installed',
                        value: lms.headerData.totalAppInstalled,
                        color: 'color-box yellow',
                        tooltip: 'The users who have installed the application.'
                    }, {
                        key: 'Total Active',
                        value: lms.headerData.totalActiveUsers,
                        color: 'color-box blue',
                        tooltip: 'The users who are currently using/have used the LMS.'
                    }]
                }
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        lms.setUserStatisticsGraph = function () {
            QueryDAO.execute({
                code: 'lms_retrieve_user_statistics_data',
                parameters: { locationId: lms.assignedLocationIds }
            }).then((response) => {
                if (response.result.length > 0) {
                    var labels = []
                    var enrolledData = []
                    var appInstalledData = []
                    var activeUsersData = []
                    response.result.forEach((item) => {
                        labels.push(item.month)
                        enrolledData.push(item.totalEnrolled)
                        appInstalledData.push(item.totalAppInstalled)
                        activeUsersData.push(item.totalActiveUsers)
                    })
                    lms.userStatisticsSeries = ['Total Registered', 'Total app installed', 'Total active users'];
                    lms.userStatisticsColors = ['#006600', '#ffbb00', '#3333cc'];
                    lms.userStatisticsOptions = {
                        responsive: true,
                        title: {
                            display: false,
                            text: 'User statistics'
                        },
                        legend: {
                            display: true,
                            position: "top"
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
                    lms.userStatisticsData2 = [enrolledData, appInstalledData, activeUsersData];
                    lms.userStatisticsLabel = labels;
                }
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        lms.setAllCourseOverviewGraph = function () {
            QueryDAO.execute({
                code: 'lms_retrieve_all_course_overview_data',
                parameters: { locationId: lms.assignedLocationIds }
            }).then((response) => {
                if (response.result.length > 0) {
                    lms.totalCourse = response.result
                    lms.courseOverviewSeries = ['Completion Rate'];
                    lms.courseOverviewColors = [{
                        backgroundColor: '#3333cc'
                    }];
                    lms.courseOverviewOptions = {
                        responsive: true,
                        layout: {
                            padding: {
                                top: 30
                            }
                        },
                        title: {
                            display: false,
                            text: 'All Courses Overview'
                        },
                        legend: {
                            display: true,
                            position: "bottom"
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
                    response.result.forEach((item) => {
                        labels.push(item.course_name)
                        data.push(item.completion_rate)
                    })
                    lms.courseOverviewData = [data];
                    lms.courseOverviewLabels = labels;
                }
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        lms.setDistrictPerformanceData = function (courseId) {
            QueryDAO.execute({
                code: 'lms_retrieve_district_performance_data',
                parameters: {
                    courseId: courseId,
                    locationId: lms.assignedLocationIds
                }
            }).then((response) => {
                if (response.result.length > 0) {
                    lms.districtPerformanceData = response.result.slice().sort(function(a, b) {
                        return b.completion_rate - a.completion_rate;
                    });
                }
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        lms.setCourseWiseGraph = function (locationId) {
            QueryDAO.execute({
                code: 'lms_retrieve_course_wise_data',
                parameters: {
                    locationId: locationId,
                }
            }).then((response) => {
                lms.courseWiseData = response.result
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            })
        }

        lms.setLearningAppUsageGraph = function () {
            QueryDAO.execute({
                code: 'lms_retrieve_learning_usage_data',
                parameters: {
                    locationId: lms.assignedLocationIds
                }
            }).then((response) => {
                if (response.result.length > 0) {
                    lms.courseList = []
                    lms.learningAppUsage = response.result[0]
                    lms.pieChartLabels = [
                        "Users who have completed all modules",
                        "Users who have started the course",
                        "Users who have not started the course"
                    ];
                    lms.pieChartColors = [
                        '#006600',
                        '#ffbb00',
                        '#3333cc'
                    ];
                    lms.pieChartOptions = {
                        responsive: true,
                        legend: {
                            display: true,
                            position: 'right'
                        },
                        title: {
                            display: true,
                            text: 'Learning App Usage'
                        },
                        plugins: {
                            labels: [{
                                render: function (args) {
                                    return args.value;
                                },
                                fontColor: 'white'
                            }]
                        }
                    }
                    lms.pieChartData = [
                        lms.learningAppUsage.completed,
                        lms.learningAppUsage.inProgress,
                        lms.learningAppUsage.notStarted
                    ]

                    lms.pieChartLabels2 = [
                        // "100% course completed",
                        "76-99% course completed",
                        "51-75% course completed",
                        "26-50% course completed",
                        "Less than or equal to 25% course completed",
                        // "Not started"
                    ];
                    lms.pieChartColors2 = [
                        // '#006600',
                        '#3399ff',
                        '#ffbb00',
                        '#ff6600',
                        '#cc0000',
                        // '#3333cc'
                    ];
                    lms.pieChartOptions2 = {
                        responsive: true,
                        legend: {
                            display: true,
                            position: 'right'
                        },
                        title: {
                            display: true,
                            text: 'User in various Completion Stages'
                        },
                        plugins: {
                            labels: [{
                                render: function (args) {
                                    return args.value;
                                },
                                fontColor: 'white'
                            }]
                        }
                    }
                    lms.pieChartData2 = [
                        // lms.learningAppUsage.completed,
                        lms.learningAppUsage.completed75,
                        lms.learningAppUsage.completed50,
                        lms.learningAppUsage.completed25,
                        lms.learningAppUsage.lessthan25completed,
                        // lms.learningAppUsage.notStarted
                    ];
                }
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            })
        }

        lms.setUserStatusGraph = function (locationId) {
            Mask.show()
            lms.dtoList = [
                {
                    code: 'lms_count_of_users_coursewise_weekly',
                    parameters: {
                        courseId: null,
                        locationId: locationId,
                        roleId: null
                    },
                    sequence: 0
                },
                {
                    code: 'lms_count_of_users_coursewise_monthly',
                    parameters: {
                        courseId: null,
                        locationId: locationId,
                        roleId: null
                    },
                    sequence: 1
                },
                {
                    code: 'lms_header_data_for_total_users',
                    parameters: {
                        locationId: locationId
                    },
                    sequence: 2
                }
            ]
            QueryDAO.executeAll(lms.dtoList).then((responses) => {
                lms.weeklyActiveUserCounts = angular.copy(responses[0].result);
                lms.monthlyActiveUserCounts = angular.copy(responses[1].result);
                lms.totalUsersForActiveGraph = responses[2].result[0].totalAppInstalled
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
                if (lms.activeGraph.user === 'active') {
                    lms.weeklyActiveUserCounts.forEach((item) => {
                        labels.push($filter('date')(item.week, "dd/MM"))
                        data.push(item.count)
                    })
                    lms.barChartSeries = ['Active users']
                }
                else {
                    lms.weeklyActiveUserCounts.forEach((item) => {
                        labels.push($filter('date')(item.week, "dd/MM"))
                        data.push(lms.totalUsersForActiveGraph - item.count)
                    })
                    lms.barChartSeries = ['Inactive users']
                }
                var labels2 = []
                var data2 = []
                if (lms.activeGraph.user === 'active') {
                    lms.monthlyActiveUserCounts.forEach((item) => {
                        labels2.push($filter('date')(item.month, "MMM-yy"))
                        data2.push(item.count)
                    })
                    lms.barChartSeries2 = ['Active users']
                }
                else {
                    lms.monthlyActiveUserCounts.forEach((item) => {
                        labels2.push($filter('date')(item.month, "MMM-yy"))
                        data2.push(lms.totalUsersForActiveGraph - item.count)
                    })
                    lms.barChartSeries2 = ['Inactive users']
                }
                lms.barChartData = [data]
                lms.barChartLabels = labels
                lms.barChartData2 = [data2]
                lms.barChartLabels2 = labels2
                lms.barChartColors = [{
                    backgroundColor: '#3333cc'
                }]
                lms.barChartColors2 = [{
                    backgroundColor: '#3333cc'
                }]
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        lms.setHeatMap = () => {
            Mask.show()
            QueryDAO.execute({
                code: 'lms_heatmap_data',
                parameters: {
                }
            }).then((resp) => {
                lms.heatMapData = resp.result
                lms.stateData2 = lms.heatMapData
                $http.get('telangana-topo-2.json').then(function (response) {
                    lms.data1 = response.data;
                    setBaseGrapth1(lms.data1);
                });
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
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
                    element = lms.stateData2.find(state => d.properties[lms.mapPropertyName1] && d.properties[lms.mapPropertyName1].toLowerCase() == getMappingName(state.x_axis_label).toLowerCase());
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

        function getMappingName(name) {
            return NAME_MAPPING_MAP[name] || name;
        }

        lms.setLeadershipBoard = function (courseId) {
            lms.dtoList = [
                {
                    code: 'lms_dashboard_retrieve_top_scorers_v2',
                    parameters: {
                        courseId: courseId,
                        locationId: lms.assignedLocationIds
                    },
                    sequence: 0
                },
                {
                    code: 'lms_dashboard_retrieve_course_completors_v2',
                    parameters: {
                        courseId: courseId,
                        locationId: lms.assignedLocationIds
                    },
                    sequence: 1
                }
            ]
            QueryDAO.executeAll(lms.dtoList).then((responses) => {
                lms.topScorerData = angular.copy(responses[0].result);
                lms.courseCompletorData = angular.copy(responses[1].result);
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        lms.setCourseStatistics = function () {
            Mask.show()
            lms.dtoList = [
                {
                    code: 'lms_dashboard_retrieve_modules_by_course_id_v2',
                    parameters: {
                        courseId: null,
                        locationId: lms.assignedLocationIds
                    },
                    sequence: 0
                },
                {
                    code: 'lms_dashboard_retrieve_lessons_by_course_id_v2',
                    parameters: {
                        courseId: null,
                        locationId: lms.assignedLocationIds
                    },
                    sequence: 1
                },
                {
                    code: 'lms_dashboard_retrieve_quizzes_by_course_id_v2',
                    parameters: {
                        courseId: null,
                        locationId: lms.assignedLocationIds
                    },
                    sequence: 2
                }
            ]
            QueryDAO.executeAll(lms.dtoList).then((responses) => {
                lms.modules = angular.copy(responses[0].result);
                lms.modules.map(module => module.hoursSpent = module.frequency === 0 ? null : module.hoursSpent === 0 ? '< 1 hr' : module.hoursSpent);
                lms.lessons = angular.copy(responses[1].result);
                lms.lessons.map(lesson => lesson.hoursSpent = lesson.frequency === 0 ? null : lesson.hoursSpent === 0 ? '< 1 hr' : lesson.hoursSpent);
                lms.quizzes = angular.copy(responses[2].result);
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        lms.getColor = function (value) {
            if (value == 100) {
                return '#006600'
            }
            else if (value < 100 && value >= 75) {
                return '#3399ff'
            }
            else if (value < 75 && value >= 50) {
                return '#ffbb00'
            }
            else if (value < 50 && value >= 25) {
                return '#ff6600'
            }
            else if (value < 25) {
                return '#cc0000'
            }
            else {
                return '#3333cc'
            }
        }

        lms.onHeaderSelection = (key) => {
            lms.key = key;
            lms.selectedModule = lms.selectedLesson = lms.selectedQuiz = null;
            switch (key) {
                case 'Total Registered':
                    lms.retrieveEnrolledList();
                    break;
                case 'Total App Installed':
                    lms.retrieveAppInstalledList();
                    break;
                case 'Total Active':
                    lms.retrieveActiveUsersList();
                    break;
                default:
            }
        }

        lms.retrieveEnrolledList = () => {
            Mask.show();
            lms.tempDTO = {
                code: 'lms_dashboard_retrieve_total_registered_members',
                parameters: {
                    locationId: null,
                    limit: lms.pagingService.limit,
                    offset: lms.pagingService.offSet
                }
            };
            PagingForQueryBuilderService.getNextPage(QueryDAO.execute, lms.tempDTO, lms.headerDataList.enrolled, null).then((response) => {
                lms.headerDataList.enrolled = response;
                $("#enrolled_details").modal({ backdrop: 'static', keyboard: false });
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        lms.retrieveAppInstalledList = () => {
            Mask.show();
            lms.tempDTO = {
                code: 'lms_dashboard_retrieve_total_app_installed_members',
                parameters: {
                    locationId: null,
                    limit: lms.pagingService.limit,
                    offset: lms.pagingService.offSet
                }
            };
            PagingForQueryBuilderService.getNextPage(QueryDAO.execute, lms.tempDTO, lms.headerDataList.appInstalled, null).then((response) => {
                lms.headerDataList.appInstalled = response;
                $("#app_details").modal({ backdrop: 'static', keyboard: false });
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        lms.retrieveActiveUsersList = () => {
            Mask.show();
            lms.tempDTO = {
                code: 'lms_dashboard_retrieve_total_active_members',
                parameters: {
                    locationId: null,
                    limit: lms.pagingService.limit,
                    offset: lms.pagingService.offSet
                }
            };
            PagingForQueryBuilderService.getNextPage(QueryDAO.execute, lms.tempDTO, lms.headerDataList.activeUsers, null).then((response) => {
                lms.headerDataList.activeUsers = response;
                $("#active_details").modal({ backdrop: 'static', keyboard: false });
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        lms.modalClose = (key) => {
            switch (key) {
                case 'Total Registered':
                    $("#enrolled_details").modal('hide');
                    lms.pagingService = PagingForQueryBuilderService.initialize();
                    break;
                case 'Total App Installed':
                    $("#app_details").modal('hide');
                    lms.pagingService = PagingForQueryBuilderService.initialize();
                    break;
                case 'Total Active':
                    $("#active_details").modal('hide');
                    lms.pagingService = PagingForQueryBuilderService.initialize();
                    break;
                default:
            }
            lms.lineData = [];
            lms.series = [];
            lms.labels = [];
            lms.lineChartData = [];
            lms.selectedComponentForLineChart = null;
        }

        lms.printExcelForEnrolledMembers = () => {
            lms.pagingService = PagingForQueryBuilderService.initialize();
            Mask.show();
            var queryDto = {
                code: 'lms_dashboard_retrieve_total_registered_members',
                parameters: {
                    locationId: null,
                    limit: null,
                    offset: 0
                }
            };
            var entrolledUsers = []
            PagingForQueryBuilderService.getNextPage(QueryDAO.execute, queryDto, entrolledUsers, null).then((response) => {
                if (response.length > 0) {
                    excelData = []
                    response.forEach((member) => {
                        excelData.push({
                            "Participant Name": member.participantName,
                            "User Name": member.userName,
                            "Role Name": member.roleName,
                            "Contact Number": member.contactNumber,
                            "App installed?": member.appInstalled,
                            "District": member.district,
                            "Division": member.division,
                            "Mandal": member.mandal,
                            "PHC": member.phc,
                            "SC": member.sc
                        });
                    });
                    lms.processAndDownloadExcel(excelData, "Total registered users")
                }
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        lms.printExcelForAppInstalledMembers = () => {
            lms.pagingService = PagingForQueryBuilderService.initialize();
            Mask.show();
            var queryDto = {
                code: 'lms_dashboard_retrieve_total_app_installed_members',
                parameters: {
                    locationId: null,
                    limit: null,
                    offset: 0
                }
            };
            var entrolledUsers = []
            PagingForQueryBuilderService.getNextPage(QueryDAO.execute, queryDto, entrolledUsers, null).then((response) => {
                if (response.length > 0) {
                    excelData = []
                    response.forEach((member) => {
                        excelData.push({
                            "Participant Name": member.participantName,
                            "User Name": member.userName,
                            "Role Name": member.roleName,
                            "District": member.district,
                            "Last login": member.last_login
                        });
                    });
                    lms.processAndDownloadExcel(excelData, "Total app installed users")
                }
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        lms.printExcelForActiveMembers = () => {
            lms.pagingService = PagingForQueryBuilderService.initialize();
            Mask.show();
            var queryDto = {
                code: 'lms_dashboard_retrieve_total_active_members',
                parameters: {
                    locationId: null,
                    limit: null,
                    offset: 0
                }
            };
            var entrolledUsers = []
            PagingForQueryBuilderService.getNextPage(QueryDAO.execute, queryDto, entrolledUsers, null).then((response) => {
                if (response.length > 0) {
                    excelData = []
                    response.forEach((member) => {
                        excelData.push({
                            "Participant Name": member.participantName,
                            "User Name": member.userName,
                            "Role Name": member.roleName,
                            "District": member.district
                        });
                    });
                    lms.processAndDownloadExcel(excelData, "Total active users")
                }
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        lms.processAndDownloadExcel = (data, fileName) => {
            let mystyle = {
                headers: true,
                column: { style: { Font: { Bold: "1" } } }
            };
            let dataCopy = [];
            dataCopy = data;
            dataCopy = JSON.parse(JSON.stringify(dataCopy));
            alasql('SELECT * INTO XLSX("' + fileName + '",?) FROM ?', [mystyle, dataCopy]);
        }

        lms.init();
    }
    angular.module('imtecho.controllers').controller('LMSDashboardControllerV2New', LMSDashboardControllerV2New);
})();
