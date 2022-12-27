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
    return Container(
        color: tabContext.backgroundColor,
        child: CustomPaint(
            willChange: false,
            size: size,
            painter: MeasurePainter(tabContext, instrument, measure, last,
                noteSpacing: NoteSpacing.fromPaintSize(size),
                stringSpacing: StringSpacing.fromPaintSize(instrument, size))));
  }
}

class MeasurePainter extends CustomPainter {
  static const double repeatBarWidth = 6;
  static const double repeatBarOffset = repeatBarWidth / 2;
  static const double repeatLineOffset = repeatBarWidth + repeatBarOffset;
  static const double repeatLineWidth = 1;
  static const double repeatCircleOffset = 13;
  final TabContext tabContext;
  final Instrument instrument;
  final Measure measure;
  final bool last;
  final Paint linePaint;
  final Paint notationPaint;
  final NoteSpacing noteSpacing;
  final StringSpacing stringSpacing;

  MeasurePainter(this.tabContext, this.instrument, this.measure, this.last,
      {required this.noteSpacing, required this.stringSpacing})
      : linePaint = tabContext.linePaint(),
        notationPaint = tabContext.notationPaint();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
        Rect.fromPoints(const Offset(0, 0), Offset(size.width, size.height)),
        linePaint);
    paintStrings(canvas, size);
    paintNotes(canvas, size);

    if (measure.repeatStart) {
      paintRepeatLine(canvas, size, false, repeatBarOffset, repeatBarWidth);
      paintRepeatLine(canvas, size, false, repeatLineOffset, repeatLineWidth);
      paintRepeatDots(canvas, size, false);
    } else if (measure.repeatEnd) {
      paintRepeatLine(canvas, size, true, repeatBarOffset, repeatBarWidth);
      paintRepeatLine(canvas, size, true, repeatLineOffset, repeatLineWidth);
      paintRepeatDots(canvas, size, true);
    } else if (last) {
      paintRepeatLine(canvas, size, true, repeatBarOffset, repeatBarWidth);
      paintRepeatLine(canvas, size, true, repeatLineOffset, repeatLineWidth);
    }
  }

  void paintRepeatLine(
      Canvas canvas, Size size, bool end, double offset, double width) {
    var path = Path();
    double lineOffset = end ? size.width - offset : offset;
    path.moveTo(lineOffset, 0);
    path.lineTo(lineOffset, size.height);
    canvas.drawPath(path, tabContext.linePaint(width: width));
  }

  void paintRepeatDots(Canvas canvas, Size size, bool end) {
    var paint = tabContext.linePaint(style: PaintingStyle.fill);
    var xOffset = end ? size.width - repeatCircleOffset : repeatCircleOffset;
    var yOffset = size.height / instrument.stringCount();
    canvas.drawCircle(Offset(xOffset, yOffset * 1.5), 2, paint);
    canvas.drawCircle(Offset(xOffset, yOffset * 4.5), 2, paint);
  }

  void paintNotes(Canvas canvas, Size size) {
    for (var note in measure.notes) {
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

  void paintStrings(Canvas canvas, Size size) {
    var path = Path();
    for (var i = 1; i < instrument.stringCount(); i++) {
      var y = stringSpacing.value * i;
      path.moveTo(0, y);
      path.lineTo(size.width, y);
    }
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
