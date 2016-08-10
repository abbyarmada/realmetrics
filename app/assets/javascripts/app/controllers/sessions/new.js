angular.module('app').controller('NewSessionController', ['NotificationService', '$scope', '$state', '$mdToast', 'SessionsService',
  function(NotificationService, $scope, $state, $mdToast, SessionsService) {
    /*
     * Public methods
     */
    $scope.login = function() {
      if (NotificationService.setBusyState()) {
        return;
      }

      SessionsService.login({
        session: {
          email: $scope.user.email,
          password: $scope.user.password
        }
      }).$promise.then(handleSuccess, NotificationService.handleError);
    };

    /*
     * Private methods
     */
    var handleSuccess = function() {
      $state.go('home');
    };

    /*
     * Initialiazer
     */
    (function() {
      $scope.user = {};
    })();
  }
]);
