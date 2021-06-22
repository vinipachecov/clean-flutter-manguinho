import 'package:meta/meta.dart';

class SurveyEntity  {
  final String id;
  final String question;
  final String datetime;
  final String didAnswer;

  SurveyEntity({
    @required this.id,
    @required this.question,
    @required this.datetime,
    @required this.didAnswer
  });
}
