import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain/domain.dart';

part 'reset_password_cubit.freezed.dart';
part 'reset_password_state.dart';

/// A [Cubit] responsible for managing the password recovery state.
@lazySingleton
class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final IAuthFacade _facade;
  ResetPasswordCubit({required IAuthFacade facade})
      : _facade = facade,
        super(ResetPasswordState.initial());

  bool get isValid => state.email.isValid();

  /// Updates the user's email address.
  ///
  /// Args:
  ///   email: The user's new email address.
  void emailChanged(String email) {
    /// Updates the state with the new email address and clears the `option`.
    emit(state.copyWith(email: IEmail(email), option: none()));
  }

  Future<void> onForgotPasswordPressed() async {
    if (isValid) {
      emit(state.copyWith(loading: true, option: none()));

      final result = await _facade.forgotPassword(state.email);

      emit(state.copyWith(loading: false, option: some(result)));
    }
  }

  /// Validates an email address.
  ///
  /// Returns an error message if the email address is invalid, or `null` if the email address is valid.
  ///
  /// Args:
  ///   value: The email address to validate.
  ///
  /// Returns:
  ///   An error message if the email address is invalid, or `null` if the email address is valid.
  String? validateEmail(String? value) {
    return state.email.value.fold(
      (error) => error.mapOrNull(
        invalidEmail: (_) => 'Please type a valid email address',
        empty: (_) => 'Email is required',
      ),
      (_) => null,
    );
  }
}
