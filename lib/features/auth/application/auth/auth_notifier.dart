import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/features/auth/domain/domain.dart';
import 'package:meno_fe_v1/injector/injector.dart';

part 'auth_notifier.freezed.dart';
part 'auth_state.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => di<AuthNotifier>(),
);

final credentialsProvider = Provider(
  (ref) => ref.watch(authProvider).credentials,
);

final userProvider = Provider((ref) => ref.watch(authProvider).user);

final userTokenProvider = Provider((ref) => ref.watch(authProvider).token);

@Injectable()
class AuthNotifier extends StateNotifier<AuthState> {
  final IAuthFacade _facade;

  AuthNotifier(this._facade) : super(AuthState.initial());

  @PostConstruct(preResolve: true)
  Future<void> checkAuthenticated() async {
    final User? currentUser = await _facade.user;
    final UserToken? currentToken = await _facade.userToken;
    final Map<String, UserCredentials>? credentials =
        await _facade.getAllUserCredentials();

    if (await _facade.isPartiallyAuthenticated) {
      state = state.copyWith(
        status: AuthStatus.partiallyAuthenticated,
        user: currentUser!,
        credentials: credentials!,
      );
    }

    if (await _facade.isAuthenticated) {
      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: currentUser!,
        credentials: credentials!,
        token: currentToken!,
      );
    }
  }

  Future<void> logout() async {
    await _facade.logout();
    state = AuthState.initial();
  }

  Future<void> partialLogout() async {
    await _facade.partialLogout();
    state = state.copyWith(token: "");
  }

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
}

enum AuthStatus { authenticated, unauthenticated, partiallyAuthenticated }
