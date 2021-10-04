import 'package:clean_flutter_manguinho/domain/entities/account_entity.dart';
import 'package:faker/faker.dart';

class FakeAccountFactory {
  static Map makeApiJson() =>
      {'accessToken': faker.guid.guid(), 'name': faker.person.name()};

  static AccountEntity makeEntity() => AccountEntity(faker.guid.guid());
}
