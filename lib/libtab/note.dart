import 'instrument.dart';

enum Chord { a, am, c, d, d7, em, f, g }

enum Finger { t, m, i }

enum NoteType { whole, half, quarter, eighth, sixteenth }

class Timing {
  final NoteType type;
  final int beats;

  Timing(this.type, this.beats);
}

// todo refactor hammers, pulls and slides type to Timing
class Note {
  /// 1-indexed string
  final int string;

  /// 1-indexed fret
  final int fret;

  /// whether melody note
  final bool melody;

  /// time to play note
  final Timing? when;

  /// time to hold note
  final Timing? length;

  /// chord composed by notes
  final Chord? chord;

  /// hammer on
  final int? hammerOn;

  /// pull off
  final int? pullOff;

  /// slide to
  final int? slideTo;

  /// which finger plays note
  final Finger? pick;

  /// additional notes played in tandem
  final Note? and;

  Note(this.string, this.fret,
      {this.melody = false,
      this.when,
      this.length,
      this.chord,
      this.hammerOn,
      this.pullOff,
      this.slideTo,
      this.pick,
      this.and});
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
