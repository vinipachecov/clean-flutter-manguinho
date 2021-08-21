import '../survey_result.dart';
import 'package:flutter/material.dart';
import './components.dart';

class SurveyResult extends StatelessWidget {
  final SurveyResultViewModel viewModel;
  void Function({@required String answer}) onSave;
  SurveyResult({@required this.viewModel, @required this.onSave});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: viewModel.answers.length + 1,
        itemBuilder: (ctx, index) {
          if (index == 0) {
            return SurveyHeader(viewModel.question);
          }

          return GestureDetector(
              onTap: () => onSave(answer: viewModel.answers[index - 1].answer),
              child: SurveyAnswer(viewModel: viewModel.answers[index - 1]));
        });
  }
}
