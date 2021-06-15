import 'package:clean_flutter_manguinho/presentation/protocols/validation.dart';
import 'package:clean_flutter_manguinho/validation/protocols/field_validation.dart';
import 'package:test/test.dart';

class MinLengthValidation implements FieldValidation {
  final String field;
  final int size;
  MinLengthValidation({this.field, this.size});

  ValidationError validate(String value) {
    return ValidationError.invalidField;
  }
}

void main() {
  MinLengthValidation sut;

  setUp(() {
    sut = MinLengthValidation(field: 'any_field', size: 5);
  });
  test('Should return error if value is empty', () {
    expect(sut.validate(''), ValidationError.invalidField);
  });

  test('Should return error if value is null', () {
    expect(sut.validate(null), ValidationError.invalidField);
  });
}
