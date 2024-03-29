import 'package:clean_flutter_manguinho/domain/entities/survey_result_entity.dart';

abstract class LoadSurveyResult {
  Future<SurveyResultEntity> loadBySurvey({required String surveyId});
}
