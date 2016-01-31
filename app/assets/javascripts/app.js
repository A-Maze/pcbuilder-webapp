pcbuilder = angular.module('pcbuilder', []);

pcbuilder.controller("PcbuilderController", ['$scope', '$http', function ($scope, $http) {
    $http.get("/api/components").success(function (data) {
        $scope.components = data;
        $scope.formData = {};
    });

    $scope.submitSpecs = function () {
        $http({
            url: "/api/build",
            method: "GET",
            params: $scope.formData
        });
    }
}]);