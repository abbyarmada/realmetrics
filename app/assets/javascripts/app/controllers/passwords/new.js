angular.module('app').controller('NewPasswordController', ['NotificationService', '$scope', '$state', 'PasswordsService',
  function(NotificationService, $scope, $state, PasswordsService) {
    /*
     * Public methods
     */
    $scope.resetPassword = function() {
      if (NotificationService.setBusyState()) {
        return;
      }

      PasswordsService.create({
        email: $scope.user.email
      }).$promise.then(handleSuccess, NotificationService.handleError);
    };

    /*
     * Private methods
     */
    var handleSuccess = function() {
      NotificationService.removeBusyState();
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
