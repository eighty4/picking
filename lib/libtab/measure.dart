import 'note.dart';

class Measure {
  final Chord? chord;
  final List<Note?> notes;
  final bool repeatStart;
  final bool repeatEnd;

  Measure(this.notes,
      {this.repeatStart = false, this.repeatEnd = false, this.chord});
}
