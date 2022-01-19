import 'package:flutter/material.dart';

Future<void> showLoading(BuildContext context) async {
  await Future.delayed(Duration.zero);
  await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => SimpleDialog(
            children: [
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                CircularProgressIndicator(),
                SizedBox(height: 10),
                Text(
                  'Aguarde..',
                  textAlign: TextAlign.center,
                )
              ])
            ],
          ));
}

void hideLoading(BuildContext context) {
  if (Navigator.canPop(context)) {
    Navigator.of(context).pop();
  }
}
