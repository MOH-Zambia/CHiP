// (function () {
//     function ViewGeoServicesController(QueryDAO, Mask) {
//         var ctrl = this;
//         ctrl.data = "info";
//         ctrl.users = [];
//         ctrl.locationId = undefined;
//         ctrl.selectedUser = 'undefined';
//         ctrl.map = undefined;
//         ctrl.serviceType = 'all';

//         ctrl.minDateFieldValidation = function (fieldValue) {
//             ctrl.minDateSelected = true;
//             ctrl.minDate = new Date(fieldValue);
//         };

//         ctrl.maxDateFieldValidation = function (fieldValue) {
//             ctrl.maxDateSelected = true;
//             ctrl.maxDate = new Date(fieldValue);
//         };

//         ctrl.resetData = function () {
//             ctrl.selectedUser = undefined;
//         };

//         ctrl.submit = function (serviceType) {
//             if (ctrl.searchForm.$invalid) {
//                 return;
//             }
//             ctrl.resetData();
//             var serviceLocationDetails = {
//                 code: "get_geo_service_location_details",
//                 parameters: {
//                     locationId: ctrl.locationId,
//                     serviceType: serviceType,
//                     from_date: moment(ctrl.dateFrom).format("DD-MM-YYYY"),
//                     to_date: moment(ctrl.dateTo).format("DD-MM-YYYY"),
//                 }
//             };
//             Mask.show();
//             return QueryDAO.execute(serviceLocationDetails).then(function (response) {
//                 ctrl.users = response.result;
//                 Mask.hide();
//                 ctrl.toggleFilter();
//             }).catch(function (err) {
//                 Mask.hide();
//                 return err;
//             });
//         }

//         ctrl.onUserClick = function (user) {
//             ctrl.selectedUser = user;
//             loadMapData(user.user_id);
//         }

//         const loadMapData = function (userId) {
//             var serviceUserDetails = {
//                 code: "get_geo_service_by_user_id",
//                 parameters: {
//                     userId: userId,
//                     locationId: ctrl.locationId,
//                     serviceType: ctrl.serviceType,
//                     from_date: moment(ctrl.dateFrom).format("DD-MM-YYYY"),
//                     to_date: moment(ctrl.dateTo).format("DD-MM-YYYY"),
//                 }
//             }
//             Mask.show();
//             QueryDAO.execute(serviceUserDetails).then(function (response) {
//                 Mask.hide();
//                 ctrl.services = response.result;
//                 loadMap(ctrl.services);
//             }).catch(function (err) {
//                 Mask.hide();
//                 return err;
//             })
//         }

//         const loadMapLayer = function (locationsLGDCodes, locationsLGDCodesArray) {

//             var mapPatams = {
//                 code: "get_geo_map_by_lgdcode",
//                 parameters: {
//                     lgdCode: locationsLGDCodesArray
//                 }
//             }
//             Mask.show();
//             QueryDAO.execute(mapPatams).then(function (response) {
//                 Mask.hide();
//                 var result = response.result;
//                 for (var index = 0; index < result.length; index++) {
//                     // var maps = [];
//                     console.info(locationsLGDCodes);
//                     maps.push(JSON.parse(result[index].st_asgeojson));
//                     /* var polygone = L.geoJSON(maps, {
//                         style: function (feature) {
//                             locationsLGDCodesArray.indexOf(parseInt(result[index].lgd_code)) == -1 ? 'greeen' : 'greeen'
//                             return { color: 'green' };
//                         }
//                     }).addTo(ctrl.map); */
//                 }
//                 /* polygone.bindTooltip("My polygon",
//                     { permanent: true, direction: "center" }
//                 ).openTooltip(); */
//             }).catch(function (err) {
//                 Mask.hide();
//                 return err;
//             })
//         }

//         const loadMap = function (services) {
//             //https://leafletjs.com/index.html
//             if (ctrl.map) {
//                 ctrl.map.off();
//                 ctrl.map.remove();
//             }
//             document.getElementById('mapid').innerHTML = '';
//             ctrl.map = L.map('mapid').setView([services[0].latitude, services[0].longitude], 13);

//             L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
//                 attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
//             }).addTo(ctrl.map);

//             var locationsLGDCodes = [];
//             var locationsLGDCodesArray = [];
//             var latLongJson = [];
//             for (var index = 0; index < services.length; index++) {
//                 var service = services[index];
//                 if (locationsLGDCodes.indexOf("'" + service.locationId + "'") == -1) {
//                     locationsLGDCodes.push("'" + service.locationId + "'");
//                     locationsLGDCodesArray.push(service.locationId);
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
//                 // just update icon and add configugations: {icon: myIcon}
//                 var foundService = undefined;
//                 for (var i = 0; i < latLongJson.length; i++) {
//                     if (latLongJson[i].lat == service.latitude && latLongJson[i].long == service.longitude) {
//                         foundService = latLongJson[i];
//                         break;
//                     }
//                 }
//                 if (foundService == undefined) {
//                     foundService = {};
//                     foundService.lat = service.latitude;
//                     foundService.long = service.longitude;
//                     foundService.html = 'SrNo: ' + service.srNo + ' Member Name:' + service.memberName + '<hr>';
//                     latLongJson.push(foundService);
//                 } else {
//                     //foundService.html = foundService.html + 'Service Date: ' + service.serviceDate + '<br> Member Name:' + service.memberName + '<br>Service Location:' + service.latLongLocation + '<hr>';
//                     foundService.html = foundService.html + 'SrNo: ' + service.srNo + ' Member Name:' + service.memberName + '<hr>';
//                 }
//             }
//             for (let j = 0; j < latLongJson.length; j++) {
//                 L.marker([latLongJson[j].lat, latLongJson[j].long]).addTo(ctrl.map)
//                     .bindPopup(latLongJson[j].html)
//                     .openPopup();
//             }
//             loadMapLayer(locationsLGDCodes, locationsLGDCodesArray);
//         }

//         ctrl.openGoogleMap = function (let1, long) {
//             var url = 'https://maps.google.com/?q=' + let1 + ',' + long;
//             window.open(url, '_blank');
//         }

//         ctrl.toggleFilter = function () {
//             if (angular.element('.filter-div').hasClass('active')) {
//                 angular.element('body').css("overflow", "auto");
//             } else {
//                 angular.element('body').css("overflow", "hidden");
//             }
//             angular.element('.cst-backdrop').fadeToggle();
//             angular.element('.filter-div').toggleClass('active');
//         }
//     }
//     angular.module('imtecho.controllers').controller('ViewGeoServicesController', ViewGeoServicesController);
// })();
