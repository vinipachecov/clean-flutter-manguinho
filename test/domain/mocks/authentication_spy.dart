import 'package:clean_flutter_manguinho/domain/entities/account_entity.dart';
import 'package:clean_flutter_manguinho/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class AuthenticationSpy extends Mock implements Authentication {
  When mockAuthenticationCall() => when(() => this.auth(any()));

  void mockAuthentication(AccountEntity data) {
    mockAuthenticationCall().thenAnswer((_) async => data);
  }

  void mockAuthenticationError(error) {
    mockAuthenticationCall().thenThrow((error));
  }
}
