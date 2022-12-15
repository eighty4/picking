import 'package:flutter/widgets.dart';

class TabContext {
  final bool drawBorder;
  final Color backgroundColor;
  final Color lineColor;
  final Color notationColor;

  const TabContext({
    this.drawBorder = true,
    this.backgroundColor = const Color.fromARGB(255, 255, 255, 255),
    this.lineColor = const Color.fromARGB(255, 96, 125, 139),
    this.notationColor = const Color.fromARGB(255, 0, 0, 0),
  });

  Paint linePaint(
      {double width = 1, PaintingStyle style = PaintingStyle.stroke}) {
    return Paint()
      ..strokeWidth = width
      ..style = style
      ..color = lineColor;
  }

  Paint notationPaint(
      {double width = 2, PaintingStyle style = PaintingStyle.stroke}) {
    return Paint()
      ..strokeWidth = width
      ..style = style
      ..color = notationColor;
  }
}
