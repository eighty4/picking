import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:picking/libtab/libtab.dart';

class ChordChartDisplay extends StatelessWidget {
  final TabContext tabContext;
  final ChordNoteSet chord;

  const ChordChartDisplay(
      {Key? key, required this.tabContext, required this.chord})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          color: tabContext.backgroundColor,
          child: CustomPaint(
              willChange: false,
              size: const Size(200, 250),
              painter: ChordChartPainter(tabContext, chord))),
    );
  }
}

class ChordChartPainter extends CustomPainter {
  final TabContext tabContext;
  final ChordNoteSet chord;
  final Paint notePaint;
  final int stringCount;
  double fretSpacing = 0;
  double stringSpacing = 0;
  double noteRadius = 0;

  ChordChartPainter(this.tabContext, this.chord)
      : notePaint = tabContext.notationPaint(PaintingStyle.fill),
        stringCount = chord.instrument.stringCount();

  @override
  void paint(Canvas canvas, Size size) {
    fretSpacing = size.height / 5;
    stringSpacing = size.width / (stringCount - 1);
    noteRadius = min(stringSpacing, fretSpacing) / 3;
    drawFretsAndStrings(canvas, size);
    drawNote(canvas, size, chord.notes);
  }

  void drawNote(Canvas canvas, Size size, Note note) {
    final x = size.width - (note.string - 1) * stringSpacing;
    final y = ((note.fret - 1) * fretSpacing) + (fretSpacing / 2);
    canvas.drawCircle(Offset(x, y), noteRadius, notePaint);

    if (note.and != null) {
      drawNote(canvas, size, note.and!);
    }
  }

  void drawFretsAndStrings(Canvas canvas, Size size) {
    final path = Path();

    // draw frets
    for (var i = 0; i < 6; i++) {
      var y = fretSpacing * i;
      path.moveTo(0, y);
      path.lineTo(size.width, y);
    }

    // draw strings
    for (var i = 0; i < stringCount; i++) {
      var x = stringSpacing * i;
      path.moveTo(x, 0);
      path.lineTo(x, size.height);
    }

    canvas.drawPath(path, tabContext.chartPaint(PaintingStyle.stroke));
    canvas.drawRect(Rect.fromPoints(Offset.zero, Offset(size.width, 3)),
        tabContext.chartPaint(PaintingStyle.fill));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
