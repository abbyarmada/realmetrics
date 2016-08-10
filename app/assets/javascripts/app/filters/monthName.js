angular.module('app').filter('monthName', [

  function() {
    return function(monthNumber) {
      var monthNames = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December'
      ];
      return monthNames[monthNumber - 1];
    };
  }
]);

angular.module('app').filter('shortMonthName', [

  function() {
    return function(monthNumber) {
      var monthNames = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      return monthNames[monthNumber - 1];
    };
  }
]);
