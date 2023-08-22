import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';

class PointedPolygon extends StatefulWidget {
  @override
  _PointedPolygonState createState() => _PointedPolygonState();
}

class _PointedPolygonState extends State<PointedPolygon> {
  List<Offset> pointPositions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dynamic Polygon with Draggable Points'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 300,
              height: 300,
              color: Colors.grey[300],
              child:
              GestureDetector(
                onTapDown: (details) {
                  setState(() {
                    pointPositions.add(details.localPosition);
                  });
                },
                child: PolygonWidget(
                  pointPositions: pointPositions,
                  color: Colors.blue,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text('Tap to add points and create a polygon.'),
          ],
        ),
      ),
    );
  }
}

class PolygonPainter extends CustomPainter {
  final List<Offset> points;
  final Color color;
  final double strokeWidth;

  PolygonPainter({
    required this.points,
    required this.color,
    this.strokeWidth = 2.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path();

    if (points.isNotEmpty) {
      path.moveTo(points[0].dx, points[0].dy);
      for (var i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
      path.close();
      canvas.drawPath(path, paint);

      final whitePaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;

      for (var point in points) {
        canvas.drawCircle(point, 4.0, whitePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class PolygonWidget extends StatelessWidget {
  final List<Offset> pointPositions;
  final Color color;
  final double strokeWidth;

  PolygonWidget({
    required this.pointPositions,
    required this.color,
    this.strokeWidth = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: PolygonPainter(
        points: pointPositions,
        color: color,
        strokeWidth: strokeWidth,
      ),
    );
  }
}
