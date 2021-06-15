import 'package:clean_flutter_manguinho/presentation/protocols/validation.dart';
import 'package:clean_flutter_manguinho/validation/protocols/field_validation.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class MinLengthValidation extends Equatable implements FieldValidation {
  final String field;
  final int size;

  MinLengthValidation({@required this.field, @required this.size});

  List<Object> get props => [field,size];

  ValidationError validate(Map value) {
    return value[field] != null && value[field].length >= size ? null : ValidationError.invalidField;
  }
}