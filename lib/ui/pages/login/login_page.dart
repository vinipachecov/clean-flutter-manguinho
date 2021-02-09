import 'package:clean_flutter_manguinho/ui/pages/login/components/email_input.dart';
import 'package:flutter/material.dart';
import '../../components/components.dart';
import './login_presenter.dart';
import './components/components.dart';
class LoginPage extends StatelessWidget {
  final LoginPresenter presenter;

  LoginPage(this.presenter);

  @override
  Widget build(BuildContext context) {

    void _hideKeyboard() {
      final currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
    }

    return Scaffold(
      body: Builder(
        builder: (context) {
          //
          presenter.isLoading.listen((isLoading) {
            if (isLoading) {
              showLoading(context);
            }
            else {
              hideLoading(context);
            }
          });

          presenter.mainError.listen((error) {
            if (error != null) {
              showErrorMessage(context, error);
            }
          });
          return GestureDetector(
            onTap: _hideKeyboard,
            child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LoginHeader(),
                Headline1(text: 'Login',),
                Padding(
                  padding: const EdgeInsets.all(32),
                  child:  Form(
                      child: Column(
                        children: [
                          EmailInput(),
                          Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 32),
                            child: PasswordInput(),
                          ),
                          LoginButton(),
                          FlatButton.icon(
                              onPressed: () {},
                              icon: Icon(Icons.person),
                              label: Text('Criar Conta'))
                        ],
                      ),
                    ),
                  ),
              ],
            ),
        ),
          );
        },
      ),
    );
  }
}
