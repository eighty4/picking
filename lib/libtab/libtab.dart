library libtab;

import 'package:flutter/widgets.dart';

enum Chord { a, c, d, d7, f, g }

enum Finger { t, m, i }

class Note {
  final int string;
  final int fret;
  final bool melody;
  final Chord? chord;
  final int? hammerOn;
  final int? pullOff;
  final int? slideTo;
  final Finger? pick;
  final Note? and;

  Note(this.string, this.fret,
      {this.melody = false,
      this.chord,
      this.hammerOn,
      this.pullOff,
      this.slideTo,
      this.pick,
      this.and});
}

class Measure {
  final Chord? chord;
  final List<Note?> notes;
  final bool repeatStart;
  final bool repeatEnd;

  Measure(this.notes,
      {this.repeatStart = false, this.repeatEnd = false, this.chord});
}

class Song {
  final Chord chord;

  Song(this.measures, {this.chord = Chord.g});

  List<Measure> measures;
}

const colorBlack = Color.fromARGB(255, 0, 0, 0);
const colorGrey = Color.fromARGB(255, 96, 125, 139);
const colorWhite = Color.fromARGB(255, 255, 255, 255);

class SongDisplay extends StatelessWidget {
  static const double padding = 5;
  final Song song;

  const SongDisplay(this.song, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      textDirection: TextDirection.ltr,
      children: buildRows(),
    );
  }

  List<Widget> buildRows() {
    if (song.measures.length == 1) {
      return [MeasureDisplay(song.measures[0], false)];
    }

    List<Widget> rows = [];
    rows.add(const SizedBox(height: padding));
    for (var i = 0; i < song.measures.length; i = i + 2) {
      if (i + 1 >= song.measures.length) {
        rows.add(buildRow(song.measures[i], null));
      } else {
        rows.add(buildRow(song.measures[i], song.measures[i + 1],
            last: i + 2 == song.measures.length));
      }
      rows.add(const SizedBox(height: padding));
    }
    return rows;
  }

  Widget buildRow(Measure measure, Measure? measure2, {last = false}) {
    return Expanded(
        child: Row(textDirection: TextDirection.ltr, children: [
      const SizedBox(width: padding),
      Expanded(child: MeasureDisplay(measure, measure2 == null)),
      const SizedBox(width: padding),
      Expanded(
          child: measure2 == null
              ? const SizedBox()
              : MeasureDisplay(measure2, last)),
      const SizedBox(width: padding),
    ]));
  }
}

class MeasureDisplay extends Container {
  MeasureDisplay(Measure measure, bool last, {Key? key})
      : super(
            key: key,
            color: colorWhite,
            height: 200,
            width: 550,
            child: CustomPaint(painter: MeasurePainter(measure, last)));
}

class MeasurePainter extends CustomPainter {
  static const double repeatBarWidth = 6;
  static const double repeatBarOffset = repeatBarWidth / 2;
  static const double repeatLineOffset = repeatBarWidth + repeatBarOffset;
  static const double repeatLineWidth = 1;
  static const double repeatCircleOffset = 13;
  final Measure measure;
  final bool last;
  double xSpacing = 0;
  double ySpacing = 0;

  MeasurePainter(this.measure, this.last);

  @override
  void paint(Canvas canvas, Size size) {
    ySpacing = size.height / 6;
    xSpacing = size.width / 9;
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
    var paint = Paint();
    paint.color = colorGrey;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = width;
    var path = Path();
    double lineOffset = end ? size.width - offset : offset;
    path.moveTo(lineOffset, 0);
    path.lineTo(lineOffset, size.height);
    canvas.drawPath(path, paint);
  }

  void paintRepeatDots(Canvas canvas, Size size, bool end) {
    var paint = Paint()..color = colorGrey;
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
      final noteX = (i + 1) * xSpacing;
      final noteY = ySpacing * note.string;
      paintNote(canvas, size, note, noteX, noteY);

      if (note.slideTo != null) {
        paintSlideLine(canvas, size, noteX, noteY);
        paintNote(canvas, size, Note(note.string, note.slideTo as int),
            noteX + xSpacing, noteY);
      }

      if (note.hammerOn != null) {
        paintHammerLine(canvas, size, noteX, noteY);
        paintNote(canvas, size, Note(note.string, note.hammerOn as int),
            noteX + xSpacing, noteY);
      }

      if (note.pullOff != null) {
        paintPullLine(canvas, size, noteX, noteY);
        paintNote(canvas, size, Note(note.string, note.pullOff as int),
            noteX + xSpacing, noteY);
      }

      if (note.and != null) {
        for (var i = 1, and = note.and; and != null; i++) {
          paintNote(canvas, size, and, noteX, and.string * ySpacing);
          and = and.and;
        }
      }
    });
  }

  void paintNote(
      Canvas canvas, Size size, Note note, double noteX, double noteY) {
    const textStyle = TextStyle(color: colorBlack, fontSize: 24);
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
      final paint = Paint();
      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = 2;
      paint.color = colorBlack;
      canvas.drawCircle(Offset(noteX, noteY), 16, paint);
    }
  }

  void paintHammerLine(Canvas canvas, Size size, double noteX, double noteY) {
    final y = noteY - (ySpacing * .3);
    final xTo = noteX + (xSpacing * .3);
    final xFrom = noteX + (xSpacing * .7);
    final xControl = ((xTo - xFrom) / 2) + xFrom;
    final yControl = y - (ySpacing * .35);
    final paint = Paint();
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2;
    paint.color = colorBlack;
    final path = Path();
    path.moveTo(xFrom, y);
    path.quadraticBezierTo(xControl, yControl, xTo, y);
    canvas.drawPath(path, paint);
  }

  void paintPullLine(Canvas canvas, Size size, double noteX, double noteY) {
    final y = noteY + (ySpacing * .3);
    final xTo = noteX + (xSpacing * .3);
    final xFrom = noteX + (xSpacing * .7);
    final xControl = ((xTo - xFrom) / 2) + xFrom;
    final yControl = y + (ySpacing * .35);
    final paint = Paint();
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2;
    paint.color = colorBlack;
    final path = Path();
    path.moveTo(xFrom, y);
    path.quadraticBezierTo(xControl, yControl, xTo, y);
    canvas.drawPath(path, paint);
  }

  void paintSlideLine(Canvas canvas, Size size, double noteX, double noteY) {
    final y = noteY - (ySpacing * .3);
    final xFrom = noteX + (xSpacing * .3);
    final xTo = noteX + (xSpacing * .7);
    final paint = Paint();
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2;
    paint.color = colorBlack;
    final path = Path();
    path.moveTo(xFrom, y);
    path.lineTo(xTo, y);
    canvas.drawPath(path, paint);
  }

  void paintStrings(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = colorGrey;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 1;

    var path = Path();
    for (var i = 1; i < 6; i++) {
      var y = ySpacing * i;
      path.moveTo(0, y);
      path.lineTo(size.width, y);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
