angular.module('app').factory('PlansService', ['$resource',
  function($resource) {
    return $resource(
      '/api/v1/plans', {}, {
        query: {
          method: 'GET',
          isArray: true
        }
      }
    );
  }
]);
