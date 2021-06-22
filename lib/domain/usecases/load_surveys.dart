import 'package:clean_flutter_manguinho/domain/entities/entities.dart';

abstract class LoadSurveys {
  Future<List<SurveyEntity>> load();
}