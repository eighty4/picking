import 'package:flutter/material.dart';
import 'package:libtab/libtab.dart';

import 'screen.dart';
import 'theme.dart';

class PlayGuitarStrums extends StatelessWidget {
  const PlayGuitarStrums({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Note?> notes = [
      null,
      null,
      Note(1, 2),
      Note(1, 3),
      Note(1, 6),
      Note(1, 3),
      Note(1, 2),
      Note(1, -1),
    ];
    return PickingScreen(
      child: Center(
        child: MeasureDisplay(
            Measure.fromNoteList(notes, repeatStart: true, repeatEnd: true),
            tabContext: PickingTheme.of(context).tabContext(),
            instrument: Instrument.guitar),
      ),
    );
  }
}
