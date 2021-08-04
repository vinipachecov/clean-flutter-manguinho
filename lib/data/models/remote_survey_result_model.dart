import 'package:clean_flutter_manguinho/domain/entities/survey_result_entity.dart';
import 'package:meta/meta.dart';
import 'package:clean_flutter_manguinho/data/models/models.dart';
import 'package:clean_flutter_manguinho/domain/entities/entities.dart';
import 'package:clean_flutter_manguinho/data/http/http_error.dart';

class RemoteSurveyResultModel {
  final String surveyId;
  final String question;
  final List<RemoteSurveyAnswerModel> answers;

  RemoteSurveyResultModel({
    @required this.surveyId,
    @required this.question,
    @required this.answers,
  });

  factory RemoteSurveyResultModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll(['surveyId', 'question', 'answers'])) {
      throw HttpError.invalidData;
    }
    return RemoteSurveyResultModel(
        surveyId: json['surveyId'],
        question: json['question'],
        answers: json['answers']
            .map<RemoteSurveyAnswerModel>(
                (answerJson) => RemoteSurveyAnswerModel.fromJson(answerJson))
            .toList());
  }

  SurveyResultEntity toEntity() => SurveyResultEntity(
      surveyId: surveyId,
      question: question,
      answers: answers
          .map<SurveyAnswerEntity>((answer) => answer.toEntity())
          .toList());
}
