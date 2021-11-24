import 'dart:async';
import 'package:clean_flutter_manguinho/ui/helpers/helpers.dart';
import 'package:clean_flutter_manguinho/ui/pages/pages.dart';
import 'package:mocktail/mocktail.dart';

class SignUpPresenterSpy extends Mock implements SignUpPresenter {
  final emailErrorController = StreamController<UIError?>();
  final passwordErrorController = StreamController<UIError?>();
  final passwordConfirmationErrorController = StreamController<UIError?>();
  final nameErrorController = StreamController<UIError?>();
  final mainErrorController = StreamController<UIError?>();
  final isFormValidController = StreamController<bool>();
  final isLoadingController = StreamController<bool>();
  final navigateToController = StreamController<String?>();

  SignUpPresenterSpy() {
    when(() => this.signUp()).thenAnswer((_) async => null);
    when(() => this.nameErrorStream)
        .thenAnswer((_) => nameErrorController.stream);
    when(() => this.emailErrorStream)
        .thenAnswer((_) => emailErrorController.stream);
    when(() => this.passwordErrorStream)
        .thenAnswer((_) => passwordErrorController.stream);
    when(() => this.passwordConfirmationErrorStream)
        .thenAnswer((_) => passwordConfirmationErrorController.stream);
    when(() => this.isFormValidStream)
        .thenAnswer((_) => isFormValidController.stream);
    when(() => this.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
    when(() => this.mainErrorStream)
        .thenAnswer((_) => mainErrorController.stream);
    when(() => this.navigateToStream)
        .thenAnswer((_) => navigateToController.stream);
  }

  void emitEmailError(UIError error) {
    emailErrorController.add(error);
  }

  void emitEmailValid() {
    emailErrorController.add(null);
  }

  void emitNameError(UIError error) {
    nameErrorController.add(error);
  }

  void emitNameValid() {
    nameErrorController.add(null);
  }

  void emitPasswordError(UIError error) {
    passwordErrorController.add(error);
  }

  void emitPasswordConfirmationError(UIError error) {
    passwordConfirmationErrorController.add(error);
  }

  void emitPasswordConfirmationValid() {
    passwordConfirmationErrorController.add(null);
  }

  void emitMainError(UIError? error) {
    mainErrorController.add(error);
  }

  void emitNavigateTo(String? route) {
    navigateToController.add(route);
  }

  void emitPasswordValid() {
    passwordErrorController.add(null);
  }

  void emitFormError() {
    isFormValidController.add(false);
  }

  void emitFormValid() {
    isFormValidController.add(true);
  }

  void emitIsLoading([bool show = true]) {
    this.isLoadingController.add(show);
  }

  void dispose() {
    emailErrorController.close();
    passwordErrorController.close();
    nameErrorController.close();
    passwordConfirmationErrorController.close();
    isFormValidController.close();
    isLoadingController.close();
    mainErrorController.close();
    navigateToController.close();
  }
}
