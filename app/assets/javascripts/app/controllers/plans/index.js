angular.module('app').controller('PlansController', ['NotificationService', '$scope', 'plans',
  function(NotificationService, $scope, plans) {
    /*
     * Initialiazer
     */
    (function() {
      $scope.plans = plans;
    })();
  }
]);
