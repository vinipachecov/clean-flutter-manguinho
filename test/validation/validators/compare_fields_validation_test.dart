import 'package:test/test.dart';

import 'package:clean_flutter_manguinho/presentation/protocols/validation.dart';
import 'package:clean_flutter_manguinho/validation/validators/validators.dart';

void main() {
  CompareFieldsValidation sut;

  setUp(() {
    sut = CompareFieldsValidation(field: 'any_field', fieldToCompare: 'other_field');
  });

  test('Should return null on invalid cases', () {
    expect(sut.validate( {'any_field': 'any_value'}), null);
    expect(sut.validate( {'other_field': 'other_Value'}), null);
    expect(sut.validate({}), null);
  });

  test('Should return error if values are not equal', () {
    final formData = {
      'any_field': 'any_value',
      'other_field': 'other_Value'
    };
    expect(sut.validate(formData), ValidationError.invalidField);
  });

  test('Should return null if values are equal', () {
    final formData = {
      'any_field': 'any_value',
      'other_field': 'any_value'
    };
    expect(sut.validate(formData), null);
  });
}
