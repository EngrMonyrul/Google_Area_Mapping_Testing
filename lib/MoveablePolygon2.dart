import 'package:flutter/material.dart';

class Point {
  Offset position;
  bool isVisible;

  Point(this.position) : isVisible = false;
}

class PolygonPage2 extends StatefulWidget {
  @override
  _PolygonPage2State createState() => _PolygonPage2State();
}

class _PolygonPage2State extends State<PolygonPage2> {
  List<Point> points = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Polygon with Draggable Points'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTapDown: (details) {
                setState(() {
                  points.add(Point(details.localPosition));
                });
              },
              child: Container(
                width: 300,
                height: 300,
                color: Colors.grey[300],
                child: Stack(
                  children: [
                    PolygonWidget(points: points),
                  ],
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
  final List<Point> points;
  final double strokeWidth;

  PolygonPainter({
    required this.points,
    this.strokeWidth = 2.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path();

    if (points.isNotEmpty) {
      path.moveTo(points[0].position.dx, points[0].position.dy);
      for (var i = 1; i < points.length; i++) {
        path.lineTo(points[i].position.dx, points[i].position.dy);
      }
      path.close();
      canvas.drawPath(path, paint);

      final dotPaint = Paint()
        ..color = Colors.red
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.fill;

      for (var point in points) {
        if (point.isVisible) {
          canvas.drawCircle(point.position, 6.0, dotPaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class PolygonWidget extends StatefulWidget {
  final List<Point> points;

  PolygonWidget({required this.points});

  @override
  _PolygonWidgetState createState() => _PolygonWidgetState();
}

class _PolygonWidgetState extends State<PolygonWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        setState(() {
          for (var point in widget.points) {
            point.isVisible = false;
          }
          final visiblePoint = widget.points.firstWhere(
                (point) => point.position == details.localPosition,
            orElse: () => Point(details.localPosition),
          );
          visiblePoint.isVisible = true;
        });
      },
      child: CustomPaint(
        painter: PolygonPainter(points: widget.points),
      ),
    );
  }
}
