angular.module('app').factory('PasswordsService', ['$resource',
  function($resource) {
    return $resource(
      '/api/v1/passwords', {}, {
        create: {
          method: 'POST'
        },
        update: {
          method: 'PATCH'
        }
      }
    );
  }
]);
