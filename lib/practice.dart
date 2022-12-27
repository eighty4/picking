import 'package:flutter/material.dart';
import 'package:picking/libtab/libtab.dart';

class PracticeScreen extends StatelessWidget {
  final PracticeMeasure practice;
  final TabContext tabContext;

  const PracticeScreen(
      {Key? key, required this.practice, required this.tabContext})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 35),
          child: Text(practice.label,
              style:
                  const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
        ),
        MeasureDisplay(practice.measure,
            tabContext: tabContext, instrument: practice.instrument)
      ],
    );
  }
}

class PracticeMeasure {
  final Instrument instrument;
  final Measure measure;
  final String label;

  PracticeMeasure(this.instrument, this.label, this.measure);
}

class BanjoRolls {
  static final PracticeMeasure forward = PracticeMeasure(
      Instrument.banjo,
      "Forward Roll",
      Measure.fromNoteList([
        Note(2, 0),
        Note(1, 0),
        Note(5, 0),
        Note(2, 0),
        Note(1, 0),
        Note(5, 0),
        Note(2, 0),
        Note(1, 0),
      ]));

  static final PracticeMeasure backward = PracticeMeasure(
      Instrument.banjo,
      'Backward Roll',
      Measure.fromNoteList([
        Note(1, 0),
        Note(2, 0),
        Note(5, 0),
        Note(1, 0),
        Note(2, 0),
        Note(5, 0),
        Note(1, 0),
        Note(2, 0),
      ]));

  static final PracticeMeasure forwardBackward = PracticeMeasure(
      Instrument.banjo,
      'Forward Backward Roll',
      Measure.fromNoteList([
        Note(3, 0),
        Note(2, 0),
        Note(1, 0),
        Note(5, 0),
        Note(1, 0),
        Note(2, 0),
        Note(3, 0),
        Note(1, 0),
      ]));

  static final PracticeMeasure alternatingThumb = PracticeMeasure(
      Instrument.banjo,
      'Alternating Thumb Roll',
      Measure.fromNoteList([
        Note(3, 0),
        Note(2, 0),
        Note(5, 0),
        Note(1, 0),
        Note(4, 0),
        Note(2, 0),
        Note(5, 0),
        Note(1, 0),
      ]));

  static final PracticeMeasure hammerOn = PracticeMeasure(
      Instrument.banjo,
      'Hammer-on',
      Measure.fromNoteList([
        Note(3, 2, hammerOn: 3),
        null,
        Note(1, 0),
        Note(4, 0, hammerOn: 2, length: const Timing(NoteType.eighth, 2)),
        null,
        null,
        null,
        Note(1, 0),
      ]));

  static final PracticeMeasure pullOff = PracticeMeasure(
      Instrument.banjo,
      'Pull-off',
      Measure.fromNoteList([
        Note(3, 3, pullOff: 2),
        null,
        Note(1, 0),
        Note(4, 2, pullOff: 0, length: const Timing(NoteType.eighth, 2)),
        null,
        null,
        null,
        Note(1, 0),
      ]));

  static final PracticeMeasure slideTo = PracticeMeasure(
      Instrument.banjo,
      'Slide',
      Measure.fromNoteList([
        Note(3, 2, slideTo: 4),
        null,
        Note(2, 0),
        Note(1, 0),
        Note(4, 0, slideTo: 2, length: const Timing(NoteType.eighth, 2)),
        null,
        null,
        Note(1, 0),
      ]));
}
