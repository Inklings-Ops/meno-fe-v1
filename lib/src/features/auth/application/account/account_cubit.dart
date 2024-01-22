import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain/domain.dart';

part 'account_cubit.freezed.dart';
part 'account_state.dart';

/// This class manages account-related actions, including retrieving user
/// credentials and switching accounts.
@injectable
class AccountCubit extends Cubit<AccountState> {
  /// Dependency injection for authentication-related operations.
  final IAuthFacade _facade;

  /// Creates an instance of [AccountCubit] with the provided [IAuthFacade].
  AccountCubit({required IAuthFacade facade})
      : _facade = facade,
        super(AccountState.empty());

  /// Retrieves all available user credentials and emits an updated state with the list.
  Future<void> get init async {
    final credentialsMap = await _facade.allCredentials;
    final allCredentials = credentialsMap?.values.toList() ?? [];

    emit(state.copyWith(allCredentials: allCredentials));
  }

  /// Switches to a different account using the provided [credentials].
  Future<void> switchAccount(UserCredential? credentials) async {
    if (credentials == null) return; // Do nothing if credentials are null.

    // Emit a loading state while switching accounts.
    emit(state.copyWith(loading: true, option: none()));

    // Attempt to switch accounts using the IAuthFacade.
    final result = await _facade.switchAccount(credentials);

    // Emit the updated state with the result of the switching attempt.
    emit(state.copyWith(
      loading: false,
      option: some(result),
      currentCredential: credentials,
    ));

    // Refresh the list of credentials after switching.
    await init;
  }
}
