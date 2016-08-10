angular.module('app').factory('NotificationService', ['$mdToast', '$compile', '$rootScope', '$state', '$window',
  function($mdToast, $compile, $rootScope, $state, $window) {
    var factory = {};

    factory.busy = false;

    factory.handleError = function(error) {
      var message = error;

      switch (error.status) {
        case 401:
          $state.go('login');
          break;

        case 404:
          $state.go('home');
          break;

        case 422:
          if (error && error.data) {
            message = 'Please fill all required fields.';
          }

          if (error && error.data && error.data.error && error.data.error.length > 0) {
            message = error.data.error;
          }

          factory.showError(message);

          break;

        case 500:
          factory.showError('Internal server error. Something definitely went wrong.');
          break;
      }

      if (factory.busy) {
        factory.removeBusyState();
      }
    };

    factory.showError = function(message) {
      $mdToast.show(
        $mdToast.build({
          locals: {
            message: message
          },
          controller: ['$scope', 'message',
            function($scope, message) {
              (function() {
                $scope.message = message;
              })();
            }
          ],
          template: '<md-toast class="md-error">{{ message }}</md-toast>',
          position: 'top center',
          hideDelay: 3000
        })
      );
    };

    factory.setBusyState = function() {
      if (factory.busy) {
        return true;
      }

      factory.busy = true;

      $window.setTimeout(function() {
        if (factory.busy) {
          var el = $compile(
            '<div id="page-spinner" layout="row" layout-align="center center">' +
            '  <md-progress-circular md-mode="indeterminate"></md-progress-circular>' +
            '</div>')($rootScope);

          angular.element(document.body).append(el);
        }
      }, 100);

      return false;
    };

    factory.removeBusyState = function() {
      factory.busy = false;

      if (document.getElementById('page-spinner')) {
        document.body.removeChild(document.getElementById('page-spinner'));
      }
    };

    return factory;
  }
]);
