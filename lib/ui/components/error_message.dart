import 'package:flutter/material.dart';

void showErrorMessage(context, error) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.red[900],
      content: Text(
        error,
        textAlign: TextAlign.center,
      )));
}
