part of 'account_bloc.dart';

@freezed
class AccountState with _$AccountState {
  const factory AccountState.loading() = AccountLoading;
  const factory AccountState.singleAccountLoaded() = SingleAccountLoaded;
  const factory AccountState.loaded({
    required UserCredential credential,
    @Default([]) List<UserCredential> allCredentials,
  }) = AccountLoaded;
  const factory AccountState.failure(AuthException exception) = AccountFailure;

  factory AccountState.initial() {
    return AccountLoaded(credential: UserCredential.empty());
  }
}
