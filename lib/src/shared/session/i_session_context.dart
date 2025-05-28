import 'package:dartz/dartz.dart';
import 'package:meno_fe_v1/src/core/exceptions/exceptions.dart';
import 'package:meno_fe_v1/src/features/auth/auth.dart';

abstract class ISessionContext {
  Future<void> logout();

  Future<Either<AuthException, Unit>> switchAccount(UserCredential credential);

  bool get isOnboarded;

  UserCredential? get credential;

  Stream<UserCredential?> get userChanges;
  
  Stream<Map<String, UserCredential>> get allAccounts;
}
