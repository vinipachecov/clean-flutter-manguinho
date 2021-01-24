abstract class LoginPresenter {
  Stream get emailErrorStream;
  Stream<String> get passwordErrorStream;
  Stream<String> get isFormValidStream;
  Stream<bool> get isLoadingStream;
  Stream<String> get mainErrorStream;

  void validateEmail(String email);
  void validatePassword(String password);
  void auth();
  void dispose();
}