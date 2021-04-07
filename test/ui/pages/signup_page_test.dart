
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:clean_flutter_manguinho/ui/pages/pages.dart';

class LoginPresenterSpy extends Mock implements LoginPresenter {}

void main() {
  Future<void> loadPage(WidgetTester tester) async {

    final signupPage = GetMaterialApp(
      initialRoute: '/signup',
      getPages: [
        GetPage(name: '/signup', page: () => SignUpPage()),
      ],
    );
    await tester.pumpWidget(signupPage);
  }

  testWidgets('Should load with correct initial state', (WidgetTester tester) async {
    await loadPage(tester);

    final nameTestChildren = find.descendant(of: find.bySemanticsLabel('Nome'), matching: find.byType(Text));
    expect(
      nameTestChildren,
      findsOneWidget,
      reason: 'when a textFormField has only one text child, means it has no errors, since one of the children is always the label'
    );

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

    final passwordConfirmationTestChildren = find.descendant(of: find.bySemanticsLabel('Confirmar Senha'), matching: find.byType(Text));
    expect(
      passwordConfirmationTestChildren,
      findsOneWidget,
      reason: 'when a textFormField has only one text child, means it has no errors, since one of the children is always the label'
    );

    final button = tester.widget<RaisedButton>(find.byType(RaisedButton));
    expect(
      button.onPressed,
      null
    );
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}