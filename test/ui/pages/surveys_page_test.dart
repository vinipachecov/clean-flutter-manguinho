import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:clean_flutter_manguinho/ui/pages/pages.dart';
import 'package:mockito/mockito.dart';

class SurveysPresenterSpy extends Mock implements SurveysPresenter {}

void main() {
  SurveysPresenterSpy presenter;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SurveysPresenterSpy();
    final surveysPage = GetMaterialApp(initialRoute: '/surveys', getPages: [
      GetPage(name: '/surveys', page: () => SurveysPage(presenter))
    ]);

    await tester.pumpWidget(surveysPage);
  }

  testWidgets('Should call LoadSurveys on page load',
      (WidgetTester tester) async {
    loadPage(tester);
    verify(presenter.loadData()).called(1);
  });
}
