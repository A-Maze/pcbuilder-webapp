pcbuilder = angular.module('pcbuilder', []);

pcbuilder.controller("PcbuilderController", ['$scope', '$http', function ($scope, $http) {
    $http.get("/api/components").success(function (data) {
        $scope.components = data;
    });
}]);