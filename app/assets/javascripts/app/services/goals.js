angular.module('app').factory('GoalsService', ['$resource',
  function($resource) {
    return $resource(
      '/api/v1/goals', {}, {
        query: {
          method: 'GET',
          isArray: true
        },
        show: {
          method: 'GET',
          params: {
            id: '@id'
          },
          url: '/api/v1/goals/:id'
        },
        create: {
          method: 'POST'
        },
        batch_upsert: {
          method: 'POST',
          url: '/api/v1/goals/batch_upsert'
        },
        set_goals: {
          method: 'POST',
          url: '/api/v1/goals/set_goals'
        },
        update: {
          method: 'PATCH',
          params: {
            id: '@id'
          },
          url: '/api/v1/goals/:id'
        }
      }
    );
  }
]);
