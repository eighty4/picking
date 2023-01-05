import 'package:flutter/material.dart';

import 'metronome.dart';

class TabContext {
  final Color backgroundColor;
  final Color chartColor;
  final Color metronomeColor;
  final Color notationColor;
  final MetronomeConfig metronomeConfig;

  TabContext.forBrightness(Brightness brightness)
      : backgroundColor = Colors.transparent,
        chartColor = Colors.blueGrey,
        metronomeColor = Colors.blue,
        notationColor =
            brightness == Brightness.dark ? Colors.white : Colors.black,
        metronomeConfig = MetronomeConfig();

  Paint chartPaint(PaintingStyle style, {double width = 1}) {
    return Paint()
      ..strokeWidth = width
      ..style = style
      ..color = chartColor;
  }

  Paint metronomePaint(PaintingStyle style, {double width = 2}) {
    return Paint()
      ..strokeWidth = width
      ..style = style
      ..color = metronomeColor;
  }

  Paint notationPaint(PaintingStyle style, {double width = 2}) {
    return Paint()
      ..strokeWidth = width
      ..style = style
      ..color = notationColor;
  }
}
