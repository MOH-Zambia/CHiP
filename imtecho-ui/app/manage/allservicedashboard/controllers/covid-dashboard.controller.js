(function () {
    function CovidDashboardController(QueryDAO,GeneralUtil,Mask,AuthenticateService) {
        let ctrl = this;

        ctrl.init = () => {
            AuthenticateService.getLoggedInUser().then(function (res) {
                ctrl.currentUser = res.data;
                ctrl.selectedLocationId = ctrl.currentUser.minLocationId;
                ctrl.chartCount();
                ctrl.tableCount();

            });
            }
            ctrl.onSearch = () =>
                {
                        ctrl.chartCount();
                        ctrl.tableCount();
                        ctrl.toggleFilter();
                }
            
            ctrl.toggleFilter = () => {
                    if (angular.element('.filter-div').hasClass('active')) {
                        angular.element('body').css("overflow", "auto");
                    } else {
                        angular.element('body').css("overflow", "hidden");
                    }
                    angular.element('.cst-backdrop').fadeToggle();
                    angular.element('.filter-div').toggleClass('active');
                };
        ctrl.chartCount = () =>
            {
                let pieQueryDto = {
                    code: 'fetch_covid_pie_chart_data',
                    parameters: {
                        location_id: ctrl.selectedLocationId   
                    }
                };
                Mask.show();
                QueryDAO.executeQuery(pieQueryDto).then(function (res) {
                    let pieResult = JSON.parse(res.result[0].result);
                    ctrl.setPieChart(pieResult);
                    
                    }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                    Mask.hide();
                });
    
                // let barQueryDto = {
                //     code: 'fetch_covid_bar_chart_data',
                //     parameters: {
                //         location_id: 554988   
                //     }
                // };
               
    
                // QueryDAO.executeQuery(barQueryDto).then(function (res) {
                //     let barResult = JSON.parse(res.result[0].result);
                //     ctrl.barChartLabels = barResult.labels;
                //     ctrl.barChartData = barResult.values;
                // }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                //     ctrl.setBarChart();
                //     Mask.hide();
                // });
            }

        ctrl.setPieChart = (pieResult) => {
           
            ctrl.pieChartColors = [
                '#38812F',
                '#004B95',
                '#F0AB00'
            ];
            ctrl.pieChartOptions = {
                responsive: true,
                legend: {
                    display: true,
                    position: 'right'
                },
                title: {
                    display: false,
                    text: 'Population'
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
            ctrl.pieChartLabels = pieResult.labels;
            ctrl.pieChartData = pieResult.values;
            
        }

        ctrl.setBarChart = () => {
            ctrl.barChartOptions = {
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
                                beginAtZero: true,
                                stepSize: 20,
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
            
            ctrl.barChartSeries = ['Vaccine type wise adverse effect']
            ctrl.barChartColors = [{
                backgroundColor: '#3333cc'
            }];
            
        }

        ctrl.tableCount = () =>
            {
                let tableQueryDto = {
                    code: 'fetch_covid_table_data',
                    parameters: {
                        location_id: ctrl.selectedLocationId   
                    }
                };
                Mask.show();
                QueryDAO.executeQuery(tableQueryDto).then(function (res) {
                    ctrl.covidTableData = res.result;
                }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                    Mask.hide();
                })
            }

        ctrl.init();

    }
    angular.module('imtecho.controllers').controller('CovidDashboardController', CovidDashboardController);
})();
