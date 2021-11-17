import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:clean_flutter_manguinho/presentation/protocols/validation.dart';
import 'package:clean_flutter_manguinho/validation/validators/validators.dart';
import 'package:clean_flutter_manguinho/validation/protocols/protocols.dart';

class FieldValidationSpy extends Mock implements FieldValidation {}

main() {
  late FieldValidationSpy validation2;
  late FieldValidationSpy validation1;
  late FieldValidationSpy validation3;
  late ValidationComposite sut;

  void mockValidation1(ValidationError? error) {
    when(() => validation1.validate(any())).thenReturn(error);
  }

  void mockValidation2(ValidationError? error) {
    when(() => validation2.validate(any())).thenReturn(error);
  }

  void mockValidation3(ValidationError? error) {
    when(() => validation3.validate(any())).thenReturn(error);
  }

  setUp(() {
    validation1 = FieldValidationSpy();
    when(() => validation1.field).thenReturn('other_field');
    mockValidation1(null);

    validation2 = FieldValidationSpy();
    when(() => validation2.field).thenReturn('any_field');
    mockValidation2(null);

    validation3 = FieldValidationSpy();
    when(() => validation3.field).thenReturn('other_field');
    mockValidation3(null);

    sut = ValidationComposite([validation1, validation2]);
  });

  test('Should return null if all validations returns null or empty', () {
    final error = sut.validate(field: 'any_field', input: {});

    expect(error, null);
  });

  test('Should return first error', () {
    mockValidation1(ValidationError.requiredField);
    mockValidation2(ValidationError.requiredField);
    mockValidation3(ValidationError.invalidField);

    final error = sut.validate(field: 'any_field', input: {});

    expect(error, ValidationError.requiredField);
  });
}
