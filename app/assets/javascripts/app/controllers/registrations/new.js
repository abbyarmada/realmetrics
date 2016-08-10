angular.module('app').controller('NewRegistrationController', ['NotificationService', '$scope', '$state', '$mdToast', 'RegistrationsService',
  function(NotificationService, $scope, $state, $mdToast, RegistrationsService) {
    /*
     * Public methods
     */
    $scope.signup = function() {
      if (NotificationService.setBusyState()) {
        return;
      }

      RegistrationsService.signup({
        user: {
          email: $scope.user.email,
          password: $scope.user.password
        }
      }).$promise.then(handleSuccess, NotificationService.handleError);
    };

    /*
     * Private methods
     */
    var handleSuccess = function() {
      NotificationService.removeBusyState();
      $state.go('setup');
    };

    /*
     * Initialiazer
     */
    (function() {
      $scope.user = {};
    })();
  }
]);
