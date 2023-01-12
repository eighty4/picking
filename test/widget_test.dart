import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:picking/main.dart';

void main() {
  testWidgets('Renders the app', (WidgetTester tester) async {
    await tester.pumpWidget(const PickingApp());
    expect(find.byType(Scaffold), findsNWidgets(1));
  });
}
