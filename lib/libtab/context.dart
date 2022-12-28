import 'package:flutter/material.dart';

class TabContext {
  final Color backgroundColor;
  final Color chartColor;
  final Color notationColor;

  TabContext.forBrightness(Brightness brightness)
      : backgroundColor = Colors.transparent,
        chartColor = Colors.blueGrey,
        notationColor =
            brightness == Brightness.dark ? Colors.white : Colors.black;

  Paint chartPaint(PaintingStyle style, {double width = 1}) {
    return Paint()
      ..strokeWidth = width
      ..style = style
      ..color = chartColor;
  }

  Paint notationPaint(PaintingStyle style, {double width = 2}) {
    return Paint()
      ..strokeWidth = width
      ..style = style
      ..color = notationColor;
  }
}
