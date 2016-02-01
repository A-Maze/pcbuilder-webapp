search = angular.module('pcbuilder', []);

search.controller("searchController", ['$scope', '$http', function ($scope, $http) {
  var pathArray = window.location.pathname.split( '/' );
  var path = pathArray[pathArray.length-1];

  $http.get("/api/search/"+path).success(function (data) {
    $scope.products = data;
    $scope.formData = {};
    $scope.params = path;
  });
  $scope.submitform = function () {
    window.location.href = $scope.searchTag;
    }
}]);

search.controller("dashboardController", ['$scope', '$http', function ($scope, $http) {
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
    var price;

    //Ophalen van de datums, voor elke datum 1 rij
    for(var i = 0 ; i < prices.length ; i ++){
      if(dateArray.indexOf(prices[i].date.split(" ")[0]) == -1){
        price = prices[i].date.split(" ");
        dateArray[dateArray.length] = price[0];
      }
    }

    //Sorteren van de datums oplopend
    dateArray.sort(function(a, b){
        var datum1 = a.split('/').reverse().join(),
            datum2 = b.split('/').reverse().join();
        return datum1 < datum2 ? -1 : (datum1 > datum2 ? 1 : 0);
    });

    // Array maken met alle webshops
    // Array maken met de prijs en de webshop gecombineerd 
    // Two dimensional Array
    for(i = 0 ; i < prices.length ; i ++){
      if(webshopArray.indexOf(prices[i].webshop) == -1){
        webshopArray[webshopArray.length] = prices[i].webshop;
      }
      priceWebshop[priceWebshop.length] = [prices[i].webshop, prices[i].price, prices[i].date.split(" ")[0]]
    }
    
    // Eerste rij in de grafiek, waar staan de waardes voor, datum en webshop namen
    // Voorbeeld: ['Date', 'Azerty', 'Afuture', 'Computerland']
    column[0] = 'Date';
    for(i = 0 ; i < webshopArray.length ; i ++){
      column[column.length] = webshopArray[i];
    }
    row[0] = column;
    column=[];

    // De rijen toevoegen
    // Two dimensional array 
    // voorbeeld: ['01-01-2016', 168.50, 166.95, 172.50]
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

    // Plaats de rijen in de grafiek
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