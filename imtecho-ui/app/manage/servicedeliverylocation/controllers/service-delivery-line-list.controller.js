// (function () {
//     function ServiceDeliveryLineListController(QueryDAO, Mask, $uibModalInstance, location) {
//         var ctrl = this;

//         ctrl.init = function () {
//             ctrl.location = location;
//             var serviceLocationDetails = {
//                 code: "get_service_line_list_by_location",
//                 parameters: {
//                     locationId: location.parent_id,
//                     fromDate: ctrl.location.fromDate,
//                     toDate: ctrl.location.toDate
//                 }
//             };
//             Mask.show();
//             return QueryDAO.execute(serviceLocationDetails).then(function (response) {
//                 ctrl.services = response.result;
//                 ctrl.loadMap(ctrl.services);
//                 Mask.hide();
//                 ctrl.toggleFilter();
//             }).catch(function (err) {
//                 Mask.hide();
//                 return err;
//             });
//         }

//         ctrl.loadMapLayer = function (locationsLGDCodes) {
//             var mapPatams = {
//                 code: "get_geo_map_by_lgdcode",
//                 parameters: {
//                     lgdCode: locationsLGDCodes
//                 }
//             }
//             Mask.show();
//             QueryDAO.execute(mapPatams).then(function (response) {
//                 Mask.hide();
//                 var result = response.result;
//                 var maps = [];
//                 for (var index = 0; index < result.length; index++) {
//                     maps.push(JSON.parse(result[index].st_asgeojson));
//                 }
//                 L.geoJSON(maps, {
//                     style: function (feature) {
//                         return { color: "green" };
//                     }
//                 }).addTo(ctrl.map);
//                 console.info(response);
//             }).catch(function (err) {
//                 Mask.hide();
//                 return err;
//             })
//         }

//         ctrl.cancel = function () {
//             $uibModalInstance.dismiss('cancel');
//         }

//         ctrl.loadMap = function (services) {
//             //https://leafletjs.com/index.html
//             if (ctrl.map) {
//                 ctrl.map.off();
//                 ctrl.map.remove();
//             }
//             document.getElementById('service-delivery-line-list-map').innerHTML = '';
//             ctrl.map = L.map('service-delivery-line-list-map').setView([services[0].latitude, services[0].longitude], 13);

//             L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
//                 attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
//             }).addTo(ctrl.map);

//             var locationsLGDCodes = [];
//             for (var index = 0; index < services.length; index++) {
//                 var service = services[index];

//                 if (locationsLGDCodes.indexOf(service.locationId) == -1) {
//                     locationsLGDCodes.push(service.locationId);
//                 }
//                 /* var myIcon = L.icon({
//                     iconUrl: 'img/fhs-icon.png',
//                     iconSize: [38, 95],
//                     iconAnchor: [22, 94],
//                     popupAnchor: [-3, -76],
//                     shadowUrl: 'img/fhs-icon.png',
//                     shadowSize: [68, 95],
//                     shadowAnchor: [22, 94]
//                 }); */

//                 if (service.latitude && service.longitude && service.latLongLocation) {
//                     // just update icon and add configugations: {icon: myIcon}
//                     L.marker([service.latitude, service.longitude]).addTo(ctrl.map)
//                         .bindPopup('Service Date: ' + service.serviceDate + '<br> Member Name:' + service.memberName + '<br>Service Location:' + service.latLongLocation)
//                         .openPopup();
//                 }
//             }
//             ctrl.loadMapLayer(locationsLGDCodes);
//         }

//         ctrl.init();

//     }
//     angular.module('imtecho.controllers').controller('ServiceDeliveryLineListController', ServiceDeliveryLineListController);

// })();
