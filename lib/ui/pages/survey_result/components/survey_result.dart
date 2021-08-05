import '../survey_result.dart';
import 'package:flutter/material.dart';
import './components.dart';

class SurveyResult extends StatelessWidget {
  final SurveyResultViewModel viewModel;
  SurveyResult(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: viewModel.answers.length + 1,
        itemBuilder: (ctx, index) {
          if (index == 0) {
            return SurveyHeader(viewModel.question);
          }

          return SurveyAnswer(viewModel: viewModel.answers[index - 1]);
        });
  }
}
