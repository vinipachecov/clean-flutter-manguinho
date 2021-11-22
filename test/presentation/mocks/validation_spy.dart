import 'package:clean_flutter_manguinho/presentation/protocols/validation.dart';
import 'package:mocktail/mocktail.dart';

class ValidationSpy extends Mock implements Validation {
  ValidationSpy() {
    this.mockValidation();
  }

  When mockValidationCall(String? field) => when(() => this.validate(
      field: field == null ? any(named: 'field') : field,
      input: any(named: 'input')));
  void mockValidation({String? field}) =>
      this.mockValidationCall(field).thenReturn(null);

  void mockValidationError({String? field, ValidationError? value}) {
    mockValidationCall(field).thenReturn(value);
  }
}
