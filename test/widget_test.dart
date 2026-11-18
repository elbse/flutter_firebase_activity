import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('forgot password text is visible', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Text('Forgot your password?'),
        ),
      ),
    );

    expect(find.text('Forgot your password?'), findsOneWidget);
  });
}