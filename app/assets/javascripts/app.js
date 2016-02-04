pcbuilder = angular.module('pcbuilder', []);

pcbuilder.controller("PcbuilderController", ['$scope', '$http', function ($scope, $http) {
    $(".toggle:visible").toggle();
    $("#components").toggle();

    $http.get("/api/components", {cache: true}).success(function (data) {
        $scope.components = data;
        $scope.formData = {};
    }).error(function () {
        var failed = '<div id="build-error" class="alert alert-danger"><a class="close" data-dismiss="alert">×</a><strong>Error!</strong> Er is iets mis gegaan met het laden van de pagina. Probeer het later opnieuw</div>';
        $("#components").html(failed);
    });

    $scope.submitSpecs = function () {
        waitingDialog.show();

        $http({
            url: "/api/build",
            method: "GET",
            params: $scope.formData
        }).success(function (data) {
            waitingDialog.hide();
            $(".toggle:visible").toggle();
            $("#build").toggle();

            if (data.length == 0) {
                var columnCount = $("$build-result").find("tr:first td").length;
                $("#build-result").find("tbody").append('<tr><td colspan="' + columnCount + '">---</td></tr>');
            } else {
                var i = 0;
                var totalPrice = 0;
                $.each(data, function (category, component) {
                    i++;
                    var currentPriceKey = Object.keys(component['current_prices'])[0];
                    var price = component['current_prices'][currentPriceKey];

                    if (!isNaN(price)) {
                        totalPrice += price;
                    } else {
                        price = "Onbekend";
                    }

                    var row = $("<tr>");
                    $("<td>").text(i).appendTo(row);
                    $("<td>").text(component['category']).appendTo(row);
                    $("<td>").text(component['brand'] + " " + component['name']).appendTo(row);

                    var url = $('<a>').attr('href', currentPriceKey).append("€ " + price);
                    $("<td>").append(url).appendTo(row);

                    $("#build-result").find("tbody").append(row);
                });

                $("#build-result").find("tfoot #total-price").text("€ " + totalPrice);
            }
        }).error(function () {
            waitingDialog.hide();
            var failed = '<div id="build-error" class="alert alert-danger"><a class="close" data-dismiss="alert">×</a><strong>Error!</strong> Er is geen build kunnen maken met je huidige criteria. Probeer je criteria aan te passen en <a href="/">probeer het opnieuw</a></div>';
            $("#components").html(failed);
        });
    };
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