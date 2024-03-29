import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../helpers/helpers.dart';
import '../login_presenter.dart';

class EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<LoginPresenter>(context);
    return StreamBuilder<UIError?>(
        stream: presenter.emailErrorStream,
        builder: (context, snapshot) {
          return TextFormField(
            onChanged: (value) {
              presenter.validateEmail(value);
            },
            decoration: InputDecoration(
                labelText: R.strings.email,
                icon: Icon(Icons.email,
                    color: Theme.of(context).primaryColorLight),
                errorText: snapshot.data?.description),
            keyboardType: TextInputType.emailAddress,
          );
        });
  }
}
