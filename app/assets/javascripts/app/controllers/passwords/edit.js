angular.module('app').controller('EditPasswordController', ['NotificationService', '$scope', '$state', '$stateParams', '$mdToast', 'PasswordsService',
  function(NotificationService, $scope, $state, $stateParams, $mdToast, PasswordsService) {
    /*
     * Public methods
     */
    $scope.updatePassword = function() {
      if (NotificationService.setBusyState()) {
        return;
      }

      PasswordsService.update({
        reset_password_token: $stateParams.token,
        password: $scope.user.password
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
