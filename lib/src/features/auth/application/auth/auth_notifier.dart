import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/isolates/m_isolates.dart';
import '../../../../dependency_injector/injector.dart';
import '../../domain/domain.dart';

part 'auth_notifier.freezed.dart';
part 'auth_notifier.g.dart';
part 'auth_state.dart';

@riverpod
List<UserCredentials> allCredentials(AllCredentialsRef ref) {
  return ref.watch(authProvider).credentials.values.toList();
}

@riverpod
IAuthFacade authFacade(AuthFacadeRef ref) => di<IAuthFacade>();

@riverpod
bool hasOneAccount(HasOneAccountRef ref) {
  return ref.watch(allCredentialsProvider).length == 1;
}

@riverpod
User user(UserRef ref) => ref.watch(authProvider).user;

@riverpod
UserToken? userToken(UserTokenRef ref) => ref.watch(authProvider).token;

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return di<AuthNotifier>();
});

@Injectable()
class AuthNotifier extends StateNotifier<AuthState> {
  final IAuthFacade _facade;
  AuthNotifier(this._facade) : super(AuthState.initial());

  @PostConstruct(preResolve: true)
  Future<void> checkAuthenticated() async {
    RootIsolateToken rootIsolateToken = RootIsolateToken.instance!;
    final List<dynamic> results = await MIsolates.authResult(rootIsolateToken);

    final User currentUser = results[0] ?? User.empty();
    final UserToken? currentToken = results[1] as UserToken?;
    final Map<String, UserCredentials> credentials = results[2] ?? {};

    final isPartiallyAuthenticated = await _facade.isPartiallyAuthenticated;
    final isAuthenticated = await _facade.isAuthenticated;

    AuthStatus status = AuthStatus.unauthenticated;
    UserToken? token;

    if (isAuthenticated) {
      status = AuthStatus.authenticated;
      token = currentToken;
    } else if (isPartiallyAuthenticated) {
      status = AuthStatus.partiallyAuthenticated;
    }

    state = state.copyWith(
      status: status,
      user: currentUser,
      credentials: credentials,
      token: token,
    );
  }

  /// Logs the user out and resets the authentication state to initial.
  Future<void> logout() async {
    await _facade.logout();
    state = AuthState.initial();
  }

  /// Performs a partial logout by clearing the token and keeping the user data.
  Future<void> partialLogout() async {
    await _facade.partialLogout();
    state = state.copyWith(
      token: "",
      status: AuthStatus.partiallyAuthenticated,
    );
  }

  /// Switches the user account and updates the authentication state.
  Future<void> switchAccount(UserCredentials credentials) async {
    state = state.copyWith(loading: true, option: none());

    final r = await _facade.switchAccount(credentials);

    state = state.copyWith(
      loading: false,
      option: some(r),
      status: AuthStatus.authenticated,
      user: credentials.user,
      token: credentials.token!,
    );
  }
}

/// Enumeration representing different authentication status.
enum AuthStatus { authenticated, unauthenticated, partiallyAuthenticated }
