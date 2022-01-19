import 'dart:async';
import 'package:clean_flutter_manguinho/ui/pages/pages.dart';
import 'package:mocktail/mocktail.dart';

class SplashPresenterSpy extends Mock implements SplashPresenter {
  final navigateToController = StreamController<String?>();

  SplashPresenterSpy() {
    when(() => this.checkAccount()).thenAnswer((_) async => null);
    when(() => this.navigateToStream)
        .thenAnswer((_) => navigateToController.stream);
  }

  void emitNavigateTo(String? route) {
    navigateToController.add(route);
  }

  void dispose() {
    navigateToController.close();
  }
}
