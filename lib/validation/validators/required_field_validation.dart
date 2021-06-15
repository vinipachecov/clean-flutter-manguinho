
import 'package:clean_flutter_manguinho/presentation/protocols/validation.dart';
import 'package:clean_flutter_manguinho/validation/protocols/protocols.dart';
import 'package:equatable/equatable.dart';

class RequiredFieldValidation extends Equatable implements FieldValidation  {
  final String field;

  RequiredFieldValidation(this.field);

  ValidationError validate(Map input) {
    return input[field]?.isNotEmpty == true ? null : ValidationError.requiredField;
  }

  @override
  List<Object> get props => [field];

}