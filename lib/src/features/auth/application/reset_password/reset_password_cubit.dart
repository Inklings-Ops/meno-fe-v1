import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meno_fe_v1/src/core/exceptions/exceptions.dart';
import 'package:meno_fe_v1/src/features/auth/domain/domain.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';

part 'reset_password_state.dart';

/// A [Cubit] responsible for managing the password recovery state.
class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit({required IAuthFacade facade})
      : _facade = facade,
        super(ResetPasswordState());
  final IAuthFacade _facade;

  /// Updates the user's email address.
  ///
  /// Args:
  ///   email: The user's new email address.
  void emailChanged(String email) => emit(state.withEmail(email));

  Future<void> onForgotPasswordPressed() async {
    if (!state.isValid) return;

    emit(state.withSubmissionLoading());

    final fOrS = await _facade.forgotPassword(state.email);

    emit(
      fOrS.fold(
        state.withSubmissionFailure,
        (success) => state.withSubmissionSuccess(),
      ),
    );
  }
}
