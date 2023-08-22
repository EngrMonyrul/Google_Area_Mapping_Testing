import 'package:flutter/material.dart';

class ColorPolygon extends StatefulWidget {
  @override
  _ColorPolygonState createState() => _ColorPolygonState();
}

class _ColorPolygonState extends State<ColorPolygon> {
  List<Offset> polygonVertices = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dynamic Polygon'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  polygonVertices.add(details.localPosition);
                });
              },
              child: Container(
                width: 300,
                height: 300,
                color: Colors.grey[300],
                child: PolygonWidget(
                  vertices: polygonVertices,
                  color: Colors.blue,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text('Draw inside the box to create a polygon.'),
          ],
        ),
      ),
    );
  }
}

class PolygonWidget extends StatelessWidget {
  final List<Offset> vertices;
  final Color color;
  final double strokeWidth;

  PolygonWidget({
    required this.vertices,
    required this.color,
    this.strokeWidth = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: PolygonPainter(
        vertices: vertices,
        color: color,
        strokeWidth: strokeWidth,
      ),
    );
  }
}

class PolygonPainter extends CustomPainter {
  final List<Offset> vertices;
  final Color color;
  final double strokeWidth;

  PolygonPainter({
    required this.vertices,
    required this.color,
    this.strokeWidth = 2.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.fill;

    final path = Path();

    if (vertices.isNotEmpty) {
      path.moveTo(vertices[0].dx, vertices[0].dy);
      for (var i = 1; i < vertices.length; i++) {
        path.lineTo(vertices[i].dx, vertices[i].dy);
      }
      path.close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
