import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:waterfilternet/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const WaterFilterNetApp());
    await tester.pumpAndSettle();

    // Verify the app starts
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
