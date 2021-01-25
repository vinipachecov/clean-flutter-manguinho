
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:clean_flutter_manguinho/domain/entities/account_entity.dart';
import 'package:clean_flutter_manguinho/domain/usecases/usecases.dart';

import 'package:clean_flutter_manguinho/presentation/protocols/protocols.dart';
import 'package:clean_flutter_manguinho/presentation/presenters/presenters.dart';


class ValidationSpy extends Mock implements Validation {}
class AuthenticationSpy extends Mock implements Authentication {}

void main() {
  StreamLoginPresenter sut;
  ValidationSpy validation;
  AuthenticationSpy authentication;
  String email;
  String password;

  PostExpectation mockValidationCall(String field) => when(validation.validate(field: field == null ? anyNamed('field') : field, value: anyNamed('value')));

  void mockValidation({String field, String value}) {
    mockValidationCall(field).thenReturn(value);
  }

  PostExpectation mockAuthenticationCall() => when(authentication.auth(any));

  void mockAuthentication({String field, String value}) {
    mockAuthenticationCall().thenAnswer((_) async => AccountEntity(faker.guid.guid()));
  }

  setUp(() {
    validation = ValidationSpy();
    authentication = AuthenticationSpy();
    sut = StreamLoginPresenter(validation: validation, authentication: authentication);
    email = faker.internet.email();
    password = faker.internet.password();
    mockValidation();
    mockAuthentication();
  });

  test('Should call Validation with correct email', () {
    sut.validateEmail(email);

    verify(validation.validate(field: 'email', value: email)).called(1);
  });

  test('Should emit email error if validation fails', () {
    mockValidation(value: 'error');

    sut.emailErrorStream.listen((expectAsync1((error) => expect(error, 'error'))));
    sut.isFormValidStream.listen((expectAsync1((isValid) => expect(isValid, false))));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should emit null email if validation succeeds', () {
    mockValidation();

    sut.emailErrorStream.listen((expectAsync1((error) => expect(error, null))));
    sut.isFormValidStream.listen((expectAsync1((isValid) => expect(isValid, false))));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should call Validation ith correct password', () {
    sut.validatePassword(password);

    verify(validation.validate(field: 'password', value: password)).called(1);
  });

    test('Should emit password error if validation fails', () {
    mockValidation();

    sut.passwordErrorStream.listen((expectAsync1((error) => expect(error, null))));
    sut.isFormValidStream.listen((expectAsync1((isValid) => expect(isValid, false))));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit null password error if validation fails', () {
    sut.passwordErrorStream.listen((expectAsync1((error) => expect(error, null))));
    sut.isFormValidStream.listen((expectAsync1((isValid) => expect(isValid, false))));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit null password error if validation fails', () {
    mockValidation(field: 'email', value: 'error');

    sut.emailErrorStream.listen((expectAsync1((error) => expect(error, 'error'))));
    sut.passwordErrorStream.listen((expectAsync1((error) => expect(error, null))));
    sut.isFormValidStream.listen((expectAsync1((isValid) => expect(isValid, false))));

    sut.validateEmail(password);
    sut.validatePassword(password);
  });

  test('Should emit null password error if validation fails', () async {

    sut.emailErrorStream.listen((expectAsync1((error) => expect(error, null))));
    sut.passwordErrorStream.listen((expectAsync1((error) => expect(error, null))));

    expectLater(sut.isFormValidStream, emitsInOrder([false, true]));

    sut.validateEmail(password);
    // require to create space for stream to emit both "false" and "true" value
    await Future.delayed(Duration.zero);
    sut.validatePassword(password);
  });

  test('Should call authentication with correct values', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    await sut.auth();
    verify(authentication.auth(AuthenticationParams(email: email, secret: password))).called(1);
  });

  test('Should emit correct events on Authentication success', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    await sut.auth();
  });
}
