import 'package:clean_flutter_manguinho/ui/helpers/errors/errors.dart';
import 'package:meta/meta.dart';
import 'package:get/get.dart';
import 'package:clean_flutter_manguinho/presentation/protocols/protocols.dart';


class GetxSignUpPresenter extends GetxController {
  final Validation validation;
  String _email;
  String _password;

  var _emailError = Rx<UIError>();
  var _mainError = Rx<UIError>();
  var _isFormValid = false.obs;

  Stream<UIError> get emailErrorStream => _emailError.stream;
  Stream<UIError> get mainErrorStream => _mainError.stream;
  Stream<bool> get isFormValidStream => _isFormValid.stream;

  GetxSignUpPresenter({@required this.validation});

  void validateEmail(String email) {
    _email = email;
    _emailError.value = _validateField(field: 'email', value: email);
    _validateForm();
  }

  UIError _validateField({String field, String value}) {
    final error = validation.validate(field: field, value: value);
    switch(error) {
      case ValidationError.invalidField: return UIError.invalidField;
      case ValidationError.requiredField: return UIError.requiredField;
      default:
        return null;
    }
  }

  void _validateForm() {
      _isFormValid.value =  false;
  }

  Future<void> auth() async {

  }

  void dispose() {}
}
