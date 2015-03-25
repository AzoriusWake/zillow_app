angular.module('AvgPriceApp.controllers', [])
.controller('AvgPriceApp', function($scope, $http, $rootScope, avgPriceAPIservice) {
  $scope.statesHash = {};

  avgPriceAPIservice.getAverage().then(function (data) {
    $scope.statesHash = data;
    var map = new Datamap({
      element: document.getElementById('zillow_map'),
      scope: 'usa',
      geographyConfig: {
        highlightBorderColor: '#FFFFFF',
        highlightBorderWidth: 2
      },
      fills: {
        "low": "#33CC33",
        "med": "#CCFF33",
        "high": "#CC0033",
        defaultFill: "#DDDDDD"
      },
      done: function(datamap) {
        datamap.svg.selectAll('.datamaps-subunit').on('click', function(geography) {
          $rootScope.$broadcast("update", {state: geography.id});
        });
      },
      data: $scope.statesHash
    });
  })

});