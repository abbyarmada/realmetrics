angular.module('app').factory('CustomersService', ['$resource',
  function($resource) {
    return $resource(
      '/api/v1/customers', {}, {
        query: {
          method: 'GET',
          isArray: true
        },
        show: {
          method: 'GET',
          params: {
            id: '@id'
          },
          url: '/api/v1/customers/:id'
        },
      }
    );
  }
]);
