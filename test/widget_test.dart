import 'package:flutter_test/flutter_test.dart';
import 'package:picking/libtab/libtab.dart';
import 'package:picking/main.dart';
import 'package:picking/start.dart';

void main() {
  testWidgets('Renders start screen', (WidgetTester tester) async {
    await tester.pumpWidget(const PickingApp());
    expect(find.byType(SelectInstrumentPic), findsNWidgets(2));
  });
  test('NoteType.notesPerMeasure', () {
    expect(NoteType.sixteenth.notesPerMeasure(), equals(16));
  });
}
