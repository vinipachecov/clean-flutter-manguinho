import 'dart:async';

import 'package:clean_flutter_manguinho/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:clean_flutter_manguinho/ui/pages/pages.dart';
import 'package:mocktail/mocktail.dart';
import '../helpers/helpers.dart';
import '../mocks/mocks.dart';

void main() {
  late SurveysPresenterSpy presenter;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SurveysPresenterSpy();

    await tester.pumpWidget(
        makePage(path: '/surveys', page: () => SurveysPage(presenter)));
  }

  tearDown(() {
    presenter.dispose();
  });

  testWidgets('Should call LoadSurveys on page load',
      (WidgetTester tester) async {
    await loadPage(tester);
    verify(() => presenter.loadData()).called(1);
  });

  testWidgets('Should call LoadSurveys on reload', (WidgetTester tester) async {
    await loadPage(tester);
    presenter.emitNavigateTo('/any_route');
    await tester.pumpAndSettle();
    await tester.pageBack();

    verify(() => presenter.loadData()).called(2);
  });

  testWidgets('Should handle loading correctly', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitIsLoading();
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    presenter.emitIsLoading(false);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);

    presenter.emitIsLoading();
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Should present error if loadingSurveysStream fails',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitSurveysError(UIError.unexpected.description);
    await tester.pump();

    expect(find.text("Algo errado aconteceu. Tente novamente em breve."),
        findsOneWidget);
    expect(find.text("Recarregar"), findsOneWidget);
    expect(find.text("Question 1"), findsNothing);
  });

  testWidgets('Should present list if loadingSurveysStream suceeds',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitSurveys(ViewModelFactory.makeSurveyList());
    await tester.pump();

    expect(find.text("Algo errado aconteceu. Tente novamente em breve."),
        findsNothing);
    expect(find.text("Recarregar"), findsNothing);
    expect(find.text("Question 1"), findsWidgets);
    expect(find.text("Question 2"), findsWidgets);
    expect(find.text("Date 1"), findsWidgets);
    expect(find.text("Date 2"), findsWidgets);
  });

  testWidgets('Should call LoadSurveys on reload button click',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitSurveysError(UIError.unexpected.description);
    await tester.pump();
    await tester.tap(find.text('Recarregar'));

    verify(() => presenter.loadData()).called(2);
  });

  testWidgets('Should call goToSurveyResult on survey click',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitSurveys(ViewModelFactory.makeSurveyList());
    await tester.pump();

    await tester.tap(find.text("Question 1"));
    await tester.pump();

    verify(() => presenter.goToSurveyResult('1')).called(1);
  });

  testWidgets('Should change page', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitNavigateTo('/any_route');
    /** use pumpAndSettle to wait for animations and stuff to happen */
    await tester.pumpAndSettle();
    expect(currentRoute, '/any_route');
    expect(find.text('fake page'), findsOneWidget);
  });

  testWidgets('Should logout', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitSessionExpired();
    await tester.pump();

    await tester.pumpAndSettle();

    expect(currentRoute, '/login');
    expect(find.text('login'), findsOneWidget);
  });

  testWidgets('Should not logout', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitSessionExpired(false);
    /** use pumpAndSettle to wait for animations and stuff to happen */
    await tester.pumpAndSettle();
    expect(currentRoute, '/surveys');
  });
}
