part of 'account_bloc.dart';

@freezed
class AccountEvent with _$AccountEvent {
  const factory AccountEvent.initialized() = AccountInitialized;
  const factory AccountEvent.switchRequested(UserCredential credential) = AccountSwitchRequested;
}