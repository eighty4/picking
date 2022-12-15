import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:picking/libtab/libtab.dart';

class ChordChartDisplay extends StatelessWidget {
  final TabContext ctx;
  final ChordNoteSet chord;

  const ChordChartDisplay(
      {Key? key, this.ctx = const TabContext(), required this.chord})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          color: ctx.backgroundColor,
          child: CustomPaint(
              willChange: false,
              size: const Size(200, 250),
              painter: ChordChartPainter(ctx, chord))),
    );
  }
}

class ChordChartPainter extends CustomPainter {
  final TabContext ctx;
  final ChordNoteSet chord;
  final Paint linePaint;
  final Paint notePaint;
  final int stringCount;
  double fretSpacing = 0;
  double stringSpacing = 0;
  double noteRadius = 0;

  ChordChartPainter(this.ctx, this.chord)
      : linePaint = ctx.linePaint(),
        notePaint = ctx.notationPaint(style: PaintingStyle.fill),
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
    var path = Path();

    canvas.drawLine(
        const Offset(0, 1), Offset(size.width, 1), ctx.linePaint(width: 3));

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

    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
