import 'package:faker/faker.dart';
import 'package:test/test.dart';

import 'package:clean_flutter_manguinho/presentation/protocols/validation.dart';
import 'package:clean_flutter_manguinho/validation/validators/validators.dart';

void main() {
  CompareFieldsValidation sut;

  setUp(() {
    sut = CompareFieldsValidation(field: 'any_field', valueToCompare: 'any_value');
  });
  test('Should return error if value is empty', () {
    expect(sut.validate('wrong_value'), ValidationError.invalidField);
  });
}
