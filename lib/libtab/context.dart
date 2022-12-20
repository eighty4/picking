import 'package:flutter/material.dart';

class TabContext {
  final Color backgroundColor;
  final Color lineColor;
  final Color notationColor;

  TabContext.forBrightness(Brightness brightness)
      : backgroundColor = Colors.transparent,
        lineColor = Colors.blueGrey,
        notationColor =
            brightness == Brightness.dark ? Colors.white : Colors.black;

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
