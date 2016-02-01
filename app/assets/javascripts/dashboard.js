console.log('test');


search = angular.module('pcbuilder', []);

search.controller("productController", ['$scope', '$http', function ($scope, $http) {
  var pathArray = window.location.pathname.split( '/' );
  var prices;

  $http.get("/api/dashboard/"+pathArray[2]+"/"+pathArray[3]).success(function (data) {
    $scope.product = data;
    prices = data.webshopprijzen;
  });

  

  google.charts.load('current', {'packages':['corechart']});
  google.charts.setOnLoadCallback(drawChart);
  
  function drawChart() {
    var column = Array();
    var priceWebshop = Array();
    var dateArray = Array();
    var webshopArray = Array();
    var row = Array();
    var prijs;
    for(var i = 0 ; i < prices.length ; i ++){
      if(dateArray.indexOf(prices[i].date.split(" ")[0]) == -1){
        prijs = prices[i].date.split(" ");
        dateArray[dateArray.length] = prijs[0];
      }
    }
    dateArray.sort(function(a, b){
      var aa = a.split('/').reverse().join(),
          bb = b.split('/').reverse().join();
      return aa < bb ? -1 : (aa > bb ? 1 : 0);
  });

    for(i = 0 ; i < prices.length ; i ++){
      if(webshopArray.indexOf(prices[i].webshop) == -1){
        webshopArray[webshopArray.length] = prices[i].webshop;
      }
    }

    for(i = 0 ; i < prices.length ; i ++){
      priceWebshop[priceWebshop.length] = [prices[i].webshop, prices[i].price, prices[i].date.split(" ")[0]]
    }
    column[0] = 'Date';
    for(i = 0 ; i < webshopArray.length ; i ++){
      column[column.length] = webshopArray[i];
    }
    row[0] = column;
    column=[];
    for(i = 0 ; i < dateArray.length ; i ++ ){
      column[0] = dateArray[i];
      for(var j = 0 ; j < priceWebshop.length ; j ++ ){
        if(dateArray[i] == priceWebshop[j][2]){
        column[webshopArray.indexOf(priceWebshop[j][0])+1] = parseFloat(priceWebshop[j][1]);
        }
      }
      row[row.length] = column;
      column = [];
    }
    console.log(row);
    var data = google.visualization.arrayToDataTable(row);

    var options = {
      title: 'Prijsverloop',
      curveType: 'function',
      legend: { position: 'bottom' }
    };

    var chart = new google.visualization.LineChart(document.getElementById('curve_chart'));

    chart.draw(data, options);
  }
      
}]);
