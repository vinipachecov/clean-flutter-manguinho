import '../survey_result.dart';
import 'package:flutter/material.dart';

class SurveyResult extends StatelessWidget {
  final SurveyResultViewModel viewmodel;
  SurveyResult(this.viewmodel);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: viewmodel.answers.length + 1,
        itemBuilder: (ctx, index) {
          if (index == 0) {
            return Container(
                padding:
                    EdgeInsets.only(top: 40, bottom: 20, left: 20, right: 20),
                decoration: BoxDecoration(
                  color: Theme.of(context).disabledColor.withAlpha(90),
                ),
                child: Text(viewmodel.question));
          }

          return Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                ),
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    viewmodel.answers[index - 1].image != null
                        ? Image.network(
                            viewmodel.answers[index - 1].image,
                            width: 40,
                          )
                        : SizedBox(height: 0),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(viewmodel.answers[index - 1].answer,
                          style: TextStyle(fontSize: 16)),
                    )),
                    Text(viewmodel.answers[index - 1].percent,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColorDark)),
                    viewmodel.answers[index - 1].isCurrentAnswer
                        ? ActiveIcon()
                        : DisabledIcon()
                  ],
                ),
              ),
              Divider(height: 1)
            ],
          );
        });
  }
}

class ActiveIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10),
      child: Icon(Icons.check_circle, color: Theme.of(context).highlightColor),
    );
  }
}

class DisabledIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10),
      child: Icon(Icons.check_circle, color: Theme.of(context).disabledColor),
    );
  }
}
