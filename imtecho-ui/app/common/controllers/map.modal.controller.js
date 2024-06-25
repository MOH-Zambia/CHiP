(function (angular) {
    let MapModalController = function ($scope, $uibModalInstance, latitude, longitude, zoom = 13) {

        const init = function () {
            let map = L.map('map').setView([latitude, longitude], zoom);
            L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
                maxZoom: 19,
                attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
            }).addTo(map);
            L.marker([latitude, longitude]).addTo(map);
            $("#map").height($(window).height());
            map.invalidateSize();
        };

        $scope.close = function () {
            $uibModalInstance.close();
        };

        $uibModalInstance.rendered.then(function () {
            init();
        });
    };
    angular.module('imtecho.controllers').controller('MapModalController', MapModalController);
})(window.angular);