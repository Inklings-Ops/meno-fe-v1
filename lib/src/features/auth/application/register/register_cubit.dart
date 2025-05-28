import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meno_fe_v1/src/core/exceptions/exceptions.dart';
import 'package:meno_fe_v1/src/features/auth/auth.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';

part 'register_state.dart';

/// A [Cubit] responsible for managing the registration state.
class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit({required IAuthFacade facade})
      : _facade = facade,
        super(RegisterState());
  final IAuthFacade _facade;

  void emailChanged(String email) => emit(state.withEmail(email));
  void fullNameChanged(String fullName) => emit(state.withFullName(fullName));

  void passwordChanged(String password) => emit(state.withPassword(password));

  void termsChanged(bool terms) => emit(state.withTerms(terms));

  void onRememberMeChanged(bool? value) => emit(state.withRememberMe(value));

  Future<void> register() async {
    if (!state.isValid) return;

    emit(state.withSubmissionLoading());

    final failureOrSuccess = await _facade.register(
      fullName: state.fullName,
      email: state.email,
      password: state.password,
    );

    emit(
      failureOrSuccess.fold(
        state.withSubmissionFailure,
        (success) => state.withSubmissionSuccess(),
      ),
    );
  }
}
