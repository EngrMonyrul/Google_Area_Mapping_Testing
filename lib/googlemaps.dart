import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;
import 'package:flutter/src/material/dropdown.dart';

import 'model_bottom_sheet.dart';

class GoogleMapsService extends StatefulWidget {
  const GoogleMapsService({super.key});

  @override
  State<GoogleMapsService> createState() => _GoogleMapsServiceState();
}

class _GoogleMapsServiceState extends State<GoogleMapsService> {
  Completer<GoogleMapController> _completer = Completer();
  TextEditingController _controller = TextEditingController();
  var uuid = Uuid();
  String sessiontoken = '112233';
  List<LatLng> selectedPosition = [];
  double area = 0;
  double MainArea = 0;
  String? convert = 'Square Meters';

  static final CameraPosition cameraPosition = const CameraPosition(
    target: LatLng(23.777176, 90.399452),
    zoom: 6,
  );
  List<Marker> _marker = [];
  bool search = false;
  List<dynamic> placesList = [];

  Future<Position> getUserPosition() async {
    await Geolocator.requestPermission().then((value) {}).onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print('error - ${error.toString()}');
    });
    return await Geolocator.getCurrentPosition();
  }

  onChangeMethod() {
    if (sessiontoken == null) {
      setState(() {
        sessiontoken = uuid.v4();
        print('session = $sessiontoken');
      });
    }

    getSuggetstion(_controller.text);
  }

  getSuggetstion(String input) async {
    String api_key = 'AIzaSyAJTDDyLJGfrCPDUhHab9K5tpXv2Vfeztk';
    String baseURL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    // String baseURL = 'https://developers.google.com/maps/documentation/places/web-service/autocomplete/json';
    String request = '$baseURL?input=$input&key=$api_key&sessiontoken=$sessiontoken';
    var response = await http.get(Uri.parse(request));
    if (response.statusCode == 200) {
      setState(() {
        placesList = jsonDecode(response.body.toString())['predictions'];
        print(response.body.toString());
      });
    }
  }

  Set<Polygon> _polygon = HashSet<Polygon>();

  tapOnMap(LatLng latLng) {
    setState(() {
      selectedPosition.add(latLng);
      _polygon.add(Polygon(
        polygonId: PolygonId('1'),
        points: selectedPosition,
        fillColor: Colors.black.withOpacity(0.3),
        geodesic: true,
        strokeColor: Colors.black,
        strokeWidth: 2,
      ));

      const double earthRadius = 6371000; // in meters
      double area = 0;

      if (selectedPosition.length > 2) {
        for (int i = 0; i < selectedPosition.length - 1; i++) {
          LatLng p1 = selectedPosition[i];
          LatLng p2 = selectedPosition[i + 1];
          area += _convertToRadian(p2.longitude - p1.longitude) *
              (2 + math.sin(_convertToRadian(p1.latitude)) +
                  math.sin(_convertToRadian(p2.latitude)));
        }
        area = area * earthRadius * earthRadius / 2;
      }
      MainArea = area.abs();
    });
  }

  double _convertToRadian(double degree) {
    return degree * math.pi / 180;
  }

  @override
  void initState() {
    // TODO: implement initState
    _controller.addListener(() {
      onChangeMethod();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: [
            GoogleMap(
              polygons: _polygon,
              onTap: tapOnMap,
              initialCameraPosition: cameraPosition,
              mapType: MapType.normal,
              myLocationButtonEnabled: true,
              compassEnabled: true,
              markers: Set<Marker>.of(_marker),
              onMapCreated: (GoogleMapController controller) {
                setState(() {
                  _completer.complete(controller);
                });
              },
            ),
            Positioned(
                top: 0,
                left: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black.withOpacity(0.3), elevation: 0, shape: CircleBorder()),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back_ios_new_outlined, color: Colors.white),
                    ),
                    if (search == true)
                      Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          height: MediaQuery.of(context).size.height * 0.06,
                          width: MediaQuery.of(context).size.width * 0.65,
                          child: TextField(
                            controller: _controller,
                            keyboardType: TextInputType.text,
                            autofocus: false,
                            cursorOpacityAnimates: true,
                            textAlign: TextAlign.left,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.8),
                                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                )),
                          )),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black.withOpacity(0.3), elevation: 0, shape: CircleBorder()),
                      onPressed: () {
                        setState(() {
                          search = !search;
                        });
                      },
                      child: Icon(Icons.search, color: Colors.white),
                    ),
                  ],
                )),
            if (selectedPosition.length > 2)
              Positioned(
                bottom: 10,
                child: GestureDetector(
                  onTap: (){
                    showBottomSheetForMeasure(context, MainArea);
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      border: Border.all(color: Colors.white),
                    ),
                    child: Text('See Measurement', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            if (search)
              Positioned(
                top: 44,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    itemCount: placesList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(placesList[index]['description']),
                      );
                    },
                  ),
                ),
              ),
            Positioned(
                bottom: 90,
                right: 0,
                child: Row(
                  children: [
                    ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.blue, elevation: 0, shape: CircleBorder()),
                      onPressed: () async {
                        getUserPosition().then((value) async {
                          setState(() {
                            _marker.add(Marker(
                              markerId: MarkerId('1'),
                              position: LatLng(value.latitude, value.longitude),
                            ));
                          });

                          GoogleMapController _controller = await _completer.future;
                          _controller.animateCamera(CameraUpdate.newCameraPosition(
                            CameraPosition(
                              target: LatLng(value.latitude, value.longitude),
                              zoom: 6,
                            ),
                          ));
                        });
                      },
                      child: Icon(Icons.my_location, color: Colors.white),
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
