import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clean_flutter_manguinho/ui/helpers/errors/ui_error.dart';
import '../login_presenter.dart';

class EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<LoginPresenter>(context);
    return StreamBuilder<UIError>(
      stream: presenter.emailErrorStream,
      builder: (context, snapshot) {
        return TextFormField(
          decoration: InputDecoration(
            labelText: 'Email',
            icon: Icon(Icons.email, color: Theme.of(context).primaryColorLight),
            errorText : snapshot.hasData ? snapshot.data.description : null
          ),
          keyboardType: TextInputType.emailAddress,
          onChanged: presenter.validateEmail,
        );
      }
    );
  }
}

