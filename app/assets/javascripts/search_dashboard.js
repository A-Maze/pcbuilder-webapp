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