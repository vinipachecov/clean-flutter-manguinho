import 'package:clean_flutter_manguinho/presentation/protocols/validation.dart';
import 'package:clean_flutter_manguinho/validation/protocols/field_validation.dart';

import 'package:meta/meta.dart';

class CompareFieldsValidation  implements FieldValidation {
  final String field;
  final String valueToCompare;
  CompareFieldsValidation({@required this.field, @required this.valueToCompare});

  ValidationError validate(String value) {
    return value == valueToCompare ? null : ValidationError.invalidField;
  }
}