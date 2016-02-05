search = angular.module('pcbuilder', []);

search.controller("searchController", ['$scope', '$http', function ($scope, $http) {
  var pathName = window.location.pathname;
  $http.get("/api"+pathName).success(function (data) {
    //Json data array voor alle gevonden producten in combinatie met de category naam
    $scope.jsonArray = data;
    //Json data met alle producten gevonden
    $scope.products = data.products;
  });
  $scope.submitform = function () {
    //Zoek naar alle producten met dat zoek woord
    window.location.href = $scope.searchTag;
  }
}]);



search.controller("dashboardController", ['$scope', '$http', function ($scope, $http) {
  var pathName = window.location.pathname;
  //Alle prijzen per dag per webshop komen in deze variabele
  var prices;
  $http.get("/api"+pathName).success(function (data) {
    //De data van het opgehaalde product
    $scope.product = data;
    $scope.keys = data;
    //Alle prijzen per dag per webshop
    prices = data.records;

    //Laad de grafiek
    google.charts.load('current', {'packages':['corechart']});
    google.charts.setOnLoadCallback(drawChart);
  });

  function drawChart() {
    var column = Array();
    var priceWebshop = Array();
    var dateArray = Array();
    var webshopArray = Array();
    var row = Array();
    var price;

    //Ophalen van de datums, voor elke datum 1 rij
    for(var i = 0 ; i < prices.length ; i ++){
      fullDate = new Date(prices[i].date.$date);
      dateField = fullDate.getDate()+'/'+(fullDate.getMonth()+1)+'/'+fullDate.getFullYear();
      if(dateArray.indexOf(dateField) == -1){
        dateArray[dateArray.length] = dateField;
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
      fullDate = new Date(prices[i].date.$date);
      dateField = fullDate.getDate()+'/'+(fullDate.getMonth()+1)+'/'+fullDate.getFullYear();
      priceWebshop[priceWebshop.length] = [prices[i].webshop, prices[i].price, dateField];
    }
    
    // Eerste rij in de grafiek, waar staan de waardes voor, datum en webshop namen
    // Voorbeeld: ['Date', 'Azerty', 'Afuture', 'Computerland']
    var data = new google.visualization.DataTable();
    data.addColumn('string', 'Datum');
    for(i = 0 ; i < webshopArray.length ; i ++){
      data.addColumn('number', ''+webshopArray[i]);
    }

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
    data.addRows(row);

    var options = {
      title: 'Prijsverloop',
      curveType: 'function',
      legend: { position: 'bottom' }
    };
    
    var chart = new google.visualization.LineChart(document.getElementById('curve_chart'));
    chart.draw(data, options);
  }
      
}]);