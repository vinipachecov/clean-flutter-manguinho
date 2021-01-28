
import 'package:clean_flutter_manguinho/validation/protocols/protocols.dart';
import 'package:equatable/equatable.dart';

class RequiredFieldValidation extends Equatable implements FieldValidation  {
  final String field;

  RequiredFieldValidation(this.field);

  String validate(String value) {
    return value?.isNotEmpty == true ? null : 'Campo obrigatório';
  }

  @override
  List<Object> get props => [field];

}