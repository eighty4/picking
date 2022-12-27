import 'instrument.dart';

enum Chord { a, am, c, d, d7, em, f, g }

enum Finger { t, m, i }

enum NoteType { whole, half, quarter, eighth, sixteenth }

extension NotesPerMeasureFn on NoteType {
  int notesPerMeasure() {
    switch (this) {
      case NoteType.whole:
        return 1;
      case NoteType.half:
        return 2;
      case NoteType.quarter:
        return 4;
      case NoteType.eighth:
        return 8;
      case NoteType.sixteenth:
        return 16;
    }
  }
}

class Timing {
  final NoteType type;
  final int beats;

  const Timing(this.type, this.beats);

  factory Timing.withinNoteList(
      {required int listLength, required int noteIndex}) {
    return Timing(notesPerMeasureToNoteType(listLength), noteIndex + 1);
  }

  static NoteType notesPerMeasureToNoteType(int bpm) {
    switch (bpm) {
      case 16:
        return NoteType.sixteenth;
      case 8:
        return NoteType.eighth;
      case 4:
        return NoteType.quarter;
      case 2:
        return NoteType.half;
      case 1:
        return NoteType.whole;
      default:
        throw ArgumentError('$bpm is not valid note count per measure');
    }
  }
}

class Note {
  /// 1-indexed string
  final int string;

  /// 1-indexed fret
  final int fret;

  /// whether melody note
  final bool melody;

  /// time to play note
  final Timing timing;

  /// length of note
  final Timing? length;

  /// chord composed by notes
  final Chord? chord;

  /// hammer on fret
  final int? hammerOn;

  /// pull off fret
  final int? pullOff;

  /// slide to fret
  final int? slideTo;

  /// which finger plays note
  final Finger? pick;

  /// additional notes played in tandem
  final Note? and;

  Note(this.string, this.fret,
      {this.melody = false,
      this.timing = const Timing(NoteType.eighth, -1),
      this.length,
      this.chord,
      this.hammerOn,
      this.pullOff,
      this.slideTo,
      this.pick,
      this.and}) {
    assert(hammerOn == null || fret < hammerOn!);
    assert(pullOff == null || fret > pullOff!);
    assert(slideTo == null || fret < slideTo!);
  }

  Note copyWithTiming(Timing timing) {
    assert(timing.beats > 0);
    return Note(
      string,
      fret,
      timing: timing,
      length: length,
      pick: pick,
      chord: chord,
      melody: melody,
      slideTo: slideTo,
      hammerOn: hammerOn,
      pullOff: pullOff,
      and: and,
    );
  }
}

class ChordNoteSet {
  final Instrument instrument;
  final Chord chord;
  final Note notes;

  ChordNoteSet.banjo(this.chord, this.notes) : instrument = Instrument.banjo;

  ChordNoteSet.guitar(this.chord, this.notes) : instrument = Instrument.guitar;

  ChordNoteSet(
      {required this.instrument, required this.chord, required this.notes});
}

class BanjoChords {
  static final ChordNoteSet c =
      ChordNoteSet.banjo(Chord.c, Note(2, 1, and: Note(4, 2, and: Note(1, 2))));
  static final ChordNoteSet d =
      ChordNoteSet.banjo(Chord.d, Note(3, 2, and: Note(2, 3, and: Note(1, 4))));
}

class GuitarChords {
  static final ChordNoteSet am = ChordNoteSet.guitar(
      Chord.am, Note(2, 1, and: Note(3, 2, and: Note(4, 2))));
  static final ChordNoteSet em =
      ChordNoteSet.guitar(Chord.am, Note(4, 2, and: Note(5, 2)));
}
