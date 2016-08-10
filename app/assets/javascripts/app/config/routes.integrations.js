angular.module('app').config(['$stateProvider',
  function($stateProvider) {
    $stateProvider

    /*
     * Integrations - List
     */
    .state('integrations', {
      url: '/integrations',
      parent: 'app',
      templateUrl: 'app/templates/integrations/index.html',
      controller: 'IntegrationsController'
    });
  }
]);
