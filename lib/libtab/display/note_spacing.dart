import 'package:flutter/widgets.dart';
import 'package:picking/libtab/libtab.dart';

class NoteSpacing {
  final double sixteenthSpacing;
  final double eighthSpacing;
  final double quarterSpacing;
  final double halfSpacing;

  const NoteSpacing(
      {required this.sixteenthSpacing,
      required this.eighthSpacing,
      required this.quarterSpacing,
      required this.halfSpacing});

  factory NoteSpacing.fromPaintSize(Size size) {
    final eighthSpacing = size.width / 9;
    final quarterSpacing = eighthSpacing * 2;
    return NoteSpacing(
      sixteenthSpacing: eighthSpacing / 2,
      eighthSpacing: eighthSpacing,
      quarterSpacing: quarterSpacing,
      halfSpacing: quarterSpacing * 2,
    );
  }

  double position(Timing timing) {
    return timing.beats * spacingFromTiming(timing);
  }

  double sustain(Note note) {
    return note.length != null
        ? note.length!.beats * spacingFromTiming(note.length!)
        : spacingFromNoteType(note.timing.type);
  }

  double spacingFromTiming(Timing timing) => spacingFromNoteType(timing.type);

  double spacingFromNoteType(NoteType noteType) {
    switch (noteType) {
      case NoteType.whole:
        return 1;
      case NoteType.half:
        return halfSpacing;
      case NoteType.quarter:
        return quarterSpacing;
      case NoteType.eighth:
        return eighthSpacing;
      case NoteType.sixteenth:
        return sixteenthSpacing;
    }
  }

  @override
  String toString() {
    return 'NoteSpacing{'
        'sixteenthSpacing: $sixteenthSpacing, '
        'eighthSpacing: $eighthSpacing, '
        'quarterSpacing: $quarterSpacing, '
        'halfSpacing: $halfSpacing}';
  }
}
