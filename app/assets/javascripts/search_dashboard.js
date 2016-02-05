search = angular.module('pcbuilder', []);

search.controller("searchController", ['$scope', '$http', function ($scope, $http) {
  var pathName = window.location.pathname;
  var categories;
  $http.get("/api/dashboard/category").success(function (category) {
    categories = category.categories;
    $http.get("/api"+pathName).success(function (data) {
      $scope.products = data;
    });
  });
  
  $scope.submitform = function () {
    window.location.href = $scope.searchTag;
  }
  $scope.getCategory = function (msg) {
    for(var i = 0; i <= categories.length ; i ++){
      if(i == categories.length){
        if(msg == 'Processors'){
          return 'cpu';
        }else if(msg == 'CPU-koelers'){
          return 'cooler';
        }else{
          return msg;
        }
      }
      if(categories[i].locale.nl_NL == msg){
        return categories[i].name;
      }
    }
        
  }
  $scope.log = function (a, b){
    console.log(a);
    console.log(b);
  }
}]);



search.controller("dashboardController", ['$scope', '$http', function ($scope, $http) {
  var pathName = window.location.pathname;

  $http.get("/api"+pathName).success(function (data) {
    $scope.product = data;
    $scope.keys = data;
    prices = data.records;
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
      priceWebshop[priceWebshop.length] = [prices[i].webshop, prices[i].price, dateField]//.split(" ")[0]]
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
    data.addRows(row);

    // Plaats de rijen in de grafiek

    //data.addRows(row);

    var options = {
      title: 'Prijsverloop',
      curveType: 'function',
      legend: { position: 'bottom' }
    };

    var chart = new google.visualization.LineChart(document.getElementById('curve_chart'));

    chart.draw(data, options);
  }
      
}]);