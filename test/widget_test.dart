import 'package:flutter_test/flutter_test.dart';
import 'package:picking/main.dart';
import 'package:picking/routes/launch_route.dart';

void main() {
  testWidgets('Renders the app', (WidgetTester tester) async {
    await tester.pumpWidget(const PickingApp());
    expect(find.byType(LaunchRoute), findsNWidgets(1));
  });
}
