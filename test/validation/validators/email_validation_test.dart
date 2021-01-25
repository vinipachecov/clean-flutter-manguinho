import 'package:clean_flutter_manguinho/validation/protocols/field_validation.dart';
import 'package:test/test.dart';

class EmailValidation implements FieldValidation {
  final String field;

  EmailValidation(this.field);

  @override
  String validate(String value) {
    return null;
  }

}

void main() {
  EmailValidation sut;
  setUp(() {
    sut = EmailValidation("any_field");
  });
  test('Should return null if email is empty', () {
    expect(sut.validate(''), null);
  });

  test('Should return null if email is empty', () {
    expect(sut.validate(null), null);
  });

  test('Should return null if email is valid', () {
    expect(sut.validate('vinicius.vieira@gmail.com'), null);
  });
}