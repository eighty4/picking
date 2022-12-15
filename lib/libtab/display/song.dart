import 'package:flutter/widgets.dart';
import 'package:picking/libtab/libtab.dart';

class Song {
  final Chord chord;

  Song(this.measures, {this.chord = Chord.g});

  List<Measure> measures;
}

class SongDisplay extends StatelessWidget {
  static const double padding = 5;
  final TabContext ctx;
  final Song song;

  const SongDisplay(this.ctx, this.song, {Key? key}) : super(key: key);

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
      return [
        MeasureDisplay(song.measures[0],
            ctx: ctx, instrument: Instrument.guitar, last: false)
      ];
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
      Expanded(
          child: MeasureDisplay(measure,
              ctx: ctx, instrument: Instrument.guitar, last: measure2 == null)),
      const SizedBox(width: padding),
      Expanded(
          child: measure2 == null
              ? const SizedBox()
              : MeasureDisplay(measure2,
                  ctx: ctx, instrument: Instrument.guitar, last: last)),
      const SizedBox(width: padding),
    ]));
  }
}
