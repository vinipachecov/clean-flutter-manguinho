import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class SurveyAnswer extends Equatable {
  final String image;
  final String answer;
  final bool isCurrentAnswer;
  final int percent;

  List get props => ['surveyId', 'question', 'isCurrentAnswer', 'percent'];
  SurveyAnswer(
      {this.image,
      @required this.answer,
      @required this.isCurrentAnswer,
      @required this.percent});
}
