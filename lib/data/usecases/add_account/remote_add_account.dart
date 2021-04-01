import 'package:clean_flutter_manguinho/data/http/http.dart';
import 'package:clean_flutter_manguinho/data/models/remote_account_model.dart';
import 'package:clean_flutter_manguinho/domain/entities/account_entity.dart';
import 'package:clean_flutter_manguinho/domain/helpers/helpers.dart';


import 'package:meta/meta.dart';

import '../../../domain/usecases/usecases.dart';
import '../../http/http_client.dart';

class RemoteAddAccount implements AddAccount {
  final HttpClient httpClient;
  final String url;

  RemoteAddAccount({@required this.httpClient, @required this.url});

  Future<AccountEntity> add(AddAccountParams params) async {
    try {
      final body = RemoteAddAccountParams.fromDomain(params).toJson();
      final httpResponse = await httpClient.request(
          url: url,
          method: 'post',
          body: body
      );
      return RemoteAccountModel.fromJson(httpResponse).toEntity();
    } on HttpError catch (error) {
      throw error == HttpError.forbidden
        ? DomainError.emailInUse
        : DomainError.unexpected;
    }
  }
}

class RemoteAddAccountParams {

  final String name;
  final String password;
  final String passwordConfirmation;
  final String email;

  RemoteAddAccountParams({
    @required this.name,
    @required this.email,
    @required this.password,
    @required this.passwordConfirmation
    });

  factory RemoteAddAccountParams.fromDomain(AddAccountParams params) =>
      RemoteAddAccountParams(
        name: params.name,
        email: params.email,
        password: params.password,
        passwordConfirmation: params.passwordConfirmation,
      );

  Map toJson() => {
    'name': name,
    'email': email,
    'password': password,
    'passwordConfirmation': passwordConfirmation,
    };
}
