import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meno/core/core.dart';
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

  final _activeUserId = ValueNotifier<Option<Id>>(const None());

  final _accounts = ValueNotifier<Map<Id, UserCredential>>({});

  @override
  ValueListenable<Option<Id>> get activeUserId => _activeUserId;

  @override
  ValueListenable<Map<Id, UserCredential>> get accounts => _accounts;

  @override
  Option<UserCredential> get currentCredential => _activeUserId.value.flatMap(
    (id) => Option.fromNullable(_accounts.value[id]),
  );

  @override
  Future<Either<AuthException, Unit>> changePassword({
    required Password currentPassword,
    required Password newPassword,
  }) {
    // TODO: implement changePassword
    throw UnimplementedError();
  }

  @override
  Future<Either<AuthException, UserCredential>> googleSignIn() {
    // TODO: implement googleSignIn
    throw UnimplementedError();
  }

  @override
  Future<void> initialize([UserCredential? refreshed]) async {
    if (refreshed != null) return _updateAccountInternal(refreshed);

    try {
      final dtos = await _local.getAllAccounts();
      final list = dtos.map((i, d) => MapEntry(Id.fromString(i), d.toDomain));
      _accounts.value = list;

      final credentialDto = await _local.getCredential();
      if (credentialDto != null) {
        final activeId = credentialDto.user.id;
        final domainCredential = credentialDto.toDomain;

        // Integrity Check: Ensure Active User exists in Vault
        if (list.containsKey(Id.fromString(activeId))) {
          // Sync Memory
          if (domainCredential.session.isExpired) {
            // Logic choice: Auto-logout or allow refresh?
            // For safety, if strictly expired, we might clear active state
            // But usually, we let the Interceptor handle the 401 later.
            // Here we just set the ID.
            _activeUserId.value = Some(Id.fromString(activeId));
          } else {
            _activeUserId.value = Some(Id.fromString(activeId));
          }
        } else {
          // Corruption: Active ID exists but data missing. Clear it.
          await _local.clearCredential();
          _activeUserId.value = const None();
        }
      } else {
        _activeUserId.value = const None();
      }
    } catch (e) {
      // Initialization failure - start with no auth
      _activeUserId.value = const None();
    }
  }

  @override
  bool get isEmailVerified {
    final credential = currentCredential;
    return credential.match(() => false, (cred) => cred.user.verified);
  }

  @override
  Future<Either<AuthException, UserCredential>> login({
    required Email email,
    required Password password,
  }) async {
    try {
      final dto = await _remote.login(
        email.getOrCrash(),
        password.getOrCrash(),
      );

      return _handleSuccessfulAuth(dto);
    } on MenoException catch (e) {
      // Translate infrastructure exception to domain exception
      return Left(AuthSystemFailure.fromMeno(e));
    } catch (e) {
      // Unexpected error
      return Left(AuthSystemFailure(e.toString()));
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _local.clearCredential();
      _activeUserId.value = const None();
      // await _loadStoredAccounts();
    } catch (e) {
      // Logout should always succeed, even if storage fails
      _activeUserId.value = none();
    }
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

  // ========================================================================
  // INTERNAL HELPERS
  // ========================================================================
  /// Shared logic for Login/Register success
  Future<Either<AuthException, UserCredential>> _handleSuccessfulAuth(
    UserCredentialDto dto,
  ) async {
    // Persist to Local Storage (Hot Keys + Vault)
    await _local.saveCredential(dto);

    // Update In-Memory Vault
    final credential = dto.toDomain;
    _updateAccountInternal(credential);

    // Update Anchor (should trigger router)
    _activeUserId.value = Some(credential.user.id);
    return Right(credential);
  }

  /// Called by Interceptor to keep memory in sync
  void _updateAccountInternal(UserCredential credential) {
    final newMap = Map<Id, UserCredential>.from(_accounts.value);
    newMap[credential.user.id] = credential;
    _accounts.value = newMap;
  }

  @override
  void dispose() {
    _activeUserId.dispose();
    _accounts.dispose();
  }
}
