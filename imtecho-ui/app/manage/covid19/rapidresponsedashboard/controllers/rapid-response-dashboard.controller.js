(function () {
    function Covid19DashboardController(Mask, QueryDAO, GeneralUtil, $state, $http) {
        var covid19Dashboardctrl = this;
        var NAME_MAPPING_MAP = {
            'Jam Kandorna': 'Jamkandorna',
            'Vinchhiya': 'Vinchchiya',
            'Kotda Sangani': 'Kotada sangani',
            'Gir Somnath': 'Gir Somnath',
            'Kachchh': 'Kutch',
            'Mahesana': 'mehsana'
        };

        var CORPORATION = [
            {
                name: "Rajkot Corporation",
                location: {
                    latitude: 22.2757,
                    longitude: 70.8070
                }
            },
            {
                name: "Bhavnagar Corporation",
                location: {
                    latitude: 21.7716,
                    longitude: 72.1458
                }
            },
            {
                name: "Ganghinagar Corporation",
                location: {
                    latitude: 23.237560,
                    longitude: 72.647781
                }
            },
            {
                name: "Junagadh Corporation",
                location: {
                    latitude: 21.5190,
                    longitude: 70.4598
                }
            },
            {
                name: "Surat Corporation",
                location: {
                    latitude: 21.170240,
                    longitude: 72.831062
                }
            },
            {
                name: "Vadodara Corporation",
                location: {
                    latitude: 22.310696,
                    longitude: 73.192635
                }
            },
            {
                name: "Ahmedabad Corporation",
                location: {
                    latitude: 23.033863,
                    longitude: 72.585022
                }
            },
            {
                name: "Jamnagar Corporation",
                location: {
                    latitude: 22.4687,
                    longitude: 70.0674
                }
            }
        ];

        covid19Dashboardctrl.chartOptions = {
            legend: {
                display: true
            },
            scales: {
                yAxes: [{
                    scaleLabel: {
                        display: true,
                        labelString: '(% of population cover)'
                    }
                }],
                xAxes: [{
                    scaleLabel: {
                        display: true,
                        labelString: '(Location)'
                    }
                }]
            },
            plugins: {
                labels: {
                    render: function () {
                        return '';
                    }
                }
            },
            responsive: true,
            maintainAspectRatio: false,
        };

        covid19Dashboardctrl.pieChartData = {};
        covid19Dashboardctrl.pieChartData.labels = [];
        covid19Dashboardctrl.pieChartData.countData = [];
        covid19Dashboardctrl.barChartData = {};
        covid19Dashboardctrl.barChartData.labels = [];
        covid19Dashboardctrl.series = ['IDSP Population coverage in % till date'];
        covid19Dashboardctrl.barChartData.countData = [];

        covid19Dashboardctrl.pieChartOptions = {
            responsive: true,
            maintainAspectRatio: false,
            legend: {
                display: true
            },
            plugins: {
                labels: [{
                    render: function (args) {
                        return '';
                    },
                    position: 'outside',
                }]
            }
        };

        covid19Dashboardctrl.lineChartOptions = {
            legend: { display: true },
        };

        covid19Dashboardctrl.init = function () {
            covid19Dashboardctrl.getChartData();
        };

        covid19Dashboardctrl.lineChart = {};
        covid19Dashboardctrl.lineChart.labels = ["January", "February", "March", "April", "May", "June", "July"];
        covid19Dashboardctrl.lineChart.series = ['Sample Tested', 'Positive Cases'];
        covid19Dashboardctrl.lineChart.data = [
            [0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0],
        ];

        covid19Dashboardctrl.getChartData = function () {
            //bar chart
            let dto = {
                code: 'covid19_dashboard_population_coverage_per',
                parameters: {
                }
            };
            Mask.show();
            QueryDAO.execute(dto).then(function (res) {
                var data = res.result;
                var countData = [];
                angular.forEach(data, function (obj) {
                    covid19Dashboardctrl.barChartData.labels.push(obj.label);
                    countData.push(obj.series_label);
                });
                covid19Dashboardctrl.barChartData.countData.push(countData);
            }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                Mask.hide();
            });
            //pie chart
            dto = {
                code: 'covid19_dashboard_person_wiith_ho_symptoms_travel',
                parameters: {
                }
            };
            Mask.show();
            QueryDAO.execute(dto).then(function (res) {
                var JsonObj = res.result[0];
                for (var key in JsonObj) {
                    covid19Dashboardctrl.pieChartData.labels.push(key);
                    covid19Dashboardctrl.pieChartData.countData.push(JsonObj[key]);
                }
            }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                Mask.hide();
            });
            //state map
            dto = {
                code: 'covid19_dashboard_population_coverage_with_colors',
                parameters: {
                }
            };
            Mask.show();
            QueryDAO.execute(dto).then(function (res) {
                covid19Dashboardctrl.stateData1 = res.result;
                $http.get('Gujarat-Topo.json').then(function (response) {
                    covid19Dashboardctrl.data = response.data;
                    setBaseGrapth(covid19Dashboardctrl.data);
                });
            }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                Mask.hide();
            });
            //testing status table
            dto = {
                code: 'covid19_dashboard_testing_status_table',
                parameters: {
                }
            };
            Mask.show();
            QueryDAO.execute(dto).then(function (res) {
                covid19Dashboardctrl.testingStatus = res.result[0];
            }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                Mask.hide();
            });
        };

        //Generating State Map

        var width = 236, height = 200;
        var projection = d3.geoMercator().scale(2);

        var path = d3.geoPath()
            .projection(projection)
            .pointRadius(2);
        covid19Dashboardctrl.randomMapId = "chart123";
        document.getElementById(covid19Dashboardctrl.randomMapId).innerHTML = "";   // clear previous chart

        var svg = d3.select("#" + covid19Dashboardctrl.randomMapId).append("svg")
            .attr("width", width)
            .attr("height", height);

        var g = svg.append("g");

        covid19Dashboardctrl.mapCode = "polygons";
        covid19Dashboardctrl.mapPropertyName = "District";

        function setBaseGrapth(data) {
            centerZoom(data);
            drawSubUnits(data);
            // colorSubunits(subunits);
            // drawSubUnitLabels(data);
            // drawPlaces(data);
            // drawOuterBoundary(data, boundary);
            // setDataPoint();
        }

        function centerZoom(data) {
            var o = topojson.mesh(data, data.objects[covid19Dashboardctrl.mapCode], function (x, y) {
                return x === y;
            });
            projection
                .scale(1)
                .translate([0, 0]);
            var b = path.bounds(o),
                s = 1 / Math.max((b[1][0] - b[0][0]) / width, (b[1][1] - b[0][1]) / height);
            projection
                .scale(s)
                .translate([(width - s * (b[1][0] + b[0][0])) / 2, (height - s * (b[1][1] + b[0][1])) / 2]);
            return o;
        }

        function drawSubUnits(data) {
            var tooltip = d3.select("body").append("div")
                .attr("class", "covid-19-tooltip")
                .style("opacity", 0);

            var subunits = g.selectAll(".subunit")
                .data(topojson.feature(data, data.objects[covid19Dashboardctrl.mapCode]).features)
                .enter().append("path")
                .attr("class", "subunit")
                .attr("d", path)
                .style("opacity", function (d) {
                    for (let stateData of covid19Dashboardctrl.stateData1) {
                        if (d.properties[covid19Dashboardctrl.mapPropertyName] && d.properties[covid19Dashboardctrl.mapPropertyName].toLowerCase() == getMappingName(stateData.x_axis_label).toLowerCase()) {
                            if (stateData.opacity == 0) {
                                return 0.1;
                            } else {
                                return stateData.opacity;
                            }
                        }
                    }
                })
                .style("fill", function (d) {
                    // console.info(d.properties.ac_name);
                    for (let stateData of covid19Dashboardctrl.stateData1) {
                        if (d.properties[covid19Dashboardctrl.mapPropertyName] && d.properties[covid19Dashboardctrl.mapPropertyName].toLowerCase() == getMappingName(stateData.x_axis_label).toLowerCase()) {
                            return stateData.color;
                        }
                    }
                })
                .style("stroke", "#fff")
                .style("stroke-width", "1px")
                .on("click", function (d) {
                    console.log(d.properties.District)
                    let districtname = d.properties.District
                    covid19Dashboardctrl.stateData1.find(state => districtname == state.x_axis_label);
                    // me.onSelectLocation(element)
                })
                .on('mouseover', function (d) {
                    element = covid19Dashboardctrl.stateData1.find(state => d.properties.District == state.x_axis_label);
                    if (!!element) {
                        tooltip.transition()
                            .duration(200)
                            .style("opacity", .9);
                        tooltip.html(d.properties.District + ":" + element.series_label + "%")
                            .style("left", (d3.event.pageX) + "px")
                            .style("top", (d3.event.pageY - 28) + "px");
                    }
                })
                .on('mouseout', function () {
                    tooltip.transition()
                        .duration(500)
                        .style("opacity", 0);
                });
            // Set corporation
            g.selectAll()
                .data(CORPORATION)
                .enter().append("circle")
                .attr("r", 4)
                .style("stroke", "white")
                .attr("transform", function (d) {
                    return "translate(" + projection([
                        d.location.longitude,
                        d.location.latitude
                    ]) + ")";
                }).style("fill", function (d) {
                    for (let stateData of covid19Dashboardctrl.stateData1) {
                        if (d.name.toLowerCase() == getMappingName(stateData.x_axis_label).toLowerCase()) {
                            return stateData.color;
                        }
                    }
                });
            return subunits;
        }

        function getMappingName(name) {
            return NAME_MAPPING_MAP[name] || name;
        }

        covid19Dashboardctrl.init();
    }
    angular.module('imtecho.controllers').controller('Covid19DashboardController', Covid19DashboardController);
})();
