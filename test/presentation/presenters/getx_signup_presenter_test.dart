
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:clean_flutter_manguinho/ui/helpers/errors/ui_error.dart';
import 'package:clean_flutter_manguinho/domain/usecases/usecases.dart';

import 'package:clean_flutter_manguinho/presentation/protocols/protocols.dart';
import 'package:clean_flutter_manguinho/presentation/presenters/presenters.dart';


class ValidationSpy extends Mock implements Validation {}
class AuthenticationSpy extends Mock implements Authentication {}
class SaveCurrentAccountSpy extends Mock implements SaveCurrentAccount {}

void main() {
  GetxSignUpPresenter sut;
  ValidationSpy validation;
  String email;

  PostExpectation mockValidationCall(String field) => when(validation.validate(field: field == null ? anyNamed('field') : field, value: anyNamed('value')));

  void mockValidation({String field, ValidationError value}) {
    mockValidationCall(field).thenReturn(value);
  }




  setUp(() {
    validation = ValidationSpy();
    sut = GetxSignUpPresenter(
      validation: validation
    );
    email = faker.internet.email();
    mockValidation();
  });

  test('Should call Validation with correct email', () {
    sut.validateEmail(email);

    verify(validation.validate(field: 'email', value: email)).called(1);
  });

  test('Should emit email invalidField error if email is invalid', () {
    mockValidation(value: ValidationError.invalidField);

    sut.emailErrorStream.listen((expectAsync1((error) => expect(error, UIError.invalidField))));
    sut.isFormValidStream.listen((expectAsync1((isValid) => expect(isValid, false))));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should emit email requiredField error if email is empty', () {
    mockValidation(value: ValidationError.requiredField);

    sut.emailErrorStream.listen((expectAsync1((error) => expect(error, UIError.requiredField))));
    sut.isFormValidStream.listen((expectAsync1((isValid) => expect(isValid, false))));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });
}
