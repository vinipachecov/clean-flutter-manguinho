


import '../../../domain/usecases/usecases.dart';
import 'package:clean_flutter_manguinho/data/usecases/add_account/remote_add_account.dart';
import '../factories.dart';

AddAccount makeRemoteAddAccount() {
  return RemoteAddAccount(
    httpClient: makeHttpAdapter(),
    url: makeApiUrl('signup')
  );
}