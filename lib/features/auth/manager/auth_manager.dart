import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_core/_core.dart';
import 'package:meno/_shared/_shared.dart';
import 'package:meno/features/auth/auth.dart';

class AuthManager extends ChangeNotifier
    implements Disposable, WillSignalReady {
  AuthManager({
    required AuthHttpService http,
    required AuthLocalService local,
    required PushNotificationsService pushService,
  }) : _http = http,
       _local = local,
       _pushService = pushService {
    initialize = Command.createAsyncNoParamNoResult(
      _initialize,
      errorFilterFn: menoExceptionFilter,
    );

    login = Command.createAsync<LoginArgs, UserCredential>(
      (args) async {
        await _pushService.requestPermissions();
        final pushNotificationToken = await _pushService.getToken();

        final dto = await _http.login(
          email: args.email.getOrCrash(),
          password: args.password.getOrCrash(),
          pushNotificationToken: pushNotificationToken,
        );

        return _handleSuccessfulAuth(dto);
      },
      initialValue: UserCredential.empty,
      errorFilterFn: menoExceptionFilter,
    );

    register = Command.createAsync<RegisterArgs, UserCredential>(
      (args) async {
        await _pushService.requestPermissions();
        final pushNotificationToken = await _pushService.getToken();

        final dto = await _http.register(
          fullName: args.fullName.getOrCrash(),
          email: args.email.getOrCrash(),
          password: args.password.getOrCrash(),
          pushNotificationToken: pushNotificationToken,
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

      final credential = _accounts.value[userId];
      if (credential == null) throw const MenoException('Account not found');

      _activeUserId.value = userId;
      _lastKnownUser.value = credential.user;
      notifyListeners();
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

    verifyEmail = Command.createAsyncNoResult<VerifyEmailArgs>((args) async {
      await _http.verifyEmail(email: args.email.getOrCrash(), code: args.code);
      _emailVerified.value = false;
    }, errorFilterFn: menoExceptionFilter);

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
  final PushNotificationsService _pushService;

  final _activeUserId = ValueNotifier<Id>(Id.empty);
  final _accounts = ValueNotifier<Map<Id, UserCredential>>({});
  final _lastKnownUser = ValueNotifier<User>(User.empty);
  final _emailVerified = ValueNotifier<bool>(false);

  StreamSubscription<UserCredentialDto?>? _subscription;

  // ======================================================================
  // STATE ACCESSORS
  // ======================================================================

  ValueListenable<Id> get activeUserId => _activeUserId;

  ValueListenable<Map<Id, UserCredential>> get accounts => _accounts;

  ValueListenable<User> get lastKnownUser => _lastKnownUser;

  ValueListenable<bool> get emailVerified => _emailVerified;

  bool get isAuthenticated => _activeUserId.value.isValid;

  // ======================================================================
  // COMMANDS
  // ======================================================================

  late final Command<void, void> initialize;
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

  Future<void> _initialize() async {
    // Pause stream events during initialization to prevent _onAuthChanged
    // from firing against partially-built state. Any credential writes
    // that happen inside (e.g. clearCredential) emit on onCredentialChanged,
    // which must not be processed until the full state is consistent.
    _subscription?.pause();

    try {
      final dtos = await _local.getAllAccounts();
      _accounts.value = dtos.map(
        (i, d) => MapEntry(Id.fromString(i), d.toDomain),
      );
      await _restoreSession(dtos);
    } finally {
      // Always resume — even on error — so the stream stays active for
      // subsequent operations (login, switchAccount, etc).
      _subscription?.resume();
      GetIt.instance.signalReady(this);
    }
  }

  Future<void> _restoreSession(Map<String, UserCredentialDto> accounts) async {
    final credentialDto = await _local.getCredential();

    // No active credential stored — leave user on login screen.
    // _lastKnownUser stays empty: getAllAccounts() has no reliable ordering,
    // so we cannot safely infer which account was "most recent".
    if (credentialDto == null) {
      _activeUserId.value = Id.empty;
      _lastKnownUser.value = User.empty;

      return;
    }

    final activeId = Id.fromString(credentialDto.user.id);
    final credential = credentialDto.toDomain;
    final user = credential.user;

    _lastKnownUser.value = user;
    _emailVerified.value = user.verified;

    // The stored credential points to an account that no longer exists
    // in the accounts map (e.g. was deleted from another device).
    if (!accounts.containsKey(activeId.getOrCrash())) {
      await _local.clearCredential();
      _activeUserId.value = Id.empty;
      _lastKnownUser.value = User.empty;

      return;
    }

    // Session has expired — clear active credential, keep lastKnownUser
    // so the login screen can pre-fill the email field.
    if (credential.session.isExpired) {
      await _local.clearCredential();
      _activeUserId.value = Id.empty;

      return;
    }

    // Valid, unexpired session — restore the user scope.
    _activeUserId.value = activeId;
  }

  // ======================================================================
  // INTERNAL HELPERS
  // ======================================================================

  Future<UserCredential> _handleSuccessfulAuth(UserCredentialDto dto) async {
    final credential = dto.toDomain;

    _emailVerified.value = dto.user.verified;
    _lastKnownUser.value = credential.user;
    _updateAccountInternal(credential);

    await _local.saveCredential(dto);

    _activeUserId.value = credential.user.id;
    notifyListeners();
    return credential;
  }

  void _updateAccountInternal(UserCredential credential) {
    final newMap = Map<Id, UserCredential>.from(_accounts.value);
    newMap[credential.user.id] = credential;
    _accounts.value = newMap;
    _lastKnownUser.value = credential.user;
  }

  Future<void> _onAuthChanged(UserCredentialDto? dto) async {
    if (dto == null) {
      _activeUserId.value = Id.empty;
      notifyListeners();
      return;
    }
    final credential = dto.toDomain;
    _activeUserId.value = credential.user.id;
    _lastKnownUser.value = credential.user;
    notifyListeners();

    _updateAccountInternal(credential);
  }

  // ======================================================================
  // LIFECYCLE
  // ======================================================================

  /// Called once from configureGlobalDependencies immediately after
  /// construction. Subscribes to credential changes AFTER commands are
  /// wired so the stream handler always operates on a fully-initialized
  /// manager.
  void startListening() {
    _subscription = _local.onCredentialChanged.listen(_onAuthChanged);
  }

  @override
  FutureOr<dynamic> onDispose() {
    _activeUserId.dispose();
    _accounts.dispose();
    _lastKnownUser.dispose();
    _emailVerified.dispose();
    _subscription?.cancel();
    initialize.dispose();
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
