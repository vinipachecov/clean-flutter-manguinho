import 'package:meta/meta.dart';
class AccountEntity  {
  final String id;
  final String question;
  final String datetime;
  final String didAnswer;

  AccountEntity({
    @required this.id,
    @required this.question,
    @required this.datetime,
    @required this.didAnswer
  });
}
