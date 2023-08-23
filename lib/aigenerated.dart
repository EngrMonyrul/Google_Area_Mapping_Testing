import 'dart:math' as math;
import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class PolygonAreaExample extends StatefulWidget {
  @override
  _PolygonAreaExampleState createState() => _PolygonAreaExampleState();
}

class _PolygonAreaExampleState extends State<PolygonAreaExample> {
  // A controller for the Google Map widget
  late GoogleMapController _controller;

  // A list of LatLng objects that define the vertices of the polygon
  List<LatLng> _polygonPoints = [
    LatLng(23.8103, 90.4125), // Dhaka
    LatLng(24.8607, 89.3713), // Mymensingh
    LatLng(24.3745, 88.6042), // Rajshahi
    LatLng(22.3569, 91.7832), // Chittagong
    LatLng(23.8103, 90.4125), // Dhaka (closing the polygon)
  ];

  // A set of Polygon objects that will be displayed on the map
  Set<Polygon> _polygons = {};

  // A method that creates a Polygon object from the list of points and adds it to the set
  void _createPolygon() {
    final String polygonIdVal = 'polygon_id_$_polygons.length';

    _polygons.add(Polygon(
      polygonId: PolygonId(polygonIdVal),
      points: _polygonPoints,
      strokeWidth: 2,
      strokeColor: Colors.yellow,
      fillColor: Colors.yellow.withOpacity(0.15),
    ));
  }

  // A method that calculates the area of a spherical polygon using the excess angle formula
  double _calculatePolygonArea() {
    const double earthRadius = 6371000; // in meters
    double area = 0;

    if (_polygonPoints.length > 2) {
      for (int i = 0; i < _polygonPoints.length - 1; i++) {
        LatLng p1 = _polygonPoints[i];
        LatLng p2 = _polygonPoints[i + 1];
        area += _convertToRadian(p2.longitude - p1.longitude) *
            (2 + math.sin(_convertToRadian(p1.latitude)) +
                math.sin(_convertToRadian(p2.latitude)));
      }
      area = area * earthRadius * earthRadius / 2;
    }
    // return math.abs(area);
    return area.abs();
  }

  // A helper method that converts degrees to radians
  double _convertToRadian(double degree) {
    return degree * math.pi / 180;
  }

  @override
  void initState() {
    super.initState();
    // Create the polygon when the widget is initialized
    _createPolygon();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Polygon Area Example'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(23.6850, 90.3563), // Bangladesh
          zoom: 6,
        ),
        polygons: _polygons,
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Calculate the area of the polygon and show it in a snackbar
          double area = _calculatePolygonArea();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('The area of the polygon is ${area.toStringAsFixed(2)} square meters'),
            ),
          );
        },
        label: Text('Calculate Area'),
        icon: Icon(Icons.calculate),
      ),
    );
  }
}
