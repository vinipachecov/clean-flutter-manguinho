import 'package:clean_flutter_manguinho/data/cache/cache.dart';
import 'package:clean_flutter_manguinho/data/models/local_survey_result_model.dart';
import 'package:clean_flutter_manguinho/domain/entities/entities.dart';
import 'package:clean_flutter_manguinho/domain/helpers/helpers.dart';
import 'package:clean_flutter_manguinho/domain/usecases/usecases.dart';
import 'package:meta/meta.dart';

class LocalLoadSurveyResult implements LoadSurveyResult {
  final CacheStorage cacheStorage;
  LocalLoadSurveyResult({@required this.cacheStorage});
  Future<SurveyResultEntity> loadBySurvey({String surveyId}) async {
    try {
      final data = await cacheStorage.fetch('survey_result/$surveyId');
      if (data?.isEmpty != false) {
        throw Exception();
      }
      return LocalSurveyResultModel.fromJson(data).toEntity();
    } catch (error) {
      throw DomainError.unexpected;
    }
  }

  Future<void> validate(String surveyId) async {
    try {
      final data = await cacheStorage.fetch('survey_result/$surveyId');
      return LocalSurveyResultModel.fromJson(data).toEntity();
    } catch (error) {
      await cacheStorage.delete('survey_result/$surveyId');
    }
  }
}
