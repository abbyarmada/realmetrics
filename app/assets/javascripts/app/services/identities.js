angular.module('app').factory('IdentitiesService', ['$resource',
  function($resource) {
    return $resource(
      '/api/v1/identities', {}, {
        delete: {
          method: 'DELETE',
          params: {
            id: '@id'
          },
          url: '/api/v1/identities/:id'
        }
      }
    );
  }
]);
