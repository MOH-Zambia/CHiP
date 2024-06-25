(function () {
  function FeatureUsageController($filter, Mask, toaster, QueryDAO, $scope, RoleService) {
    var ctrl = this;
    var bubbleChartData = [];
    var demochart;
    var showGraphs;
    var roleIds;
    var bubbleDisplay;

    ctrl.initPage = function () {

      ctrl.usage = [];
      ctrl.pageTitles = [];
      ctrl.avgUsage = [];
      ctrl.maxUsage = [];
      ctrl.pageCount = [];
      ctrl.userCount = [];
      ctrl.percentValue = [];
      ctrl.filteredData = [];
      ctrl.pageList = ctrl.filteredpageList = ctrl.selectedPage = [];
      ctrl.roleList = ctrl.filteredroleList = ctrl.selectedRole = [];

      var previousDay = new Date();
      ctrl.todayFormatted = $filter('date')(previousDay, 'yyyy-MM-dd');
      ctrl.startDate = new Date();
      ctrl.startDate.setDate(previousDay.getDate() - 7);
      ctrl.endDate = previousDay;
      demochart = new Chart(document.getElementById("bubble-chart"), {
        type: 'bubble',
        data: {},
        options: {
          //responsive: true,
          plugins: {
            legend: {
              display: false
            },
            tooltip: {
              callbacks: {
                label: function (context) {
                  let label = context.dataset.label || '';
                  return label;
                }
              }
            }
          },
          scales: {
            xAxis: {
              display: false,
            },
            yAxis: {
              display: false,
            }
          }
        }
      });
      showGraphs = true;
      ctrl.fetchRoles();
    }

    ctrl.fetchData = function () {
      Mask.show();
      ctrl.usage = [];
      ctrl.pageTitles = [];
      ctrl.avgUsage = [];
      ctrl.maxUsage = [];
      ctrl.pageCount = [];
      ctrl.userCount = [];
      ctrl.percentValue = [];
      ctrl.filteredData = [];
      bubbleChartData = [];

      let dtoUsage = {
        code: 'feature_usage_analytics',
        parameters: {
          end_date: $filter('date')(ctrl.endDate, 'dd-MM-yyyy'),
          from_date: $filter('date')(ctrl.startDate, 'dd-MM-yyyy'),
          rids: roleIds
        }
      };

      QueryDAO.execute(dtoUsage).then((data) => {
        ctrl.usage = data.result;
        var xValues = [8, 5, 7, 9, 4, 2, 6, 3, 10, 1];
        var yValues = [5, 9, 2, 10, 1, 4, 3, 6, 7, 8];
        var bValues = ["rgba(255,221,50,0.2)", "rgba(60,186,159,0.2)", "rgba(0,0,0,0.2)", "rgba(193,46,12,0.2)", "rgba(255,221,50,0.2)", "rgba(60,186,159,0.2)", "rgba(0,0,0,0.2)", "rgba(193,46,12,0.2)", "rgba(255,221,50,0.2)", "rgba(60,186,159,0.2)"];
        var bdValues = ["rgba(255,221,50,1)", "rgba(60,186,159,1)", "#000", "rgba(193,46,12,1)", "rgba(255,221,50,1)", "rgba(60,186,159,1)", "#000", "rgba(193,46,12,1)", "rgba(255,221,50,1)", "rgba(60,186,159,1)"];
        var count = 0, maxR = 80, minR = 30;
        if (ctrl.usage.length > 0) {
          ctrl.filteredData = ctrl.usage.filter((tmp) => {
            return ctrl.filteredpageList.some((t) => {
              return t === tmp.menu_name
            })
          });
          if (ctrl.filteredData.length > 0) {
            if (ctrl.filteredData && ctrl.filteredData.length >= 10) {
              minValue = ctrl.filteredData[9].page_count;
              maxValue = ctrl.filteredData[0].page_count
            }
            else if (ctrl.filteredData && ctrl.filteredData.length < 10) {
              minValue = ctrl.filteredData[ctrl.filteredData.length - 1].page_count;
              maxValue = ctrl.filteredData[0].page_count
            }
            else if (!ctrl.filteredData) {
              minValue = 0;
              maxValue = 0
            }
            else {
              minValue = minR;
              maxValue = maxR
            }



            angular.forEach(ctrl.filteredData, function (value, key) {
              ctrl.pageTitles.push(value.menu_name);
              ctrl.avgUsage.push((value.avg_time / 1000).toFixed(0));
              ctrl.maxUsage.push((value.max_time / 1000).toFixed(0));
              ctrl.pageCount.push(value.page_count);
              ctrl.userCount.push(value.user_count);
              ctrl.percentValue.push(value.percentvalue).toFixed(2);

              if (ctrl.filteredData.length >= 10) {
                if (count < 10) {
                  bubbleChartData.push({
                    label: ["Page Title : " + value.menu_name,
                    "Number of times page visited : " + value.page_count,
                    "Distinct number of users visited the page :" + value.user_count],
                    backgroundColor: bValues[count],
                    borderColor: bdValues[count],
                    title: value.menu_name,
                    hoverRadius: 0,
                    data: [{
                      x: xValues[count],
                      y: yValues[count],
                      r: (maxValue !== minValue) ? (((maxR - minR) * (value.page_count - minValue) / (maxValue - minValue)) + minR).toFixed(0) : minR
                    }]
                  })
                }
              }
              else {
                bubbleChartData.push({
                  label: ["Page Title : " + value.menu_name,
                  "Number of times page visited : " + value.page_count,
                  "Distinct number of users visited the page :" + value.user_count],
                  backgroundColor: bValues[count],
                  borderColor: bdValues[count],
                  title: value.menu_name,
                  hoverRadius: 0,
                  data: [{
                    x: xValues[count],
                    y: yValues[count],
                    r: (maxValue !== minValue) ? (((maxR - minR) * (value.page_count - minValue) / (maxValue - minValue)) + minR).toFixed(0) : minR
                  }]
                })
              }
              count++
            });
            bubbleDisplay = document.getElementById("myDIV");
            bubbleDisplay.style.display = "block";
          }
          else
          {
            bubbleDisplay = document.getElementById("myDIV");
            bubbleDisplay.style.display = "none";
          }
        }
        else {
          ctrl.usage = [];
          ctrl.pageTitles = [];
          ctrl.avgUsage = [];
          ctrl.maxUsage = [];
          ctrl.pageCount = [];
          ctrl.userCount = [];
          ctrl.percentValue = [];
          ctrl.filteredData = [];
          bubbleChartData = [];
          bubbleDisplay = document.getElementById("myDIV");
          bubbleDisplay.style.display = "none";
        }
        ctrl.setGraph1();
        ctrl.setGraph2();
        Mask.hide();
      }).catch((err) => {
        Mask.hide();
        toaster.pop('error', err.data.message);
      })

      Mask.hide();
    }

    ctrl.fetchPages = function () {
      Mask.show();
      let dtoPage = {
        code: 'menu_list_by_role_ids',
        parameters: {
          rids: roleIds
        }
      };
      ctrl.pageList = ctrl.filteredpageList = [];
      QueryDAO.execute(dtoPage).then((data) => {
        angular.forEach(data.result, function (page) {
          ctrl.pageList.push(page.menu_name);
        })
        ctrl.fetchData();
      }).catch((err) => {
        Mask.hide();
        toaster.pop('error', err.data.message);
      });
    }

    ctrl.fetchRoles = function () {
      Mask.show();
      RoleService.getAllRoles().then((data) => {
        ctrl.roleList = ctrl.filteredroleList = [...data];
        roleIds = [];
        angular.forEach(ctrl.filteredroleList, function (role) {
          roleIds.push(role.id)
        })
        ctrl.fetchPages();
      }).catch((err) => {
        Mask.hide();
        toaster.pop('error', err.data.message);
      });
    }

    ctrl.onSelectedPageChange = function () {
      Mask.show();
      ctrl.filteredpageList = ctrl.pageList.filter((page) => {
        if (Array.isArray(ctrl.selectedPage) && ctrl.selectedPage.length) {
          return ctrl.selectedPage.includes(page);
        } else {
          return true;
        }
      });
      ctrl.fetchData();
    }

    ctrl.onSelectedRoleChange = function () {
      Mask.show();
      ctrl.filteredroleList = ctrl.roleList.filter((role) => {
        if (Array.isArray(ctrl.selectedRole) && ctrl.selectedRole.length) {
          return ctrl.selectedRole.includes(role);
        } else {
          return true;
        }
      });
      roleIds = [];
      angular.forEach(ctrl.filteredroleList, function (role) {
        roleIds.push(role.id)
      })
      ctrl.selectedPage = [];
      ctrl.fetchPages();
      Mask.hide();
    }

    ctrl.onDateChange = function () {
      ctrl.fetchData();
    }

    ctrl.setGraph1 = function () {

      $scope.labels = ctrl.pageTitles;
      $scope.series = ['Average usage of all visits', 'Maximum usage of all visits'];
      $scope.data = [ctrl.avgUsage, ctrl.maxUsage];
      $scope.ColorBar = ['#2b7dce', '#FF6600'];
      $scope.options = {
        plugins: {
          labels: {
            render: () => { }
          }
        },
        legend: {
          display: true
        },
        scales: {
          yAxes: [
            {
              position: 'left',
              scaleLabel: {
                display: true,
                labelString: 'Time in seconds'
              },
              gridLines: {
                display: false
              },
              stacked: true
            },
          ],
          xAxes: [{
            display: true,
            scaleLabel: {
              display: false,
              labelString: 'Page titles'
            },
            gridLines: {
              display: false
            },
            stacked: true
          }]
        }
      }
    }

    ctrl.setGraph2 = function () {
      demochart.data = {
        datasets: bubbleChartData
      }
      Chart.register({
        id: 'bubble-chart',
        afterDatasetsDraw: function (chart, args, options) {
          var ctx = chart.ctx

          chart.data.datasets.forEach(function (dataset, i) {
            var meta = chart.getDatasetMeta(i)
            var txt = dataset.label;
            var txtSize = ctx.measureText(txt).width
            var that = this;
            if (meta.type == 'bubble') {
              meta.data.forEach(function (element, index) {
                ctx.textAlign = 'center'
                ctx.textBaseline = 'middle'
                var position = element.tooltipPosition()
                ctx.fillText(dataset.title, position.x + element.options.radius, position.y);

              })
            }
          })
        },
      })
      demochart.update();
      Mask.hide();
    }

    ctrl.initPage();
  }

  angular.module('imtecho.controllers').controller('FeatureUsageController', FeatureUsageController);
})();
