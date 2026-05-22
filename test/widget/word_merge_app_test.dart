import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:word_merge/main.dart';

void main() {
  testWidgets('MyApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.text('Flutter Demo Home Page'), findsOneWidget);
  });
}
