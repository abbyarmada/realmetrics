angular.module('app').factory('SessionsService', ['$resource',
  function($resource) {
    return $resource(
      '/api/v1/sessions', {}, {
        current: {
          method: 'GET'
        },
        current_user: {
          method: 'GET',
          url: '/api/v1/sessions/current_user'
        },
        current_organization: {
          method: 'GET',
          url: '/api/v1/sessions/organization'
        },
        login: {
          method: 'POST'
        },
        logout: {
          method: 'DELETE'
        }
      }
    );
  }
]);
