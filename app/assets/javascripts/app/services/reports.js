angular.module('app').factory('ReportsService', ['$resource',
  function($resource) {
    return $resource(
      '/api/v1/reports', {}, {
        revenues: {
          method: 'GET',
          url: '/api/v1/reports/revenues'
        },
        customers: {
          method: 'GET',
          url: '/api/v1/reports/customers'
        },
        subscriptions: {
          method: 'GET',
          url: '/api/v1/reports/subscriptions'
        }
      }
    );
  }
]);
