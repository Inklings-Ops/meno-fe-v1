import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_core/_core.dart';
import 'package:meno/_di/user_scope_locator.dart';
import 'package:meno/_shared/_shared.dart';
import 'package:meno/features/auth/auth.dart';

class AuthManager extends ChangeNotifier implements Disposable {
  AuthManager(this._http, this._local) {
    _subscription = _local.onCredentialChanged.listen(_onAuthChanged);

    login = Command.createAsync<LoginArgs, UserCredential>(
      (args) async {
        final dto = await _http.login(
          email: args.email.getOrCrash(),
          password: args.password.getOrCrash(),
        );
        return _handleSuccessfulAuth(dto);
      },
      initialValue: UserCredential.empty,
      errorFilterFn: menoExceptionFilter,
    );

    register = Command.createAsync<RegisterArgs, UserCredential>(
      (args) async {
        final dto = await _http.register(
          fullName: args.fullName.getOrCrash(),
          email: args.email.getOrCrash(),
          password: args.password.getOrCrash(),
        );
        return _handleSuccessfulAuth(dto);
      },
      initialValue: UserCredential.empty,
      errorFilterFn: menoExceptionFilter,
    );

    googleSignIn = Command.createAsync<String, UserCredential>(
      (idToken) async {
        final dto = await _http.googleSignIn(idToken: idToken);
        return _handleSuccessfulAuth(dto);
      },
      initialValue: UserCredential.empty,
      errorFilterFn: menoExceptionFilter,
    );

    googleSignUp = Command.createAsync<String, UserCredential>(
      (idToken) async {
        final dto = await _http.googleSignUp(idToken: idToken);
        return _handleSuccessfulAuth(dto);
      },
      initialValue: UserCredential.empty,
      errorFilterFn: menoExceptionFilter,
    );

    logout = Command.createAsyncNoParamNoResult(() async {
      await _local.clearCredential();
      _activeUserId.value = Id.empty;
    }, errorFilterFn: menoExceptionFilter);

    switchAccount = Command.createAsyncNoResult<Id>((userId) async {
      final targetIdStr = userId.getOrCrash();
      await _local.switchActiveUser(targetIdStr);

      final accounts = _accounts.value;
      final credential = accounts[userId];
      if (credential == null) throw const MenoException('Account not found');

      _activeUserId.value = userId;
      _lastKnownUser.value = credential.user;
    }, errorFilterFn: menoExceptionFilter);

    addAccount = Command.createAsyncNoParamNoResult(() async {
      _activeUserId.value = Id.empty;
      _lastKnownUser.value = User.empty;
      await _local.clearCredential();
    }, errorFilterFn: menoExceptionFilter);

    requestOtp = Command.createAsyncNoResult<OtpRequestArgs>(
      (args) => _http.requestOtp(
        email: args.email.getOrCrash(),
        type: args.type.value,
      ),
      errorFilterFn: menoExceptionFilter,
    );

    verifyEmail = Command.createAsyncNoResult<VerifyEmailArgs>(
      (args) =>
          _http.verifyEmail(email: args.email.getOrCrash(), code: args.code),
      errorFilterFn: menoExceptionFilter,
    );

    resetPassword = Command.createAsyncNoResult<ResetPasswordArgs>(
      (args) => _http.resetPassword(
        email: args.email.getOrCrash(),
        code: args.code,
        newPassword: args.newPassword.getOrCrash(),
      ),
      errorFilterFn: menoExceptionFilter,
    );

    changePassword = Command.createAsyncNoResult<ChangePasswordArgs>(
      (args) => _http.changePassword(
        currentPassword: args.currentPassword.getOrCrash(),
        newPassword: args.newPassword.getOrCrash(),
      ),
      errorFilterFn: menoExceptionFilter,
    );

    deleteAccount = Command.createAsyncNoParamNoResult(() async {
      await _http.deleteUser();
    }, errorFilterFn: menoExceptionFilter)..pipeToCommand(logout);
  }

  final AuthHttpService _http;
  final AuthLocalService _local;

  final _activeUserId = ValueNotifier<Id>(Id.empty);
  final _accounts = ValueNotifier<Map<Id, UserCredential>>({});
  final _lastKnownUser = ValueNotifier<User>(User.empty);

  StreamSubscription<UserCredentialDto?>? _subscription;

  // ======================================================================
  // STATE ACCESSORS
  // ======================================================================

  ValueListenable<Id> get activeUserId => _activeUserId;

  ValueListenable<Map<Id, UserCredential>> get accounts => _accounts;

  ValueListenable<User> get lastKnownUser => _lastKnownUser;

  bool get isAuthenticated => _activeUserId.value.isValid;

  ValueListenable<UserCredential> get currentCredential {
    return _activeUserId.combineLatest(
      _accounts,
      (id, accounts) => accounts[id] ?? UserCredential.empty,
    );
  }

