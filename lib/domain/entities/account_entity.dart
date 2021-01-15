import 'package:clean_flutter_manguinho/domain/entities/entities.dart';

class AccountEntity {
  final String token;

  AccountEntity(this.token);

  factory AccountEntity.fromJson(Map json) => AccountEntity(json['accessToken']);
}