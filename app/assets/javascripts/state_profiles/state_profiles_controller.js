angular.module('StateApp.controllers', [])
.controller('StateApp', function($scope, $http, stateAPIservice) {
  $scope.state = "";

  stateAPIservice.getProfile().then(function(data) {
    $scope.state = data;
  })

  $scope.$on("update", function(event, data){
    stateAPIservice.updateProfile(data.state).then(function(data) {
      $scope.state = data;
    })
  });

});