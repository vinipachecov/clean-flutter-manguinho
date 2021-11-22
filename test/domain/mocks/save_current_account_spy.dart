import 'package:mocktail/mocktail.dart';
import 'package:clean_flutter_manguinho/domain/helpers/helpers.dart';
import 'package:clean_flutter_manguinho/domain/usecases/usecases.dart';

class SaveCurrentAccountSpy extends Mock implements SaveCurrentAccount {
  SaveCurrentAccountSpy() {
    this.mockSaveCurrentAccount();
  }
  When mockSaveCurrentAccountCall() => when(() => this.save(any()));

  void mockSaveCurrentAccount() =>
      this.mockSaveCurrentAccountCall().thenAnswer((_) async => null);

  void mockSaveCurrentAccountError() {
    mockSaveCurrentAccountCall().thenThrow((DomainError.unexpected));
  }
}
