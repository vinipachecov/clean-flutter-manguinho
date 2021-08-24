import 'package:clean_flutter_manguinho/domain/entities/entities.dart';
import 'package:clean_flutter_manguinho/ui/pages/pages.dart';

/** Dart extensions allow creating methods like "static" methods, however it doesn't include
 * in to all instances but only to the ones inside this module.
*/
extension SurveyResultEntityExtensions on SurveyResultEntity {
  SurveyResultViewModel toViewModel() => SurveyResultViewModel(
      surveyId: surveyId,
      question: question,
      answers: answers.map((answer) => answer.toViewModel()).toList());
}

extension SurveyAnswerEntityExtensions on SurveyAnswerEntity {
  SurveyAnswerViewModel toViewModel() => SurveyAnswerViewModel(
      answer: answer, isCurrentAnswer: isCurrentAnswer, percent: '${percent}%');
}
