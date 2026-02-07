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

  final _authState = ValueNotifier<Option<UserCredential>>(none());

  @override
  ValueListenable<Option<UserCredential>> get authState => _authState;

  @override
  Future<Either<AuthException, Unit>> changePassword({
    required Password currentPassword,
    required Password newPassword,
  }) {
    // TODO: implement changePassword
    throw UnimplementedError();
  }

  @override
  Option<UserCredential> get currentCredential => _authState.value;

  @override
  Future<Either<AuthException, UserCredential>> googleSignIn() {
    // TODO: implement googleSignIn
    throw UnimplementedError();
  }

  @override
  Future<void> initialize([UserCredential? credential]) async {
    if (credential != null) {
      await _checkExpiryAndUpdateState(credential);
    } else {
      final credentialDto = await _local.getCredential();
      credentialDto.match(() => _authState.value = none(), (dto) async {
        await _checkExpiryAndUpdateState(dto.toDomain);
      });
    }
  }

  @override
  bool get isEmailVerified {
    final credential = _authState.value;
    return credential.match(() => false, (cred) => cred.user.verified);
  }

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

  @override
  void dispose() {
    _authState.dispose();
  }

  // ========================================================================
  // SUPPORTING METHODS
  // ========================================================================
  Future<void> _checkExpiryAndUpdateState(UserCredential credential) async {
    if (credential.session.isExpired) {
      await _local.clearCredential();
      _authState.value = none();
    } else {
      _authState.value = some(credential);
    }
  }
}
