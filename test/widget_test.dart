// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fish_app/Pages/add_fish_page.dart';
import 'package:fish_app/main.dart';
void main() {
  testWidgets('Add fish page', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: NewPage()));
    expect(find.text('Add Fish'), findsOneWidget);
    expect(find.text('Add Fish'), findsNothing);
  });

  testWidgets('MyApp', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    expect(find.text('0'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    expect(find.text('1'), findsOneWidget);
  });

 
}

