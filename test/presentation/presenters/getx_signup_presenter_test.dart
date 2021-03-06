import 'package:clean_flutter_manguinho/domain/entities/account_entity.dart';
import 'package:clean_flutter_manguinho/domain/helpers/helpers.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:clean_flutter_manguinho/ui/helpers/errors/ui_error.dart';
import 'package:clean_flutter_manguinho/domain/usecases/usecases.dart';

import 'package:clean_flutter_manguinho/presentation/protocols/protocols.dart';
import 'package:clean_flutter_manguinho/presentation/presenters/presenters.dart';

class ValidationSpy extends Mock implements Validation {}

class AddAccountSpy extends Mock implements AddAccount {}

class SaveCurrentAccountSpy extends Mock implements SaveCurrentAccount {}

void main() {
  GetxSignUpPresenter sut;
  AddAccountSpy addAccount;
  ValidationSpy validation;
  SaveCurrentAccountSpy saveCurrentAccount;
  String email;
  String password;
  String passwordConfirmation;
  String name;
  String token;

  PostExpectation mockAddAccountCall() => when(addAccount.add(any));

  void mockAddAccount({String field, String value}) {
    mockAddAccountCall().thenAnswer((_) async => AccountEntity(token));
  }

  void mockAddAccountError(error) {
    mockAddAccountCall().thenThrow((error));
  }

  PostExpectation mockValidationCall(String field) => when(validation.validate(
      field: field == null ? anyNamed('field') : field,
      input: anyNamed('input')));

  void mockValidation({String field, ValidationError value}) {
    mockValidationCall(field).thenReturn(value);
  }

  PostExpectation mockSaveCurrentAccountCall() =>
      when(saveCurrentAccount.save(any));

  void mockSaveCurrentAccountError() {
    mockSaveCurrentAccountCall().thenThrow((DomainError.unexpected));
  }

  setUp(() {
    validation = ValidationSpy();
    addAccount = AddAccountSpy();
    saveCurrentAccount = SaveCurrentAccountSpy();
    sut = GetxSignUpPresenter(
        validation: validation,
        addAccount: addAccount,
        saveCurrentAccount: saveCurrentAccount);
    email = faker.internet.email();
    name = faker.person.name();
    password = faker.internet.password();
    passwordConfirmation = password;
    token = faker.guid.guid();
    mockValidation();
    mockAddAccount();
  });

  test('Should call Validation with correct email', () {
     final formData = {
      'name': null,
      'email': email,
      'password': null,
      'passwordConfirmation': null
    };

    sut.validateEmail(email);


    verify(validation.validate(field: 'email', input: formData)).called(1);
  });

  test('Should emit email invalidField error if email is invalid', () {
    mockValidation(value: ValidationError.invalidField);

    sut.emailErrorStream
        .listen((expectAsync1((error) => expect(error, UIError.invalidField))));
    sut.isFormValidStream
        .listen((expectAsync1((isValid) => expect(isValid, false))));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should emit email requiredField error if email is empty', () {
    mockValidation(value: ValidationError.requiredField);

    sut.emailErrorStream.listen(
        (expectAsync1((error) => expect(error, UIError.requiredField))));
    sut.isFormValidStream
        .listen((expectAsync1((isValid) => expect(isValid, false))));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should emit null email if validation succeeds', () {
    mockValidation();

    sut.emailErrorStream.listen((expectAsync1((error) => expect(error, null))));
    sut.isFormValidStream
        .listen((expectAsync1((isValid) => expect(isValid, false))));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should call Validation with correct name', () {
    sut.validateName(name);
     final formData = {
      'name': name,
      'email': null,
      'password': null,
      'passwordConfirmation': null
    };

    verify(validation.validate(field: 'name', input: formData)).called(1);
  });

  test('Should emit name invalidField error if name is invalid', () {
    mockValidation(value: ValidationError.invalidField);

    sut.nameErrorStream
        .listen((expectAsync1((error) => expect(error, UIError.invalidField))));
    sut.isFormValidStream
        .listen((expectAsync1((isValid) => expect(isValid, false))));

    sut.validateName(name);
    sut.validateName(name);
  });

  test('Should emit name requiredField error if name is empty', () {
    mockValidation(value: ValidationError.requiredField);

    sut.nameErrorStream.listen(
        (expectAsync1((error) => expect(error, UIError.requiredField))));
    sut.isFormValidStream
        .listen((expectAsync1((isValid) => expect(isValid, false))));

    sut.validateName(name);
    sut.validateName(name);
  });

  test('Should emit null name if validation succeeds', () {
    mockValidation();

    sut.nameErrorStream.listen((expectAsync1((error) => expect(error, null))));
    sut.isFormValidStream
        .listen((expectAsync1((isValid) => expect(isValid, false))));

    sut.validateName(name);
    sut.validateName(name);
  });

  test('Should call Validation with correct password', () {
    sut.validatePassword(password);

    final formData = {
      'name': null,
      'email': null,
      'password': password,
      'passwordConfirmation': null
    };

    verify(validation.validate(field: 'password', input: formData)).called(1);
  });

  test('Should emit password invalidField error if password is invalid', () {
    mockValidation(value: ValidationError.invalidField);

    sut.passwordErrorStream
        .listen((expectAsync1((error) => expect(error, UIError.invalidField))));
    sut.isFormValidStream
        .listen((expectAsync1((isValid) => expect(isValid, false))));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit password requiredField error if password is empty', () {
    mockValidation(value: ValidationError.requiredField);

    sut.passwordErrorStream.listen(
        (expectAsync1((error) => expect(error, UIError.requiredField))));
    sut.isFormValidStream
        .listen((expectAsync1((isValid) => expect(isValid, false))));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit null password if validation succeeds', () {
    mockValidation();

    sut.nameErrorStream.listen((expectAsync1((error) => expect(error, null))));
    sut.isFormValidStream
        .listen((expectAsync1((isValid) => expect(isValid, false))));

    sut.validateName(password);
    sut.validateName(password);
  });

  test('Should call Validation with correct passwordConfirmation', () {
    sut.validatePasswordConfirmation(passwordConfirmation);
     final formData = {
      'name': null,
      'email': null,
      'password': null,
      'passwordConfirmation': passwordConfirmation
    };


    verify(validation.validate(
            field: 'passwordConfirmation', input: formData))
        .called(1);
  });

  test(
      'Should emit passwordConfirmation invalidField error if passwordConfirmation is invalid',
      () {
    mockValidation(value: ValidationError.invalidField);

    sut.passwordConfirmationErrorStream
        .listen((expectAsync1((error) => expect(error, UIError.invalidField))));
    sut.isFormValidStream
        .listen((expectAsync1((isValid) => expect(isValid, false))));

    sut.validatePasswordConfirmation(passwordConfirmation);
    sut.validatePasswordConfirmation(passwordConfirmation);
  });

  test(
      'Should emit passwordConfirmation requiredField error if passwordConfirmation is empty',
      () {
    mockValidation(value: ValidationError.requiredField);

    sut.passwordConfirmationErrorStream.listen(
        (expectAsync1((error) => expect(error, UIError.requiredField))));
    sut.isFormValidStream
        .listen((expectAsync1((isValid) => expect(isValid, false))));

    sut.validatePasswordConfirmation(passwordConfirmation);
    sut.validatePasswordConfirmation(passwordConfirmation);
  });

  test('Should emit null passwordConfirmation if validation succeeds', () {
    mockValidation();

    sut.passwordConfirmationErrorStream
        .listen((expectAsync1((error) => expect(error, null))));
    sut.isFormValidStream
        .listen((expectAsync1((isValid) => expect(isValid, false))));

    sut.validatePasswordConfirmation(passwordConfirmation);
    sut.validatePasswordConfirmation(passwordConfirmation);
  });

  test('Should enable form button if all fields are valid', () async {
    expectLater(sut.isFormValidStream, emitsInOrder([false, true]));

    sut.validateName(name);
    await Future.delayed(Duration.zero);
    sut.validateEmail(email);
    await Future.delayed(Duration.zero);
    sut.validatePassword(password);
    await Future.delayed(Duration.zero);
    sut.validatePasswordConfirmation(passwordConfirmation);
  });

  test('Should call authentication with correct values', () async {
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    await sut.signUp();
    verify(addAccount.add(AddAccountParams(
            name: name,
            email: email,
            password: password,
            passwordConfirmation: passwordConfirmation)))
        .called(1);
  });

  test('Should call SaveCurrentAccount with correct values', () async {
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    await sut.signUp();
    verify(saveCurrentAccount.save(AccountEntity(token))).called(1);
  });

  test('Should emit  UnexpectedError if SaveCurrentAccount fails', () async {
    mockSaveCurrentAccountError();
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.mainErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.unexpected)));

    await sut.signUp();
  });

  test('Should emit correct events on SignUp success', () async {
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    expectLater(sut.isLoadingStream, emits(true));

    await sut.signUp();
  });



  test('Should emit correct events on EmailAlreadyInUse', () async {
    mockAddAccountError(DomainError.emailInUse);

    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.mainErrorStream.listen(
        expectAsync1((error) => expect(error, UIError.emailInUse)));

    await sut.signUp();
  });

  test('Should emit correct events on UnexpectedError', () async {
    mockAddAccountError(DomainError.unexpected);

    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.mainErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.unexpected)));

    await sut.signUp();
  });

  test('Should change page on success', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);
     sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    sut.navigateToStream.listen((expectAsync1((page) => expect(page, '/surveys'))));

    await sut.signUp();
  });

  test('Should go to Login page link click', () async {
    // always remember to set stream tests before function invocation
    sut.navigateToStream.listen((expectAsync1((page) => expect(page, '/login'))));

    sut.goToLogin();
  });
}
