import 'package:clean_flutter_manguinho/presentation/protocols/validation.dart';

import '../../validation/protocols/field_validation.dart';
import 'package:equatable/equatable.dart';
class EmailValidation extends Equatable implements FieldValidation {
  final String field;

  @override
  List<Object> get props => [field];

  EmailValidation(this.field);

  @override
  ValidationError validate(String value) {
    final regex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    final isValid = value?.isNotEmpty != true || regex.hasMatch(value);
    return isValid ? null : ValidationError.invalidField;
  }

}