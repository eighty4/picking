import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:libtab/libtab.dart';
import 'package:picking/routing.dart';

import 'instrument.dart';
import 'screen.dart';
import 'theme.dart';

class ChordsMenuRoute extends StatelessWidget {
  const ChordsMenuRoute({super.key});

  @override
  Widget build(BuildContext context) {
    final instrument = InstrumentModel.of(context);
    return ChordsMenuGrid(
        chords: switch (instrument) {
          Instrument.banjo => banjoChordNotes,
          Instrument.guitar => guitarChordNotes,
        }
            .keys
            .toList(growable: false),
        instrument: instrument);
  }
}

class ChordsMenuGrid extends StatefulWidget {
  final List<Chord> chords;
  final Instrument instrument;

  const ChordsMenuGrid(
      {super.key, required this.chords, required this.instrument});

  @override
  State<ChordsMenuGrid> createState() => _ChordsMenuGridState();
}

class _ChordsMenuGridState extends State<ChordsMenuGrid> {
  late final List<FocusNode> focusNodes;
  int focusedIndex = -1;

  @override
  void initState() {
    super.initState();
    focusNodes = List.generate(widget.chords.length, (i) => FocusNode());
  }

  @override
  void dispose() {
    for (final focusNode in focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            itemCount: widget.chords.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
            ),
            itemBuilder: (context, i) {
              return MouseRegion(
                cursor: SystemMouseCursors.click,
                onEnter: (event) => setFocusOnHover(i),
                child: GestureDetector(
                  onTap: navToFocusedChord,
                  child: Focus(
                    focusNode: focusNodes[i],
                    onFocusChange: (focused) => onFocusChange(i, focused),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: focusNodes[i].hasFocus
                                  ? Colors.red
                                  : Colors.transparent)),
                      child: ChordWithLabel(
                          chord: widget.chords[i],
                          instrument: widget.instrument),
                    ),
                  ),
                ),
              );
            }),
      ),
    ));
  }

  onFocusChange(int i, bool focused) {
    setState(() {
      focusedIndex = focused ? i : -1;
    });
  }

  setFocusOnHover(int i) {
    focusNodes[i].requestFocus();
  }

  navToFocusedChord() {
    for (int i = 0; i < focusNodes.length; i++) {
      if (focusNodes[i].hasFocus) {
        context.playChord(widget.chords[i]);
      }
    }
  }
}

class PlayChordRoute extends StatelessWidget {
  final Chord chord;

  const PlayChordRoute(this.chord, {super.key});

  @override
  Widget build(BuildContext context) {
    return PickingScreen(
        child: ChordWithLabel(
            chord: chord, instrument: InstrumentModel.of(context)));
  }
}

class ChordWithLabel extends StatelessWidget {
  final Chord chord;
  final Instrument instrument;

  const ChordWithLabel(
      {super.key, required this.chord, required this.instrument});

  @override
  Widget build(BuildContext context) {
    final tabContext = PickingTheme.of(context).tabContext();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ChordChartDisplay(
            size: const Size(80, 100),
            tabContext: tabContext,
            chord: ChordNoteSet(instrument, chord)),
        const SizedBox(height: 10),
        Text(chord.id()),
      ],
    );
  }
}
