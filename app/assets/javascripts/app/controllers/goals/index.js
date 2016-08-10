angular.module('app').controller('GoalsController', ['NotificationService', '$scope', '$rootScope', '$timeout', '$filter', 'gross_revenue_goals', 'customers_count_goals', 'GoalsService',
  function(NotificationService, $scope, $rootScope, $timeout, $filter, gross_revenue_goals, customers_count_goals, GoalsService) {
    /*
     * Listeners
     */
    $rootScope.$on('goals.changed',
      function() {
        GoalsService.query({
          metric: 'gross_revenue'
        }).$promise.then(
          function(gross_revenue_goals) {
            $scope.gross_revenue_goals = gross_revenue_goals;

            $scope.grossRevenueGoalsReport.update(
              getGrossRevenueGoalsReportData(),
              getGrossRevenueGoalsReportOptions()
            );
          },
          NotificationService.handleError
        );

        GoalsService.query({
          metric: 'customers_count'
        }).$promise.then(
          function(customers_count_goals) {
            $scope.customers_count_goals = customers_count_goals;

            $scope.customersCountGoalsReport.update(
              getCustomersCountGoalsReportData(),
              getCustomersCountGoalsReportOptions()
            );
          },
          NotificationService.handleError
        );
      }
    );

    /*
     * Private methods
     */
    var getGrossRevenueGoalsReportData = function() {
      return {
        labels: $scope.gross_revenue_goals.map(function(item, index) {
          return $filter('monthName')($scope.gross_revenue_goals[index].month);
        }),
        series: [{
          data: $scope.gross_revenue_goals.map(function(item, index) {
            return $scope.gross_revenue_goals[index].value / 100.0;
          })
        }]
      };
    };

    var getGrossRevenueGoalsReportOptions = function() {
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

    var drawGrossRevenueGoalsReport = function() {
      $scope.grossRevenueGoalsReport = new Chartist.Line(
        '#grossRevenueGoalsReport',
        getGrossRevenueGoalsReportData(),
        getGrossRevenueGoalsReportOptions()
      );
    };

    var getCustomersCountGoalsReportData = function() {
      return {
        labels: $scope.customers_count_goals.map(function(item, index) {
          return $filter('monthName')($scope.customers_count_goals[index].month);
        }),
        series: [{
          data: $scope.customers_count_goals.map(function(item, index) {
            return $scope.customers_count_goals[index].value / 100.0;
          })
        }]
      };
    };

    var getCustomersCountGoalsReportOptions = function() {
      return {
        lineSmooth: true,
        axisY: {
          type: Chartist.AutoScaleAxis,
          onlyInteger: true
        }
      };
    };

    var drawCustomersCountGoalsReport = function() {
      $scope.customersCountGoalsReport = new Chartist.Line(
        '#customersCountGoalsReport',
        getCustomersCountGoalsReportData(),
        getCustomersCountGoalsReportOptions()
      );
    };

    /*
     * Initialiazer
     */
    (function() {
      $scope.gross_revenue_goals = gross_revenue_goals;
      $scope.customers_count_goals = customers_count_goals;

      $timeout(function() {
        drawGrossRevenueGoalsReport();
        drawCustomersCountGoalsReport();
      });
    })();
  }
]);
