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
