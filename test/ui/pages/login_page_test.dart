
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:clean_flutter_manguinho/ui/pages/pages.dart';

void main() {
  testWidgets('Should load with correct initial state', (WidgetTester tester) async {
    final loginPage = MaterialApp(home: LoginPage());
    await tester.pumpWidget(loginPage);

    final emailTestChildren = find.descendant(of: find.bySemanticsLabel('Email'), matching: find.byType(Text));
    expect(
      emailTestChildren,
      findsOneWidget,
      reason: 'when a textFormField has only one text child, means it has no errors, since one of the children is always the label'
    );

    final passwordTestChildren = find.descendant(of: find.bySemanticsLabel('Senha'), matching: find.byType(Text));
    expect(
      passwordTestChildren,
      findsOneWidget,
      reason: 'when a textFormField has only one text child, means it has no errors, since one of the children is always the label'
    );

    final button = tester.widget<RaisedButton>(find.byType(RaisedButton));
    expect(
      button.onPressed,
      null
    );
  });
}