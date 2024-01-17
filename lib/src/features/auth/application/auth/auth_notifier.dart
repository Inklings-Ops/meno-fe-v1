import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../dependency_injector/injector.dart';
import '../../domain/domain.dart';

part 'auth_notifier.freezed.dart';
part 'auth_notifier.g.dart';
part 'auth_state.dart';

@riverpod
IAuthFacade authFacade(AuthFacadeRef ref) => di<IAuthFacade>();

/// Provider that retrieves a list of all user credentials.
final allCredentialsProvider = Provider(
  (ref) => ref.watch(authProvider).credentials.values.toList(),
);

/// Provider that manages the authentication state.
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => di<AuthNotifier>(),
);

/// Provider that checks if the user has only one account.
final hasOneAccountProvider = Provider(
  (ref) => ref.watch(allCredentialsProvider).length == 1,
);

/// Provider that retrieves the user data from the authentication state.
final userProvider = Provider((ref) => ref.watch(authProvider).user);

/// Provider that retrieves the user token from the authentication state.
final userTokenProvider = Provider((ref) => ref.watch(authProvider).token);

@Injectable()
class AuthNotifier extends StateNotifier<AuthState> {
  final IAuthFacade _facade;

  AuthNotifier(this._facade) : super(AuthState.initial());

  ValueNotifier<AuthStatus> get listener => ValueNotifier(state.status);

  /// Checks the authentication status and updates the state accordingly.
  @PostConstruct(preResolve: true)
  Future<void> checkAuthenticated() async {
    final (
      isPartiallyAuthenticated,
      isAuthenticated,
      currentUser,
      currentToken,
      credentials
    ) = await (
      _facade.isPartiallyAuthenticated,
      _facade.isAuthenticated,
      _facade.user,
      _facade.userToken,
      _facade.allUserCredentials,
    ).wait;

    AuthStatus status = AuthStatus.unauthenticated;
    UserToken? token;

    if (isAuthenticated) {
      token = currentToken;
      status = AuthStatus.authenticated;
    } else if (isPartiallyAuthenticated) {
      status = AuthStatus.partiallyAuthenticated;
    }

    state = state.copyWith(
      loading: false,
      option: none(),
      status: status,
      user: currentUser,
      credentials: credentials ?? {},
      token: token,
    );
  }

  ///Logs the user out and resets the authentication state to initial.
  Future<void> logout() async {
    state = AuthState.initial();
    return await _facade.logout();
  }

  /// Performs a partial logout by clearing the token and keeping the user data.
  Future<void> partialLogout() async {
    state = state.copyWith(
      token: null,
      status: AuthStatus.partiallyAuthenticated,
    );
    return await _facade.partialLogout();
  }

  /// Switches the user account and updates the authentication state.
  Future<void> switchAccount(UserCredentials credentials) async {
    state = state.copyWith(loading: true, option: none());

    final result = await _facade.switchAccount(credentials);

    state = state.copyWith(
      loading: false,
      option: some(result),
      status: AuthStatus.authenticated,
      user: credentials.user,
      token: credentials.token!,
    );
  }

  Future<void> login(IEmail email, IPassword password) async {
    final isEmailValid = email.isValid();
    final isPasswordValid = password.get() != null;

    /// If the email and password are valid, attempts to log the user in.
    if (isEmailValid && isPasswordValid) {
      state = state.copyWith(loading: true, option: none());

      /// Calls the `login()` method on the `_authFacade` object to attempt to log the user in.
      final result = await _facade.login(email: email, password: password);

      result.fold(
        (l) => state = state.copyWith(loading: false, option: some(result)),
        (r) async => await checkAuthenticated(),
      );
    }
  }
}

/// Enumeration representing different authentication status.
enum AuthStatus { authenticated, unauthenticated, partiallyAuthenticated }
