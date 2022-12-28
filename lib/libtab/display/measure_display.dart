import 'package:flutter/widgets.dart';
import 'package:picking/libtab/libtab.dart';

class MeasureDisplay extends StatelessWidget {
  static const size = Size(300, 200);
  final TabContext tabContext;
  final Instrument instrument;
  final bool last;
  final Measure measure;

  const MeasureDisplay(this.measure,
      {Key? key,
      required this.tabContext,
      required this.instrument,
      this.last = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stringSpacing = StringSpacing.fromPaintSize(instrument, size);
    return Container(
        color: tabContext.backgroundColor,
        child: MultiPainter(size: size, painters: [
          MeasureChartPainter(
              tabContext: tabContext,
              instrument: instrument,
              measure: measure,
              last: last,
              stringSpacing: stringSpacing),
          MeasureNotePainter(
              tabContext: tabContext,
              measure: measure,
              noteSpacing: NoteSpacing.fromPaintSize(size),
              stringSpacing: StringSpacing.fromPaintSize(instrument, size)),
        ]));
  }
}

class MeasureChartPainter extends CustomPainter {
  static const double barPad = 3;
  static const double fatBar = 5;
  static const double thinBar = 2;
  static const double repeatDot = 18;
  static const double repeatDotRadius = 3;
  final Instrument instrument;
  final bool last;
  final Measure measure;
  final StringSpacing stringSpacing;
  final TabContext tabContext;

  MeasureChartPainter(
      {required this.instrument,
      required this.last,
      required this.measure,
      required this.stringSpacing,
      required this.tabContext});

  @override
  void paint(Canvas canvas, Size size) {
    paintStrings(canvas, size);
    paintMeasureDecorations(canvas, size);
  }

  void paintStrings(Canvas canvas, Size size) {
    final path = Path();
    for (var i = 1; i < instrument.stringCount(); i++) {
      final y = stringSpacing.value * i;
      path.moveTo(0, y);
      path.lineTo(size.width, y);
    }
    path.addRect(Rect.fromPoints(Offset.zero, Offset(size.width, size.height)));
    canvas.drawPath(path, tabContext.chartPaint(PaintingStyle.stroke));
  }

  void paintMeasureDecorations(Canvas canvas, Size size) {
    final path = Path();
    if (measure.repeatStart || measure.repeatEnd || last) {
      addRepeatBarsToPath(path, size);
    }
    if (measure.repeatStart || measure.repeatEnd) {
      addRepeatCirclesToPath(path, size);
    }
    canvas.drawPath(path, tabContext.chartPaint(PaintingStyle.fill));
  }

  void addRepeatBarsToPath(Path path, Size size) {
    final fat = Rect.fromPoints(Offset.zero, Offset(fatBar, size.height));
    final thin = Rect.fromPoints(const Offset(fatBar + barPad, 0),
        Offset(fatBar + thinBar + barPad, size.height));
    if (measure.repeatStart) {
      path.addRect(fat);
      path.addRect(thin);
    }
    if (measure.repeatEnd || last) {
      path.addRect(fat.translate(size.width - fat.width, 0));
      path.addRect(
          thin.translate(size.width - (thin.left * 2) - thin.width, 0));
    }
  }

