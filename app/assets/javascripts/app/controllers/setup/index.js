angular.module('app').controller('SetupController', ['NotificationService', '$scope', 'current_organization',
  function(NotificationService, $scope, current_organization) {
    /*
     * Initialiazer
     */
    (function() {
      $scope.current_organization = current_organization;
      $scope.goal = {};
    })();
  }
]);
