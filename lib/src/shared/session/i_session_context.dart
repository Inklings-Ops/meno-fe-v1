import 'package:dartz/dartz.dart';
import 'package:meno_fe_v1/src/features/auth/auth.dart';
import 'package:meno_fe_v1/src/shared/shared.dart' show Token;

abstract class ISessionContext {
  Future<void> logout();

  Future<Either<AuthException, UserCredential>> switchAccount(
    UserCredential credential,
  );

  bool get isOnboarded;

  UserCredential? get credential;

  Future<List<UserCredential>> get allCredentials;

  Stream<UserCredential?> get userChanges;

  Future<void> refresh();

  Future<Token?> getCurrentAuthToken();
}
