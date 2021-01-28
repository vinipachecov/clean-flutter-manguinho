
import 'package:test/test.dart';
import 'package:clean_flutter_manguinho/main/factories/factories.dart';
import 'package:clean_flutter_manguinho/validation/validators/validators.dart';

void main() {
  test('Should return the correct validations', () {
    final validations = makeLoginValidations();
    expect(validations, [
      RequiredFieldValidation('email'),
      EmailValidation('email'),
      RequiredFieldValidation('password')
    ]);
  });
}