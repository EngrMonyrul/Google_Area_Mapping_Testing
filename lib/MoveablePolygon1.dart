import 'package:flutter/material.dart';
import 'dart:math' as math;

class MoveablePolygonWidget1 extends StatefulWidget {
  MoveablePolygonWidget1({Key? key}):super(key: key);

  @override
  _MoveablePolygonWidget1State createState() => _MoveablePolygonWidget1State();
}

class _MoveablePolygonWidget1State extends State<MoveablePolygonWidget1> {

  Offset pointerPosition = Offset(0, 0);
  final int sides = 5;

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          pointerPosition = details.localPosition;
        });
      },
      child: CustomPaint(
        painter: PolygonPainter(sides: sides),
        foregroundPainter: PointerPainter(position: pointerPosition),
        child: Container(
          height: double.infinity,
          width: double.infinity,
        ),
      ),
    );

  }
}


class PolygonPainter extends CustomPainter {
  final int sides;
  final double radius;
  final Color color;

  PolygonPainter({this.sides = 3, this.radius = 100.0, this.color = Colors.blue});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke;

    var path = Path();
    var angle = (math.pi * 2) / sides;

    Offset center = Offset(size.width / 2, size.height / 2);

    // Move to the first vertex
    path.moveTo(center.dx + radius * math.cos(0.0), center.dy + radius * math.sin(0.0));

    // Draw the remaining vertices
    for(int i = 1; i < sides; i++){
      path.lineTo(center.dx + radius * math.cos(angle * i), center.dy + radius * math.sin(angle * i));
    }

    // Close the path
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class PointerPainter extends CustomPainter {
  final Offset position;
  final Color color;

  PointerPainter({required this.position, this.color = Colors.red});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke;

    var path = Path();

    // Draw a circle with a cross inside
    path.addOval(Rect.fromCircle(center: position, radius: 10.0));
    path.moveTo(position.dx - 10.0, position.dy);
    path.lineTo(position.dx + 10.0, position.dy);
    path.moveTo(position.dx, position.dy - 10.0);
    path.lineTo(position.dx, position.dy + 10.0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

