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

    $http.get("/api/categories").success(function (data) {
        $scope.nameDictionary = data;
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
                var i = 0;
                $.each(data, function (category, component) {
                    i++;

                    var row = $("<tr>");
                    $("<td>").text(i).appendTo(row);
                    $("<td>").text(component['category']).appendTo(row);
                    $("<td>").text(component['brand'] + " " + component['name']).appendTo(row);

                    var url = $('<a>').attr('href', '#').append("€ " + "99,99");
                    $("<td>").append(url).appendTo(row);

                    $("#build-result tbody").append(row);
                });
            }
        }).error(function () {
            $("#components").html(failed);
            $("#build-error").append(" of wijzig uw criteria voor de samenstelling.");
        });
    };

    function getName(category) {
        for (var i = 0; i < $scope.nameDictionary['categories'].length; i++) {
            var cat = $scope.nameDictionary['categories'][i];
            if (cat['locale']['nl_NL'] == category) {
                return cat['locale']['nl_NL'];
            }
        }
        return null;
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