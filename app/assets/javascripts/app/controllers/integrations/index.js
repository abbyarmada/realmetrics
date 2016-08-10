angular.module('app').controller('IntegrationsController', ['NotificationService', '$scope', 'IdentitiesService',
  function(NotificationService, $scope, IdentitiesService) {
    /*
     * Public methods
     */
    $scope.deletePaymentGateway = function(paymentGateway) {
      if (NotificationService.setBusyState()) {
        return;
      }

      IdentitiesService.delete({
        id: paymentGateway.id
      }).$promise.then(function() {
        $scope.$emit('current_organization.changed');
        NotificationService.removeBusyState();
      }, NotificationService.handleError);
    };

    $scope.refreshStripeInfo = function() {
      if (NotificationService.setBusyState()) {
        return;
      }

      $scope.$emit('current_organization.changed');
    };

    /*
     * Initialiazer
     */
    (function() {})();
  }
]);
