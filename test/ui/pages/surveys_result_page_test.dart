import 'package:clean_flutter_manguinho/ui/helpers/helpers.dart';
import 'package:clean_flutter_manguinho/ui/pages/survey_result/components/components.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clean_flutter_manguinho/ui/pages/pages.dart';
import 'package:image_test_utils/image_test_utils.dart';
import 'package:mockito/mockito.dart';

class SurveyResultPresenterSpy extends Mock implements SurveyResultPresenter {}

void main() {
  SurveyResultPresenterSpy presenter;
  StreamController<bool> isLoadingController;
  StreamController<SurveyResultViewModel> surveyResultController;

  void initStreams() {
    isLoadingController = StreamController<bool>();
    surveyResultController = StreamController<SurveyResultViewModel>();
  }

  void mockStreams() {
    when(presenter.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
    when(presenter.surveyResultStream)
        .thenAnswer((realInvocation) => surveyResultController.stream);
  }

  void closeStreams() {
    isLoadingController.close();
    surveyResultController.close();
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SurveyResultPresenterSpy();
    initStreams();
    mockStreams();
    final surveysPage =
        GetMaterialApp(initialRoute: '/survey_result/any_survey_id', getPages: [
      GetPage(
          name: '/survey_result/:survey_id',
          page: () => SurveyResultPage(presenter))
    ]);
    await provideMockedNetworkImages(() async {
      await tester.pumpWidget(surveysPage);
    });
  }

  SurveyResultViewModel makeSurveyResult() =>
      SurveyResultViewModel(surveyId: 'any_id', question: 'Question', answers: [
        SurveyAnswerViewModel(
          image: 'Image 0',
          answer: 'Answer 0',
          isCurrentAnswer: true,
          percent: '60%',
        ),
        SurveyAnswerViewModel(
          answer: 'Answer 1',
          isCurrentAnswer: false,
          percent: '40%',
        )
      ]);

  tearDown(() {
    closeStreams();
  });
  testWidgets('Should call LoadSurveyResult on page load',
      (WidgetTester tester) async {
    await loadPage(tester);
    verify(presenter.loadData()).called(1);
  });

  testWidgets('Should handle loading correctly', (WidgetTester tester) async {
    await loadPage(tester);

    isLoadingController.add(true);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    isLoadingController.add(false);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);

    isLoadingController.add(true);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    isLoadingController.add(null);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Should present error if loadingSurveysStream fails',
      (WidgetTester tester) async {
    await loadPage(tester);

    surveyResultController.addError(UIError.unexpected.description);
    await tester.pump();

    expect(find.text("Algo errado aconteceu. Tente novamente em breve."),
        findsOneWidget);
    expect(find.text("Recarregar"), findsOneWidget);
    expect(find.text("Question 1"), findsNothing);
  });

  testWidgets('Should call LoadSurveys on reload button click',
      (WidgetTester tester) async {
    await loadPage(tester);

    surveyResultController.addError(UIError.unexpected.description);
    await tester.pump();
    await tester.tap(find.text('Recarregar'));

    verify(presenter.loadData()).called(2);
  });

  testWidgets('Should present list if loadingSurveyResultStream suceeds',
      (WidgetTester tester) async {
    await loadPage(tester);

    surveyResultController.add(makeSurveyResult());
    await provideMockedNetworkImages(() async {
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

    surveyResultController.addError(UIError.unexpected.description);
    await provideMockedNetworkImages(() async {
      await tester.pump();
    });

    expect(find.text("Algo errado aconteceu. Tente novamente em breve."),
        findsOneWidget);
    expect(find.text("Recarregar"), findsOneWidget);
    expect(find.text("Question 1"), findsNothing);
  });
}
