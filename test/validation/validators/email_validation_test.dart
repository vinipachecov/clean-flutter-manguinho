import 'package:test/test.dart';

import 'package:clean_flutter_manguinho/validation/validators/validators.dart';

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
    expect(sut.validate('vinicius@gmail.com'), null);
  });

  test('Should return error if email is invalid', () {
    expect(sut.validate('viniciusvieira'), 'Campo inválido');
  });
}