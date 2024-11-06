import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:meno_fe_v1/src/features/auth/domain/domain.dart';

part 'reset_password_cubit.freezed.dart';
part 'reset_password_state.dart';

/// A [Cubit] responsible for managing the password recovery state.
class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit({required IAuthFacade facade})
      : _facade = facade,
        super(ResetPasswordState.initial());
  final IAuthFacade _facade;

  /// Updates the user's email address.
  ///
  /// Args:
  ///   email: The user's new email address.
  void emailChanged(String email) {
    emit(state.copyWith(email: Email(email), option: none()));
  }

  Future<void> onForgotPasswordPressed() async {
    late Either<AuthException, Unit> fOrS;
    if (state.isValid) {
      emit(state.copyWith(loading: true, option: none()));
      fOrS = await _facade.forgotPassword(state.email);
    }
    emit(state.copyWith(loading: false, option: optionOf(fOrS)));
  }
}
