import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meno_fe_v1/src/core/exceptions/auth_exception.dart';
import 'package:meno_fe_v1/src/features/auth/auth.dart';
import 'package:meno_fe_v1/src/features/settings/settings.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';

part 'login_state.dart';

/// A [Cubit] responsible for managing the login state.
class LoginCubit extends Cubit<LoginState> {
  LoginCubit({
    required IAuthFacade facade,
    required ISettingsFacade settingsFacade,
  })  : _facade = facade,
        _settingsFacade = settingsFacade,
        super(LoginState());
  final IAuthFacade _facade;
  final ISettingsFacade _settingsFacade;

  bool get isOnboarded => _settingsFacade.isOnboarded;

  void emailChanged(String email) => emit(state.withEmail(email));

  void passwordChanged(String password) => emit(state.withPassword(password));

  /// Initiates the login process.
  ///
  /// Returns:
  ///   A `Future` that completes when the login process is finished.
  Future<void> login() async {
    if (!state.isValid) return;
    
    emit(state.withSubmissionLoading());
    
    final failureOrSuccess = await _facade.login(
      email: state.email,
      password: state.password,
    );

    emit(
      failureOrSuccess.fold(
        state.withSubmissionFailure,
        (success) {
          unawaited(_settingsFacade.completeOnboarding);
          return state.withSubmissionSuccess();
        },
      ),
    );
  }
}
