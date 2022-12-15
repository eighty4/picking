import 'package:flutter/widgets.dart';
import 'package:picking/libtab/libtab.dart';

class MeasureDisplay extends StatelessWidget {
  final TabContext ctx;
  final Instrument instrument;
  final bool last;
  final Measure measure;

  const MeasureDisplay(this.measure,
      {Key? key,
      this.ctx = const TabContext(),
      required this.instrument,
      this.last = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: ctx.backgroundColor,
        child: CustomPaint(
            willChange: false,
            size: const Size(550, 200),
            painter: MeasurePainter(ctx, instrument, measure, last)));
  }
}

class MeasurePainter extends CustomPainter {
  static const double repeatBarWidth = 6;
  static const double repeatBarOffset = repeatBarWidth / 2;
  static const double repeatLineOffset = repeatBarWidth + repeatBarOffset;
  static const double repeatLineWidth = 1;
  static const double repeatCircleOffset = 13;
  final TabContext ctx;
  final Instrument instrument;
  final Measure measure;
  final bool last;
  final Paint linePaint;
  final Paint notationPaint;
  double eighthSpacing = 0;
  double stringSpacing = 0;

  MeasurePainter(this.ctx, this.instrument, this.measure, this.last)
      : linePaint = ctx.linePaint(),
        notationPaint = ctx.notationPaint();

  @override
  void paint(Canvas canvas, Size size) {
    stringSpacing = size.height / instrument.stringCount();
    eighthSpacing = size.width / 9;

    if (ctx.drawBorder) {
      canvas.drawRect(
          Rect.fromPoints(const Offset(0, 0), Offset(size.width, size.height)),
          linePaint);
    }
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
    canvas.drawPath(path, ctx.linePaint(width: width));
  }

  void paintRepeatDots(Canvas canvas, Size size, bool end) {
    var paint = ctx.linePaint(style: PaintingStyle.fill);
    var xOffset = end ? size.width - repeatCircleOffset : repeatCircleOffset;
    var yOffset = size.height / 6;
    canvas.drawCircle(Offset(xOffset, yOffset * 1.5), 2, paint);
    canvas.drawCircle(Offset(xOffset, yOffset * 4.5), 2, paint);
  }

  void paintNotes(Canvas canvas, Size size) {
    measure.notes.asMap().forEach((i, note) {
      if (note == null) {
        return;
      }
      final noteX = (i + 1) * eighthSpacing;
      final noteY = stringSpacing * note.string;
      paintNote(canvas, size, note, noteX, noteY);

      if (note.slideTo != null) {
        paintSlideLine(canvas, size, noteX, noteY);
        paintNote(canvas, size, Note(note.string, note.slideTo as int),
            noteX + eighthSpacing, noteY);
      }

      if (note.hammerOn != null) {
        paintHammerLine(canvas, size, noteX, noteY);
        paintNote(canvas, size, Note(note.string, note.hammerOn as int),
            noteX + eighthSpacing, noteY);
      }

      if (note.pullOff != null) {
        paintPullLine(canvas, size, noteX, noteY);
        paintNote(canvas, size, Note(note.string, note.pullOff as int),
            noteX + eighthSpacing, noteY);
      }

      if (note.and != null) {
        for (var and = note.and; and != null;) {
          paintNote(canvas, size, and, noteX, and.string * stringSpacing);
          and = and.and;
        }
      }
    });
  }

  void paintNote(
      Canvas canvas, Size size, Note note, double noteX, double noteY) {
    final textStyle = TextStyle(color: ctx.notationColor, fontSize: 24);
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

  void paintHammerLine(Canvas canvas, Size size, double noteX, double noteY) {
    final y = noteY - (stringSpacing * .3);
    final xTo = noteX + (eighthSpacing * .3);
    final xFrom = noteX + (eighthSpacing * .7);
    final xControl = ((xTo - xFrom) / 2) + xFrom;
    final yControl = y - (stringSpacing * .35);
    final path = Path();
    path.moveTo(xFrom, y);
    path.quadraticBezierTo(xControl, yControl, xTo, y);
    canvas.drawPath(path, notationPaint);
  }

  void paintPullLine(Canvas canvas, Size size, double noteX, double noteY) {
    final y = noteY + (stringSpacing * .3);
    final xTo = noteX + (eighthSpacing * .3);
    final xFrom = noteX + (eighthSpacing * .7);
    final xControl = ((xTo - xFrom) / 2) + xFrom;
    final yControl = y + (stringSpacing * .35);
    final path = Path();
    path.moveTo(xFrom, y);
    path.quadraticBezierTo(xControl, yControl, xTo, y);
    canvas.drawPath(path, notationPaint);
  }

  void paintSlideLine(Canvas canvas, Size size, double noteX, double noteY) {
    final y = noteY - (stringSpacing * .3);
    final xFrom = noteX + (eighthSpacing * .3);
    final xTo = noteX + (eighthSpacing * .7);
    final path = Path();
    path.moveTo(xFrom, y);
    path.lineTo(xTo, y);
    canvas.drawPath(path, notationPaint);
  }

  void paintStrings(Canvas canvas, Size size) {
    var path = Path();
    for (var i = 1; i < 6; i++) {
      var y = stringSpacing * i;
      path.moveTo(0, y);
      path.lineTo(size.width, y);
    }
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
