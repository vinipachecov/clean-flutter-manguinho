import 'package:clean_flutter_manguinho/presentation/protocols/validation.dart';
import 'package:clean_flutter_manguinho/validation/protocols/field_validation.dart';

import 'package:meta/meta.dart';

class CompareFieldsValidation  implements FieldValidation {
  final String field;
  final String fieldToCompare;
  CompareFieldsValidation({@required this.field, @required this.fieldToCompare});

  ValidationError validate(Map input) {
    return input[field] != null &&
    input[fieldToCompare] != null &&
    input[field] != input[fieldToCompare] ? ValidationError.invalidField : null;
  }
}