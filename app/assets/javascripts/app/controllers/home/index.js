angular.module('app').controller('HomeController', ['NotificationService', '$scope', 'revenues', 'customers', '$timeout', '$filter',
  function(NotificationService, $scope, revenues, customers, $timeout, $filter) {
    /*
     * Private methods
     */
    var getRevenuesReportData = function() {
      return {
        labels: $scope.revenues.data[0].data.map(function(item, index) {
          return $filter('shortMonthName')(index + 1);
        }),
        series: [{
          data: $scope.revenues.data[0].data.map(function(item, index) {
            return $scope.revenues.data[0].data[index].goal / 100.0;
          })
        }, {
          data: $scope.revenues.data[0].data.map(function(item, index) {
            var amount = $scope.revenues.data[0].data[index].amount;
            return amount > 0 ? amount / 100.0 : null;
          })
        }]
      };
    };

    var getRevenuesReportOptions = function() {
      return {
        lineSmooth: true,
        axisY: {
          labelInterpolationFnc: function(value) {
            return $filter('currency')(value, '$', 0);
          },
          type: Chartist.AutoScaleAxis,
          onlyInteger: true
        }
      };
    };

    var drawRevenuesReport = function() {
      if ($scope.current_organization.initial_crawl_completed) {
        $scope.revenuesReport = new Chartist.Line(
          '#revenuesReport',
          getRevenuesReportData(),
          getRevenuesReportOptions()
        );
      }
    };

    var getCustomersReportData = function() {
      return {
        labels: $scope.customers.data[0].data.map(function(item, index) {
          return $filter('shortMonthName')(index + 1);
        }),
        series: [{
          data: $scope.customers.data[0].data.map(function(item, index) {
            return $scope.customers.data[0].data[index].goal / 100.0;
          })
        }, {
          data: $scope.customers.data[0].data.map(function(item, index) {
            var amount = $scope.customers.data[0].data[index].amount;
            return amount > 0 ? amount / 100.0 : null;
          })
        }]
      };
    };

    var getCustomersReportOptions = function() {
      return {
        lineSmooth: true,
        axisY: {
          type: Chartist.AutoScaleAxis,
          onlyInteger: true
        }
      };
    };

    var drawCustomersReport = function() {
      if ($scope.current_organization.initial_crawl_completed) {
        $scope.customersReport = new Chartist.Line(
          '#customersReport',
          getCustomersReportData(),
          getCustomersReportOptions()
        );
      }
    };

    /*
     * Initialiazer
     */
    (function() {
      $scope.revenues = revenues;
      $scope.customers = customers;

      $timeout(function() {
        drawRevenuesReport();
        drawCustomersReport();
      });
    })();
  }
]);
