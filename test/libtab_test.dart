import 'package:flutter_test/flutter_test.dart';
import 'package:picking/libtab/libtab.dart';

void main() {
  test('NoteType.notesPerMeasure', () {
    expect(NoteType.sixteenth.notesPerMeasure(), equals(16));
  });
}
