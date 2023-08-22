import 'package:flutter/material.dart';

class MoveableLinePolygon3 extends StatefulWidget {
  @override
  _MoveableLinePolygon3State createState() => _MoveableLinePolygon3State();
}

class _MoveableLinePolygon3State extends State<MoveableLinePolygon3> {
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
              child: GestureDetector(
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
        canvas.drawCircle(point, 15.0, whitePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class DraggablePoint extends StatefulWidget {
  final Offset position;
  final ValueChanged<Offset> onUpdate;

  DraggablePoint({
    required this.position,
    required this.onUpdate,
  });

  @override
  _DraggablePointState createState() => _DraggablePointState();
}

class _DraggablePointState extends State<DraggablePoint> {
  Offset currentPosition = Offset.zero;

  @override
  void initState() {
    super.initState();
    currentPosition = widget.position;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: currentPosition.dx - 8, // Adjust for point size
      top: currentPosition.dy - 8,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            currentPosition = Offset(
              currentPosition.dx + details.delta.dx,
              currentPosition.dy + details.delta.dy,
            );
            widget.onUpdate(currentPosition);
          });
        },
        child: Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class PolygonWidget extends StatefulWidget {
  final List<Offset> pointPositions;
  final Color color;
  final double strokeWidth;

  PolygonWidget({
    required this.pointPositions,
    required this.color,
    this.strokeWidth = 2.0,
  });

  @override
  _PolygonWidgetState createState() => _PolygonWidgetState();
}

class _PolygonWidgetState extends State<PolygonWidget> {
  List<Offset> draggablePositions = [];

  @override
  void initState() {
    super.initState();
    draggablePositions = List.from(widget.pointPositions);
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: PolygonPainter(
        points: widget.pointPositions,
        color: widget.color,
        strokeWidth: widget.strokeWidth,
      ),
      child: Stack(
        children: [
          for (var position in draggablePositions)
            DraggablePoint(
              position: position,
              onUpdate: (newPosition) {
                setState(() {
                  final index = draggablePositions.indexOf(position);
                  draggablePositions[index] = newPosition;
                });
              },
            ),
        ],
      ),
    );
  }
}
