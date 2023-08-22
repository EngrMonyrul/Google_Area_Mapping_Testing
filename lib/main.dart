import 'package:flutter/material.dart';
import 'package:googleareamapping/MoveablePolygon1.dart';
import 'package:googleareamapping/PointedPolygon.dart';
import 'package:googleareamapping/Line Polygon.dart';
import 'package:googleareamapping/CoveredColorPolygon.dart';
import 'package:googleareamapping/testing1.dart';

import 'MoveablePolygon2.dart';
import 'MoveablePolygon3.dart';
import 'MovealbePointedLinePolygon.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PolylineOrPloygoanExample(),
    );
  }
}

class PolylineOrPloygoanExample extends StatefulWidget {
  const PolylineOrPloygoanExample({super.key});

  @override
  State<PolylineOrPloygoanExample> createState() => _PolylineOrPloygoanExampleState();
}

class _PolylineOrPloygoanExampleState extends State<PolylineOrPloygoanExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Polygon Examples'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            buildButtons(context, 'Covered Color Polygon', ColorPolygon()),
            const SizedBox(height: 10),
            buildButtons(context, 'Line Polygon', LinePolygon()),
            const SizedBox(height: 10),
            buildButtons(context, 'Pointed Polygon', PointedPolygon()),
            const SizedBox(height: 10),
            buildButtons(context, 'Moveable Pointed Polygon', MoveableLinePolygon()),
            const SizedBox(height: 10),
            buildButtons(context, 'Moveable Pointed Polygon 1', MoveablePolygonWidget1()),
            const SizedBox(height: 10),
            buildButtons(context, 'Moveable Pointed Polygon 2', PolygonPage2()),
            const SizedBox(height: 10),
            buildButtons(context, 'Moveable Pointed Polygon 3', MoveableLinePolygon3()),
            const SizedBox(height: 10),
            buildButtons(context, 'Testing', TestingMovedPainterPoint()),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Padding buildButtons(BuildContext context, text, nav) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueGrey,
          elevation: 0,
        ),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => nav));
        },
        child: ListTile(
          title: Text(
            text,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
