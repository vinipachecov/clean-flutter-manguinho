import 'package:clean_flutter_manguinho/domain/entities/survey_result_entity.dart';
import 'package:meta/meta.dart';

abstract class SaveSurveyResult {
  Future<SurveyResultEntity> save({@required String surveyId});
}
