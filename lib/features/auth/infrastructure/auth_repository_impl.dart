import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meno/features/auth/domain/domain.dart';
import 'package:meno/features/auth/infrastructure/infrastructure.dart';
import 'package:meno/shared/shared.dart';

final class AuthRepositoryImpl implements IAuthRepository {
  AuthRepositoryImpl({
    required AuthLocalDataSource local,
    required AuthRemoteDataSource remote,
  }) : _local = local,
       _remote = remote;

  final AuthLocalDataSource _local;
  final AuthRemoteDataSource _remote;

  // We use ValueNotifier to hold the state
  final _authState = ValueNotifier<Option<UserCredential>>(none());

  @override
  // TODO: implement authState
  ValueListenable<Option<UserCredential>> get authState =>
      throw UnimplementedError();

  @override
  Future<Either<AuthException, Unit>> changePassword({
    required Password currentPassword,
    required Password newPassword,
  }) {
    // TODO: implement changePassword
    throw UnimplementedError();
  }

  @override
  // TODO: implement currentCredential
  Option<UserCredential> get currentCredential => throw UnimplementedError();

  @override
  Future<Either<AuthException, UserCredential>> googleSignIn() {
    // TODO: implement googleSignIn
    throw UnimplementedError();
  }

  @override
  Future<void> initialize() {
    // TODO: implement initialize
    throw UnimplementedError();
  }

  @override
  // TODO: implement isEmailVerified
  bool get isEmailVerified => throw UnimplementedError();

  @override
  Future<Either<AuthException, UserCredential>> login({
    required Email email,
    required Password password,
  }) async {
    final res = await _remote.login(email.getOrCrash(), password.getOrCrash());
    return res.match(
      (exception) => Left(AuthSystemFailure.fromMeno(exception)),
      (credentialDto) async {
        await _local.saveCredential(credentialDto);
        final credential = credentialDto.toDomain;
        _authState.value = some(credential);
        return Right(credential);
      },
    );
  }

  @override
  Future<void> logout() async {
    await _local.clearCredential();
    _authState.value = none();
  }

  @override
  Future<Either<AuthException, UserCredential>> register({
    required SingleLineString fullName,
    required Email email,
    required Password password,
    required TermsAcceptance terms,
    MultiLineString? bio,
    ImageInput? avatar,
  }) {
    // TODO: implement register
    throw UnimplementedError();
  }

  @override
  Future<void> removeAccount(Id userId) {
    // TODO: implement removeAccount
    throw UnimplementedError();
  }

  @override
  Future<Either<AuthException, Unit>> requestOtp({
    required Email email,
    required OtpType type,
  }) {
    // TODO: implement requestOtp
    throw UnimplementedError();
  }

  @override
  Future<Either<AuthException, Unit>> resetPassword({
    required Email email,
    required String code,
    required Password newPassword,
  }) {
    // TODO: implement resetPassword
    throw UnimplementedError();
  }

  @override
  // TODO: implement storedAccounts
  ValueListenable<Map<Id, UserCredential>> get storedAccounts =>
      throw UnimplementedError();

  @override
  Future<Either<AuthException, Unit>> switchAccount(Id userId) {
    // TODO: implement switchAccount
    throw UnimplementedError();
  }

  @override
  Future<Either<AuthException, Unit>> verifyEmail({
    required Email email,
    required String code,
  }) {
    // TODO: implement verifyEmail
    throw UnimplementedError();
  }
}
