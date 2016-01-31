pcbuilder = angular.module('pcbuilder', []);

pcbuilder.controller("searchController", ['$scope', '$http', function ($scope, $http) {
	$http.get("/api/search/cpu").success(function (data) {
		$scope.products = data;
		$scope.formData = {};
		$scope.params = $http.zoekterm;
	});
	$scope.add = function(searchTag) {
		$http.get("/api/search/"+searchTag).success(function (data) {
			$scope.products = data;
			$scope.formData = {};
		});
	}
}]);