import 'package:meta/meta.dart';

import 'package:clean_flutter_manguinho/domain/entities/entities.dart';
import 'package:clean_flutter_manguinho/data/http/http_error.dart';

class RemoteSurveyAnswerModel {
  final String image;
  final String answer;
  final bool isCurrentAccountAnswer;
  final int percent;

  RemoteSurveyAnswerModel({
    this.image,
    @required this.answer,
    @required this.isCurrentAccountAnswer,
    @required this.percent,
  });

  factory RemoteSurveyAnswerModel.fromJson(Map json) {
    if (!json.keys
        .toSet()
        .containsAll(['answer', 'isCurrentAccountAnswer', 'percent'])) {
      throw HttpError.invalidData;
    }
    return RemoteSurveyAnswerModel(
        image: json['image'],
        answer: json['answer'],
        isCurrentAccountAnswer: json['isCurrentAccountAnswer'],
        percent: json['percent']);
  }

  SurveyAnswerEntity toEntity() => SurveyAnswerEntity(
      image: image,
      answer: answer,
      isCurrentAnswer: isCurrentAccountAnswer,
      percent: percent);
}
