enum Chord { a, c, d, d7, f, g }

enum Finger { t, m, i }

class Note {
  final int string;
  final int fret;
  final bool melody;
  final Chord? chord;
  final int? hammerOn;
  final int? pullOff;
  final int? slideTo;
  final Finger? pick;
  final Note? and;

  Note(this.string, this.fret,
      {this.melody = false,
      this.chord,
      this.hammerOn,
      this.pullOff,
      this.slideTo,
      this.pick,
      this.and});
}
