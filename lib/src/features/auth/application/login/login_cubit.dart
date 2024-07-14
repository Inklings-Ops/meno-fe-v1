import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../onboarding/onboarding.dart';
import '../../domain/domain.dart';

part 'login_cubit.freezed.dart';
part 'login_state.dart';

/// A [Cubit] responsible for managing the login state.
@lazySingleton
class LoginCubit extends Cubit<LoginState> {
  final IAuthFacade _facade;
  final IOnboardingFacade _onboardingFacade;

  LoginCubit({
    required IAuthFacade facade,
    required IOnboardingFacade onboardingFacade,
  })  : _facade = facade,
        _onboardingFacade = onboardingFacade,
        super(LoginState.initial());


  /// Updates the user's email address.
  ///
  /// Args:
  ///   email: The user's new email address.
  void emailChanged(String email) {
    emit(state.copyWith(email: Email(email), option: none()));
  }

  /// Updates the user's password.
  ///
  /// Args:
  ///   password: The user's new password.
  void passwordChanged(String password) {
    emit(
      state.copyWith(
        password: Password(password, isLogin: true),
        option: none(),
      ),
    );
  }

  /// Initiates the login process.
  ///
  /// Returns:
  ///   A `Future` that completes when the login process is finished.
  Future<void> login() async {
    late Either<AuthException, UserCredential> fOrS;
    final isEmailValid = state.email.isValid;
    final isPasswordValid = state.password.isValid;
    if (isEmailValid && isPasswordValid) {
      emit(state.copyWith(loading: true, option: none()));
      fOrS = await _facade.login(email: state.email, password: state.password);
      unawaited(_onboardingFacade.completeOnboarding);
    }
    emit(state.copyWith(option: optionOf(fOrS), loading: false));
  }
}
