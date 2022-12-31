import 'package:flutter/material.dart';
import 'package:picking/libtab/libtab.dart';

class BanjoRolls {
  static final Map<String, Measure> byLabel = {
    'Forward Roll': forward,
    'Backward Roll': backward,
    'Forward Backward Roll': forwardBackward,
    'Alternating Thumb Roll': alternatingThumb,
  };

  static List<WidgetBuilder> widgetBuilders(TabContext tabContext) =>
      byLabel.entries
          .map((element) => (context) => MeasureDisplay(element.value,
              tabContext: tabContext,
              instrument: Instrument.banjo,
              label: element.key))
          .toList();

  static final Measure forward = Measure.fromNoteList([
    Note(2, 0),
    Note(1, 0),
    Note(5, 0),
    Note(2, 0),
    Note(1, 0),
    Note(5, 0),
    Note(2, 0),
    Note(1, 0),
  ]);

  static final Measure backward = Measure.fromNoteList([
    Note(1, 0),
    Note(2, 0),
    Note(5, 0),
    Note(1, 0),
    Note(2, 0),
    Note(5, 0),
    Note(1, 0),
    Note(2, 0)
  ]);

  static final Measure forwardBackward = Measure.fromNoteList([
    Note(3, 0),
    Note(2, 0),
    Note(1, 0),
    Note(5, 0),
    Note(1, 0),
    Note(2, 0),
    Note(3, 0),
    Note(1, 0),
  ]);

  static final Measure alternatingThumb = Measure.fromNoteList([
    Note(3, 0),
    Note(2, 0),
    Note(5, 0),
    Note(1, 0),
    Note(4, 0),
    Note(2, 0),
    Note(5, 0),
    Note(1, 0),
  ]);
}

class BanjoTechniques {
  static final Map<String, Measure> byLabel = {
    'Hammer-on': hammerOn,
    'Pull-off': pullOff,
    'Slide': slideTo,
  };

  static final Measure hammerOn = Measure.fromNoteList([
    Note(3, 2, hammerOn: 3),
    null,
    Note(1, 0),
    Note(4, 0, hammerOn: 2, length: const Timing(NoteType.eighth, 2)),
    null,
    null,
    null,
    Note(1, 0),
  ]);

  static final Measure pullOff = Measure.fromNoteList([
    Note(3, 3, pullOff: 2),
    null,
    Note(1, 0),
    Note(4, 2, pullOff: 0, length: const Timing(NoteType.eighth, 2)),
    null,
    null,
    null,
    Note(1, 0),
  ]);

  static final Measure slideTo = Measure.fromNoteList([
    Note(3, 2, slideTo: 4),
    null,
    Note(2, 0),
    Note(1, 0),
    Note(4, 0, slideTo: 2, length: const Timing(NoteType.eighth, 2)),
    null,
    null,
    Note(1, 0),
  ]);
}
