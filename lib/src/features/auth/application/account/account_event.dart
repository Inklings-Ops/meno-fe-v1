part of 'account_bloc.dart';

sealed class AccountEvent with EquatableMixin {
  const AccountEvent();

  @override
  List<Object?> get props => [];
}

final class AccountInitialized extends AccountEvent {
  const AccountInitialized();
}

final class AccountSwitchRequested extends AccountEvent {
  const AccountSwitchRequested(this.credential);
  final UserCredential credential;

  @override
  List<Object?> get props => [credential];
}
