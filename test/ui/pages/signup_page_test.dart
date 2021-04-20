
import 'dart:async';


import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

import 'package:clean_flutter_manguinho/ui/helpers/helpers.dart';
import 'package:clean_flutter_manguinho/ui/pages/pages.dart';

class SignUpPresenterSpy extends Mock implements SignUpPresenter {}

void main() {
  SignUpPresenter presenter;
  StreamController<UIError> emailErrorController;
  StreamController<UIError> passwordErrorController;
  StreamController<UIError> passwordConfirmationErrorController;
  StreamController<UIError> nameErrorController;

  void initStreams() {
    emailErrorController = StreamController<UIError>();
    passwordErrorController = StreamController<UIError>();
    passwordConfirmationErrorController =  StreamController<UIError>();
    nameErrorController =  StreamController<UIError>();
  }

  void mockStreams() {
    when(presenter.emailErrorStream).thenAnswer((_) => nameErrorController.stream);
    when(presenter.emailErrorStream).thenAnswer((_) => emailErrorController.stream);
    when(presenter.passwordErrorStream).thenAnswer((_) => passwordErrorController.stream);
    when(presenter.passwordErrorStream).thenAnswer((_) => passwordConfirmationErrorController.stream);
  }

  void closeStreams() {
    emailErrorController.close();
    passwordErrorController.close();
    nameErrorController.close();
    passwordConfirmationErrorController.close();
  }

  tearDown(() {
    closeStreams();
  });

  Future<void> loadPage(WidgetTester tester) async {
      presenter = SignUpPresenterSpy();
      initStreams();
      mockStreams();

    final signupPage = GetMaterialApp(
      initialRoute: '/signup',
      getPages: [
        GetPage(name: '/signup', page: () => SignUpPage(presenter: presenter)),
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

   testWidgets('Should call validate with correct values', (WidgetTester tester) async {
    await loadPage(tester);

    final name = faker.person.name();
    await tester.enterText(find.bySemanticsLabel('Nome'), name);
    verify(presenter.validateName(name));

    final email = faker.internet.email();
    await tester.enterText(find.bySemanticsLabel('Email'), email);
    verify(presenter.validateEmail(email));

    final password = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel('Senha'), password);
    verify(presenter.validatePassword(password));

    await tester.enterText(find.bySemanticsLabel('Confirmar Senha'), password);

    verify(presenter.validatePasswordConfirmation(password));
  });
}