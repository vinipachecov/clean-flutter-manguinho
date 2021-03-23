import 'package:clean_flutter_manguinho/presentation/protocols/validation.dart';

abstract class FieldValidation {
  String get field;
  ValidationError validate(String value);
}