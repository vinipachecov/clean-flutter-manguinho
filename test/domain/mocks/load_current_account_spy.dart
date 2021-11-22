import 'package:mocktail/mocktail.dart';
import 'package:clean_flutter_manguinho/domain/entities/account_entity.dart';
import 'package:clean_flutter_manguinho/domain/usecases/load_current_account.dart';

class LoadCurrentAccountSpy extends Mock implements LoadCurrentAccount {
  When mockLoadCall() {
    return when(() => this.load());
  }

  void mockLoad({required AccountEntity account}) {
    this.mockLoadCall().thenAnswer((_) async => account);
  }

  mockLoadError() {
    this.mockLoadCall().thenThrow(Exception());
  }
}
