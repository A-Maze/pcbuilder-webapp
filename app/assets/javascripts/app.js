pcbuilder = angular.module('pcbuilder', []);

pcbuilder.controller("PcbuilderController", ['$scope', '$http', function ($scope, $http) {
    var failed = '<div id="build-error" class="alert alert-danger"><a class="close" data-dismiss="alert">×</a><strong>Error!</strong> Er is iets mis gegaan met het laden van de pagina. Probeer het later opnieuw</div>';
    $(".toggle:visible").toggle();
    $("#components").toggle();

    $http.get("/api/components").success(function (data) {
        $scope.components = data;
        $scope.formData = {};
    }).error(function () {
        $("#components").html(failed);
    });

    $scope.submitSpecs = function () {
        $http({
            url: "/api/build",
            method: "GET",
            params: $scope.formData
        }).success(function (data) {
            $(".toggle:visible").toggle();
            $("#build").toggle();

            if (data.length == 0) {
                var columnCount = $("$build-result").find("tr:first td").length;
                $("#build-result tbody").append('<tr><td colspan="' + columnCount + '">---</td></tr>');
            } else {
                // for data
                var row = $('<tr>').append('<td>1</td><td>Category</td><td>Title</td><td>99,99</td>');
                $("#build-result tbody").append(row);
            }
        }).error(function () {
            $("#components").html(failed);
            $("#build-error").append(" of wijzig uw criteria voor de samenstelling.");
        });
    }
}]);

pcbuilder.filter('isEmpty', function () {
    var bar;
    return function (obj) {
        for (bar in obj) {
            if (obj.hasOwnProperty(bar)) {
                return false;
            }
        }
        return true;
    };
});