import 'package:flutter/material.dart';
import 'package:libtab/libtab.dart';
import 'package:picking/browse.dart';
import 'package:picking/controller.dart';
import 'package:picking/instrument.dart';
import 'package:picking/routing.dart';
import 'package:picking/theme.dart';

class BrowseChords extends StatelessWidget {
  const BrowseChords({super.key});

  @override
  Widget build(BuildContext context) {
    final instrument = InstrumentModel.of(context);
    final chordNotes = switch (instrument) {
      Instrument.banjo => banjoChordNotes,
      Instrument.guitar => guitarChordNotes,
    };
    final chords = chordNotes.keys.toList(growable: false);
    return BrowsingGrid<Chord>(
      crossAxisCount: 4,
      controller: PickingController.of(context),
      itemBuilder: <Chord>(chord) =>
          ChordWithLabel(chord: chord, instrument: instrument),
      items: chords,
      onItemSelected: (chord) => context.playChord(chord),
    );
  }
}

class PlayChord extends StatelessWidget {
  final Chord chord;

  const PlayChord(this.chord, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChordWithLabel(
        chord: chord, instrument: InstrumentModel.of(context));
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
