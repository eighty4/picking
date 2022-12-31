import 'package:flutter_test/flutter_test.dart';
import 'package:picking/libtab/libtab.dart';
import 'package:picking/main.dart';
import 'package:picking/screens.dart';

void main() {
  testWidgets('Renders start screen', (WidgetTester tester) async {
    await tester.pumpWidget(PickingApp());
    expect(find.byType(PickingAppScreen), findsNWidgets(1));
  });
  test('NoteType.notesPerMeasure', () {
    expect(NoteType.sixteenth.notesPerMeasure(), equals(16));
  });
}
