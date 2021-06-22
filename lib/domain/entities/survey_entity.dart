import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
class SurveyEntity extends Equatable  {
  final String id;
  final String question;
  final DateTime dateTime;
  final bool didAnswer;

  List get props => ['id', 'question', 'datetime', 'didAnswer'];
  SurveyEntity({
    @required this.id,
    @required this.question,
    @required this.dateTime,
    @required this.didAnswer
  });
}