import 'package:clean_flutter_manguinho/ui/helpers/errors/errors.dart';
import 'package:get/get.dart';
import 'package:clean_flutter_manguinho/domain/usecases/usecases.dart';
import 'package:clean_flutter_manguinho/domain/helpers/helpers.dart';
import 'package:clean_flutter_manguinho/presentation/protocols/protocols.dart';
import 'package:clean_flutter_manguinho/ui/pages/pages.dart';
import 'package:clean_flutter_manguinho/presentation/mixins/mixins.dart';

class GetxLoginPresenter extends GetxController
    with LoadingManager, UIErrorManager, NavigationManager, FormManager
    implements LoginPresenter {
  final Validation validation;
  final Authentication authentication;
  final SaveCurrentAccount saveCurrentAccount;
  String? _email;
  String? _password;

  var _emailError = Rx<UIError?>(null);
  var _passwordError = Rx<UIError?>(null);

  Stream<UIError?> get emailErrorStream => _emailError.stream;
  Stream<UIError?> get passwordErrorStream => _passwordError.stream;

  GetxLoginPresenter(
      {required this.validation,
      required this.authentication,
      required this.saveCurrentAccount});

  void validateEmail(String email) {
    _email = email;
    _emailError.value = _validateField('email');
    _validateForm();
  }

  void validatePassword(String password) {
    _password = password;
    _passwordError.value = _validateField('password');
    _validateForm();
  }

  UIError? _validateField(String field) {
    final formData = {'email': _email, 'password': _password};
    final error = validation.validate(field: field, input: formData);
    switch (error) {
      case ValidationError.invalidField:
        return UIError.invalidField;
      case ValidationError.requiredField:
        return UIError.requiredField;
      default:
        return null;
    }
  }

  void _validateForm() {
    isFormValid = _emailError.value == null &&
        _passwordError.value == null &&
        _email != null &&
        _password != null;
  }

  Future<void> auth() async {
    try {
      isLoading = true;
      final account = await authentication
          .auth(AuthenticationParams(email: _email!, secret: _password!));
      await saveCurrentAccount.save(account);
      navigateTo = '/surveys';
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.invalidCredentials:
          mainError = UIError.invalidCredentials;
          break;
        default:
          mainError = UIError.unexpected;
      }
      isLoading = false;
    }
  }

  void goToSignUp() {
    navigateTo = "/signup";
  }
}
