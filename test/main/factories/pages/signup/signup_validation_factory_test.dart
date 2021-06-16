
import 'package:test/test.dart';
import 'package:clean_flutter_manguinho/main/factories/factories.dart';
import 'package:clean_flutter_manguinho/validation/validators/validators.dart';

void main() {
  test('Should return the correct validations', () {
    final validations = makeSignUpValidations();
    expect(validations, [
      RequiredFieldValidation('name'),
      MinLengthValidation(field: 'name', size: 3),
      RequiredFieldValidation('email'),
      EmailValidation('email'),
      RequiredFieldValidation('password'),
      MinLengthValidation(field: 'password', size: 3),
      RequiredFieldValidation('passwordConfirmation'),
      CompareFieldsValidation(field: 'passwordConfirmation', fieldToCompare: 'password'),
    ]);
  });
}