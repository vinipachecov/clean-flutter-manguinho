import 'package:clean_flutter_manguinho/domain/entities/entities.dart';
import 'package:clean_flutter_manguinho/domain/entities/survey_result_entity.dart';

abstract class LoadSurveyResult {
  Future<SurveyResultEntity> loadBySurvey({String surveyId});
}
