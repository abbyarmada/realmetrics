angular.module('app').controller('ConfirmRegistrationController', ['NotificationService', '$state', '$stateParams', 'RegistrationsService',
  function(NotificationService, $state, $stateParams, RegistrationsService) {
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
      if (NotificationService.setBusyState()) {
        return;
      }

      RegistrationsService.confirm({
        token: $stateParams.token
      }).$promise.then(handleSuccess, NotificationService.handleError);
    })();
  }
]);
