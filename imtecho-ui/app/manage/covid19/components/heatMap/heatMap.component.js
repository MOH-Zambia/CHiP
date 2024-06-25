angular.module("imtecho.components")
    .component("heatMap", {
        templateUrl: 'app/manage/covid19/components/heatMap/heatMap.component.html',
        bindings: {
            height: "="
        },
        controllerAs: 'heatMapCtrl',
        controller: function ($http, Mask, QueryDAO, GeneralUtil) {
            var heatMapCtrl = this;
            heatMapCtrl.height = heatMapCtrl.height + 'px' || '300px';
            var map, heatmap, heatMapData = [], /*winInfo,  markers = [],*/ locations = [], clusterMarker;
            var InfoWindow;
            var Latlngbounds;
            var markersData = [];
            /* var gradient = [
                'rgba(0, 255, 255, 0)',
                'rgba(0, 255, 255, 1)',
                'rgba(0, 191, 255, 1)',
                'rgba(0, 127, 255, 1)',
                'rgba(0, 63, 255, 1)',
                'rgba(0, 0, 255, 1)',
                'rgba(0, 0, 223, 1)',
                'rgba(0, 0, 191, 1)',
                'rgba(0, 0, 159, 1)',
                'rgba(0, 0, 127, 1)',
                'rgba(63, 0, 91, 1)',
                'rgba(127, 0, 63, 1)',
                'rgba(191, 0, 31, 1)',
                'rgba(255, 0, 0, 1)'
            ]; */
            heatMapCtrl.casesTypes = {
                POSITIVE_CASES: 'Positive cases',
                SYMPTOMATIC_CASES: 'All cases',
                TRAVEL_HISTORY_CASES: 'Domestic Travellers With Symptoms',
                INT_TRAVEL_HISTORY_CASES: 'International Travellers With Symptoms',
                NO_TRAVEL_HISTORY_CASES: 'Non Travellers With Symptoms'
            };
            heatMapCtrl.heatMapView = true
            heatMapCtrl.caseType = 'POSITIVE_CASES';

            /* function closeOtherInfo() {
                for (var i = 0; i < markers.length; i++) {
                    markers[i].setMap(null);
                }
                markers = [];
            }

            function showPopUp(latitude, longitude) {
                var markerInfo = new google.maps.Marker({
                    map: map,
                    position: new google.maps.LatLng(latitude, longitude),
                    visible: false
                });
                closeOtherInfo();
                markers.push(markerInfo);
                winInfo.setContent("<div class='heat-map-popup'>" + latitude + " ," + longitude + "</div>")
                winInfo.open(map, markerInfo);
            }

            function getCircle(magnitude) {
                return {
                    path: google.maps.SymbolPath.CIRCLE,
                    fillColor: 'red',
                    fillOpacity: .2,
                    scale: Math.pow(2, magnitude) / 2,
                    strokeColor: 'white',
                    strokeWeight: .5
                };
            } */

            // initialize Gujarat map with GeoJSON
            function initializeGoogleMap() {
                // Set Gujarat as center of the map
                var gujarat = new google.maps.LatLng(22.2587, 71.1924);
                // Define the LatLng coordinates for the outer path.
                map = new google.maps.Map(document.getElementById('googleMap'), {
                    center: gujarat,
                    zoom: 6,
                    mapTypeId: google.maps.MapTypeId.ROADMAP,
                    mapTypeControl: false
                });
                map.data.setStyle({
                    fillColor: '#9dc4eb',
                    strokeWeight: 1,
                    strokeOpacity: 0.8,
                    strokeColor: '#767676'
                });
                map.data.addGeoJson(
                    heatMapCtrl.geoJsonData);
            }

            // for getting HeatMapData for covid19 cases according to query code.
            heatMapCtrl.getHeatMapData = function (queryCode) {
                if (!queryCode) {
                    queryCode = 'covid_heat_map_data';
                    heatMapCtrl.caseType = 'POSITIVE_CASES';
                }
                heatMapCtrl.heatMapView = true;
                Mask.show();
                var dto = {
                    code: queryCode,
                    parameters: {
                    }
                };
                QueryDAO.execute(dto).then(function (res) {
                    var heapMapDataResponse = res.result;
                    heatMapData = [];
                    locations = [];
                    angular.forEach(heapMapDataResponse, function (object) {
                        // if data has weight then create heatmap object as WeightedLocation otherwise simple LatLng object
                        if (object && object.weight !== null) {
                            heatMapData.push({ location: new google.maps.LatLng(object.latitude, object.longitude), weight: object.weight });
                        } else {
                            heatMapData.push(new google.maps.LatLng(object.latitude, object.longitude));
                        }
                        locations.push({ location: { lat: Number(object.latitude), lng: Number(object.longitude) }, count: object.weight });
                    });
                    heatMapCtrl.initMap();
                }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                    Mask.hide();
                });
            }

            // for getting basic details of the covid19 positive cases
            heatMapCtrl.getMarkersData = function () {
                heatMapCtrl.heatMapView = false;
                Mask.show();
                var dto = {
                    code: 'covid_case_markings_retrieval',
                    parameters: {
                    }
                };
                QueryDAO.execute(dto).then(function (res) {
                    markersData = res.result;
                    initializeGoogleMap();
                    heatMapCtrl.addMarkers(markersData);
                }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                    Mask.hide();
                });
            };

            heatMapCtrl.changeHeatMap = function (mapType) {
                switch (mapType) {
                    case 'POSITIVE_CASES':
                        heatMapCtrl.caseType = 'POSITIVE_CASES';
                        heatMapCtrl.getHeatMapData('covid_heat_map_data');
                        break;
                    case 'SYMPTOMATIC_CASES':
                        heatMapCtrl.caseType = 'SYMPTOMATIC_CASES';
                        heatMapCtrl.getHeatMapData('idsp_heat_map_all_travellers');
                        break;
                    case 'TRAVEL_HISTORY_CASES':
                        heatMapCtrl.caseType = 'TRAVEL_HISTORY_CASES';
                        heatMapCtrl.getHeatMapData('idsp_heat_map_domestic_trav');
                        break;
                    case 'INT_TRAVEL_HISTORY_CASES':
                        heatMapCtrl.caseType = 'INT_TRAVEL_HISTORY_CASES';
                        heatMapCtrl.getHeatMapData('idsp_heat_map_int_trav');
                        break;
                    case 'NO_TRAVEL_HISTORY_CASES':
                        heatMapCtrl.caseType = 'NO_TRAVEL_HISTORY_CASES';
                        heatMapCtrl.getHeatMapData('idsp_heat_map_no_trav');
                        break;
                    default:
                        break;
                }
            };

            heatMapCtrl.isActive = function (caseType) {
                return heatMapCtrl.caseType === caseType;
            };

            heatMapCtrl.changeRadius = function () {
                heatmap.set('radius', heatmap.get('radius') ? null : 30);
            };

            heatMapCtrl.initMap = function () {
                initializeGoogleMap();
                // winInfo = new google.maps.InfoWindow({ maxWidth: 200 });
                heatmap = new google.maps.visualization.HeatmapLayer({
                    data: heatMapData,
                    // dissipating: false,
                    radius: 25,
                    // gradient: gradient
                });
                heatmap.setMap(map); // this will show heatmap data in google map
                heatMapCtrl.showCountsOnMap();
                // this will give you any click event in the map
                map.addListener('click', function (e) {
                    // showPopUp(e.latLng.lat(), e.latLng.lng());
                });

                map.addListener('mousemove', function (e) {
                    // winInfo.close();
                    // winInfo = new google.maps.InfoWindow({
                    //     content: "<div class='heat-map-popup'>(" + e.latLng.lat() + "," + e.latLng.lng() + ")</div>",
                    //     position: new google.maps.LatLng(e.latLng.lat(), e.latLng.lng())
                    // });
                    // winInfo.open(map);
                });
            }

            heatMapCtrl.addMarkers = function (newMarkers) {
                //Initializing the InfoWindow, Map and LatLngBounds objects.
                InfoWindow = new google.maps.InfoWindow();
                Latlngbounds = new google.maps.LatLngBounds();

                //Looping through the Array and adding Markers.
                for (let i = 0; i < newMarkers.length; i++) {
                    let data = newMarkers[i];
                    let myLatlng = new google.maps.LatLng(data.latitude, data.longitude);
                    //Initializing the Marker object.
                    let marker = new google.maps.Marker({
                        position: myLatlng,
                        map: map,
                        title: data.title
                    });

                    //Adding InfoWindow to the Marker.
                    (function (marker1, data1) {
                        google.maps.event.addListener(marker1, "click", function (e) {
                            InfoWindow.setContent("<div class='heat-map-popup'><b>" + data1.description.replace(/\r?\n/g, "<br />") + "</b></div>");
                            InfoWindow.open(map, marker1);
                        });
                    })(marker, data);

                    //Plotting the Marker on the Map.
                    Latlngbounds.extend(marker.position);
                }
            }

            heatMapCtrl.init = function () {
                Mask.show();
                $http.get('Gujarat-line.json').then(function (response) {
                    Mask.hide();
                    heatMapCtrl.geoJsonData = response.data;
                    heatMapCtrl.getHeatMapData();
                }, function (error) {
                    console.log(error);
                    Mask.hide();
                });
            };

            heatMapCtrl.showCountsOnMap = function () {
                if (heatMapCtrl.showCounts) {
                    var image = {
                        url: 'img/orange-cluster.png',
                        scaledSize: new google.maps.Size(50, 50), // scaled size
                        origin: new google.maps.Point(0, 0), // origin
                        anchor: new google.maps.Point(0, 0) // anchor
                    };
                    let markers = locations.map(function (location, i) {
                        var label = {
                            text: "" + location.count + "",
                            color: 'black',
                            fontSize: '11px',
                            fontFamily: "Arial,sans-serif",
                            fontWeight: 'bold',
                            fontStyle: 'normal',
                            textAlign: 'center',
                            lineHeight: '55px',
                        };
                        var marker = new google.maps.Marker({
                            position: location.location,
                            label: label,
                            weight: location.count,
                            icon: image
                        });
                        marker.addListener('click', function (e) {
                            // console.log("marker cluster click", e.latLng.lat(), e.latLng.lng())
                        });
                        return marker;
                    });
                    let calc = function (markers1, numStyles) {
                        var weight = 0;
                        for (var i = 0; i < markers1.length; ++i) {
                            weight += Number(markers1[i].weight);
                        }
                        return {
                            text: weight,
                            index: Math.min(String(weight).length, numStyles)
                        };
                    }
                    // Add a marker clusterer to manage the markers.it will group nearby loation and dsplay count of that area.
                    clusterMarker = new MarkerClusterer(map, null, { imagePath: 'img/m' });
                    clusterMarker.setCalculator(calc);
                    clusterMarker.addMarkers(markers);
                } else {
                    if (clusterMarker) {
                        clusterMarker.clearMarkers();
                    }
                }
            };

            heatMapCtrl.init();
        }
    });
