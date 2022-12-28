import 'package:flutter/widgets.dart';
import 'package:picking/libtab/libtab.dart';

class GridPainter extends CustomPainter {
  final TabContext tabContext;
  final int? verticalLines;
  final int? horizontalLines;

  GridPainter(
      {required this.tabContext, this.verticalLines, this.horizontalLines}) {
    assert(verticalLines != null || horizontalLines != null);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..addRect(Rect.fromPoints(Offset.zero, Offset(size.width, size.height)));
    if (horizontalLines != null) {
      final horizontalLines = this.horizontalLines!.toDouble();
      final horizontalSpacing = size.height / (horizontalLines - 1);
      for (var i = 1; i < horizontalLines - 1; i++) {
        var y = horizontalSpacing * i;
        path.moveTo(0, y);
        path.lineTo(size.width, y);
      }
    }
    if (verticalLines != null) {
      final verticalLines = this.verticalLines!.toDouble();
      final verticalSpacing = size.width / (verticalLines - 1);
      for (var i = 1; i < verticalLines - 1; i++) {
        var x = verticalSpacing * i;
        path.moveTo(x, 0);
        path.lineTo(x, size.height);
      }
    }
    canvas.drawPath(path, tabContext.chartPaint(PaintingStyle.stroke));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
