(function () {
    function SymptomaticMembersHeatmapController($http, Mask, QueryDAO, GeneralUtil) {
        var heatMapCtrl = this;
        heatMapCtrl.height = heatMapCtrl.height + 'px' || '300px';
        var map, heatmap, heatMapData = [], locations = [], clusterMarker, circle, circles = [], currentCicrleId;
        var deletMarkers = [];
        var exportPlaces = [];
        var containmnetCircle = [];
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
        heatMapCtrl.heatMapView = true;
        heatMapCtrl.isShowContainmnetArea = false;
        heatMapCtrl.showExport = false;
        heatMapCtrl.isDeleteEnable = false;
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
                zoom: 7,
                mapTypeId: google.maps.MapTypeId.ROADMAP,
                mapTypeControl: false
            });
            map.data.setStyle({
                fillColor: '#9dc4eb',
                strokeWeight: 1,
                strokeOpacity: 0.8,
                strokeColor: '#767676',
                clickable: false
            });
            map.data.addGeoJson(
                heatMapCtrl.geoJsonData);

            map.addListener('click', function (e) {
                if (heatMapCtrl.addCircleView) {
                    heatMapCtrl.addCicrle(e.latLng.lat(), e.latLng.lng());
                }
            });
        }

        function saveCircle(circleParam, id) {
            var obj = { shapeJson: JSON.stringify(circleParam) };
            if (id) {
                obj.id = id;
            }
            // Mask.show();
            $http.post('/api/idsp/createorupdateobject', obj)
                .then(function (resposne) {
                    // Mask.hide();
                    if (!id) {
                        heatMapCtrl.showContainmnetAreas();
                        if (circleParam) {
                            circleParam.setMap(null);
                        }
                    }
                })
                .catch(function (error) {
                    // Mask.hide();
                });
        }

        function deleteCircle(id) {
            Mask.show();
            $http.post('/api/idsp/deleteobject?id=' + id)
                .then(function (response) {
                    Mask.hide();
                    if (heatMapCtrl.isShowContainmnetArea) {
                        heatMapCtrl.showContainmnetAreas();
                    }
                })
                .catch(function (error) {
                    Mask.hide();
                });
        }

        // for getting HeatMapData for covid19 cases according to query code.
        heatMapCtrl.getHeatMapData = function (queryCode) {
            if (!queryCode) {
                queryCode = 'covid_heat_map_data';
                heatMapCtrl.caseType = 'POSITIVE_CASES';
            }
            heatMapCtrl.heatMapView = true;
            heatMapCtrl.addCircleView = false;
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
            heatMapCtrl.addCircleView = false;
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
            heatmap = new google.maps.visualization.HeatmapLayer({
                data: heatMapData,
                // dissipating: false,
                radius: 25,
                // gradient: gradient
            });
            heatmap.setMap(map); // this will show heatmap data in google map
            heatMapCtrl.showCountsOnMap();
            heatMapCtrl.showContainmnetAreas();
            map.addListener('mousemove', function (e) {
                // winInfo.close();
                // winInfo = new google.maps.InfoWindow({
                //     content: "<div class='heat-map-popup'>(" + e.latLng.lat() + "," + e.latLng.lng() + ")</div>",
                //     position: new google.maps.LatLng(e.latLng.lat(), e.latLng.lng())
                // });
                // winInfo.open(map);
            });
        }

        heatMapCtrl.addMarkers = function (markers) {
            //Initializing the InfoWindow, Map and LatLngBounds objects.
            InfoWindow = new google.maps.InfoWindow();
            Latlngbounds = new google.maps.LatLngBounds();

            //Looping through the Array and adding Markers.
            for (var i = 0; i < markers.length; i++) {
                var data = markers[i];
                var myLatlng = new google.maps.LatLng(data.latitude, data.longitude);

                //Initializing the Marker object.
                var marker = new google.maps.Marker({
                    position: myLatlng,
                    map: map,
                    title: data.title
                });

                //Adding InfoWindow to the Marker.
                (function (markerparam, dataparam) {
                    google.maps.event.addListener(markerparam, "click", function (e) {
                        InfoWindow.setContent("<div class='heat-map-popup'><b>" + dataparam.description.replace(/\r?\n/g, "<br />") + "</b></div>");
                        InfoWindow.open(map, markerparam);
                    });
                })(marker, data);

                //Plotting the Marker on the Map.
                Latlngbounds.extend(marker.position);
            }
            heatMapCtrl.showContainmnetAreas();
        }

        heatMapCtrl.init = function () {
            Mask.show();
            $http.get('Gujarat-line.json').then(function (response) {
                Mask.hide();
                heatMapCtrl.geoJsonData = response.data;
                heatMapCtrl.getHeatMapData();
            }, function (error) {
                Mask.hide();
            });
        };

        heatMapCtrl.showCountsOnMap = function () {
            if (heatMapCtrl.showCounts) {
                var clusterMarkers = [];
                var image = {
                    url: 'img/orange-cluster.png',
                    scaledSize: new google.maps.Size(50, 50), // scaled size
                    origin: new google.maps.Point(0, 0), // origin
                    anchor: new google.maps.Point(0, 0) // anchor
                };
                var markers = locations.map(function (location, i) {
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
                    clusterMarkers.push(marker)
                    marker.addListener('click', function (e) {
                    });
                    return marker;
                });
                var calc = function (markers, numStyles) {
                    var weight = 0;
                    for (var i = 0; i < markers.length; ++i) {
                        weight += Number(markers[i].weight);
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

        heatMapCtrl.addCicrle = function (lat, lng) {
            if (circle) {
                deleteCircle(currentCicrleId)
                circle.setMap(null);
            }

            circle = new google.maps.Circle({
                strokeColor: '#FF0000',
                strokeOpacity: 0.8,
                strokeWeight: 2,
                fillColor: '#FF0000',
                fillOpacity: 0.25,
                map: map,
                center: { lat, lng },
                radius: 3000,
                editable: true
            });

            saveCircle({ radius: circle.getRadius(), center: { lat: circle.getCenter().lat(), lng: circle.getCenter().lng() } });
        }

        heatMapCtrl.enableShowContainment = function () {
            if (heatMapCtrl.addCircleView) {
                if (!heatMapCtrl.isShowContainmnetArea) {
                    heatMapCtrl.isShowContainmnetArea = true;
                    heatMapCtrl.showContainmnetAreas();
                }
            }
        }

        heatMapCtrl.showContainmnetAreas = function () {
            if (heatMapCtrl.isShowContainmnetArea) {
                if (circle) {
                    circle.setMap(null);
                }

                if (containmnetCircle.length > 0) {
                    containmnetCircle.forEach(circleObj => {
                        circleObj.setMap(null);
                    });
                }
                if (deletMarkers.length > 0) {
                    deletMarkers.forEach(marker => {
                        marker.setMap(null);
                    });
                }
                if (exportPlaces.length > 0) {
                    exportPlaces.forEach(marker => {
                        marker.setMap(null);
                    })
                }
                containmnetCircle = [];
                deletMarkers = [];
                var j = 0;
                Mask.show();
                $http.get('/api/idsp/retrieveallobjects')
                    .then(function (resposne) {
                        Mask.hide();
                        circles = resposne.data;
                        for (var i = 0; i < circles.length; i++) {
                            try {
                                circles[i].shapeJson = JSON.parse(circles[i].shapeJson);

                                containmnetCircle[j] = new google.maps.Circle({
                                    strokeColor: '#FF0000',
                                    strokeOpacity: 0.8,
                                    strokeWeight: 2,
                                    fillColor: '#FF0000',
                                    fillOpacity: 0.10,
                                    map: map,
                                    center: circles[i].shapeJson.center,
                                    radius: circles[i].shapeJson.radius,
                                    editable: (heatMapCtrl.isDeleteEnable || heatMapCtrl.showExport) ? false : true,
                                    id: circles[i].id
                                });

                                if (heatMapCtrl.showExport) {
                                    exportPlaces[i] = new google.maps.Marker({
                                        position: containmnetCircle[j].getCenter(),
                                        map: map,
                                        title: 'Export Places',
                                        icon: {
                                            url: "img/arrows.svg",
                                            scaledSize: new google.maps.Size(20, 20), // scaled size
                                        }
                                    });

                                    (function (marker, id) {
                                        google.maps.event.addListener(marker, "click", function (e) {
                                            heatMapCtrl.showProminentPlaces(id)
                                        });
                                    })(exportPlaces[i], circles[i].id);
                                }

                                if (heatMapCtrl.isDeleteEnable) {
                                    deletMarkers[i] = new google.maps.Marker({
                                        position: containmnetCircle[j].getCenter(),
                                        map: map,
                                        title: 'Delete',
                                        icon: {
                                            url: "img/cancel.svg",
                                            scaledSize: new google.maps.Size(20, 20), // scaled size
                                        }
                                    });

                                    (function (marker, id) {
                                        google.maps.event.addListener(marker, "click", function (e) {
                                            deleteCircle(id);
                                            marker.setMap(null);
                                        });
                                    })(deletMarkers[i], circles[i].id);
                                }

                                function updateCircle(changedPoint) {
                                    if (changedPoint) {
                                        saveCircle({ radius: changedPoint.getRadius(), center: { lat: changedPoint.getCenter().lat(), lng: changedPoint.getCenter().lng() } }, changedPoint.id);
                                    }
                                }

                                containmnetCircle[j].addListener('radius_changed', (event) => {
                                    var changedPoint;
                                    containmnetCircle.forEach(newCircle => {
                                        var oldCircle = circles.filter(circleObj => circleObj.id == newCircle.id);
                                        if (newCircle.getRadius() != oldCircle[0].shapeJson.radius) {
                                            changedPoint = newCircle;
                                        }
                                    });
                                    updateCircle(changedPoint);
                                });

                                containmnetCircle[j].addListener('center_changed', (event) => {
                                    var changedPoint;
                                    containmnetCircle.forEach(newCircle => {
                                        var oldCircle = circles.filter(circleObj => circleObj.id == newCircle.id);
                                        if (newCircle.getCenter().lat() != oldCircle[0].shapeJson.center.lat || newCircle.getCenter().lng() != oldCircle[0].shapeJson.center.lng) {
                                            changedPoint = newCircle;
                                        }
                                    });
                                    updateCircle(changedPoint);
                                });

                                j++;

                            } catch (error) {
                                console.log('----', error);
                                circles[i].shapeJson = {};
                            }
                        }
                    })
                    .catch(function (error) {
                        Mask.hide();
                    });
            } else {
                if (containmnetCircle.length > 0) {
                    containmnetCircle.forEach(circleObj => {
                        circleObj.setMap(null);
                    });
                }
                if (deletMarkers.length > 0) {
                    deletMarkers.forEach(marker => {
                        marker.setMap(null);
                    });
                }

                if (exportPlaces.length > 0) {
                    exportPlaces.forEach(marker => {
                        marker.setMap(null);
                    })
                }
                containmnetCircle = [];
                deletMarkers = [];
                exportPlaces = [];
            }
        }

        heatMapCtrl.showProminentPlaces = function (circleId) {
            var currCircle = circles.filter(c => c.id == circleId);
            if (currCircle.length == 0) {
                return;
            }
            currCircle = currCircle[0];
            const radius = currCircle.shapeJson.radius;
            const latLng = new google.maps.LatLng(currCircle.shapeJson.center.lat, currCircle.shapeJson.center.lng);
            const address = [];
            const data = [];
            const types = [
                'park', 'amusement_park', 'rv_park', 'restaurant',
                'bank', 'mosque', 'hindu_temple', 'church',
                'post_office', 'school', 'secondary_school', 'university'
            ];

            const promiseJob = [];

            for (let i = 0; i < types.length; i++) {
                const request = {
                    location: latLng,
                    radius: radius,
                    type: types[i]
                };
                const service = new google.maps.places.PlacesService(map);
                promiseJob.push(new Promise((resolve, reject) => {
                    service.nearbySearch(request, (results, status) => {
                        if (status == google.maps.places.PlacesServiceStatus.OK) {
                            for (let j = 0; j < results.length; j++) {
                                const temp = address.find(a => a.place_id == results[j].place_id);
                                if (!temp || !Array.isArray(temp) || temp.length === 0) {
                                    address.push(results[j]);
                                }
                            }
                        }
                        resolve();
                    });
                }));
            }

            Promise.all(promiseJob).then(() => {
                address.forEach(add => {
                    data.push({
                        'Name': add.name,
                        'GPS Co-ordinates': add.geometry.location,
                        'Address': add.vicinity
                    });
                });
                heatMapCtrl.export(data);
            });

        }

        heatMapCtrl.export = function (data) {
            function compare(a, b) {
                const nameA = a.Name.toUpperCase();
                const nameB = b.Name.toUpperCase();

                let comparison = 0;
                if (nameA > nameB) {
                    comparison = 1;
                } else if (nameA < nameB) {
                    comparison = -1;
                }
                return comparison;
            }

            var mystyle = {
                headers: true,
                column: { style: { Font: { Bold: "1" } } }
            };

            data = data.sort(compare);
            alasql('SELECT * INTO XLSX("' + "Places List" + '",?) FROM ?', [mystyle, data]);
        }

        heatMapCtrl.init();
    }
    angular.module('imtecho.controllers').controller('SymptomaticMembersHeatmapController', SymptomaticMembersHeatmapController);
})();
