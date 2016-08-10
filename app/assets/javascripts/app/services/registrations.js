angular.module('app').factory('RegistrationsService', ['$resource',
  function($resource) {
    return $resource(
      '/api/v1/registrations', {}, {
        query: {
          method: 'GET'
        },
        signup: {
          method: 'POST'
        },
        update: {
          method: 'PATCH'
        },
        confirm: {
          method: 'PATCH',
          params: {
            token: '@token'
          },
          url: '/api/v1/registrations/confirm/:token'
        }
      }
    );
  }
]);
