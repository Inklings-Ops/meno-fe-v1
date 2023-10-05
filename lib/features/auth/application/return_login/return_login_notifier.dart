import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/features/auth/domain/domain.dart';
import 'package:meno_fe_v1/injector/injector.dart';

part 'return_login_notifier.freezed.dart';
part 'return_login_state.dart';

/// A state notifier provider for the login form.
final returnLoginProvider =
    StateNotifierProvider.autoDispose<ReturnLoginNotifier, ReturnLoginState>(
        (ref) => ReturnLoginNotifier(di<IAuthFacade>()));

/// A state notifier for the login form.
@lazySingleton
class ReturnLoginNotifier extends StateNotifier<ReturnLoginState> {
  /// The auth facade dependency.
  final IAuthFacade _authFacade;

  /// Creates a new `ReturnLoginNotifier` object.
  ReturnLoginNotifier(this._authFacade) : super(ReturnLoginState.initial());

  /// Initiates the login process.
  ///
  /// Returns:
  ///   A `Future` that completes when the login process is finished.
  Future<void> loginPressed() async {
    /// Checks if the password are valid.
    final IEmail? email = (await _authFacade.user)?.email;
    final bool isEmailValid = email?.isValid() == true;
    final bool isPasswordValid = state.password.get() != null;

    /// If the email and password are valid, attempts to log the user in.
    if (isEmailValid && isPasswordValid) {
      /// Updates the state to indicate that the login process is in progress.
      state = state.copyWith(loading: true, option: none());

      /// Calls the `login()` method on the `_authFacade` object to attempt to log the user in.
      final Either<AuthException, Unit> result = await _authFacade.login(
        email: email!,
        password: state.password,
      );

      /// Updates the state with the result of the login attempt.
      state = state.copyWith(loading: false, option: some(result));
    }
  }

  /// Updates the user's password.
  ///
  /// Args:
  ///   password: The user's new password.
  void passwordChanged(String password) {
    /// Creates a new `IPassword` object from the given password and the `isSignIn` flag.
    final IPassword iPassword = IPassword(password, isSignIn: true);

    /// Updates the state with the new password and clears the `option`.
    state = state.copyWith(password: iPassword, option: none());
  }

  /// Validates a password.
  ///
  /// Returns an error message if the password is invalid, or `null` if the password is valid.
  ///
  /// Args:
  ///   value: The password to validate.
  ///
  /// Returns:
  ///   An error message if the password is invalid, or `null` if the password is valid.
  String? validatePassword(String? value) {
    return state.password.value.fold(
      (error) => error.mapOrNull(
        empty: (_) => 'Password is required',
      ),
      (_) => null,
    );
  }

  @override
  void dispose() {
    state = ReturnLoginState.initial();
    super.dispose();
  }
}