  void addRepeatCirclesToPath(Path path, Size size) {
    final top = Rect.fromCircle(
        center: Offset(repeatDot,
            stringSpacing.proportion(instrument.topRepeatCircleCenter())),
        radius: repeatDotRadius);
    final bottom = Rect.fromCircle(
        center: Offset(repeatDot,
            stringSpacing.proportion(instrument.bottomRepeatCircleCenter())),
        radius: repeatDotRadius);
    if (measure.repeatStart) {
      path.addOval(top);
      path.addOval(bottom);
    }
    if (measure.repeatEnd) {
      path.addOval(top.translate(size.width - (repeatDot * 2), 0));
      path.addOval(bottom.translate(size.width - (repeatDot * 2), 0));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

extension RepeatCircleCenterFns on Instrument {
  double topRepeatCircleCenter() => 1.5;

  double bottomRepeatCircleCenter() {
    switch (this) {
      case Instrument.banjo:
        return 2.5;
      case Instrument.guitar:
        return 3.5;
    }
  }
}

class MeasureNotePainter extends CustomPainter {
  final TabContext tabContext;
  final Measure measure;
  final Paint notationPaint;
  final NoteSpacing noteSpacing;
  final StringSpacing stringSpacing;

  MeasureNotePainter(
      {required this.tabContext,
      required this.measure,
      required this.noteSpacing,
      required this.stringSpacing})
      : notationPaint = tabContext.notationPaint(PaintingStyle.stroke);

  @override
  void paint(Canvas canvas, Size size) {
    for (final note in measure.notes) {
      final noteX = noteSpacing.position(note.timing);
      final noteY = stringSpacing.position(note.string);
      paintNote(canvas, size, note, noteX, noteY);

      if (note.slideTo != null) {
        paintSlideLine(canvas, size, note);
        paintNote(canvas, size, Note(note.string, note.slideTo!),
            noteX + noteSpacing.sustain(note), noteY);
      }

      if (note.hammerOn != null) {
        paintHammerLine(canvas, size, note);
        paintNote(canvas, size, Note(note.string, note.hammerOn!),
            noteX + noteSpacing.sustain(note), noteY);
      }

      if (note.pullOff != null) {
        paintPullLine(canvas, size, note);
        paintNote(canvas, size, Note(note.string, note.pullOff!),
            noteX + noteSpacing.sustain(note), noteY);
      }

      if (note.and != null) {
        for (var and = note.and; and != null;) {
          final noteY = stringSpacing.position(and.string);
          paintNote(canvas, size, and, noteX, noteY);
          and = and.and;
        }
      }
    }
  }

  void paintNote(
      Canvas canvas, Size size, Note note, double noteX, double noteY) {
    final textStyle = TextStyle(color: tabContext.notationColor, fontSize: 24);
    final textSpan = TextSpan(text: note.fret.toString(), style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter.layout(
      minWidth: 30,
      maxWidth: size.width,
    );
    final offset = Offset(noteX - 15, noteY - 14);
    textPainter.paint(canvas, offset);

    if (note.melody) {
      canvas.drawCircle(Offset(noteX, noteY), 16, notationPaint);
    }
  }

  void paintHammerLine(Canvas canvas, Size size, Note note) {
    final y = stringSpacing.sustainNotationPositionAbove(note.string);
    final noteX = noteSpacing.position(note.timing);
    final sustain = noteSpacing.sustain(note);
    final xTo = (sustain * .3) + noteX;
    final xFrom = (sustain * .7) + noteX;
    final xControl = ((xTo - xFrom) / 2) + xFrom;
    final yControl = y - stringSpacing.proportion(.3);
    final path = Path()
      ..moveTo(xFrom, y)
      ..quadraticBezierTo(xControl, yControl, xTo, y);
    canvas.drawPath(path, notationPaint);
  }

  void paintPullLine(Canvas canvas, Size size, Note note) {
    final y = stringSpacing.sustainNotationPositionBelow(note.string);
    final noteX = noteSpacing.position(note.timing);
    final sustain = noteSpacing.sustain(note);
    final xTo = (sustain * .3) + noteX;
    final xFrom = (sustain * .7) + noteX;
    final xControl = ((xTo - xFrom) / 2) + xFrom;
    final yControl = y + stringSpacing.proportion(.3);
    final path = Path()
      ..moveTo(xFrom, y)
      ..quadraticBezierTo(xControl, yControl, xTo, y);
    canvas.drawPath(path, notationPaint);
  }

  void paintSlideLine(Canvas canvas, Size size, Note note) {
    final y = stringSpacing.sustainNotationPositionAbove(note.string);
    final noteX = noteSpacing.position(note.timing);
    final sustain = noteSpacing.sustain(note);
    final path = Path()
      ..moveTo((sustain * .3) + noteX, y)
      ..lineTo((sustain * .7) + noteX, y);
    canvas.drawPath(path, notationPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
