import 'dart:async';

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
       _remote = remote {
    _tokenSubscription = _local.onCredentialChanged.listen(_onAuthChanged);
  }

  final AuthLocalDataSource _local;
  final AuthRemoteDataSource _remote;

  final _activeUserId = ValueNotifier<Option<Id>>(const None());
  final _accounts = ValueNotifier<Map<Id, UserCredential>>({});
  final _lastKnownUser = ValueNotifier<Option<User>>(const None());

  StreamSubscription<UserCredentialDto?>? _tokenSubscription;

  @override
  ValueListenable<Option<Id>> get activeUserId => _activeUserId;

  @override
  ValueListenable<Map<Id, UserCredential>> get accounts => _accounts;

  @override
  ValueListenable<Option<User>> get lastKnownUser => _lastKnownUser;

  @override
  void clearLastKnownUser() => _lastKnownUser.value = const None();

  @override
  bool get isEmailVerified {
    final credential = currentCredential;
    return credential.match(() => false, (cred) => cred.user.verified);
  }

  @override
  Option<UserCredential> get currentCredential => _activeUserId.value.flatMap(
    (id) => Option.fromNullable(_accounts.value[id]),
  );

  @override
  Future<void> initialize([UserCredential? refreshed]) async {
    if (refreshed != null) return _updateAccountInternal(refreshed);

    try {
      final dtos = await _local.getAllAccounts();
      final map = dtos.map((i, d) => MapEntry(Id.fromString(i), d.toDomain));
      _accounts.value = map;

      final credentialDto = await _local.getCredential();
      if (credentialDto != null) {
        final activeId = Id.fromString(credentialDto.user.id);
        final domainCredential = credentialDto.toDomain;
        final user = domainCredential.user;

        _lastKnownUser.value = some(user);

        // Integrity Check: Ensure Active User exists in Vault
        if (map.containsKey(activeId)) {
          if (domainCredential.session.isExpired) {
            // Session expired - clear active ID but keep lastKnownUser
            // This creates the "partially authenticated" state
            _activeUserId.value = const None();

            // Optionally: Clear the expired credential from hot storage
            // but keep it in vault for "Welcome back" display
            await _local.clearCredential();
          } else {
            // Valid session - set active user
            _activeUserId.value = some(activeId);
          }
        } else {
          // Corruption: Active ID exists but data missing
          await _local.clearCredential();
          _activeUserId.value = const None();
          _lastKnownUser.value = const None();
        }
      } else {
        // No active credential - check if we have any accounts in vault
        if (map.isNotEmpty) {
          // User logged out but we have stored accounts
          // Get the most recent user for "Welcome back"
          final mostRecentUser = map.values.first.user;
          _lastKnownUser.value = some(mostRecentUser);
        } else {
          _lastKnownUser.value = const None();
        }

        _activeUserId.value = const None();
      }
    } catch (error) {
      // Initialization failure - start with no auth
      _activeUserId.value = const None();
      _lastKnownUser.value = const None();
    }
  }

  @override
  Future<Either<MenoException, UserCredential>> login(
    Email email,
    Password password,
  ) async {
    try {
      final dto = await _remote.login(
        email.getOrCrash(),
        password.getOrCrash(),
      );

      return _handleSuccessfulAuth(dto);
    } on MenoException catch (exception) {
      return Left(exception);
    } catch (error) {
      return Left(MenoException(error.toString()));
    }
  }

  @override
  Future<void> logout() async {
    try {
      // Keep lastKnownUser for "Welcome back" on next visit
      // Only clear active session
      await _local.clearCredential();
      _activeUserId.value = const None();

      // Note: We intentionally DON'T clear _lastKnownUser here
      // so the user sees "Welcome back" when they return
    } catch (error) {
      // Logout should always succeed
      _activeUserId.value = const None();
    }
  }

  @override
  Future<Either<MenoException, UserCredential>> register({
    required SingleLineString fullName,
    required Email email,
    required Password password,
    required TermsAcceptance terms,
  }) async {
    try {
      final dto = await _remote.register(
        fullName: fullName.getOrCrash(),
        email: email.getOrCrash(),
        password: password.getOrCrash(),
      );

      return _handleSuccessfulAuth(dto);
    } on MenoException catch (exception) {
      return Left(exception);
    } catch (error) {
      return Left(MenoException(error.toString()));
    }
  }

  @override
  Future<Either<MenoException, Unit>> changePassword({
    required Password currentPassword,
    required Password newPassword,
  }) {
    // TODO: implement changePassword
    throw UnimplementedError();
  }

  @override
  Future<Either<MenoException, UserCredential>> googleSignIn() {
    // TODO: implement googleSignIn
    throw UnimplementedError();
  }

  @override
  Future<void> removeAccount(Id userId) {
    // TODO: implement removeAccount
    throw UnimplementedError();
  }

  @override
  Future<Either<MenoException, Unit>> requestOtp({
    required Email email,
    required OtpType type,
  }) {
    // TODO: implement requestOtp
    throw UnimplementedError();
  }

  @override
  Future<Either<MenoException, Unit>> resetPassword({
    required Email email,
    required String code,
    required Password newPassword,
  }) {
    // TODO: implement resetPassword
    throw UnimplementedError();
  }

  @override
  Future<Either<MenoException, Unit>> switchAccount(Id userId) async {
    try {
      final targetIdStr = userId.getOrCrash();

      // Overwrite hot keys in secure storage (Vault → Hot Cache)
      await _local.switchActiveUser(targetIdStr);

      // Look up the full credential from the in-memory vault
      final cred = _accounts.value[userId];
      if (cred == null) return const Left(MenoException('Account not found'));

      _activeUserId.value = some(userId);
      _lastKnownUser.value = some(cred.user);

      return const Right(unit);
    } on StorageException catch (e) {
      return Left(MenoException(e.message));
    } catch (e) {
      return Left(MenoException(e.toString()));
    }
  }

  @override
  Future<Either<MenoException, Unit>> verifyEmail({
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
  Future<Either<MenoException, UserCredential>> _handleSuccessfulAuth(
    UserCredentialDto dto,
  ) async {
    // Persist to Local Storage (Hot Keys + Vault)
    await _local.saveCredential(dto);

    // Update In-Memory State
    final credential = dto.toDomain;
    _updateAccountInternal(credential);

    // Update last known user
    _lastKnownUser.value = some(credential.user);

    // Update active user ID (triggers router)
    _activeUserId.value = some(credential.user.id);

    return Right(credential);
  }

  /// Called by Interceptor to keep memory in sync
  void _updateAccountInternal(UserCredential credential) {
    final newMap = Map<Id, UserCredential>.from(_accounts.value);
    newMap[credential.user.id] = credential;
    _accounts.value = newMap;

    // Also update lastKnownUser
    _lastKnownUser.value = some(credential.user);
  }

  void _onAuthChanged(UserCredentialDto? dto) {
    if (dto == null) {
      // Case: Session Expired (Token deleted)
      _activeUserId.value = const None();
      // We do NOT clear accounts (Soft Logout)
    } else {
      // Case: Token Refreshed / Login
      final credential = dto.toDomain;

      // 1. Update Vault
      _updateAccountInternal(credential);

      // 2. Update State
      _activeUserId.value = some(credential.user.id);
      _lastKnownUser.value = some(credential.user);
    }
  }

  @override
  FutureOr<dynamic> onDispose() {
    _activeUserId.dispose();
    _accounts.dispose();
    _lastKnownUser.dispose();
    _tokenSubscription?.cancel();
  }
}
