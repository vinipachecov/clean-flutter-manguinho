
import 'package:test/test.dart';
import 'package:clean_flutter_manguinho/presentation/protocols/validation.dart';
import 'package:clean_flutter_manguinho/validation/validators/validators.dart';

void main() {
  EmailValidation sut;
  setUp(() {
    sut = EmailValidation("any_field");
  });

  test('Should return null on invalid case', () {
    expect(sut.validate({ }), null);
  });

  test('Should return null if email is empty', () {
    expect(sut.validate({ 'any_field': ''}), null);
  });

  test('Should return null if email is empty', () {
    expect(sut.validate({ 'any_field': null}), null);
  });

  test('Should return null if email is valid', () {
    expect(sut.validate({ 'any_field': 'vinicius@gmail.com'}), null);
  });

  test('Should return error if email is invalid', () {
    expect(sut.validate({ 'any_field': 'viniciusvieira'}), ValidationError.invalidField);
  });
}