import 'package:clean_flutter_manguinho/ui/helpers/helpers.dart';
import 'package:clean_flutter_manguinho/ui/pages/survey_result/components/components.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:clean_flutter_manguinho/ui/pages/pages.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:mocktail/mocktail.dart';
import '../helpers/helpers.dart';
import '../mocks/mocks.dart';
import '../mocks/survey_result_presenter_spy.dart';

void main() {
  late SurveyResultPresenterSpy presenter;

  void closeStreams() {
    presenter.dispose();
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SurveyResultPresenterSpy();

    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(makePage(
          path: '/survey_result/any_survey_id',
          page: () => SurveyResultPage(presenter)));
    });
  }

  tearDown(() {
    closeStreams();
  });
  testWidgets('Should call LoadSurveyResult on page load',
      (WidgetTester tester) async {
    await loadPage(tester);
    verify(() => presenter.loadData()).called(1);
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

    presenter.emitSurveyResultError(UIError.unexpected.description);
    await tester.pump();

    expect(find.text("Algo errado aconteceu. Tente novamente em breve."),
        findsOneWidget);
    expect(find.text("Recarregar"), findsOneWidget);
    expect(find.text("Question 1"), findsNothing);
  });

  testWidgets('Should call LoadSurveys on reload button click',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitSurveyResultError(UIError.unexpected.description);
    await tester.pump();
    await tester.tap(find.text('Recarregar'));

    verify(() => presenter.loadData()).called(2);
  });

  testWidgets('Should present list if loadingSurveyResultStream suceeds',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitSurveyResult(ViewModelFactory.makeSurveyResult());
    await mockNetworkImagesFor(() async {
      await tester.pump();
    });

    expect(find.text("Algo errado aconteceu. Tente novamente em breve."),
        findsNothing);
    expect(find.text("Recarregar"), findsNothing);
    expect(find.text("Question"), findsWidgets);
    expect(find.text("Answer 0"), findsWidgets);
    expect(find.text("Answer 1"), findsWidgets);
    expect(find.text("60%"), findsWidgets);
    expect(find.text("40%"), findsWidgets);
    expect(find.byType(ActiveIcon), findsWidgets);
    expect(find.byType(DisabledIcon), findsWidgets);
    final image =
        tester.widget<Image>(find.byType(Image)).image as NetworkImage;
    expect(image.url, 'Image 0');
  });

  testWidgets('Should present error if loadingSurveysResultStream fails',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitSurveyResultError(UIError.unexpected.description);
    await mockNetworkImagesFor(() async {
      await tester.pump();
    });

    expect(find.text("Algo errado aconteceu. Tente novamente em breve."),
        findsOneWidget);
    expect(find.text("Recarregar"), findsOneWidget);
    expect(find.text("Question 1"), findsNothing);
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
    expect(currentRoute, '/survey_result/any_survey_id');
  });

  testWidgets('Should call save on list item click',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitSurveyResult(ViewModelFactory.makeSurveyResult());
    await mockNetworkImagesFor(() async {
      await tester.pump();
    });

    await tester.tap(find.text('Answer 1'));

    verify(() => presenter.save(answer: 'Answer 1')).called(1);
  });

  testWidgets('Should not call on current answer click',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitSurveyResult(ViewModelFactory.makeSurveyResult());
    await mockNetworkImagesFor(() async {
      await tester.pump();
    });

    await tester.tap(find.text('Answer 0'));

    verifyNever(() => presenter.save(answer: 'Answer 0'));
  });
}