  ValueListenable<User> get currentUser {
    return _activeUserId.combineLatest(
      _accounts,
      (id, accounts) => accounts[id]?.user ?? .empty,
    );
  }

  // ======================================================================
  // COMMANDS
  // ======================================================================

  late final Command<LoginArgs, UserCredential> login;
  late final Command<RegisterArgs, UserCredential> register;
  late final Command<String, UserCredential> googleSignIn;
  late final Command<String, UserCredential> googleSignUp;
  late final Command<void, void> logout;
  late final Command<Id, void> switchAccount;
  late final Command<void, void> addAccount;
  late final Command<OtpRequestArgs, void> requestOtp;
  late final Command<VerifyEmailArgs, void> verifyEmail;
  late final Command<ResetPasswordArgs, void> resetPassword;
  late final Command<ChangePasswordArgs, void> changePassword;
  late final Command<void, void> deleteAccount;

  // ======================================================================
  // INITIALIZATION
  // ======================================================================

  Future<void> init() async {
    try {
      final dtos = await _local.getAllAccounts();
      final map = dtos.map((i, d) => MapEntry(Id.fromString(i), d.toDomain));
      _accounts.value = map;

      final credentialDto = await _local.getCredential();
      if (credentialDto != null) {
        final activeId = Id.fromString(credentialDto.user.id);
        final domainCredential = credentialDto.toDomain;
        final user = domainCredential.user;

        _lastKnownUser.value = user;

        if (map.containsKey(activeId)) {
          if (domainCredential.session.isExpired) {
            _activeUserId.value = .empty;
            await _local.clearCredential();
          } else {
            _activeUserId.value = activeId;
          }
        } else {
          await _local.clearCredential();
          _activeUserId.value = .empty;
          _lastKnownUser.value = .empty;
        }
      } else if (map.isNotEmpty) {
        final mostRecentUser = map.values.first.user;
        _lastKnownUser.value = mostRecentUser;
        _activeUserId.value = .empty;
      } else {
        _activeUserId.value = .empty;
        _lastKnownUser.value = .empty;
      }
    } catch (error) {
      _activeUserId.value = .empty;
      _lastKnownUser.value = .empty;
    }
  }

  // ======================================================================
  // INTERNAL HELPERS
  // ======================================================================

  Future<UserCredential> _handleSuccessfulAuth(UserCredentialDto dto) async {
    await _local.saveCredential(dto);
    final credential = dto.toDomain;

    _updateAccountInternal(credential);
    _lastKnownUser.value = credential.user;
    _activeUserId.value = credential.user.id;

    return credential;
  }

  void _updateAccountInternal(UserCredential credential) {
    final newMap = Map<Id, UserCredential>.from(_accounts.value);
    newMap[credential.user.id] = credential;
    _accounts.value = newMap;
    _lastKnownUser.value = credential.user;
  }

  void _onAuthChanged(UserCredentialDto? dto) {
    if (dto == null) {
      _activeUserId.value = .empty;

      popUserSessionScope();
    } else {
      final credential = dto.toDomain;

      _activeUserId.value = credential.user.id;
      _lastKnownUser.value = credential.user;

      _updateAccountInternal(credential);

      pushUserSessionScope(credential);
    }
  }

  @override
  FutureOr<dynamic> onDispose() {
    _activeUserId.dispose();
    _accounts.dispose();
    _lastKnownUser.dispose();
    _subscription?.cancel();
    login.dispose();
    register.dispose();
    googleSignIn.dispose();
    googleSignUp.dispose();
    logout.dispose();
    switchAccount.dispose();
    addAccount.dispose();
    requestOtp.dispose();
    verifyEmail.dispose();
    resetPassword.dispose();
    changePassword.dispose();
    deleteAccount.dispose();
  }
}

final class LoginArgs {
  const LoginArgs(this.email, this.password);

  final Email email;
  final Password password;
}

final class RegisterArgs {
  const RegisterArgs({
    required this.fullName,
    required this.email,
    required this.password,
  });

  final SingleLineString fullName;
  final Email email;
  final Password password;
}

final class OtpRequestArgs {
  const OtpRequestArgs({required this.email, required this.type});

  final Email email;
  final OtpType type;
}

final class VerifyEmailArgs {
  const VerifyEmailArgs({required this.email, required this.code});

  final Email email;
  final String code;
}

final class ResetPasswordArgs {
  const ResetPasswordArgs({
    required this.email,
    required this.code,
    required this.newPassword,
  });

  final Email email;
  final String code;
  final Password newPassword;
}

final class ChangePasswordArgs {
  const ChangePasswordArgs({
    required this.currentPassword,
    required this.newPassword,
  });

  final Password currentPassword;
  final Password newPassword;
}
