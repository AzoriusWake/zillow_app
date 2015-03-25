angular.module('AvgPriceApp.services', []).
factory('avgPriceAPIservice', function($http) {
  var averageAPI = {};
  averageAPI.getAverage = function() {
    var promise = $http({
      method: 'get',
      url: 'pillows/endpoint'
    }).then(function(response){
      return response.data;
    });
    return promise;
  }
  return averageAPI;
});