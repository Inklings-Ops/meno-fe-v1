import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/features/auth/auth.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';

part 'register_cubit.freezed.dart';
part 'register_state.dart';

/// A [Cubit] responsible for managing the registration state.
@lazySingleton
class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit({required IAuthFacade facade})
      : _facade = facade,
        super(RegisterState.initial());
  final IAuthFacade _facade;

  /// Updates the user's email address.
  ///
  /// Args:
  ///   email: The user's new email address.
  void emailChanged(String email) {
    emit(state.copyWith(email: Email(email), option: none()));
  }

  /// Updates the user's full name
  ///
  /// Args:
  ///   email: The user's new full name
  void fullNameChanged(String value) {
    emit(state.copyWith(fullName: SingleLineString(value), option: none()));
  }

  /// Updates the user's password.
  ///
  /// Args:
  ///   password: The user's new password.
  void passwordChanged(String value) {
    emit(state.copyWith(password: Password(value), option: none()));
  }

  /// Initiates the registration process.
  ///
  /// Returns:
  ///   A `Future` that completes when the registration process is finished.
  Future<void> registerPressed() async {
    late Either<AuthException, UserCredential> fOrS;

    if (state.isFormValid) {
      emit(state.copyWith(loading: true, option: none()));
      fOrS = await _facade.register(
        fullName: state.fullName,
        email: state.email,
        password: state.password,
      );
    }
    emit(state.copyWith(loading: false, option: optionOf(fOrS)));
  }

  void onRememberMeChanged(bool? value) {
    emit(state.copyWith(rememberMe: value ?? state.rememberMe));
  }
}
