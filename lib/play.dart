import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:picking/libtab/libtab.dart';

import 'instrument.dart';
import 'routes.dart';

class PlayScreen extends StatelessWidget {
  final PlayMode play;

  const PlayScreen(this.play, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final instrument = InstrumentModel.of(context);
    if (kDebugMode) {
      print('$instrument $play ${ModalRoute.of(context)?.settings.name}');
    }
    switch (play) {
      case PlayMode.chords:
        switch (instrument) {
          case Instrument.banjo:
            return ChordChartDisplay(chord: BanjoChords.c);
          case Instrument.guitar:
            return ChordChartDisplay(chord: GuitarChords.am);
        }
      case PlayMode.tabs:
        return Padding(
          padding: const EdgeInsets.all(150),
          child: MeasureDisplay(
              Measure([
                Note(1, 12),
                null,
                Note(3, 11),
                Note(3, 11),
                Note(1, 12, and: Note(2, 10)),
                null,
                Note(1, 14, and: Note(2, 14))
              ]),
              instrument: instrument,
              last: true),
        );
    }
  }
}
