import 'package:clean_flutter_manguinho/ui/helpers/errors/errors.dart';
import 'package:meta/meta.dart';
import 'package:get/get.dart';
import 'package:clean_flutter_manguinho/presentation/protocols/protocols.dart';
import '../../domain/usecases/usecases.dart';

class GetxSignUpPresenter extends GetxController {
  final Validation validation;
  final AddAccount addAccount;
  final SaveCurrentAccount saveCurrentAccount;
  String _email;
  String _password;
  String _passwordConfirmation;
  String _name;

  var _emailError = Rx<UIError>();
  var _nameError = Rx<UIError>();
  var _mainError = Rx<UIError>();
  var _passwordError = Rx<UIError>();
  var _passwordConfirmationError = Rx<UIError>();
  var _isFormValid = false.obs;

  Stream<UIError> get emailErrorStream => _emailError.stream;
  Stream<UIError> get passwordErrorStream => _passwordError.stream;
  Stream<UIError> get passwordConfirmationErrorStream =>
      _passwordConfirmationError.stream;
  Stream<UIError> get mainErrorStream => _mainError.stream;
  Stream<UIError> get nameErrorStream => _nameError.stream;
  Stream<bool> get isFormValidStream => _isFormValid.stream;

  GetxSignUpPresenter({@required this.validation, @required this.addAccount, @required this.saveCurrentAccount});

  void validateEmail(String email) {
    _email = email;
    _emailError.value = _validateField(field: 'email', value: email);
    _validateForm();
  }

  void validatePassword(String password) {
    _password = password;
    _passwordError.value = _validateField(field: 'password', value: password);
    _validateForm();
  }

  void validatePasswordConfirmation(String password) {
    _passwordConfirmation = password;
    _passwordConfirmationError.value =
        _validateField(field: 'passwordConfirmation', value: password);
    _validateForm();
  }

  void validateName(String name) {
    _name = name;
    _nameError.value = _validateField(field: 'name', value: name);
    _validateForm();
  }

  UIError _validateField({String field, String value}) {
    final error = validation.validate(field: field, value: value);
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
    _isFormValid.value = _emailError.value == null &&
        _passwordError.value == null &&
        _nameError.value == null &&
        _passwordConfirmationError.value == null &&
        _email != null &&
        _password != null &&
        _passwordConfirmation != null;
  }

  Future<void> signUp() async {
       final account = await addAccount.add(AddAccountParams(
          email: _email,
          name: _name,
          password: _password,
          passwordConfirmation: _passwordConfirmation));
        await saveCurrentAccount.save(account);
  }
}
