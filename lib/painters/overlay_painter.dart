import 'package:flutter/cupertino.dart';

class OverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = const Color(0xff995588)
      ..style = PaintingStyle.fill;
    canvas.drawRect(const Offset(100, 100) & const Size(200, 200), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}