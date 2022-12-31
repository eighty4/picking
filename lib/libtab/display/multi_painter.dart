import 'package:flutter/cupertino.dart';

typedef CustomPaintBuilder = CustomPaint Function(
    BuildContext context, CustomPainter painter);

class MultiPainter extends StatelessWidget {
  final CustomPaintBuilder? customPaintBuilder;
  final List<CustomPainter>? painters;
  final List<CustomPaint>? paints;
  final Size? size;

  MultiPainter(
      {super.key,
      this.painters,
      this.paints,
      this.size,
      this.customPaintBuilder}) {
    assert(painters != null || paints != null);
    assert((painters == null && painters!.isEmpty) || size != null);
  }

  @override
  Widget build(BuildContext context) {
    final paints = this.paints ?? [];
    final buildCustomPaint = customPaintBuilder ??
        (context, painter) => CustomPaint(painter: painter, size: size!);
    painters?.forEach((painter) {
      paints.add(buildCustomPaint(context, painter));
    });
    return Stack(children: paints);
  }
}
