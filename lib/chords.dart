import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:libtab/libtab.dart';

import 'instrument.dart';
import 'routing.dart';
import 'screen.dart';
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
    final instrument = InstrumentModel.of(context);
    final chords =
        (instrument == Instrument.banjo ? banjoChordNotes : guitarChordNotes)
            .keys
            .toList(growable: false);
    navToFocusedChord() {
      if (focused > -1) {
        context.playChord(chords[focused]);
      }
    }

    return PickingScreen(
        child: CallbackShortcuts(
      bindings: <LogicalKeySet, VoidCallback>{
        LogicalKeySet(LogicalKeyboardKey.enter): navToFocusedChord,
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
              return MouseRegion(
                cursor: SystemMouseCursors.click,
                onEnter: (event) => setFocusedIndex(i),
                child: GestureDetector(
                  onTap: navToFocusedChord,
                  child: Focus(
                    onFocusChange: (focused) => setFocusedIndex(i),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: focused == i
                                  ? Colors.red
                                  : Colors.transparent)),
                      child: ChordWithLabel(chord: chords[i]),
                    ),
                  ),
                ),
              );
            }),
      ),
    ));
  }

  setFocusedIndex(int index) {
    setState(() {
      focused = index;
    });
  }
}

class PlayChordRoute extends StatelessWidget {
  final Chord chord;

  const PlayChordRoute(this.chord, {super.key});

  @override
  Widget build(BuildContext context) {
    return PickingScreen(child: ChordWithLabel(chord: chord));
  }
}

class ChordWithLabel extends StatelessWidget {
  final Chord chord;

  const ChordWithLabel({super.key, required this.chord});

  @override
  Widget build(BuildContext context) {
    final tabContext = PickingTheme.of(context).tabContext();
    final instrument = InstrumentModel.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 11),
          child: ChordChartDisplay(
              size: const Size(80, 100),
              tabContext: tabContext,
              chord: ChordNoteSet(instrument, chord)),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 11),
          child: Text(chord.id()),
        ),
      ],
    );
  }
}
