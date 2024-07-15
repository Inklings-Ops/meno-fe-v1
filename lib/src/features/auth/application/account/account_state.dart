part of 'account_bloc.dart';

@freezed
class AccountState with _$AccountState {
  const factory AccountState.initial() = _AccountInitial;
  const factory AccountState.loading() = AccountLoading;
  const factory AccountState.loadSuccess({
    required List<UserCredential> allCredentials,
    required UserCredential currentCredential,
  }) = AccountLoadSuccess;
  const factory AccountState.loadFailure(AuthException e) = AccountLoadFailure;
}
