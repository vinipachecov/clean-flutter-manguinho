// import 'dart:async';

// import 'package:meta/meta.dart';

// import 'package:clean_flutter_manguinho/domain/usecases/usecases.dart';
// import 'package:clean_flutter_manguinho/domain/helpers/helpers.dart';
// import 'package:clean_flutter_manguinho/presentation/protocols/protocols.dart';
// import 'package:clean_flutter_manguinho/ui/pages/pages.dart';


// class LoginState {
//   String email;
//   String password;
//   String emailError;
//   String passwordError;
//   String mainError;
//   bool isLoading = false;
//   bool get isFormValid =>  emailError == null
//     &&  passwordError == null
//     &&  email != null
//     &&  password != null;
// }

// class StreamLoginPresenter implements LoginPresenter {
//   var _controller = StreamController<LoginState>.broadcast();
//   final Validation validation;
//   final Authentication authentication;
//   var _state = LoginState();

//   Stream<String> get emailErrorStream => _controller?.stream?.map((state) => state.emailError)?.distinct();
//   Stream<String> get passwordErrorStream => _controller?.stream?.map((state) => state.passwordError)?.distinct();
//     Stream<String> get mainErrorStream => _controller?.stream?.map((state) => state.mainError)?.distinct();
//   Stream<bool> get isFormValidStream => _controller?.stream?.map((state) => state.isFormValid)?.distinct();
//   Stream<bool> get isLoadingStream => _controller?.stream?.map((state) => state.isLoading)?.distinct();


//   StreamLoginPresenter({@required this.validation, @required this.authentication});

//   void _update() => _controller?.add(_state);
//   void validateEmail(String email) {
//     _state.email = email;
//     _state.emailError = validation.validate(field: 'email', value: email);
//     _update();
//   }

//   void validatePassword(String password) {
//     _state.password = password;
//     _state.passwordError = validation.validate(field: 'password', value: password);
//     _update();
//   }

//   Future<void> auth() async {
//     _state.isLoading = true;
//     _update();
//     try {
//       await authentication.auth(AuthenticationParams(email: _state.email, secret: _state.password));
//     } on DomainError catch (error) {
//       _state.mainError = error.description;
//     }
//     _state.isLoading = false;
//     _update();
//   }

//   void dispose() {
//     _controller.close();
//     _controller = null;
//   }
// }
