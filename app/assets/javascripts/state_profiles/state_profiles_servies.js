angular.module('StateApp.services', []).
factory('stateAPIservice', function($http) {
  var stateAPI = {};
  stateAPI.getProfile = function() {
    var promise = $http({
      method: 'get',
      url: 'pillows/state_profile'
    }).then(function(response){
      return response.data;
    });
    return promise;
  }
  stateAPI.updateProfile = function(data) {
    var promise = $http({
      method: 'get',
      url: 'pillows/state_profile',
      params: {state: data}
    }).then(function(response){
      return response.data;
    });
    return promise;
  }
  return stateAPI;
});