


import '../../../domain/usecases/usecases.dart';
import '../../../data/usecases/authentication/remote_authentication.dart';
import '../factories.dart';

Authentication makeRemoteAuthentication() {
  return RemoteAuthentication(
    httpClient: makeHttpAdapter(),
    url: makeApiUrl('login')
  );
}