import 'package:flutter/material.dart';

class TestingMovedPainterPoint extends StatefulWidget {
  const TestingMovedPainterPoint({super.key});

  @override
  State<TestingMovedPainterPoint> createState() => _TestingMovedPainterPointState();
}

class _TestingMovedPainterPointState extends State<TestingMovedPainterPoint> {
  List<Offset> repointPositions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/img2.jpg'),
                fit: BoxFit.fill,
              )
            ),
            child: GestureDetector(
              onTapDown: (details){
                setState(() {
                  repointPositions.add(details.localPosition);
                });
              },
              child: rePolygonWidget(
                recolor: Colors.blue,
                rePointPositions: repointPositions,
                reStrokeWidth: 3.0,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class rePolygonWidget extends StatefulWidget {
  final List<Offset> rePointPositions;
  final Color recolor;
  final double reStrokeWidth;
  const rePolygonWidget({Key? key, required this.rePointPositions, required this.recolor, required this.reStrokeWidth}):super(key: key);

  @override
  State<rePolygonWidget> createState() => _rePolygonWidgetState();
}

class _rePolygonWidgetState extends State<rePolygonWidget> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: rePolygonPainter(
        repoints: widget.rePointPositions,
        recolor: widget.recolor,
        restrokeWidth: widget.reStrokeWidth,
      ),
    );
  }
}

class rePolygonPainter extends CustomPainter{
  final List<Offset> repoints;
  final Color recolor;
  final double restrokeWidth;

  rePolygonPainter({
    required this.repoints,
    required this.recolor,
    required this.restrokeWidth,
});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
        ..color = recolor
        ..strokeWidth = restrokeWidth
        ..style = PaintingStyle.stroke;

    final path = Path();

    if(repoints.isNotEmpty){
      path.moveTo(repoints[0].dx, repoints[0].dy);
      for(var i=1; i<repoints.length; i++){
        path.lineTo(repoints[i].dx, repoints[i].dy);
      }

      path.close();
      canvas.drawPath(path, paint);

      final whitePaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

      for(var point in repoints){
        canvas.drawCircle(point, 5.0, whitePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}