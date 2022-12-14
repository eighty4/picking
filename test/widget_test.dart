import 'package:flutter_test/flutter_test.dart';
import 'package:picking/main.dart';
import 'package:picking/start.dart';

void main() {
  testWidgets('Renders start screen', (WidgetTester tester) async {
    await tester.pumpWidget(const PickingApp());
    expect(find.byType(SelectInstrumentPic), findsNWidgets(2));
  });
}
