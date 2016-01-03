pcbuilder = angular.module('pcbuilder', []);

pcbuilder.controller("PcbuilderController", ['$scope', '$http', function ($scope, $http) {
    $http.get("/api/components").success(function (data) {
        $scope.components = data;
        $scope.formData = {};
    }).error(function () {
        $("#components").html('<div class="alert alert-danger"><a class="close" data-dismiss="alert">×</a><strong>Error!</strong> Er is iets mis gegaan met het laden van de pagina.</div></div>');
    });

    $scope.submitSpecs = function () {
        $http({
            url: "/api/build",
            method: "GET",
            params: $scope.formData
        });
    }
}]);