dashboard = angular.module('pcbuilder', []);

dashboard.controller("productController", ['$scope', '$http', function ($scope, $http) {
  //var pathArray = window.location.pathname.split( '/' );
  //alert(pathArray[pathArray.length-2]);

  $http.get("/api/dashboard/"+pathArray[pathArray.length-2]+"/"+pathArray[pathArray.length-1]).success(function (data) {
    $scope.jsonData = data;
    $scope.text = 'test Text';
  });
}]);

/*
google.charts.load('current', {'packages':['corechart']});
google.charts.setOnLoadCallback(drawChart);

function drawChart() {
  var data = google.visualization.arrayToDataTable([
    ['Datum', 'Winkel1', 'Afuture', 'Azerty'],
    ['1995',  1000,      400, <%= @value_array[0] %>],
    ['1996',  1170,      <%= @value_array[1] %>, 1170-460],
    ['1997',  660,       <%= @value_array[2] %>, 660-1120],
    ['1998',  1170,      <%= @value_array[3] %>, 1170-460],
    ['1999',  660,       <%= @value_array[4] %>, 660-1120],
    ['2000',  1170,      <%= @value_array[5] %>, 1170-460],
    ['2001',  660,       <%= @value_array[6] %>, 660-1120],
    ['2002',  1170,      <%= @value_array[7] %>, 1170-460],
    ['2003',  660,       <%= @value_array[8] %>, 660-1120],
    ['2004',  1170,      <%= @value_array[9] %>, 1170-460]
  ]);

  var options = {
    title: 'Prijsverloop',
    curveType: 'function',
    legend: { position: 'bottom' }
  };

  var chart = new google.visualization.LineChart(document.getElementById('curve_chart'));

  chart.draw(data, options);
}*/