import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:libtab/libtab.dart';

import 'instrument.dart';
import 'routing.dart';
import 'theme.dart';

class ChordsMenuRoute extends StatefulWidget {
  const ChordsMenuRoute({super.key});

  @override
  State<ChordsMenuRoute> createState() => _ChordsMenuRouteState();
}

class _ChordsMenuRouteState extends State<ChordsMenuRoute> {
  int focused = -1;

  @override
  Widget build(BuildContext context) {
    final tabContext = PickingTheme.of(context).tabContext();
    final instrument = InstrumentModel.of(context);
    final chords =
        (instrument == Instrument.banjo ? banjoChordNotes : guitarChordNotes)
            .keys
            .toList(growable: false);
    return CallbackShortcuts(
      bindings: <LogicalKeySet, VoidCallback>{
        LogicalKeySet(LogicalKeyboardKey.enter): () {
          context.playChord(chords[focused]);
        },
      },
      child: FocusScope(
        autofocus: true,
        child: GridView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(50),
            itemCount: chords.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
            ),
            itemBuilder: (context, i) {
              return Focus(
                onFocusChange: (focused) {
                  if (focused) {
                    setState(() {
                      this.focused = i;
                    });
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color:
                              focused == i ? Colors.red : Colors.transparent)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ChordChartDisplay(
                          size: const Size(80, 100),
                          tabContext: tabContext,
                          chord: ChordNoteSet(instrument, chords[i])),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(chords[i].id()),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}

class PlayChordRoute extends StatelessWidget {
  final Chord chord;

  const PlayChordRoute(this.chord, {super.key});

  @override
  Widget build(BuildContext context) {
    final tabContext = PickingTheme.of(context).tabContext();
    final instrument = InstrumentModel.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ChordChartDisplay(
            size: const Size(80, 100),
            tabContext: tabContext,
            chord: ChordNoteSet(instrument, chord)),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(chord.id()),
        ),
      ],
    );
  }
}
