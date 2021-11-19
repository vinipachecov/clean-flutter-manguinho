import 'package:test/test.dart';

import 'package:clean_flutter_manguinho/presentation/protocols/validation.dart';
import 'package:clean_flutter_manguinho/validation/validators/validators.dart';

import '../../validation/mocks/field_validation_spy.dart';

main() {
  late FieldValidationSpy validation2;
  late FieldValidationSpy validation1;
  late FieldValidationSpy validation3;
  late ValidationComposite sut;

  setUp(() {
    validation1 = FieldValidationSpy();
    validation1.mockFieldName('other_field');
    validation2 = FieldValidationSpy();

    validation3 = FieldValidationSpy();

    sut = ValidationComposite([validation1, validation2, validation3]);
  });

  test('Should return null if all validations returns null or empty', () {
    final error = sut.validate(field: 'any_field', input: {});

    expect(error, null);
  });

  test('Should return first error', () {
    validation1.mockValidationError(ValidationError.invalidField);
    validation2.mockValidationError(ValidationError.requiredField);
    validation3.mockValidationError(ValidationError.invalidField);

    final error = sut.validate(field: 'any_field', input: {});

    expect(error, ValidationError.requiredField);
  });
}
