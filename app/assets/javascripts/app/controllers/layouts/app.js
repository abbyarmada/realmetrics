angular.module('app').controller('AppController', ['NotificationService', '$scope', '$rootScope', '$state', '$interval', 'SessionsService', 'current_user', 'current_organization',
  function(NotificationService, $scope, $rootScope, $state, $interval, SessionsService, current_user, current_organization) {
    /*
     * Listeners
     */
    $rootScope.$on('$stateChangeSuccess',
      function() {
        handlePageState();
      }
    );

    $rootScope.$on('current_organization.changed',
      function() {
        SessionsService.current_organization().$promise.then(function(organization) {
          $scope.current_organization = organization;
          NotificationService.removeBusyState();
        }, NotificationService.handleError);
      }
    );

    /*
     * Public methods
     */
    $scope.logout = function() {
      SessionsService.logout().$promise.then(handleSuccess, NotificationService.handleError);
    };

    /*
     * Private methods
     */
    var handleSuccess = function() {
      $state.go('login');
    };

    var handlePageState = function() {
      if (!$scope.current_organization) {
        $state.go('setup');
      }

      NotificationService.removeBusyState();
      showSidePanel();
    };

    var showSidePanel = function() {
      if ($state.$current.params.sidepanel) {
        angular.element(document.querySelector('#sidepanel')).addClass('sidenav-open');
      } else {
        angular.element(document.querySelector('#sidepanel')).removeClass('sidenav-open');
      }
    };

    /*
     * Initialiazer
     */
    (function() {
      $scope.current_user = current_user;
      $scope.current_organization = current_organization;

      var waitForInitialCrawlCompleted = $interval(function() {
        SessionsService.current_organization().$promise.then(function(organization) {
          $scope.current_organization = organization;

          if ($scope.current_organization.initial_crawl_completed) {
            $interval.cancel(waitForInitialCrawlCompleted);
          }
        }, NotificationService.handleError);
      }, 5 * 1000);

      handlePageState();
    })();
  }
]);
