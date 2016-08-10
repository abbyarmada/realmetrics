angular.module('app').controller('GoalDetailsController', ['NotificationService', '$scope', '$state', '$stateParams', '$q', 'GoalsService', 'goals',
  function(NotificationService, $scope, $state, $stateParams, $q, GoalsService, goals) {
    /*
     * Public methods
     */
    $scope.create = function() {
      var jsonGoal = {
        year: Util.toApi($scope.goal.year),
        month: Util.toApi($scope.goal.month),
        metric: $stateParams.metric,
        value: Util.toApi($scope.goal.value),
        growth: Util.toApi($scope.goal.growth),
      };

      GoalsService.set_goals({
        goal: jsonGoal
      }).$promise.then(handleSuccess, NotificationService.handleError);
    };

    $scope.update = function() {
      if (NotificationService.setBusyState()) {
        return;
      }

      var goals = [];

      angular.forEach($scope.goals, function(goal) {
        goals.push({
          year: Util.toApi(goal.year),
          month: Util.toApi(goal.month),
          metric: $stateParams.metric,
          value: Util.toApi(goal.value)
        });
      });

      GoalsService.batch_upsert({
        goals: goals
      }).$promise.then(handleSuccess, NotificationService.handleError);
    };

    $scope.cancel = function() {
      goToPreviousState();
    };

    /*
     * Private methods
     */
    var handleSuccess = function() {
      $scope.$emit('goals.changed');
      goToPreviousState();
    };

    var goToPreviousState = function() {
      $state.go('goals');
    };

    /*
     * Initialiazer
     */
    (function() {
      $scope.goals = goals;
      $scope.goal = {};

      var thisYearGoals = [false, false, false, false, false, false, false, false, false, false, false, false];

      angular.forEach($scope.goals, function(goal) {
        if (goal.year == 2016) {
          thisYearGoals[goal.month - 1] = true;
        }
      });

      for (var i = 0; i < thisYearGoals.length; i++) {
        if (!thisYearGoals[i]) {
          $scope.goals.push({
            year: 2016,
            month: i + 1,
            value: 0
          });
        }
      }
    })();
  }
]);
