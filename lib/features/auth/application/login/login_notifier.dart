import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/features/auth/domain/domain.dart';
import 'package:meno_fe_v1/injector/injector.dart';

part 'login_notifier.freezed.dart';
part 'login_state.dart';

/// A state notifier provider for the login form.
final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  return LoginNotifier(di<IAuthFacade>());
});

/// A state notifier for the login form.
@lazySingleton
class LoginNotifier extends StateNotifier<LoginState> {
  /// The auth facade dependency.
  final IAuthFacade _authFacade;

  /// Creates a new `LoginNotifier` object.
  LoginNotifier(this._authFacade) : super(LoginState.initial());

  /// Updates the user's email address.
  void emailChanged(String email) {
    final IEmail iEmail = IEmail(email);
    state = state.copyWith(email: iEmail, option: none());
  }

  /// Initiates the login process.
  Future<void> loginPressed() async {
    Either<AuthException, Unit> result;

    final isEmailValid = state.email.isValid();
    final isPasswordValid = state.password.get() != null;

    if (isEmailValid && isPasswordValid) {
      state = state.copyWith(loading: true, option: none());
      result = await _authFacade.login(
        email: state.email,
        password: state.password,
      );
      state = state.copyWith(loading: false, option: some(result));
    }
  }

  /// Updates the user's password.
  void passwordChanged(String password) {
    final IPassword iPassword = IPassword(password, isSignIn: true);
    state = state.copyWith(password: iPassword, option: none());
  }
}
