part of 'account_bloc.dart';

sealed class AccountState with EquatableMixin {
  const AccountState();

  @override
  List<Object?> get props => [];
}

final class AccountInitial extends AccountState {
  const AccountInitial();
}

final class AccountLoadInProgress extends AccountState {
  const AccountLoadInProgress();
}

final class AccountLoadSingleAccountSuccess extends AccountState {
  const AccountLoadSingleAccountSuccess();
}

final class AccountLoadSuccess extends AccountState {
  const AccountLoadSuccess({
    required this.credential,
    this.allCredentials = const [],
  });

  final UserCredential credential;
  final List<UserCredential?> allCredentials;

  @override
  List<Object?> get props => [credential, allCredentials];
}

final class AccountLoadFailure extends AccountState {
  const AccountLoadFailure(this.exception);

  final AuthException exception;

  @override
  List<Object?> get props => [exception];
}
